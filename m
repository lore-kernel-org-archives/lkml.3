Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934829AbaDJNvn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Apr 2014 09:51:43 -0400
Received: from eusmtp01.atmel.com ([212.144.249.243]:37216 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933057AbaDJNvj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Apr 2014 09:51:39 -0400
Message-ID: <5346A1E7.4010000@atmel.com>
Date: Thu, 10 Apr 2014 15:51:35 +0200
From: Nicolas Ferre <nicolas.ferre@atmel.com>
Organization: atmel
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Alexandre Belloni <alexandre.belloni@free-electrons.com>,
        Thierry Reding <thierry.reding@gmail.com>
CC: <linux-pwm@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH] pwm: atmel: set pwm_chip can_sleep flag
References: <1397067969-19905-1-git-send-email-alexandre.belloni@free-electrons.com>
In-Reply-To: <1397067969-19905-1-git-send-email-alexandre.belloni@free-electrons.com>
X-Enigmail-Version: 1.5.2
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.161.30.18]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/04/2014 20:26, Alexandre Belloni :
> atmel_pwm_config() calls clk_get_rate() which might sleep, so we need to set
> pwm_chip can_sleep flag.
> 
> Signed-off-by: Alexandre Belloni <alexandre.belloni@free-electrons.com>

Acked-by: Nicolas Ferre <nicolas.ferre@atmel.com>

> ---
>  drivers/pwm/pwm-atmel.c | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/drivers/pwm/pwm-atmel.c b/drivers/pwm/pwm-atmel.c
> index 0e589594b1cb..180e34e46617 100644
> --- a/drivers/pwm/pwm-atmel.c
> +++ b/drivers/pwm/pwm-atmel.c
> @@ -369,6 +369,7 @@ static int atmel_pwm_probe(struct platform_device *pdev)
>  
>  	atmel_pwm->chip.base = -1;
>  	atmel_pwm->chip.npwm = 4;
> +	atmel_pwm->chip.can_sleep = true;
>  	atmel_pwm->config = data->config;
>  
>  	ret = pwmchip_add(&atmel_pwm->chip);
> 


-- 
Nicolas Ferre
