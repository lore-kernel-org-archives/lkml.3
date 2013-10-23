Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752337Ab3JWQKh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Oct 2013 12:10:37 -0400
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:63493 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750847Ab3JWQKf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Oct 2013 12:10:35 -0400
Date: Wed, 23 Oct 2013 17:09:36 +0100
From: Mark Rutland <mark.rutland@arm.com>
To: Sebastian Reichel <sre@debian.org>
Cc: Sebastian Reichel <sre@ring0.de>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        "grant.likely@linaro.org" <grant.likely@linaro.org>,
        "rob.herring@calxeda.com" <rob.herring@calxeda.com>,
        Peter Ujfalusi <peter.ujfalusi@ti.com>,
        Sachin Kamat <sachin.kamat@linaro.org>,
        "linux-input@vger.kernel.org" <linux-input@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>
Subject: Re: [PATCHv2 1/3] Input: twl4030-pwrbutton - add device tree support
Message-ID: <20131023160934.GA6042@kartoffel>
References: <1382540482-12261-1-git-send-email-sre@debian.org>
 <1382540482-12261-2-git-send-email-sre@debian.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1382540482-12261-2-git-send-email-sre@debian.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 23, 2013 at 04:01:20PM +0100, Sebastian Reichel wrote:
> Add device tree support for twl4030 power button driver.

This requires a binding document. As it is it's not possible to review.

Mark.

> 
> Signed-off-by: Sebastian Reichel <sre@debian.org>
> ---
>  drivers/input/misc/twl4030-pwrbutton.c | 16 ++++++++++++----
>  1 file changed, 12 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/input/misc/twl4030-pwrbutton.c b/drivers/input/misc/twl4030-pwrbutton.c
> index b9a05fd..a3a0fe3 100644
> --- a/drivers/input/misc/twl4030-pwrbutton.c
> +++ b/drivers/input/misc/twl4030-pwrbutton.c
> @@ -52,7 +52,7 @@ static irqreturn_t powerbutton_irq(int irq, void *_pwr)
>  	return IRQ_HANDLED;
>  }
>  
> -static int __init twl4030_pwrbutton_probe(struct platform_device *pdev)
> +static int twl4030_pwrbutton_probe(struct platform_device *pdev)
>  {
>  	struct input_dev *pwr;
>  	int irq = platform_get_irq(pdev, 0);
> @@ -106,16 +106,24 @@ static int __exit twl4030_pwrbutton_remove(struct platform_device *pdev)
>  	return 0;
>  }
>  
> +#if IS_ENABLED(CONFIG_OF)
> +static const struct of_device_id twl4030_pwrbutton_dt_match_table[] = {
> +       { .compatible = "ti,twl4030-pwrbutton" },

There's no need to shorten this, "ti,twl4030-power-button" would be far easier
to understand. Unless the datasheet refers to it as pwrbutton?

Thanks,
Mark.
