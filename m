Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965642AbaFSVZj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jun 2014 17:25:39 -0400
Received: from smtprelay0165.hostedemail.com ([216.40.44.165]:51314 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S964845AbaFSVZh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jun 2014 17:25:37 -0400
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 50,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::::::::,RULES_HIT:41:355:379:541:599:967:973:988:989:1260:1261:1277:1311:1313:1314:1345:1359:1373:1437:1515:1516:1518:1534:1540:1593:1594:1711:1730:1747:1777:1792:2198:2199:2393:2525:2553:2560:2563:2682:2685:2828:2859:2915:2933:2937:2939:2942:2945:2947:2951:2954:3022:3138:3139:3140:3141:3142:3352:3622:3865:3866:3867:3868:3872:3873:3934:3936:3938:3941:3944:3947:3950:3953:3956:3959:4321:5007:6119:7652:8829:8957:8985:9025:9388:10004:10400:10848:11026:11657:11658:11854:11914:12043:12294:12296:12438:12517:12519:12740:13019:13069:13311:13357,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL
X-HE-Tag: shop71_13a8a24acf743
X-Filterd-Recvd-Size: 1857
Message-ID: <1403213133.2753.20.camel@joe-AO725>
Subject: Re: [PATCH] staging: rtl8192e: check return value of dev_skb_alloc
From: Joe Perches <joe@perches.com>
To: Nicholas Krause <xerofoify@gmail.com>
Cc: gregkh@linuxfoundation.org, valentina.manea.m@gmail.com,
        lisa@xenapiadmin.com, ben@decadent.org.uk, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Date: Thu, 19 Jun 2014 14:25:33 -0700
In-Reply-To: <1403206156-3702-1-git-send-email-xerofoify@gmail.com>
References: <1403206156-3702-1-git-send-email-xerofoify@gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.10.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2014-06-19 at 15:29 -0400, Nicholas Krause wrote:

> diff --git a/drivers/staging/rtl8192e/rtl8192e/r8192E_firmware.c b/drivers/staging/rtl8192e/rtl8192e/r8192E_firmware.c
[]
> @@ -59,7 +58,8 @@ static bool fw_download_code(struct net_device *dev, u8 *code_virtual_address,
>  			bLastIniPkt = 1;
>  
>  		}
> -
> +		if (!skb)
> +			return false;
>  		skb  = dev_alloc_skb(frag_length + 4);

Nick.

You may have compiled this, but it's obvious you
haven't tested it.

Please stop sending patches until you can verify what
you're doing with the code.

Please train a few more of your neurons for coding.

It takes some time and some practice but please don't
practice on linux-kernel.

Use google to find some other suitable forums like
http://cboard.cprogramming.com/c-programming/

Back to your patch:

	if (!skb)
		return false;

must go _after_

	skb = dev_alloc_skb(frag_length + 4);



