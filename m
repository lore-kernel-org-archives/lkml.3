Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754155AbaLIIu4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Dec 2014 03:50:56 -0500
Received: from mail-ie0-f182.google.com ([209.85.223.182]:49984 "EHLO
	mail-ie0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752365AbaLIIuy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Dec 2014 03:50:54 -0500
Date: Tue, 9 Dec 2014 08:50:47 +0000
From: Lee Jones <lee.jones@linaro.org>
To: Jacek Anaszewski <j.anaszewski@samsung.com>
Cc: linux-leds@vger.kernel.org, linux-media@vger.kernel.org,
        linux-kernel@vger.kernel.org, kyungmin.park@samsung.com,
        b.zolnierkie@samsung.com, pavel@ucw.cz, cooloney@gmail.com,
        rpurdie@rpsys.net, sakari.ailus@iki.fi, s.nawrocki@samsung.com,
        robh+dt@kernel.org, pawel.moll@arm.com, mark.rutland@arm.com,
        ijc+devicetree@hellion.org.uk, galak@codeaurora.org,
        Chanwoo Choi <cw00.choi@samsung.com>
Subject: Re: [PATCH/RFC v9 04/19] mfd: max77693: adjust
 max77693_led_platform_data
Message-ID: <20141209085047.GR3951@x1>
References: <1417622814-10845-1-git-send-email-j.anaszewski@samsung.com>
 <1417622814-10845-5-git-send-email-j.anaszewski@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1417622814-10845-5-git-send-email-j.anaszewski@samsung.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 03 Dec 2014, Jacek Anaszewski wrote:

> Add "label" array for Device Tree strings with the name of a LED device
> and make flash_timeout a two element array, for caching the sub-led
> related flash timeout. Added is also an array for caching pointers to the
> sub-nodes representing sub-leds.
> 
> Signed-off-by: Jacek Anaszewski <j.anaszewski@samsung.com>
> Acked-by: Kyungmin Park <kyungmin.park@samsung.com>
> Cc: Chanwoo Choi <cw00.choi@samsung.com>
> Cc: Lee Jones <lee.jones@linaro.org>
> ---
>  include/linux/mfd/max77693.h |    4 +++-
>  1 file changed, 3 insertions(+), 1 deletion(-)
> 
> diff --git a/include/linux/mfd/max77693.h b/include/linux/mfd/max77693.h
> index f0b6585..c80ee99 100644
> --- a/include/linux/mfd/max77693.h
> +++ b/include/linux/mfd/max77693.h
> @@ -88,16 +88,18 @@ enum max77693_led_boost_mode {
>  };
>  
>  struct max77693_led_platform_data {
> +	const char *label[2];
>  	u32 fleds[2];
>  	u32 iout_torch[2];
>  	u32 iout_flash[2];
>  	u32 trigger[2];
>  	u32 trigger_type[2];
> +	u32 flash_timeout[2];
>  	u32 num_leds;
>  	u32 boost_mode;
> -	u32 flash_timeout;
>  	u32 boost_vout;
>  	u32 low_vsys;
> +	struct device_node *sub_nodes[2];

I haven't seen anyone do this before.  Why can't you use the provided
OF functions to traverse through your tree?

>  };
>  
>  /* MAX77693 */

-- 
Lee Jones
Linaro STMicroelectronics Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
