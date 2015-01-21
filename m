Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754749AbbAUPzq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Jan 2015 10:55:46 -0500
Received: from smtprelay0195.hostedemail.com ([216.40.44.195]:59211 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753629AbbAUPz3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Jan 2015 10:55:29 -0500
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::::::,RULES_HIT:41:355:379:541:599:973:988:989:1260:1277:1311:1313:1314:1345:1359:1373:1437:1515:1516:1518:1534:1539:1593:1594:1711:1714:1730:1747:1777:1792:2194:2199:2393:2559:2562:2828:3138:3139:3140:3141:3142:3351:3622:3865:3866:3867:3873:3874:4321:5007:6119:6261:10004:10400:10471:10848:11026:11232:11658:11914:12043:12438:12517:12519:12740:13069:13101:13255:13311:13357:21080,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: flock65_69bf947a4b057
X-Filterd-Recvd-Size: 1677
Message-ID: <1421855724.10574.11.camel@perches.com>
Subject: Re: [PATCH] staging: vt6656: fix Prefer ether_addr_copy() over
 memcpy() if the Ethernet addresses are __aligned(2)
From: Joe Perches <joe@perches.com>
To: Lin Kassem <linsara1@gmail.com>
Cc: devel@driverdev.osuosl.org, forest@alittletooquiet.net,
        gregkh@linuxfoundation.org, tvboxspy@gmail.com,
        linux-kernel@vger.kernel.org
Date: Wed, 21 Jan 2015 07:55:24 -0800
In-Reply-To: <20150121164458.GA10302@lin-535U4C>
References: <20150121164458.GA10302@lin-535U4C>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.12.7-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2015-01-21 at 18:44 +0200, Lin Kassem wrote:
> This patch fixes the following checkpatch.pl warning:
> fix Prefer ether_addr_copy() over memcpy() 
> if the Ethernet addresses are __aligned(2)
> 
> Pahole showed that the 2 structs are aligned to u16
[]
> diff --git a/drivers/staging/vt6656/rxtx.c b/drivers/staging/vt6656/rxtx.c
[]
> @@ -749,7 +749,7 @@ static void vnt_fill_txkey(struct vnt_usb_send_context *tx_context,
>  		else
>  			mic_hdr->hlen = cpu_to_be16(22);
>  
> -		memcpy(mic_hdr->addr1, hdr->addr1, ETH_ALEN);
> +		ether_addr_copy(mic_hdr->addr1, hdr->addr1);
>  		memcpy(mic_hdr->addr2, hdr->addr2, ETH_ALEN);
>  		memcpy(mic_hdr->addr3, hdr->addr3, ETH_ALEN);
>  

Why would you modify only one of these?
Please modify all 4.


