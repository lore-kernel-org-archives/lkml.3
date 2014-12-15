Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750998AbaLOCLm (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Dec 2014 21:11:42 -0500
Received: from smtprelay0137.hostedemail.com ([216.40.44.137]:59906 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1750745AbaLOCLd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Dec 2014 21:11:33 -0500
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::,RULES_HIT:41:355:379:541:599:973:988:989:1260:1277:1311:1313:1314:1345:1359:1373:1437:1515:1516:1518:1534:1540:1593:1594:1711:1730:1747:1777:1792:2393:2559:2562:2828:3138:3139:3140:3141:3142:3352:3622:3867:3871:3872:4321:5007:6261:10004:10400:10848:11232:11658:11914:12043:12438:12517:12519:12740:13069:13255:13311:13357:21080,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: iron63_47883338c8711
X-Filterd-Recvd-Size: 1743
Message-ID: <1418609490.2674.7.camel@perches.com>
Subject: Re: [PATCH] Staging: wlan-ng: hfa384x_usb: fixed an 'else'
 statement coding style issue
From: Joe Perches <joe@perches.com>
To: Eduardo Barretto <edusbarretto@gmail.com>
Cc: gregkh@linuxfoundation.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Date: Sun, 14 Dec 2014 18:11:30 -0800
In-Reply-To: <1418608974-22509-1-git-send-email-edusbarretto@gmail.com>
References: <1418608974-22509-1-git-send-email-edusbarretto@gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.12.7-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2014-12-15 at 00:02 -0200, Eduardo Barretto wrote:
> Fixed a coding style issue
[]
> diff --git a/drivers/staging/wlan-ng/hfa384x_usb.c b/drivers/staging/wlan-ng/hfa384x_usb.c
[]
> @@ -4123,12 +4123,11 @@ static int hfa384x_isgood_pdrcode(u16 pdrcode)
>  			pr_debug("Encountered unknown PDR#=0x%04x, assuming it's ok.\n",
>  				 pdrcode);
>  			return 1;
> -		} else {
> -			/* bad code */
> -			pr_debug("Encountered unknown PDR#=0x%04x, (>=0x1000), assuming it's bad.\n",
> -				 pdrcode);
> -			return 0;
>  		}
> +		/* bad code */
> +		pr_debug("Encountered unknown PDR#=0x%04x, (>=0x1000), assuming it's bad.\n",
> +			 pdrcode);
> +		return 0;
>  	}
>  	return 0;		/* avoid compiler warnings */
>  }

While this patch isn't necessary, if any change is
done, it might better to not have two consecutive
return 0; uses.


