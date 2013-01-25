Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757358Ab3AYNvt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jan 2013 08:51:49 -0500
Received: from devils.ext.ti.com ([198.47.26.153]:39894 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756869Ab3AYNvr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jan 2013 08:51:47 -0500
Message-ID: <51028DE2.1050904@ti.com>
Date: Fri, 25 Jan 2013 14:51:30 +0100
From: Peter Ujfalusi <peter.ujfalusi@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130115 Thunderbird/17.0.2
MIME-Version: 1.0
To: Florian Vaussard <florian.vaussard@epfl.ch>
CC: Bryan Wu <cooloney@gmail.com>, Richard Purdie <rpurdie@rpsys.net>,
        Thierry Reding <thierry.reding@avionic-design.de>,
        <linux-leds@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2 2/3] pwm: Add can_sleep property to drivers
References: <1359121471-21457-1-git-send-email-florian.vaussard@epfl.ch> <1359121471-21457-3-git-send-email-florian.vaussard@epfl.ch>
In-Reply-To: <1359121471-21457-3-git-send-email-florian.vaussard@epfl.ch>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/25/2013 02:44 PM, Florian Vaussard wrote:
> Calls to PWM drivers connected through I2C can sleep.
> Use the new can_sleep property.
> 
> Signed-off-by: Florian Vaussard <florian.vaussard@epfl.ch>

Acked-by: Peter Ujfalusi <peter.ujfalusi@ti.com>

> ---
>  drivers/pwm/pwm-twl-led.c |    1 +
>  drivers/pwm/pwm-twl.c     |    1 +
>  2 files changed, 2 insertions(+), 0 deletions(-)
> 
> diff --git a/drivers/pwm/pwm-twl-led.c b/drivers/pwm/pwm-twl-led.c
> index 9dfa0f3..6261193 100644
> --- a/drivers/pwm/pwm-twl-led.c
> +++ b/drivers/pwm/pwm-twl-led.c
> @@ -300,6 +300,7 @@ static int twl_pwmled_probe(struct platform_device *pdev)
>  
>  	twl->chip.dev = &pdev->dev;
>  	twl->chip.base = -1;
> +	twl->chip.can_sleep = 1;
>  
>  	mutex_init(&twl->mutex);
>  
> diff --git a/drivers/pwm/pwm-twl.c b/drivers/pwm/pwm-twl.c
> index e65db95..4e56cd8 100644
> --- a/drivers/pwm/pwm-twl.c
> +++ b/drivers/pwm/pwm-twl.c
> @@ -315,6 +315,7 @@ static int twl_pwm_probe(struct platform_device *pdev)
>  	twl->chip.dev = &pdev->dev;
>  	twl->chip.base = -1;
>  	twl->chip.npwm = 2;
> +	twl->chip.can_sleep = 1;
>  
>  	mutex_init(&twl->mutex);
>  
> 


-- 
Péter
