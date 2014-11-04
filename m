Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752284AbaKDIZU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Nov 2014 03:25:20 -0500
Received: from mail-ig0-f177.google.com ([209.85.213.177]:59306 "EHLO
	mail-ig0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751017AbaKDIZQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Nov 2014 03:25:16 -0500
Date: Tue, 4 Nov 2014 08:25:10 +0000
From: Lee Jones <lee.jones@linaro.org>
To: Heiko =?iso-8859-1?Q?St=FCbner?= <heiko@sntech.de>
Cc: Jingoo Han <jg1.han@samsung.com>, Bryan Wu <cooloney@gmail.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] backlight: extend of_find_backlight_by_node stub-check
 to modules
Message-ID: <20141104082510.GF17577@x1>
References: <16457372.FsSJIFmsla@diego>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <16457372.FsSJIFmsla@diego>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 04 Nov 2014, Heiko Stübner wrote:

> Commit de3d75dc2311 ("backlight: Use of_find_backlight_by_node stub when
> backlight class disabled") did not take into account that the backlight
> class can also be compiled as module. Extend the check to prevent
> redefinition warnings when the backlight device class is compiled as module.
> 
> Reported-by: kbuild test robot
> Signed-off-by: Heiko Stuebner <heiko@sntech.de>
> ---
>  include/linux/backlight.h | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)

Applied with Jingoo's Ack.

> diff --git a/include/linux/backlight.h b/include/linux/backlight.h
> index d9cb644..92b9817 100644
> --- a/include/linux/backlight.h
> +++ b/include/linux/backlight.h
> @@ -157,7 +157,8 @@ struct generic_bl_info {
>  	void (*kick_battery)(void);
>  };
>  
> -#if defined(CONFIG_OF) && defined(CONFIG_BACKLIGHT_CLASS_DEVICE)
> +#if defined(CONFIG_OF) && (defined(CONFIG_BACKLIGHT_CLASS_DEVICE) || \
> +			   defined(CONFIG_BACKLIGHT_CLASS_DEVICE_MODULE))
>  struct backlight_device *of_find_backlight_by_node(struct device_node *node);
>  #else
>  static inline struct backlight_device *

-- 
Lee Jones
Linaro STMicroelectronics Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
