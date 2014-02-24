Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753198AbaBXVAM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Feb 2014 16:00:12 -0500
Received: from smtprelay0071.hostedemail.com ([216.40.44.71]:37927 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752836AbaBXVAL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Feb 2014 16:00:11 -0500
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::,RULES_HIT:41:355:379:541:599:982:988:989:1260:1261:1277:1311:1313:1314:1345:1359:1373:1437:1515:1516:1518:1534:1541:1593:1594:1711:1730:1747:1777:1792:2393:2553:2559:2562:2693:2828:3138:3139:3140:3141:3142:3352:3622:3865:3866:3867:3868:3870:3871:3872:3873:3874:4321:5007:7652:10004:10400:10848:11232:11658:11914:12043:12517:12519:12740:13019:13069:13071:13311:13357:21060,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: yard71_589d6e71fad24
X-Filterd-Recvd-Size: 1910
Message-ID: <1393275606.11020.59.camel@joe-AO722>
Subject: Re: [PATCH] checkpatch.pl: Add warning for new __packed additions
From: Joe Perches <joe@perches.com>
To: Tom Rini <trini@ti.com>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        Josh Triplett <josh@joshtriplett.org>
Date: Mon, 24 Feb 2014 13:00:06 -0800
In-Reply-To: <1393274296-26179-1-git-send-email-trini@ti.com>
References: <1393274296-26179-1-git-send-email-trini@ti.com>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.8.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2014-02-24 at 15:38 -0500, Tom Rini wrote:
> While there are valid reasons to use __packed, often the answer is that
> you should be doing something else here instead.
[]
> diff --git a/scripts/checkpatch.pl b/scripts/checkpatch.pl
[]
> @@ -4010,6 +4010,11 @@ sub process {
>  			WARN("PREFER_PACKED",
>  			     "__packed is preferred over __attribute__((packed))\n" . $herecurr);
>  		}
> +# Check for new packed usage, warn to use care
> +		if ($line =~ /\b(__attribute__\s*\(\s*\(.*\bpacked|__packed)\b/) {
> +			WARN("NEW_PACKED",
> +			     "Adding new packed members is to be done with care\n" . $herecurr);
> +		}

Hi Tom.

This might be too noisy as it will warn on any use of __packed,
including existing ones if checking using -f/--file.

(there are some odd, probably broken ones in drivers/char/tpm/tpm_acpi.c)

How often is this actually a problem?

It'll warn on any use of packed not just packed members.

This may be better as
	"Using 'packed' can impact performance\n"
and only tested when not in --file mode.



