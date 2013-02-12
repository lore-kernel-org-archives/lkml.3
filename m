Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753812Ab3BLGR7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Feb 2013 01:17:59 -0500
Received: from perches-mx.perches.com ([206.117.179.246]:58414 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751267Ab3BLGR5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Feb 2013 01:17:57 -0500
Message-ID: <1360649875.5128.18.camel@joe-AO722>
Subject: Re: [PATCH V4 1/2] get_maintainer: allow keywords to match filenames
From: Joe Perches <joe@perches.com>
To: Stephen Warren <swarren@wwwdotorg.org>
Cc: arm@kernel.org, linux-tegra@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Julian Andres Klode <jak@jak-linux.org>,
        Marc Dietrich <marvin24@gmx.de>, Stephen Warren <swarren@nvidia.com>
Date: Mon, 11 Feb 2013 22:17:55 -0800
In-Reply-To: <1360629574-23989-1-git-send-email-swarren@wwwdotorg.org>
References: <1360629574-23989-1-git-send-email-swarren@wwwdotorg.org>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.6.2-0ubuntu0.1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2013-02-11 at 17:39 -0700, Stephen Warren wrote:
> From: Stephen Warren <swarren@nvidia.com>
> 
> Allow K: entries in MAINTAINERS to match directly against filenames;
> either those extracted from patch +++ or --- lines, or those specified
> on the command-line using the -f option.
[]
> diff --git a/MAINTAINERS b/MAINTAINERS
[]
> @@ -97,12 +97,12 @@ Descriptions of section entries:
>  	   X:	net/ipv6/
>  	   matches all files in and below net excluding net/ipv6/
>  	K: Keyword perl extended regex pattern to match content in a
> -	   patch or file.  For instance:
> +	   patch, or an affected filename.  For instance:

The removal of file isn't correct.

This should read "patch, file or filename".

If the -f pattern is a single file,
get_maintainer reads that file content and then
matches any K: patterns.

When the -f pattern is a directory, it doesn't.

>  	   K: of_get_profile
> -	      matches patches or files that contain "of_get_profile"
> +	      matches patches or filenames that contain "of_get_profile"

here too.

>  	   K: \b(printk|pr_(info|err))\b
> -	      matches patches or files that contain one or more of the words
> -	      printk, pr_info or pr_err
> +	      matches patches or filenames that contain one or more of
> +	      the words printk, pr_info or pr_err

three.

cheers, Joe

