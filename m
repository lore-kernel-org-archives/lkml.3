Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932256Ab3CGAGL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Mar 2013 19:06:11 -0500
Received: from perches-mx.perches.com ([206.117.179.246]:44695 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S932150Ab3CGAGJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Mar 2013 19:06:09 -0500
Message-ID: <1362614767.2093.29.camel@joe-AO722>
Subject: Re: [PATCH 1/2] get_maintainer: create filename-only regex match
 type
From: Joe Perches <joe@perches.com>
To: Stephen Warren <swarren@wwwdotorg.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
        Marcin Slusarz <marcin.slusarz@gmail.com>,
        Lucas Stach <dev@lynxeye.de>, Borislav Petkov <bp@alien8.de>,
        dri-devel@lists.freedesktop.org, nouveau@lists.freedesktop.org,
        Maarten Lankhorst <maarten.lankhorst@canonical.com>,
        linux-tegra@vger.kernel.org, Stephen Warren <swarren@nvidia.com>
Date: Wed, 06 Mar 2013 16:06:07 -0800
In-Reply-To: <1362613005-31439-1-git-send-email-swarren@wwwdotorg.org>
References: <1362613005-31439-1-git-send-email-swarren@wwwdotorg.org>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.6.2-0ubuntu0.1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2013-03-06 at 16:36 -0700, Stephen Warren wrote:
> From: Stephen Warren <swarren@nvidia.com>
> 
> Create a new N: entry type in MAINTAINERS which performs a regex match
> against filenames; either those extracted from patch +++ or --- lines,
> or those specified on the command-line using the -f option.

NAK

At least get the prefix right and remove the
now incorrect filename matches in K:

> diff --git a/MAINTAINERS b/MAINTAINERS
> index 9561658..1671842 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -90,6 +90,9 @@ Descriptions of section entries:
>  	   F:	drivers/net/*	all files in drivers/net, but not below
>  	   F:	*/net/*		all files in "any top level directory"/net
>  	   One pattern per line.  Multiple F: lines acceptable.
> +	N: Files and directories with regex patterns.
> +	   K:	[^a-z]tegra	all files whose patch contains the word tegra

N: not K:

> +	   One pattern per line.  Multiple N: lines acceptable.
>  	X: Files and directories that are NOT maintained, same rules as F:
>  	   Files exclusions are tested before file matches.
>  	   Can be useful for excluding a specific subdirectory, for instance:

and remove the K: descriptions that show filename too.

> diff --git a/scripts/get_maintainer.pl b/scripts/get_maintainer.pl
> index ce4cc83..27dc5cb 100755
> --- a/scripts/get_maintainer.pl
> +++ b/scripts/get_maintainer.pl
> @@ -611,7 +611,7 @@ sub get_maintainers {
>  				    $hash{$tvi} = $value_pd;
>  				}
>  			    }
> -			} elsif ($type eq 'K') {
> +			} elsif ($type eq 'K' || $type eq 'N') {
>  			    if ($file =~ m/$value/x) {
>  				$hash{$tvi} = 0;
>  			    }

Remove K:  It has no value here.



