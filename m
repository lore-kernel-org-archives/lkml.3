Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932790AbbAIR4q (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Jan 2015 12:56:46 -0500
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:39302 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750835AbbAIR4o (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Jan 2015 12:56:44 -0500
Date: Fri, 9 Jan 2015 18:56:41 +0100
From: Pavel Machek <pavel@ucw.cz>
To: Jacek Anaszewski <j.anaszewski@samsung.com>
Cc: linux-leds@vger.kernel.org, linux-media@vger.kernel.org,
        linux-kernel@vger.kernel.org, devicetree@vger.kernel.org,
        kyungmin.park@samsung.com, b.zolnierkie@samsung.com,
        cooloney@gmail.com, rpurdie@rpsys.net, sakari.ailus@iki.fi,
        s.nawrocki@samsung.com, Chanwoo Choi <cw00.choi@samsung.com>,
        Lee Jones <lee.jones@linaro.org>
Subject: Re: [PATCH/RFC v10 06/19] mfd: max77693: modifications around
 max77693_led_platform_data
Message-ID: <20150109175641.GH18076@amd>
References: <1420816989-1808-1-git-send-email-j.anaszewski@samsung.com>
 <1420816989-1808-7-git-send-email-j.anaszewski@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1420816989-1808-7-git-send-email-j.anaszewski@samsung.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri 2015-01-09 16:22:56, Jacek Anaszewski wrote:
> 1. Rename max77693_led_platform_data to max77693_led_config_data to
>    avoid making impression that the led driver expects a board file -
>    it relies on Device Tree data.
> 2. Remove fleds array, as the DT binding design has changed
> 3. Add "label" array for Device Tree strings with the name of a LED device
> 4. Make flash_timeout a two element array, for caching the sub-led
>    related flash timeout.
> 5. Remove trigger array as the related data will not be provided
>    in the DT binding
> 
> Signed-off-by: Jacek Anaszewski <j.anaszewski@samsung.com>
> Acked-by: Kyungmin Park <kyungmin.park@samsung.com>
> Cc: Chanwoo Choi <cw00.choi@samsung.com>
> Cc: Lee Jones <lee.jones@linaro.org>

Seems that max77693_led_platform_data is unused at the moment, so it
should not break bisect.

Acked-by: Pavel Machek <pavel@ucw.cz>

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

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
