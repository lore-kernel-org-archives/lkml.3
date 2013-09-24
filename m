Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750957Ab3IXEoj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Sep 2013 00:44:39 -0400
Received: from kirsty.vergenet.net ([202.4.237.240]:40997 "EHLO
	kirsty.vergenet.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750857Ab3IXEoh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Sep 2013 00:44:37 -0400
Date: Tue, 24 Sep 2013 13:44:32 +0900
From: Simon Horman <horms@verge.net.au>
To: takasi-y@ops.dti.ne.jp
Cc: SH-Linux <linux-sh@vger.kernel.org>, Magnus Damm <magnus.damm@gmail.com>,
        ben.dooks@codethink.co.uk,
        Shinya Kuribayashi <shinya.kuribayashi.px@renesas.com>,
        devicetree@vger.kernel.org, linux-serial@vger.kernel.org,
        Paul Mundt <lethal@linux-sh.org>,
        Mike Turquette <mturquette@linaro.org>, linux-kernel@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Re: [PATCH 2/6] serial8250-em: convert to clk_prepare/unprepare
Message-ID: <20130924044432.GD3619@verge.net.au>
References: <52410F86.4040301@renesas.com>
 <20130924131039.3c871cad7acb2a068a988d0f@ops.dti.ne.jp>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130924131039.3c871cad7acb2a068a988d0f@ops.dti.ne.jp>
Organisation: Horms Solutions Ltd.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[ CCed Greg Kroah-Hartman, the serial maintainer for his review ]

On Tue, Sep 24, 2013 at 01:10:39PM +0900, takasi-y@ops.dti.ne.jp wrote:
> From: Shinya Kuribayashi <shinya.kuribayashi.px@renesas.com>
> 
> Add calls to clk_prepare and unprepare so that EMMA Mobile EV2 can
> migrate to the common clock framework.
> 
> Signed-off-by: Shinya Kuribayashi <shinya.kuribayashi.px@renesas.com>
> [takashi.yoshii.ze@renesas.com: edited for conflicts]
> Signed-off-by: Takashi Yoshii <takashi.yoshii.zj@renesas.com>
> ---
>  drivers/tty/serial/8250/8250_em.c | 6 +++---
>  1 file changed, 3 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/tty/serial/8250/8250_em.c b/drivers/tty/serial/8250/8250_em.c
> index 5f3bba1..d1a9078 100644
> --- a/drivers/tty/serial/8250/8250_em.c
> +++ b/drivers/tty/serial/8250/8250_em.c
> @@ -122,7 +122,7 @@ static int serial8250_em_probe(struct platform_device *pdev)
>  	up.port.dev = &pdev->dev;
>  	up.port.private_data = priv;
>  
> -	clk_enable(priv->sclk);
> +	clk_prepare_enable(priv->sclk);
>  	up.port.uartclk = clk_get_rate(priv->sclk);
>  
>  	up.port.iotype = UPIO_MEM32;
> @@ -134,7 +134,7 @@ static int serial8250_em_probe(struct platform_device *pdev)
>  	ret = serial8250_register_8250_port(&up);
>  	if (ret < 0) {
>  		dev_err(&pdev->dev, "unable to register 8250 port\n");
> -		clk_disable(priv->sclk);
> +		clk_disable_unprepare(priv->sclk);
>  		return ret;
>  	}
>  
> @@ -148,7 +148,7 @@ static int serial8250_em_remove(struct platform_device *pdev)
>  	struct serial8250_em_priv *priv = platform_get_drvdata(pdev);
>  
>  	serial8250_unregister_port(priv->line);
> -	clk_disable(priv->sclk);
> +	clk_disable_unprepare(priv->sclk);
>  	return 0;
>  }
>  
> -- 
> 1.8.1.5
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-sh" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
