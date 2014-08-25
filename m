Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932322AbaHYNPY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Aug 2014 09:15:24 -0400
Received: from smtprelay0041.hostedemail.com ([216.40.44.41]:54634 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753582AbaHYNPX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Aug 2014 09:15:23 -0400
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::,RULES_HIT:41:355:379:541:599:968:988:989:1260:1261:1277:1311:1313:1314:1345:1359:1373:1437:1515:1516:1518:1534:1541:1593:1594:1711:1730:1747:1777:1792:2393:2553:2559:2562:2828:3138:3139:3140:3141:3142:3352:3622:3865:3866:3867:3872:3874:4250:4321:5007:7652:8957:9040:10004:10400:10848:11026:11232:11473:11657:11658:11914:12043:12438:12517:12519:12740:13069:13141:13230:13255:13311:13357:21080,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: watch38_4be0dc4d5f748
X-Filterd-Recvd-Size: 2079
Message-ID: <1408972519.20683.41.camel@joe-AO725>
Subject: Re: [PATCH] drivers: staging: rtl8821ae: Fix spaces required around
 that '?' errors
From: Joe Perches <joe@perches.com>
To: Greg Donald <gdonald@gmail.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Date: Mon, 25 Aug 2014 06:15:19 -0700
In-Reply-To: <1408966502-22350-1-git-send-email-gdonald@gmail.com>
References: <1408966502-22350-1-git-send-email-gdonald@gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.10.4-0ubuntu2 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2014-08-25 at 06:35 -0500, Greg Donald wrote:
> Fix checkpatch.pl spaces required around that '?' errors

It'd be better to convert all parts of the
ternary at the same time.

> diff --git a/drivers/staging/rtl8821ae/btcoexist/HalBtc8812a1Ant.c b/drivers/staging/rtl8821ae/btcoexist/HalBtc8812a1Ant.c
[]
> @@ -652,7 +652,7 @@ halbtc8812a1ant_SetFwDecBtPwr(
>  	u1Byte	buf[5] = {0};
>  
>  	BTC_PRINT(BTC_MSG_ALGORITHM, ALGO_TRACE_FW_EXEC, ("[BTCoex], decrease Bt Power : %s\n", 
> -			(dec_bt_pwr? "Yes!!":"No!!")));
> +			(dec_bt_pwr ? "Yes!!":"No!!")));

		    (dec_bt_pwr ? "Yes!!" : "No!!")
			
>  
>  	buf[0] = dataLen;
>  	buf[1] = 0x3;		// OP_Code
> @@ -674,7 +674,7 @@ halbtc8812a1ant_DecBtPwr(
>  {
>  	return;
>  	BTC_PRINT(BTC_MSG_ALGORITHM, ALGO_TRACE_FW, ("[BTCoex], %s Dec BT power = %s\n",  
> -		(force_exec? "force to":""), ((dec_bt_pwr)? "ON":"OFF")));
> +		(force_exec ? "force to":""), ((dec_bt_pwr) ? "ON":"OFF")));

		    (force_exec ? "force to" : ""), ((dec_bt_pwr) ? "ON" : "OFF")));

etc...

A subsequent change might be to remove the unnecessary
parentheses like:

		    force_exec ? "force to" : "", dec_bt_pwr ? "ON" : "OFF");


