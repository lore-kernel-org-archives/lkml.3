Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760725Ab3BLAAa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Feb 2013 19:00:30 -0500
Received: from perches-mx.perches.com ([206.117.179.246]:58257 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1760018Ab3BLAA3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Feb 2013 19:00:29 -0500
Message-ID: <1360627226.4707.6.camel@joe-AO722>
Subject: Re: [PATCH V3 1/2] get_maintainer: allow keywords to match filenames
From: Joe Perches <joe@perches.com>
To: Stephen Warren <swarren@wwwdotorg.org>
Cc: arm@kernel.org, linux-tegra@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Julian Andres Klode <jak@jak-linux.org>,
        Marc Dietrich <marvin24@gmx.de>, Stephen Warren <swarren@nvidia.com>
Date: Mon, 11 Feb 2013 16:00:26 -0800
In-Reply-To: <1360626016-23332-1-git-send-email-swarren@wwwdotorg.org>
References: <1360626016-23332-1-git-send-email-swarren@wwwdotorg.org>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.6.2-0ubuntu0.1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2013-02-11 at 16:40 -0700, Stephen Warren wrote:
> From: Stephen Warren <swarren@nvidia.com>
> 
> Allow K: entries in MAINTAINERS to match directly against filenames;
> either those extracted from patch +++ or --- lines, or those specified
> on the command-line using the -f option.
[]
> I don't think setting exact_pattern_match_hash would be appropriate here;
> at least for intended Tegra use case, this feature is to ensure that all
> Tegra-related driver changes get Cc'd to the Tegra mailing list. Setting
> exact_pattern_match_hash would prevent git history parsing for e.g. S-o-b
> tags, which still seems like it would be useful. Hence, this flag isn't
> set.

And I don't think that's necessary because for filenames,
you could add the appropriate control to the MAINTAINERS

"K:	^pattern$"

> The value in $hash{$tvi} doesn't seem relevant, so I just assign 0.

0 is good.

It would be relevant if --pattern-depth was set.

> Joe, I'm not sure if you care where this gets merged; could it go through
> arm-soc together with patch 2/2? A quick look at git history of the
> script in linux-next indicates there won't be conflicts doing that.

I don't care how it gets merged.

Andrew Morton typically picks these up but
if you want to get it merged separately,
I don't see a problem.

trivial comment below:

> diff --git a/scripts/get_maintainer.pl b/scripts/get_maintainer.pl
[]
> @@ -611,6 +611,10 @@ sub get_maintainers {
>  				    $hash{$tvi} = $value_pd;
>  				}
>  			    }
> +			} elsif ($type eq "K") {

This should probably be 'K' to match the other
'F' use above it.


