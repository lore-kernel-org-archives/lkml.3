Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753072Ab3ISHY4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Sep 2013 03:24:56 -0400
Received: from eusmtp01.atmel.com ([212.144.249.242]:59273 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752589Ab3ISHYz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Sep 2013 03:24:55 -0400
Message-ID: <523AA6C4.6000305@atmel.com>
Date: Thu, 19 Sep 2013 09:24:52 +0200
From: Nicolas Ferre <nicolas.ferre@atmel.com>
Organization: atmel
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130803 Thunderbird/17.0.8
MIME-Version: 1.0
To: Boris BREZILLON <b.brezillon@overkiz.com>,
        Thierry Reding <thierry.reding@gmail.com>
CC: <linux-pwm@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH 2/2] pwm: atmel-tcb: fix max time computation for slow
 clk source
References: <1379516720-23289-1-git-send-email-b.brezillon@overkiz.com> <1379516781-23379-1-git-send-email-b.brezillon@overkiz.com>
In-Reply-To: <1379516781-23379-1-git-send-email-b.brezillon@overkiz.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.161.30.18]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 18/09/2013 17:06, Boris BREZILLON :
> Use the the tcb counter width to compute the maximum time that can be
> represented using the slow clock source instead of the static 16 bit width.
>
> Signed-off-by: Boris BREZILLON <b.brezillon@overkiz.com>

Acked-by: Nicolas Ferre <nicolas.ferre@atmel.com>

> ---
>   drivers/pwm/pwm-atmel-tcb.c |    2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/drivers/pwm/pwm-atmel-tcb.c b/drivers/pwm/pwm-atmel-tcb.c
> index 0266969..f3dcd02 100644
> --- a/drivers/pwm/pwm-atmel-tcb.c
> +++ b/drivers/pwm/pwm-atmel-tcb.c
> @@ -307,7 +307,7 @@ static int atmel_tcb_pwm_config(struct pwm_chip *chip, struct pwm_device *pwm,
>   		i = slowclk;
>   		rate = 32768;
>   		min = div_u64(NSEC_PER_SEC, rate);
> -		max = min << 16;
> +		max = min << tc->tcb_config->counter_width;
>
>   		/* If period is too big return ERANGE error */
>   		if (max < period_ns)
>


-- 
Nicolas Ferre
