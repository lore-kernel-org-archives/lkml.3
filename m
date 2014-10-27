Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751959AbaJ0AlA (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 Oct 2014 20:41:00 -0400
Received: from smtprelay0007.hostedemail.com ([216.40.44.7]:37882 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751722AbaJ0Ak7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 Oct 2014 20:40:59 -0400
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::::::::,RULES_HIT:41:355:379:541:599:988:989:1260:1277:1311:1313:1314:1345:1359:1373:1437:1515:1516:1518:1534:1541:1593:1594:1711:1730:1747:1777:1792:2194:2199:2393:2559:2562:2828:3138:3139:3140:3141:3142:3353:3622:3865:3867:3872:4321:5007:6261:8957:10004:10400:10848:11026:11473:11657:11658:11914:12043:12296:12517:12519:12555:12683:12740:13069:13311:13357:14110:21080,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: pump90_4285175ae140a
X-Filterd-Recvd-Size: 2484
Message-ID: <1414370455.15751.24.camel@perches.com>
Subject: Re: [PATCH] staging: rtl8723au: create macro get_max_rate
From: Joe Perches <joe@perches.com>
To: Paul McQuade <paulmcquad@gmail.com>
Cc: linux-kernel@vger.kernel.org, devel@driverdev.osuosl.org,
        linux-wireless@vger.kernel.org, gregkh@linuxfoundation.org,
        Jes.Sorensen@redhat.com, Larry.Finger@lwfinger.net
Date: Sun, 26 Oct 2014 17:40:55 -0700
In-Reply-To: <1414368300-9596-1-git-send-email-paulmcquad@gmail.com>
References: <1414368300-9596-1-git-send-email-paulmcquad@gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.12.7-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2014-10-27 at 00:05 +0000, Paul McQuade wrote:
> create marco for max_rate values

macro

> diff --git a/drivers/staging/rtl8723au/core/rtw_ieee80211.c b/drivers/staging/rtl8723au/core/rtw_ieee80211.c
[]
> @@ -13,6 +13,8 @@
>   *
>   ******************************************************************************/
>  #define _IEEE80211_C
> +#define get_max_rate(r1, r2, r3, r4)					\
> +	(bw_40MHz ? (short_GI_40 ? r1 : r2) : (short_GI_20 ? r3 : r4))

This macro should really be defined next to the uses as
it's dependent on naming within the rtw_mcs_rate23a function.

> @@ -794,64 +796,56 @@ u16 rtw_mcs_rate23a(u8 rf_type, u8 bw_40MHz, u8 short_GI_20, u8 short_GI_40,
>  
>  	if (rf_type == RF_1T1R) {
>  		if (mcs->rx_mask[0] & BIT(7))
> -			max_rate = (bw_40MHz) ? ((short_GI_40)?1500:1350):
> -				((short_GI_20)?722:650);
> +			max_rate = get_max_rate(1500, 1350, 722, 650);
[...]
>  	} else {
>  		if (mcs->rx_mask[1]) {
>  			if (mcs->rx_mask[1] & BIT(7))
> -				max_rate = (bw_40MHz) ? ((short_GI_40)?3000:2700):((short_GI_20)?1444:1300);
> +				max_rate = get_max_rate(3000, 2700, 1444, 1300);
[...]
>  		} else {
>  			if (mcs->rx_mask[0] & BIT(7))
> -				max_rate = (bw_40MHz) ? ((short_GI_40)?1500:1350):((short_GI_20)?722:650);
> +				max_rate = get_max_rate(1500, 1350, 722, 650);
[...]
>  		}
>  	}
>  	return max_rate;

This can be written with fewer indents as

	if (rf_type == RF_1T1R( {
		[...]
	else if (mcs->rx_mask[1]) {
		[...]
	} else {
		[...]
	}

	return max_rate;
}


