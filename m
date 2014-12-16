Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751785AbaLPIm4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Dec 2014 03:42:56 -0500
Received: from smtprelay0199.hostedemail.com ([216.40.44.199]:53433 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751474AbaLPImJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Dec 2014 03:42:09 -0500
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::::::,RULES_HIT:41:355:379:541:599:988:989:1260:1277:1311:1313:1314:1345:1359:1373:1437:1515:1516:1518:1534:1540:1593:1594:1711:1730:1747:1777:1792:2194:2199:2393:2559:2562:2828:3138:3139:3140:3141:3142:3352:3622:3865:3866:3867:3868:3870:3871:3872:3874:4321:5007:6261:10004:10400:10848:11026:11232:11473:11658:11914:12043:12114:12438:12517:12519:12555:12679:12731:12737:12740:13019:13069:13161:13229:13311:13357:21080,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: brain53_2fa05c7f36627
X-Filterd-Recvd-Size: 1823
Message-ID: <1418719326.2674.32.camel@perches.com>
Subject: Re: [PATCH] staging: vt6656: Use ether_addr_copy() in
 vnt_fill_ieee80211_rts.
From: Joe Perches <joe@perches.com>
To: Krzysztof Adamski <k@japko.eu>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Malcolm Priestley <tvboxspy@gmail.com>,
        Forest Bond <forest@alittletooquiet.net>, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Date: Tue, 16 Dec 2014 00:42:06 -0800
In-Reply-To: <20141216083021.GA14666@box2.japko.eu>
References: <20141216083021.GA14666@box2.japko.eu>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.12.7-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2014-12-16 at 09:30 +0100, Krzysztof Adamski wrote:
> Both struct ieee80211_rts and struct ieee80211_hdr defined in
> linux/ieee80211.h are declared as __aligned(2) so it is safe to use
> ether_addr_copy() instead of memcpy().

Just fyi:

That the structure is declared __aligned(2) is not
the important bit.  What's necessary is that the
members in the struct are __aligned(2).

In this case, all of these members are.

> diff --git a/drivers/staging/vt6656/rxtx.c b/drivers/staging/vt6656/rxtx.c
[]
> @@ -392,8 +393,8 @@ static int vnt_fill_ieee80211_rts(struct vnt_usb_send_context *tx_context,
>   	rts->frame_control =
>   		cpu_to_le16(IEEE80211_FTYPE_CTL | IEEE80211_STYPE_RTS);
>   
> -	memcpy(rts->ra, hdr->addr1, ETH_ALEN);
> -	memcpy(rts->ta, hdr->addr2, ETH_ALEN);
> +	ether_addr_copy(rts->ra, hdr->addr1);
> +	ether_addr_copy(rts->ta, hdr->addr2);



