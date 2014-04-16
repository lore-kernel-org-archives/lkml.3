Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755924AbaDPKfv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Apr 2014 06:35:51 -0400
Received: from mail-we0-f175.google.com ([74.125.82.175]:45990 "EHLO
	mail-we0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755527AbaDPKfq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Apr 2014 06:35:46 -0400
Date: Wed, 16 Apr 2014 11:35:40 +0100
From: Lee Jones <lee.jones@linaro.org>
To: Jacek Anaszewski <j.anaszewski@samsung.com>
Cc: linux-media@vger.kernel.org, linux-leds@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        s.nawrocki@samsung.com, a.hajda@samsung.com, kyungmin.park@samsung.com,
        Bryan Wu <cooloney@gmail.com>, Richard Purdie <rpurdie@rpsys.net>,
        SangYoung Son <hello.son@smasung.com>,
        Samuel Ortiz <sameo@linux.intel.com>
Subject: Re: [PATCH/RFC v3 3/5] leds: Add support for max77693 mfd flash cell
Message-ID: <20140416103540.GM4754@lee--X1>
References: <1397228216-6657-1-git-send-email-j.anaszewski@samsung.com>
 <1397228216-6657-4-git-send-email-j.anaszewski@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1397228216-6657-4-git-send-email-j.anaszewski@samsung.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> This patch adds led-flash support to Maxim max77693 chipset.
> A device can be exposed to user space through LED subsystem
> sysfs interface or through V4L2 subdevice when the support
> for V4L2 Flash sub-devices is enabled. Device supports up to
> two leds which can work in flash and torch mode. Leds can
> be triggered externally or by software.
> 
> Signed-off-by: Andrzej Hajda <a.hajda@samsung.com>
> Signed-off-by: Jacek Anaszewski <j.anaszewski@samsung.com>
> Acked-by: Kyungmin Park <kyungmin.park@samsung.com>
> Cc: Bryan Wu <cooloney@gmail.com>
> Cc: Richard Purdie <rpurdie@rpsys.net>
> Cc: SangYoung Son <hello.son@smasung.com>
> Cc: Samuel Ortiz <sameo@linux.intel.com>
> Cc: Lee Jones <lee.jones@linaro.org>
> ---
>  drivers/leds/Kconfig         |   10 +
>  drivers/leds/Makefile        |    1 +
>  drivers/leds/leds-max77693.c |  794 ++++++++++++++++++++++++++++++++++++++++++
>  drivers/mfd/max77693.c       |    2 +-
>  include/linux/mfd/max77693.h |   38 ++
>  5 files changed, 844 insertions(+), 1 deletion(-)
>  create mode 100644 drivers/leds/leds-max77693.c

[...]

> diff --git a/drivers/mfd/max77693.c b/drivers/mfd/max77693.c
> index c5535f0..f061aa8 100644
> --- a/drivers/mfd/max77693.c
> +++ b/drivers/mfd/max77693.c
> @@ -44,7 +44,7 @@
>  static const struct mfd_cell max77693_devs[] = {
>  	{ .name = "max77693-pmic", },
>  	{ .name = "max77693-charger", },
> -	{ .name = "max77693-flash", },
> +	{ .name = "max77693-flash", .of_compatible = "maxim,max77693-flash", },

I would prefer for this to be opened up i.e. not on one line.

>  	{ .name = "max77693-muic", },
>  	{ .name = "max77693-haptic", },
>  };
> diff --git a/include/linux/mfd/max77693.h b/include/linux/mfd/max77693.h
> index 3f3dc45..f2285b7 100644
> --- a/include/linux/mfd/max77693.h
> +++ b/include/linux/mfd/max77693.h
> @@ -63,6 +63,43 @@ struct max77693_muic_platform_data {
>  	int path_uart;
>  };
>  
> +/* MAX77693 led flash */
> +
> +/* triggers */
> +enum max77693_led_trigger {
> +	MAX77693_LED_TRIG_OFF,
> +	MAX77693_LED_TRIG_FLASH,
> +	MAX77693_LED_TRIG_TORCH,
> +	MAX77693_LED_TRIG_EXT,
> +	MAX77693_LED_TRIG_SOFT,
> +};
> +
> +

Extra '\n' here.

> +/* trigger types */
> +enum max77693_led_trigger_type {
> +	MAX77693_LED_TRIG_TYPE_EDGE,
> +	MAX77693_LED_TRIG_TYPE_LEVEL,
> +};
> +
> +/* boost modes */
> +enum max77693_led_boost_mode {
> +	MAX77693_LED_BOOST_NONE,
> +	MAX77693_LED_BOOST_ADAPTIVE,
> +	MAX77693_LED_BOOST_FIXED,
> +};
> +
> +struct max77693_led_platform_data {
> +	u32 iout[4];
> +	u32 trigger[4];
> +	u32 trigger_type[2];
> +	u32 timeout[2];
> +	u32 boost_mode[2];
> +	u32 boost_vout;
> +	u32 low_vsys;
> +};

Bryan will have to review this.

> +/* MAX77693 */
> +
>  struct max77693_platform_data {
>  	/* regulator data */
>  	struct max77693_regulator_data *regulators;
> @@ -70,5 +107,6 @@ struct max77693_platform_data {
>  
>  	/* muic data */
>  	struct max77693_muic_platform_data *muic_data;
> +	struct max77693_led_platform_data *led_data;
>  };
>  #endif	/* __LINUX_MFD_MAX77693_H */

-- 
Lee Jones
Linaro STMicroelectronics Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
