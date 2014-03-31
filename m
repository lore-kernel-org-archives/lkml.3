Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753476AbaCaHsQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Mar 2014 03:48:16 -0400
Received: from mail-wg0-f47.google.com ([74.125.82.47]:62131 "EHLO
	mail-wg0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753005AbaCaHsN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Mar 2014 03:48:13 -0400
Date: Mon, 31 Mar 2014 08:48:08 +0100
From: Lee Jones <lee.jones@linaro.org>
To: Jacek Anaszewski <j.anaszewski@samsung.com>
Cc: linux-media@vger.kernel.org, linux-leds@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        s.nawrocki@samsung.com, a.hajda@samsung.com, kyungmin.park@samsung.com,
        Bryan Wu <cooloney@gmail.com>, Richard Purdie <rpurdie@rpsys.net>,
        SangYoung Son <hello.son@smasung.com>,
        Samuel Ortiz <sameo@linux.intel.com>
Subject: Re: [PATCH/RFC v2 4/8] leds: Add support for max77693 mfd flash cell
Message-ID: <20140331074808.GM17779@lee--X1>
References: <1396020545-15727-1-git-send-email-j.anaszewski@samsung.com>
 <1396020545-15727-5-git-send-email-j.anaszewski@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1396020545-15727-5-git-send-email-j.anaszewski@samsung.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 28 Mar 2014, Jacek Anaszewski wrote:

> This patch adds led-flash support to Maxim max77693 chipset.
> Device can be exposed to user space through LED subsystem
> sysfs interface or through V4L2 subdevice when the support
> for Multimedia Framework is enabled. Device supports up to
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
>  drivers/leds/leds-max77693.c |  864 ++++++++++++++++++++++++++++++++++++++++++
>  drivers/mfd/max77693.c       |    3 +-
>  include/linux/mfd/max77693.h |   32 ++
>  5 files changed, 909 insertions(+), 1 deletion(-)
>  create mode 100644 drivers/leds/leds-max77693.c

[...]

> diff --git a/drivers/mfd/max77693.c b/drivers/mfd/max77693.c
> index c5535f0..d53c497 100644
> --- a/drivers/mfd/max77693.c
> +++ b/drivers/mfd/max77693.c
> @@ -44,7 +44,8 @@
>  static const struct mfd_cell max77693_devs[] = {
>  	{ .name = "max77693-pmic", },
>  	{ .name = "max77693-charger", },
> -	{ .name = "max77693-flash", },
> +	{ .name = "max77693-flash",
> +	  .of_compatible = "maxim,max77693-flash", },

On one line please.

>  	{ .name = "max77693-muic", },
>  	{ .name = "max77693-haptic", },
>  };
> diff --git a/include/linux/mfd/max77693.h b/include/linux/mfd/max77693.h
> index 3f3dc45..5859698 100644
> --- a/include/linux/mfd/max77693.h
> +++ b/include/linux/mfd/max77693.h
> @@ -63,6 +63,37 @@ struct max77693_muic_platform_data {
>  	int path_uart;
>  };
>  
> +/* MAX77693 led flash */
> +
> +/* triggers */
> +#define MAX77693_LED_TRIG_OFF	0
> +#define MAX77693_LED_TRIG_FLASH	1
> +#define MAX77693_LED_TRIG_TORCH	2
> +#define MAX77693_LED_TRIG_EXT	(MAX77693_LED_TRIG_FLASH |\
> +				MAX77693_LED_TRIG_TORCH)
> +#define MAX77693_LED_TRIG_SOFT	4
> +
> +/* trigger types */
> +#define MAX77693_LED_TRIG_TYPE_EDGE	0
> +#define MAX77693_LED_TRIG_TYPE_LEVEL	1
> +
> +/* boost modes */
> +#define MAX77693_LED_BOOST_NONE		0
> +#define MAX77693_LED_BOOST_ADAPTIVE	1
> +#define MAX77693_LED_BOOST_FIXED	2

I think it would be better to enum all of the above.

> +struct max77693_led_platform_data {
> +	u32 iout[4];
> +	u32 trigger[4];
> +	u32 trigger_type[2];
> +	u32 timeout[2];
> +	u32 boost_mode[2];
> +	u32 boost_vout;
> +	u32 low_vsys;
> +};

I'll leave this LED stuff to the expert(s).

[...]

-- 
Lee Jones
Linaro STMicroelectronics Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
