Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755239AbaIDT1P (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Sep 2014 15:27:15 -0400
Received: from smtprelay0055.hostedemail.com ([216.40.44.55]:43919 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754087AbaIDT1O (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Sep 2014 15:27:14 -0400
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::,RULES_HIT:41:334:355:368:369:379:541:599:800:960:973:982:988:989:1260:1261:1277:1311:1313:1314:1345:1359:1373:1437:1515:1516:1518:1534:1541:1593:1594:1711:1730:1747:1777:1792:2393:2559:2562:2687:2828:3138:3139:3140:3141:3142:3352:3622:3865:3866:3867:3868:3870:3871:3872:3873:3874:4321:4362:4823:5007:7652:7875:7903:10004:10400:10848:11026:11232:11658:11914:12438:12517:12519:12740:13069:13141:13230:13311:13357:21080,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: tail42_7918927085401
X-Filterd-Recvd-Size: 2304
Message-ID: <1409858830.2770.13.camel@joe-AO725>
Subject: Re: [PATCH v2] checkpatch: allow optional shorter config
 descriptions
From: Joe Perches <joe@perches.com>
To: Vadim Bendebury <vbendeb@chromium.org>
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        Andy Whitcroft <apw@canonical.com>
Date: Thu, 04 Sep 2014 12:27:10 -0700
In-Reply-To: <1409855029-22598-1-git-send-email-vbendeb@chromium.org>
References: <1409761945-545-1-git-send-email-vbendeb@chromium.org>
	 <1409855029-22598-1-git-send-email-vbendeb@chromium.org>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.10.4-0ubuntu2 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2014-09-04 at 11:23 -0700, Vadim Bendebury wrote:
> This script is used by many other projects, and in some of them the
> requirement of at least 4 line long description for all Kconfig items
> is excessive. This patch adds a command line option to control the
> required minimum length.
> 
> Tested running this script over a patch including a two line config
> description. The script generated a warning when invoked as is, and
> did not generate it when invoked with --min-conf-desc-length=2.
> 
> Signed-off-by: Vadim Bendebury <vbendeb@chromium.org>
> ---
> 
> Changes in v2:
>   - modified the condition check as requested
[]
> diff --git a/scripts/checkpatch.pl b/scripts/checkpatch.pl
[]
> @@ -2280,8 +2283,10 @@ sub process {
>  				}
>  				$length++;
>  			}
> -			WARN("CONFIG_DESCRIPTION",
> -			     "please write a paragraph that describes the config symbol fully\n" . $herecurr) if ($is_start && $is_end && $length < 4);
> +			if ($is_start && $is_end && $length < $min_conf_desc_length) {
> +			    WARN("CONFIG_DESCRIPTION",
> +				 "please write a paragraph that describes the config symbol fully\n" . $herecurr)
> +			}
>  			#print "is_start<$is_start> is_end<$is_end> length<$length>\n";
>  		}
>  

Thank you but this is not quite right.

checkpatch uses tabs for indentation.

You've used 4 spaces for the WARN.


