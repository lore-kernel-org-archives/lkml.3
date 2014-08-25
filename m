Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932230AbaHYLuF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Aug 2014 07:50:05 -0400
Received: from cantor2.suse.de ([195.135.220.15]:45483 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932203AbaHYLuB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Aug 2014 07:50:01 -0400
Message-ID: <53FB22E4.8040906@suse.de>
Date: Mon, 25 Aug 2014 13:49:56 +0200
From: =?ISO-8859-1?Q?Andreas_F=E4rber?= <afaerber@suse.de>
Organization: SUSE LINUX Products GmbH
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.7.0
MIME-Version: 1.0
To: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
CC: Javier Martinez Canillas <javier.martinez@collabora.co.uk>,
        Kukjin Kim <kgene.kim@samsung.com>,
        Doug Anderson <dianders@chromium.org>, Olof Johansson <olof@lixom.net>,
        Kevin Hilman <khilman@linaro.org>,
        Ajay Kumar <ajaykumar.rs@samsung.com>,
        linux-samsung-soc@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 1/1] ARM: exynos_defconfig: Enable options for display
 panel support
References: <1408956336-17376-1-git-send-email-javier.martinez@collabora.co.uk> <5825205.70RuHaSG5p@amdc1032>
In-Reply-To: <5825205.70RuHaSG5p@amdc1032>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Am 25.08.2014 13:43, schrieb Bartlomiej Zolnierkiewicz:
> On Monday, August 25, 2014 10:45:36 AM Javier Martinez Canillas wrote:
>> Many Exynos devices have a display panel. Most of them just have
>> a simple panel while others have more complex configurations that
>> requires an embedded DisplayPort (eDP) to LVDS bridges.
>>
>> This patch enables the following features to be built in the kernel
>> image to suport both setups:
>>
>> - Direct Rendering Manager (DRM)
>> - DRM bridge registration and lookup framework
>> - Parade ps8622/ps8625 eDP/LVDS bridge
>> - NXP ptn3460 eDP/LVDS bridge
>> - Exynos Fully Interactive Mobile Display controller (FIMD)
>> - Panel registration and lookup framework
>> - Simple panels
>> - Backlight & LCD device support
>>
>> Signed-off-by: Javier Martinez Canillas <javier.martinez@collabora.co.uk>
>> Tested-by: Kevin Hilman <khilman@linaro.org>
> 
> Could you please also do corresponding update to multi_v7_defconfig?

As was mentioned in v1 (but now below), some of these options depend on
patches yet to be respun and be accepted into drm, so I would consider
this an RFC patch and suggest to wait with multi_v7.

It could of course be split, as CONFIG_DRM_EXYNOS* and backlight parts
are certainly okay.

Regards,
Andreas

> 
> Best regards,
> --
> Bartlomiej Zolnierkiewicz
> Samsung R&D Institute Poland
> Samsung Electronics
> 
>> ---
>>
>> Changes since v1:
>>  - Forgot to enable ptn3460 eDP/LVDS bridge config option
>>    which is used for some boards (e.g: Exynos5250 Snow).
>>
>>  arch/arm/configs/exynos_defconfig | 15 +++++++++++++++
>>  1 file changed, 15 insertions(+)
>>
>> diff --git a/arch/arm/configs/exynos_defconfig b/arch/arm/configs/exynos_defconfig
>> index 676c744..d6d1f7c 100644
>> --- a/arch/arm/configs/exynos_defconfig
>> +++ b/arch/arm/configs/exynos_defconfig
>> @@ -101,11 +101,26 @@ CONFIG_REGULATOR_S2MPA01=y
>>  CONFIG_REGULATOR_S2MPS11=y
>>  CONFIG_REGULATOR_S5M8767=y
>>  CONFIG_REGULATOR_TPS65090=y
>> +CONFIG_DRM=y
>> +CONFIG_DRM_BRIDGE=y
>> +CONFIG_DRM_PTN3460=y
>> +CONFIG_DRM_PS8622=y
>> +CONFIG_DRM_EXYNOS=y
>> +CONFIG_DRM_EXYNOS_FIMD=y
>> +CONFIG_DRM_EXYNOS_DP=y
>> +CONFIG_DRM_PANEL=y
>> +CONFIG_DRM_PANEL_SIMPLE=y
>>  CONFIG_FB=y
>>  CONFIG_FB_MODE_HELPERS=y
>>  CONFIG_FB_SIMPLE=y
>>  CONFIG_EXYNOS_VIDEO=y
>>  CONFIG_EXYNOS_MIPI_DSI=y
>> +CONFIG_BACKLIGHT_LCD_SUPPORT=y
>> +CONFIG_LCD_CLASS_DEVICE=y
>> +CONFIG_LCD_PLATFORM=y
>> +CONFIG_BACKLIGHT_CLASS_DEVICE=y
>> +CONFIG_BACKLIGHT_GENERIC=y
>> +CONFIG_BACKLIGHT_PWM=y
>>  CONFIG_FRAMEBUFFER_CONSOLE=y
>>  CONFIG_FONTS=y
>>  CONFIG_FONT_7x14=y
> 


-- 
SUSE LINUX Products GmbH, Maxfeldstr. 5, 90409 Nürnberg, Germany
GF: Jeff Hawn, Jennifer Guild, Felix Imendörffer; HRB 16746 AG Nürnberg
