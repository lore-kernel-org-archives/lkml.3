Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751761AbaI3WhQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Sep 2014 18:37:16 -0400
Received: from violet.fr.zoreil.com ([92.243.8.30]:58042 "EHLO
	violet.fr.zoreil.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751268AbaI3WhN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Sep 2014 18:37:13 -0400
Date: Wed, 1 Oct 2014 00:37:07 +0200
From: Francois Romieu <romieu@fr.zoreil.com>
To: Chun-Hao Lin <hau@realtek.com>
Cc: netdev@vger.kernel.org, nic_swsd@realtek.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next 07/10] r8169:change function name of function
 "rtl_w1w0_eri"
Message-ID: <20140930223707.GB27610@electric-eye.fr.zoreil.com>
References: <1412089230-10208-1-git-send-email-hau@realtek.com>
 <1412089230-10208-7-git-send-email-hau@realtek.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1412089230-10208-7-git-send-email-hau@realtek.com>
X-Organisation: Land of Sunshine Inc.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Chun-Hao Lin <hau@realtek.com> :
> Change the name of this function to "rtl_w0_w1_eri".
> It is more suitable for this function's behavior.

Afaiks it used to follow the same rule as the one I outlined in the
comment to #6/10 for rtl_w0_w1_phy.

Could you elaborate (or say so if it should be clear for me after
some sleep) ?

[...]
> diff --git a/drivers/net/ethernet/realtek/r8169.c b/drivers/net/ethernet/realtek/r8169.c
> index e68fe5e..e79def5 100644
> --- a/drivers/net/ethernet/realtek/r8169.c
> +++ b/drivers/net/ethernet/realtek/r8169.c
[...]
> @@ -1629,14 +1629,14 @@ static void __rtl8169_set_wol(struct rtl8169_private *tp, u32 wolopts)
>  	case RTL_GIGA_MAC_VER_48:
>  		tmp = ARRAY_SIZE(cfg) - 1;
>  		if (wolopts & WAKE_MAGIC)
> -			rtl_w1w0_eri(tp,
> +			rtl_w0w1_eri(tp,
>  				     0x0dc,
>  				     ERIAR_MASK_0100,
>  				     MagicPacket_v2,
>  				     0x0000,
>  				     ERIAR_EXGMAC);
>  		else
> -			rtl_w1w0_eri(tp,
> +			rtl_w0w1_eri(tp,
>  				     0x0dc,
>  				     ERIAR_MASK_0100,
>  				     0x0000,

Please turn these into:

			rtl_..._eri(tp, 0x0dc, ERIAR_MASK_0100, MagicPacket_v2,
 				    0x0000, ERIAR_EXGMAC);

-- 
Ueimor
