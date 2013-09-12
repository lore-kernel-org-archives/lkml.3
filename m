Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754247Ab3ILPkI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Sep 2013 11:40:08 -0400
Received: from mail-wi0-f175.google.com ([209.85.212.175]:57427 "EHLO
	mail-wi0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753153Ab3ILPkF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Sep 2013 11:40:05 -0400
Date: Thu, 12 Sep 2013 16:40:00 +0100
From: Lee Jones <lee.jones@linaro.org>
To: Milo Kim <milo.kim@ti.com>
Cc: Samuel Ortiz <sameo@linux.intel.com>, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org, linux-pwm@vger.kernel.org,
        Linus Walleij <linus.walleij@linaro.org>,
        Thierry Reding <thierry.reding@gmail.com>
Subject: Re: [PATCH v3 1/4] mfd: add LP3943 MFD driver
Message-ID: <20130912154000.GP11227@lee--X1>
References: <1378949524-6143-1-git-send-email-milo.kim@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1378949524-6143-1-git-send-email-milo.kim@ti.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 12 Sep 2013, Milo Kim wrote:

> LP3943 has 16 output pins which can be used as GPIO expander and PWM generator.
> 
> * Regmap I2C interface for R/W LP3943 registers
> 
> * Atomic operations for output pin assignment
>   The driver should check whether requested pin is available or not.
>   If the pin is already used, pin request returns as a failure.
>   A driver data, 'pin_used' is checked when gpio_request() and
>   pwm_request() are called. If the pin is available, then pin_used is set.
>   And it is cleared when gpio_free() and pwm_free().
> 
> * Device tree support
>   Compatible strings for GPIO and PWM driver.
>   LP3943 platform data is PWM related, so parsing the device tree is
>   implemented in the PWM driver.
> 
> Cc: Lee Jones <lee.jones@linaro.org>
> Cc: Linus Walleij <linus.walleij@linaro.org>
> Cc: Samuel Ortiz <sameo@linux.intel.com>
> Cc: Thierry Reding <thierry.reding@gmail.com>
> Signed-off-by: Milo Kim <milo.kim@ti.com>
> ---
> * Patch v3
>   Now, output pin number is exactly matched with enum value of '
>   lp3943_pwm_output'.
>   Use dev_get_platdata() helper function in probe().
>   Use module_i2c_driver() for initcall.
> 
> * Patch v2
>   Handle atomic operations for output pin assignment.
> 
>  drivers/mfd/Kconfig        |   11 ++++
>  drivers/mfd/Makefile       |    1 +
>  drivers/mfd/lp3943.c       |  148 ++++++++++++++++++++++++++++++++++++++++++++
>  include/linux/mfd/lp3943.h |  114 ++++++++++++++++++++++++++++++++++
>  4 files changed, 274 insertions(+)
>  create mode 100644 drivers/mfd/lp3943.c
>  create mode 100644 include/linux/mfd/lp3943.h

Code looks good to me. For the MFD parts:

Acked-by: Lee Jones <lee.jones@linaro.org>

-- 
Lee Jones
Linaro STMicroelectronics Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
