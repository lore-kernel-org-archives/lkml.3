Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752085AbaFSEOf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jun 2014 00:14:35 -0400
Received: from smtprelay0236.hostedemail.com ([216.40.44.236]:53199 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1750708AbaFSEOe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jun 2014 00:14:34 -0400
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::::::::,RULES_HIT:41:355:379:541:599:973:988:989:1260:1261:1277:1311:1313:1314:1345:1359:1373:1437:1515:1516:1518:1534:1541:1593:1594:1711:1730:1747:1777:1792:2393:2559:2562:2828:3138:3139:3140:3141:3142:3352:3622:3865:3866:3867:3868:3870:3871:3872:3873:4250:4321:5007:6119:7652:7903:8829:8957:10004:10400:10848:11026:11232:11473:11657:11658:11914:12043:12296:12438:12517:12519:12679:12740:13069:13071:13161:13229:13311:13357,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: boat95_278ef0122b631
X-Filterd-Recvd-Size: 2081
Message-ID: <1403151270.14018.17.camel@joe-AO725>
Subject: Re: [PATCH] staging: rtl8192e: check return value of dev_skb_alloc
From: Joe Perches <joe@perches.com>
To: Nicholas Krause <xerofoify@gmail.com>
Cc: gregkh@linuxfoundation.org, lisa@xenapiadmin.com,
        valentina.manea.m@gmail.com, ben@decadent.org.uk,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Date: Wed, 18 Jun 2014 21:14:30 -0700
In-Reply-To: <1403144681-6902-1-git-send-email-xerofoify@gmail.com>
References: <1403144681-6902-1-git-send-email-xerofoify@gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.10.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2014-06-18 at 22:24 -0400, Nicholas Krause wrote:
> Checks if dev_skb_alloc returns Null in function, fw_download_code.
> If the return value of dev_skb_alloc is NULL return false and exit
> this function.

Hello Nicholas.

If you're going to try add these checks, please look at
the code a bit more before submitting defective patches.

> diff --git a/drivers/staging/rtl8192e/rtl8192e/r8192E_firmware.c b/drivers/staging/rtl8192e/rtl8192e/r8192E_firmware.c
[]
> @@ -62,6 +62,8 @@ static bool fw_download_code(struct net_device *dev, u8 *code_virtual_address,
>  
>  		skb  = dev_alloc_skb(frag_length + 4);
>  		memcpy((unsigned char *)(skb->cb), &dev, sizeof(dev));
> +		if (!skb)
> +			return !rt_status;

Umm, if you're going to check whether or not skb is NULL,
do it before it's dereferenced  as skb->cb.

Oh, and get rid of rt_status and use

			return false;

directly.

>  		tcb_desc = (struct cb_desc *)(skb->cb + MAX_DEV_ADDR_SIZE);
>  		tcb_desc->queue_index = TXCMD_QUEUE;
>  		tcb_desc->bCmdOrInit = DESC_PACKET_TYPE_INIT;

and change the end of function

from:
	return rt_status;
to:
	return true;

