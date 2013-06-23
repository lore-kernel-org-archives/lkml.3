Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751242Ab3FWI0i (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Jun 2013 04:26:38 -0400
Received: from gloria.sntech.de ([95.129.55.99]:35627 "EHLO gloria.sntech.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751022Ab3FWI0d (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Jun 2013 04:26:33 -0400
From: Heiko =?utf-8?q?St=C3=BCbner?= <heiko@sntech.de>
To: Axel Lin <axel.lin@ingics.com>
Subject: Re: [PATCH] pinctrl: rockchip: Add missing irq_gc_unlock() call before return error
Date: Sun, 23 Jun 2013 10:26:28 +0200
User-Agent: KMail/1.13.7 (Linux/3.2.0-3-686-pae; KDE/4.8.4; i686; ; )
Cc: Linus Walleij <linus.walleij@linaro.org>, linux-kernel@vger.kernel.org
References: <1371948514.9509.1.camel@phoenix>
In-Reply-To: <1371948514.9509.1.camel@phoenix>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201306231026.29244.heiko@sntech.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Sonntag, 23. Juni 2013, 02:48:34 schrieb Axel Lin:
> Signed-off-by: Axel Lin <axel.lin@ingics.com>

Thanks for catching this glitch.

Acked-by: Heiko Stuebner <heiko@sntech.de>

> ---
>  drivers/pinctrl/pinctrl-rockchip.c | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/drivers/pinctrl/pinctrl-rockchip.c
> b/drivers/pinctrl/pinctrl-rockchip.c index 427564f..1eb5a2e 100644
> --- a/drivers/pinctrl/pinctrl-rockchip.c
> +++ b/drivers/pinctrl/pinctrl-rockchip.c
> @@ -1035,6 +1035,7 @@ static int rockchip_irq_set_type(struct irq_data *d,
> unsigned int type) polarity &= ~mask;
>  		break;
>  	default:
> +		irq_gc_unlock(gc);
>  		return -EINVAL;
>  	}

