Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756723Ab3C3Mn3 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Mar 2013 08:43:29 -0400
Received: from violet.fr.zoreil.com ([92.243.8.30]:33670 "EHLO
	violet.fr.zoreil.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756639Ab3C3Mn0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Mar 2013 08:43:26 -0400
Date: Sat, 30 Mar 2013 13:43:19 +0100
From: Francois Romieu <romieu@fr.zoreil.com>
To: Hayes Wang <hayeswang@realtek.com>
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org, bowgotsai@google.com
Subject: Re: [PATCH] r8169: fix auto speed down issue
Message-ID: <20130330124319.GB19236@electric-eye.fr.zoreil.com>
References: <1364541062-9024-1-git-send-email-hayeswang@realtek.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1364541062-9024-1-git-send-email-hayeswang@realtek.com>
X-Organisation: Land of Sunshine Inc.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hayes Wang <hayeswang@realtek.com> :
[...]
> diff --git a/drivers/net/ethernet/realtek/r8169.c b/drivers/net/ethernet/realtek/r8169.c
> index 28fb50a..a9eedf7 100644
> --- a/drivers/net/ethernet/realtek/r8169.c
> +++ b/drivers/net/ethernet/realtek/r8169.c
> @@ -3818,6 +3818,21 @@ static void rtl_init_mdio_ops(struct rtl8169_private *tp)
>  	}
>  }
>  
> +static void rtl_speed_down(struct rtl8169_private *tp)
> +{
> +	u32	adv;
> +	int	lpa;
> +
> +	rtl_writephy(tp, 0x1f, 0x0000);
> +	lpa = rtl_readphy(tp, MII_LPA);
> +
> +	adv = ADVERTISED_10baseT_Half | ADVERTISED_10baseT_Full;
> +	if (!(lpa & (ADVERTISE_10HALF | ADVERTISE_10FULL)))

You may use the LPA_* #defines here.

-- 
Ueimor
