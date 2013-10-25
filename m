Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754860Ab3JYUFR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Oct 2013 16:05:17 -0400
Received: from filtteri2.pp.htv.fi ([213.243.153.185]:47699 "EHLO
	filtteri2.pp.htv.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751619Ab3JYUFN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Oct 2013 16:05:13 -0400
Date: Fri, 25 Oct 2013 23:05:03 +0300
From: Aaro Koskinen <aaro.koskinen@iki.fi>
To: Sebastian Reichel <sre@debian.org>
Cc: Sebastian Reichel <sre@ring0.de>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Grant Likely <grant.likely@linaro.org>,
        Rob Herring <rob.herring@calxeda.com>,
        Peter Ujfalusi <peter.ujfalusi@ti.com>,
        Sachin Kamat <sachin.kamat@linaro.org>,
        Florian Vaussard <florian.vaussard@epfl.ch>,
        linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org
Subject: Re: [PATCHv6 2/3] Input: twl4030-pwrbutton: use dev_err for errors
Message-ID: <20131025200503.GE17447@blackmetal.musicnaut.iki.fi>
References: <1382626126-12565-1-git-send-email-sre@debian.org>
 <1382626126-12565-3-git-send-email-sre@debian.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1382626126-12565-3-git-send-email-sre@debian.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Thu, Oct 24, 2013 at 04:48:45PM +0200, Sebastian Reichel wrote:
> Use dev_err() to output errors instead of dev_dbg().
> 
> Signed-off-by: Sebastian Reichel <sre@debian.org>

Reviewed-by: Aaro Koskinen <aaro.koskinen@iki.fi>

> ---
>  drivers/input/misc/twl4030-pwrbutton.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/input/misc/twl4030-pwrbutton.c b/drivers/input/misc/twl4030-pwrbutton.c
> index a3a0fe3..48639ff 100644
> --- a/drivers/input/misc/twl4030-pwrbutton.c
> +++ b/drivers/input/misc/twl4030-pwrbutton.c
> @@ -74,13 +74,13 @@ static int twl4030_pwrbutton_probe(struct platform_device *pdev)
>  			IRQF_TRIGGER_FALLING | IRQF_TRIGGER_RISING,
>  			"twl4030_pwrbutton", pwr);
>  	if (err < 0) {
> -		dev_dbg(&pdev->dev, "Can't get IRQ for pwrbutton: %d\n", err);
> +		dev_err(&pdev->dev, "Can't get IRQ for pwrbutton: %d\n", err);
>  		goto free_input_dev;
>  	}
>  
>  	err = input_register_device(pwr);
>  	if (err) {
> -		dev_dbg(&pdev->dev, "Can't register power button: %d\n", err);
> +		dev_err(&pdev->dev, "Can't register power button: %d\n", err);
>  		goto free_irq;
>  	}
>  
> -- 
> 1.8.4.rc3
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
