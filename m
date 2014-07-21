Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752743AbaGUEMe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jul 2014 00:12:34 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:53092 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751033AbaGUEMc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jul 2014 00:12:32 -0400
Date: Sun, 20 Jul 2014 21:12:32 -0700 (PDT)
Message-Id: <20140720.211232.1172882419541843442.davem@davemloft.net>
To: cyrille.pitchen@atmel.com
Cc: nicolas.ferre@atmel.com, linux-arm-kernel@lists.infradead.org,
        netdev@vger.kernel.org, soren.brinkmann@xilinx.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/6] net/macb: configure for FIFO mode and non-gigabit
From: David Miller <davem@davemloft.net>
In-Reply-To: <34adf38d52eb31e3ffd36149d320eb0872452bb1.1405689937.git.cyrille.pitchen@atmel.com>
References: <cover.1405689937.git.cyrille.pitchen@atmel.com>
	<34adf38d52eb31e3ffd36149d320eb0872452bb1.1405689937.git.cyrille.pitchen@atmel.com>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.7 (shards.monkeyblade.net [149.20.54.216]); Sun, 20 Jul 2014 21:12:32 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Cyrille Pitchen <cyrille.pitchen@atmel.com>
Date: Fri, 18 Jul 2014 16:21:13 +0200

> From: Nicolas Ferre <nicolas.ferre@atmel.com>
> 
> This addition will also allow to configure DMA burst length.
> 
> Signed-off-by: Nicolas Ferre <nicolas.ferre@atmel.com>
> Acked-by: Cyrille Pitchen <cyrille.pitchen@atmel.com>
> ---
>  drivers/net/ethernet/cadence/macb.c | 72 +++++++++++++++++++++++++++----------
>  drivers/net/ethernet/cadence/macb.h | 19 ++++++++--
>  2 files changed, 71 insertions(+), 20 deletions(-)
> 
> diff --git a/drivers/net/ethernet/cadence/macb.c b/drivers/net/ethernet/cadence/macb.c
> index e9daa07..0896d88 100644
> --- a/drivers/net/ethernet/cadence/macb.c
> +++ b/drivers/net/ethernet/cadence/macb.c
> @@ -264,7 +264,8 @@ static void macb_handle_link_change(struct net_device *dev)
>  				reg |= MACB_BIT(FD);
>  			if (phydev->speed == SPEED_100)
>  				reg |= MACB_BIT(SPD);
> -			if (phydev->speed == SPEED_1000)
> +			if (phydev->speed == SPEED_1000
> +			 && bp->caps & MACB_CAPS_GIGABIT_MODE_AVAILABLE)

Conditional operators end lines, they do not begin lines.

Also you must start the second and subsequent lines at the very
first column after the openning parenthesis of the first line.
