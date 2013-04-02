Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762382Ab3DBVhq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Apr 2013 17:37:46 -0400
Received: from violet.fr.zoreil.com ([92.243.8.30]:40320 "EHLO
	violet.fr.zoreil.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760170Ab3DBVhp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Apr 2013 17:37:45 -0400
Date: Tue, 2 Apr 2013 23:37:36 +0200
From: Francois Romieu <romieu@fr.zoreil.com>
To: Hayes Wang <hayeswang@realtek.com>
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org, bowgotsai@google.com
Subject: Re: [PATCH v2] r8169: fix auto speed down issue
Message-ID: <20130402213736.GA15328@electric-eye.fr.zoreil.com>
References: <1364541062-9024-1-git-send-email-hayeswang@realtek.com>
 <1364785324-1604-1-git-send-email-hayeswang@realtek.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1364785324-1604-1-git-send-email-hayeswang@realtek.com>
X-Organisation: Land of Sunshine Inc.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hayes Wang <hayeswang@realtek.com> :
> It would cause no link after suspending or shutdowning when the
> nic changes the speed to 10M and connects to a link partner which
> forces the speed to 100M.
> 
> Check the link partner ability to determine which speed to set.
> 
> Signed-off-by: Hayes Wang <hayeswang@realtek.com>

Acked-by: Francois Romieu <romieu@fr.zoreil.com>

I have given it a short sanity testing with suspend or shutdown (no rpm)
on 8168evl or 8168e and it did not seem to regress (8168e and 8168evl).

The driver does not do what it is requested to when the r81xx - not the
link partner - forces the link. Not that it ever did but autonegotiation
will now always end up enabled and nothing will prevent a higher than
expected link speed after that.

It could be worth to check MII_BMCR for BMCR_ANENABLE before anything else
in rtl_speed_down.

[...]
> diff --git a/drivers/net/ethernet/realtek/r8169.c b/drivers/net/ethernet/realtek/r8169.c
> index 28fb50a..bdc03a9 100644
> --- a/drivers/net/ethernet/realtek/r8169.c
> +++ b/drivers/net/ethernet/realtek/r8169.c
> @@ -3818,6 +3818,30 @@ static void rtl_init_mdio_ops(struct rtl8169_private *tp)
>  	}
>  }
>  
> +static void rtl_speed_down(struct rtl8169_private *tp)
> +{
> +	u32	adv;
> +	int	lpa;
           ^^^^^
Please use a single, true space (no tabs) next time.

-- 
Ueimor
