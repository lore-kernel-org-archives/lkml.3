Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752539AbaBXVbf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Feb 2014 16:31:35 -0500
Received: from relay4-d.mail.gandi.net ([217.70.183.196]:54244 "EHLO
	relay4-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750899AbaBXVbe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Feb 2014 16:31:34 -0500
Date: Mon, 24 Feb 2014 13:31:28 -0800
From: josh@joshtriplett.org
To: Tom Rini <trini@ti.com>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        Joe Perches <joe@perches.com>
Subject: Re: [PATCH] checkpatch.pl: Add warning for new __packed additions
Message-ID: <20140224213128.GB12233@cloud>
References: <1393274296-26179-1-git-send-email-trini@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1393274296-26179-1-git-send-email-trini@ti.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 24, 2014 at 03:38:16PM -0500, Tom Rini wrote:
> While there are valid reasons to use __packed, often the answer is that
> you should be doing something else here instead.
> 
> Cc: Andrew Morton <akpm@linux-foundation.org>
> Cc: Joe Perches <joe@perches.com>
> Cc: Josh Triplett <josh@joshtriplett.org>
> Signed-off-by: Tom Rini <trini@ti.com>
> ---
>  scripts/checkpatch.pl |    5 +++++
>  1 file changed, 5 insertions(+)
> 
> diff --git a/scripts/checkpatch.pl b/scripts/checkpatch.pl
> index 0ea2a1e..fef3b13 100755
> --- a/scripts/checkpatch.pl
> +++ b/scripts/checkpatch.pl
> @@ -4010,6 +4010,11 @@ sub process {
>  			WARN("PREFER_PACKED",
>  			     "__packed is preferred over __attribute__((packed))\n" . $herecurr);
>  		}
> +# Check for new packed usage, warn to use care
> +		if ($line =~ /\b(__attribute__\s*\(\s*\(.*\bpacked|__packed)\b/) {
> +			WARN("NEW_PACKED",
> +			     "Adding new packed members is to be done with care\n" . $herecurr);
> +		}

This seems wrong; "is to be done with care" is the very definition of a
false positive.  At *best* this should always be CHK, and even then it
seems excessive.

- Josh Triplett
