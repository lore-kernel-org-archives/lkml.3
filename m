Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755077AbaCNOyR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Mar 2014 10:54:17 -0400
Received: from eusmtp01.atmel.com ([212.144.249.242]:33862 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754182AbaCNOyQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Mar 2014 10:54:16 -0400
Message-ID: <53231811.1020309@atmel.com>
Date: Fri, 14 Mar 2014 15:54:09 +0100
From: Nicolas Ferre <nicolas.ferre@atmel.com>
Organization: atmel
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Alexandre Belloni <alexandre.belloni@free-electrons.com>,
        Thierry Reding <thierry.reding@gmail.com>
CC: <linux-kernel@vger.kernel.org>, Bo Shen <voice.shen@atmel.com>,
        <linux-pwm@vger.kernel.org>
Subject: Re: [PATCH 2/2] PWM: atmel: correct CDTY calculation
References: <1394806749-29778-1-git-send-email-alexandre.belloni@free-electrons.com> <1394806749-29778-3-git-send-email-alexandre.belloni@free-electrons.com>
In-Reply-To: <1394806749-29778-3-git-send-email-alexandre.belloni@free-electrons.com>
X-Enigmail-Version: 1.5.2
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.161.30.18]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 14/03/2014 15:19, Alexandre Belloni :
>>From the datasheet, the actual duty cycle is:
> (period - (1/clk) * CDTY)/period
> 
> This actually correct the polarity of the PWM and solves the issue that pwm-leds
> exhibits: when setting a duty cycle of 0 and then disabling a channel, the level
> was wrong (1 when the polarity was normal and 0 when the polarity was inversed).
> 
> Signed-off-by: Alexandre Belloni <alexandre.belloni@free-electrons.com>

Acked-by: Nicolas Ferre <nicolas.ferre@atmel.com>

> ---
>  drivers/pwm/pwm-atmel.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/pwm/pwm-atmel.c b/drivers/pwm/pwm-atmel.c
> index 2d69e9c431dd..0adc952cc4ef 100644
> --- a/drivers/pwm/pwm-atmel.c
> +++ b/drivers/pwm/pwm-atmel.c
> @@ -133,7 +133,7 @@ static int atmel_pwm_config(struct pwm_chip *chip, struct pwm_device *pwm,
>  	prd = div;
>  	div *= duty_ns;
>  	do_div(div, period_ns);
> -	dty = div;
> +	dty = prd - div;
>  
>  	ret = clk_enable(atmel_pwm->clk);
>  	if (ret) {
> 


-- 
Nicolas Ferre
