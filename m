Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753843AbbATLQF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Jan 2015 06:16:05 -0500
Received: from mail-ie0-f176.google.com ([209.85.223.176]:45397 "EHLO
	mail-ie0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752120AbbATLQD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Jan 2015 06:16:03 -0500
Date: Tue, 20 Jan 2015 11:15:55 +0000
From: Lee Jones <lee.jones@linaro.org>
To: Jacek Anaszewski <j.anaszewski@samsung.com>
Cc: linux-leds@vger.kernel.org, linux-media@vger.kernel.org,
        linux-kernel@vger.kernel.org, devicetree@vger.kernel.org,
        kyungmin.park@samsung.com, b.zolnierkie@samsung.com, pavel@ucw.cz,
        cooloney@gmail.com, rpurdie@rpsys.net, sakari.ailus@iki.fi,
        s.nawrocki@samsung.com, Chanwoo Choi <cw00.choi@samsung.com>
Subject: Re: [PATCH/RFC v10 06/19] mfd: max77693: modifications around
 max77693_led_platform_data
Message-ID: <20150120111555.GE13701@x1>
References: <1420816989-1808-1-git-send-email-j.anaszewski@samsung.com>
 <1420816989-1808-7-git-send-email-j.anaszewski@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1420816989-1808-7-git-send-email-j.anaszewski@samsung.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 09 Jan 2015, Jacek Anaszewski wrote:

> 1. Rename max77693_led_platform_data to max77693_led_config_data to
>    avoid making impression that the led driver expects a board file -
>    it relies on Device Tree data.
> 2. Remove fleds array, as the DT binding design has changed
> 3. Add "label" array for Device Tree strings with the name of a LED device
> 4. Make flash_timeout a two element array, for caching the sub-led
>    related flash timeout.
> 5. Remove trigger array as the related data will not be provided
>    in the DT binding

Code looks fine, and I'm sure you've tested this thoroughly.

I'm slightly concerned about current users though.  Are there any?  Is
this patch-set fully bisectable?

> Signed-off-by: Jacek Anaszewski <j.anaszewski@samsung.com>
> Acked-by: Kyungmin Park <kyungmin.park@samsung.com>
> Cc: Chanwoo Choi <cw00.choi@samsung.com>
> Cc: Lee Jones <lee.jones@linaro.org>
> ---
>  include/linux/mfd/max77693.h |    9 ++++-----
>  1 file changed, 4 insertions(+), 5 deletions(-)
> 
> diff --git a/include/linux/mfd/max77693.h b/include/linux/mfd/max77693.h
> index f0b6585..c1ccb13 100644
> --- a/include/linux/mfd/max77693.h
> +++ b/include/linux/mfd/max77693.h
> @@ -87,17 +87,16 @@ enum max77693_led_boost_mode {
>  	MAX77693_LED_BOOST_FIXED,
>  };
>  
> -struct max77693_led_platform_data {
> -	u32 fleds[2];
> +struct max77693_led_config_data {
> +	const char *label[2];
>  	u32 iout_torch[2];
>  	u32 iout_flash[2];
> -	u32 trigger[2];
> -	u32 trigger_type[2];
> +	u32 flash_timeout[2];
>  	u32 num_leds;
>  	u32 boost_mode;
> -	u32 flash_timeout;
>  	u32 boost_vout;
>  	u32 low_vsys;
> +	u32 trigger_type;
>  };
>  
>  /* MAX77693 */

-- 
Lee Jones
Linaro STMicroelectronics Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
