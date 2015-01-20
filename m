Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754469AbbATLRa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Jan 2015 06:17:30 -0500
Received: from mail-ig0-f182.google.com ([209.85.213.182]:59124 "EHLO
	mail-ig0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754192AbbATLR0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Jan 2015 06:17:26 -0500
Date: Tue, 20 Jan 2015 11:17:19 +0000
From: Lee Jones <lee.jones@linaro.org>
To: Jacek Anaszewski <j.anaszewski@samsung.com>
Cc: linux-leds@vger.kernel.org, linux-media@vger.kernel.org,
        linux-kernel@vger.kernel.org, devicetree@vger.kernel.org,
        kyungmin.park@samsung.com, b.zolnierkie@samsung.com, pavel@ucw.cz,
        cooloney@gmail.com, rpurdie@rpsys.net, sakari.ailus@iki.fi,
        s.nawrocki@samsung.com, Chanwoo Choi <cw00.choi@samsung.com>
Subject: Re: [PATCH/RFC v10 07/19] mfd: max77693: Adjust FLASH_EN_SHIFT and
 TORCH_EN_SHIFT macros
Message-ID: <20150120111719.GF13701@x1>
References: <1420816989-1808-1-git-send-email-j.anaszewski@samsung.com>
 <1420816989-1808-8-git-send-email-j.anaszewski@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1420816989-1808-8-git-send-email-j.anaszewski@samsung.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 09 Jan 2015, Jacek Anaszewski wrote:

> Modify FLASH_EN_SHIFT and TORCH_EN_SHIFT macros to work properly
> when passed enum max77693_fled values (0 for FLED1 and 1 for FLED2)
> from leds-max77693 driver.

Off-by-one ay?  Wasn't the original code tested?

> Signed-off-by: Jacek Anaszewski <j.anaszewski@samsung.com>
> Acked-by: Kyungmin Park <kyungmin.park@samsung.com>
> Cc: Chanwoo Choi <cw00.choi@samsung.com>
> Cc: Lee Jones <lee.jones@linaro.org>
> ---
>  include/linux/mfd/max77693-private.h |    4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/include/linux/mfd/max77693-private.h b/include/linux/mfd/max77693-private.h
> index 08dae01..01799a9 100644
> --- a/include/linux/mfd/max77693-private.h
> +++ b/include/linux/mfd/max77693-private.h
> @@ -113,8 +113,8 @@ enum max77693_pmic_reg {
>  #define FLASH_EN_FLASH		0x1
>  #define FLASH_EN_TORCH		0x2
>  #define FLASH_EN_ON		0x3
> -#define FLASH_EN_SHIFT(x)	(6 - ((x) - 1) * 2)
> -#define TORCH_EN_SHIFT(x)	(2 - ((x) - 1) * 2)
> +#define FLASH_EN_SHIFT(x)	(6 - (x) * 2)
> +#define TORCH_EN_SHIFT(x)	(2 - (x) * 2)
>  
>  /* MAX77693 MAX_FLASH1 register */
>  #define MAX_FLASH1_MAX_FL_EN	0x80

-- 
Lee Jones
Linaro STMicroelectronics Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
