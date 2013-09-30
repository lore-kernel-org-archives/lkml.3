Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756037Ab3I3PZm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Sep 2013 11:25:42 -0400
Received: from perceval.ideasonboard.com ([95.142.166.194]:52742 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754813Ab3I3PZk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Sep 2013 11:25:40 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: takasi-y@ops.dti.ne.jp
Cc: SH-Linux <linux-sh@vger.kernel.org>, Magnus Damm <magnus.damm@gmail.com>,
        ben.dooks@codethink.co.uk,
        Shinya Kuribayashi <shinya.kuribayashi.px@renesas.com>,
        devicetree@vger.kernel.org, linux-serial@vger.kernel.org,
        Simon Horman <horms@verge.net.au>, Paul Mundt <lethal@linux-sh.org>,
        Mike Turquette <mturquette@linaro.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/6] serial8250-em: convert to clk_prepare/unprepare
Date: Mon, 30 Sep 2013 17:25:40 +0200
Message-ID: <4895580.Leadr2OAf1@avalon>
User-Agent: KMail/4.10.5 (Linux/3.8.13-gentoo; KDE/4.10.5; x86_64; ; )
In-Reply-To: <20130924131039.3c871cad7acb2a068a988d0f@ops.dti.ne.jp>
References: <52410F86.4040301@renesas.com> <20130924131039.3c871cad7acb2a068a988d0f@ops.dti.ne.jp>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Yoshii-san,

Thank you for the patch.

On Tuesday 24 September 2013 13:10:39 takasi-y@ops.dti.ne.jp wrote:
> From: Shinya Kuribayashi <shinya.kuribayashi.px@renesas.com>
> 
> Add calls to clk_prepare and unprepare so that EMMA Mobile EV2 can
> migrate to the common clock framework.
> 
> Signed-off-by: Shinya Kuribayashi <shinya.kuribayashi.px@renesas.com>
> [takashi.yoshii.ze@renesas.com: edited for conflicts]
> Signed-off-by: Takashi Yoshii <takashi.yoshii.zj@renesas.com>

Acked-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>

> ---
>  drivers/tty/serial/8250/8250_em.c | 6 +++---
>  1 file changed, 3 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/tty/serial/8250/8250_em.c
> b/drivers/tty/serial/8250/8250_em.c index 5f3bba1..d1a9078 100644
> --- a/drivers/tty/serial/8250/8250_em.c
> +++ b/drivers/tty/serial/8250/8250_em.c
> @@ -122,7 +122,7 @@ static int serial8250_em_probe(struct platform_device
> *pdev) up.port.dev = &pdev->dev;
>  	up.port.private_data = priv;
> 
> -	clk_enable(priv->sclk);
> +	clk_prepare_enable(priv->sclk);
>  	up.port.uartclk = clk_get_rate(priv->sclk);
> 
>  	up.port.iotype = UPIO_MEM32;
> @@ -134,7 +134,7 @@ static int serial8250_em_probe(struct platform_device
> *pdev) ret = serial8250_register_8250_port(&up);
>  	if (ret < 0) {
>  		dev_err(&pdev->dev, "unable to register 8250 port\n");
> -		clk_disable(priv->sclk);
> +		clk_disable_unprepare(priv->sclk);
>  		return ret;
>  	}
> 
> @@ -148,7 +148,7 @@ static int serial8250_em_remove(struct platform_device
> *pdev) struct serial8250_em_priv *priv = platform_get_drvdata(pdev);
> 
>  	serial8250_unregister_port(priv->line);
> -	clk_disable(priv->sclk);
> +	clk_disable_unprepare(priv->sclk);
>  	return 0;
>  }
-- 
Regards,

Laurent Pinchart

