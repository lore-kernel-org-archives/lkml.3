Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161248AbaDQKwV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Apr 2014 06:52:21 -0400
Received: from mail-we0-f174.google.com ([74.125.82.174]:60828 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754328AbaDQKwU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Apr 2014 06:52:20 -0400
Date: Thu, 17 Apr 2014 11:52:14 +0100
From: Lee Jones <lee.jones@linaro.org>
To: Linus Walleij <linus.walleij@linaro.org>
Cc: Samuel Ortiz <sameo@linux.intel.com>, linux-kernel@vger.kernel.org,
        Silvio F <silvio.fricke@gmail.com>,
        Philipp Zabel <p.zabel@pengutronix.de>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        Shawn Guo <shawn.guo@linaro.org>,
        Viresh Kumar <viresh.linux@gmail.com>,
        Shiraz Hashim <shiraz.hashim@st.com>, spear-devel@list.st.com
Subject: Re: [PATCH 4/6] mfd: stmpe: mask off unused blocks properly
Message-ID: <20140417105214.GN28725@lee--X1>
References: <1397659455-13638-1-git-send-email-linus.walleij@linaro.org>
 <1397659455-13638-5-git-send-email-linus.walleij@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1397659455-13638-5-git-send-email-linus.walleij@linaro.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> The STMPE driver would just read/modify/write the system control
> register on the STMPE1601, meaning it would not properly mask off
> the PWM block, which remained active if it was on at boot time.
> This makes sure the blocks are always masked off if they were
> active on boot, saving some power. Also rename the inconsistenty
> named STMPE1601 define for the PWM block activation.
> 
> Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
> ---
>  drivers/mfd/stmpe.c | 9 +++++++++
>  drivers/mfd/stmpe.h | 2 +-
>  2 files changed, 10 insertions(+), 1 deletion(-)

Patch looks good to me.

Acked-by: Lee Jones <lee.jones@linaro.org>

> diff --git a/drivers/mfd/stmpe.c b/drivers/mfd/stmpe.c
> index 692452442ead..065c923cb2a9 100644
> --- a/drivers/mfd/stmpe.c
> +++ b/drivers/mfd/stmpe.c
> @@ -606,9 +606,18 @@ static int stmpe1601_enable(struct stmpe *stmpe, unsigned int blocks,
>  
>  	if (blocks & STMPE_BLOCK_GPIO)
>  		mask |= STMPE1601_SYS_CTRL_ENABLE_GPIO;
> +	else
> +		mask &= ~STMPE1601_SYS_CTRL_ENABLE_GPIO;
>  
>  	if (blocks & STMPE_BLOCK_KEYPAD)
>  		mask |= STMPE1601_SYS_CTRL_ENABLE_KPC;
> +	else
> +		mask &= ~STMPE1601_SYS_CTRL_ENABLE_KPC;
> +
> +	if (blocks & STMPE_BLOCK_PWM)
> +		mask |= STMPE1601_SYS_CTRL_ENABLE_SPWM;
> +	else
> +		mask &= ~STMPE1601_SYS_CTRL_ENABLE_SPWM;
>  
>  	return __stmpe_set_bits(stmpe, STMPE1601_REG_SYS_CTRL, mask,
>  				enable ? mask : 0);
> diff --git a/drivers/mfd/stmpe.h b/drivers/mfd/stmpe.h
> index 6639f1b0fef5..9e4d21d37a11 100644
> --- a/drivers/mfd/stmpe.h
> +++ b/drivers/mfd/stmpe.h
> @@ -192,7 +192,7 @@ int stmpe_remove(struct stmpe *stmpe);
>  
>  #define STMPE1601_SYS_CTRL_ENABLE_GPIO		(1 << 3)
>  #define STMPE1601_SYS_CTRL_ENABLE_KPC		(1 << 1)
> -#define STMPE1601_SYSCON_ENABLE_SPWM		(1 << 0)
> +#define STMPE1601_SYS_CTRL_ENABLE_SPWM		(1 << 0)
>  
>  /* The 1601/2403 share the same masks */
>  #define STMPE1601_AUTOSLEEP_TIMEOUT_MASK	(0x7)

-- 
Lee Jones
Linaro STMicroelectronics Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
