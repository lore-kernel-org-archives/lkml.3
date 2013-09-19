Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752980Ab3ISHYY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Sep 2013 03:24:24 -0400
Received: from eusmtp01.atmel.com ([212.144.249.242]:59143 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752774Ab3ISHYX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Sep 2013 03:24:23 -0400
Message-ID: <523AA6A1.4070000@atmel.com>
Date: Thu, 19 Sep 2013 09:24:17 +0200
From: Nicolas Ferre <nicolas.ferre@atmel.com>
Organization: atmel
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130803 Thunderbird/17.0.8
MIME-Version: 1.0
To: Boris BREZILLON <b.brezillon@overkiz.com>
CC: Thierry Reding <thierry.reding@gmail.com>, <linux-pwm@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH 1/2] pwm: atmel-tcb: add missing clk source config
References: <1379516720-23289-1-git-send-email-b.brezillon@overkiz.com> <1379516765-23342-1-git-send-email-b.brezillon@overkiz.com>
In-Reply-To: <1379516765-23342-1-git-send-email-b.brezillon@overkiz.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.161.30.18]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 18/09/2013 17:06, Boris BREZILLON :
> Clock source changes are never applied to the CMR register.
> This may lead to wrong period/duty cycle configuration.
>
> Signed-off-by: Boris BREZILLON <b.brezillon@overkiz.com>

Acked-by: Nicolas Ferre <nicolas.ferre@atmel.com>

> ---
>   drivers/pwm/pwm-atmel-tcb.c |    2 ++
>   1 file changed, 2 insertions(+)
>
> diff --git a/drivers/pwm/pwm-atmel-tcb.c b/drivers/pwm/pwm-atmel-tcb.c
> index ba6ce01..0266969 100644
> --- a/drivers/pwm/pwm-atmel-tcb.c
> +++ b/drivers/pwm/pwm-atmel-tcb.c
> @@ -249,6 +249,8 @@ static int atmel_tcb_pwm_enable(struct pwm_chip *chip, struct pwm_device *pwm)
>   		}
>   	}
>
> +	cmr |= (tcbpwm->div & ATMEL_TC_TCCLKS);
> +
>   	__raw_writel(cmr, regs + ATMEL_TC_REG(group, CMR));
>
>   	if (index == 0)
>


-- 
Nicolas Ferre
