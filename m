Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752137AbaIEGfH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Sep 2014 02:35:07 -0400
Received: from mail-ig0-f174.google.com ([209.85.213.174]:34464 "EHLO
	mail-ig0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750765AbaIEGfE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Sep 2014 02:35:04 -0400
MIME-Version: 1.0
In-Reply-To: <041101cfc793$d5cdd4b0$81697e10$@samsung.com>
References: <1408749185-14133-1-git-send-email-javier.martinez@collabora.co.uk>
	<041101cfc793$d5cdd4b0$81697e10$@samsung.com>
Date: Fri, 5 Sep 2014 12:05:03 +0530
Message-ID: <CAEC9eQNy=3LwwyAEJOSt1vFkZACzx9CAzAbsrpS2q4RfW3JiUw@mail.gmail.com>
Subject: Re: [PATCH 1/1] ARM: exynos_defconfig: Enable options for display
 panel support
From: Ajay kumar <ajaynumb@gmail.com>
To: Kukjin Kim <kgene.kim@samsung.com>, InKi Dae <inki.dae@samsung.com>,
        Javier Martinez Canillas <javier.martinez@collabora.co.uk>
Cc: Doug Anderson <dianders@chromium.org>, Olof Johansson <olof@lixom.net>,
        Kevin Hilman <khilman@linaro.org>,
        =?UTF-8?Q?Andreas_F=C3=A4rber?= <afaerber@suse.de>,
        Ajay Kumar <ajaykumar.rs@samsung.com>,
        "linux-samsung-soc@vger.kernel.org" 
	<linux-samsung-soc@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Thierry Reding <thierry.reding@gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Wed, Sep 3, 2014 at 9:56 PM, Kukjin Kim <kgene.kim@samsung.com> wrote:
> Javier Martinez Canillas wrote:
>>
>> Many Exynos devices have a display panel, most of them just have
>> a simple panel while others have more complex configurations that
>> requires an embedded DisplayPort (eDP) to LVDS display bridge.
>>
>> This patch enables the following features to support both setups:
>>
>> - Direct Rendering Manager (DRM)
>> - DRM bridge registration and lookup framework
>> - Parade ps8622/ps8625 eDP/LVDS bridge
>> - NXP ptn3460 eDP/LVDS bridge
>> - Exynos Fully Interactive Mobile Display controller (FIMD)
>> - Panel registration and lookup framework
>> - Simple panels
>> - Backlight and LCD device support
>>
> Thanks a lot.
>
>
>> Signed-off-by: Javier Martinez Canillas <javier.martinez@collabora.co.uk>
>> ---
>>
>> Some of the options enabled here (e.g: the eDP/LVDS bridges)
>> are still not merged in mainline so this patch depends on
>> the following posted patches that were still not merged:
>>
>> "drm/bridge: Modify drm_bridge core to support driver model" [0]
>> "drm/bridge: Add i2c based driver for ptn3460 bridge" [1]
>> "drm/bridge: Add i2c based driver for ps8622/ps8625 bridge" [2]
>>
> BTW, I can't find its re-spin...how was going on?
I already sent this a week back.Find it here:
http://www.spinics.net/lists/dri-devel/msg66740.html

Inki Dae,
In this patchset, patch "[PATCH V7 5/12] drm/exynos: dp: support drm_bridge"
introduces following Kconfig error:
drivers/video/fbdev/Kconfig:5:error: recursive dependency detected!
drivers/video/fbdev/Kconfig:5: symbol FB is selected by DRM_KMS_FB_HELPER
drivers/gpu/drm/Kconfig:39: symbol DRM_KMS_FB_HELPER depends on DRM_KMS_HELPER
drivers/gpu/drm/Kconfig:33: symbol DRM_KMS_HELPER is selected by DRM_BRIDGE
drivers/gpu/drm/bridge/Kconfig:1: symbol DRM_BRIDGE is selected by DRM_EXYNOS_DP
drivers/gpu/drm/exynos/Kconfig:53: symbol DRM_EXYNOS_DP depends on
DRM_EXYNOS_FIMD
drivers/gpu/drm/exynos/Kconfig:28: symbol DRM_EXYNOS_FIMD depends on FB_S3C
drivers/video/fbdev/Kconfig:2038: symbol FB_S3C depends on FB

How to fix this?
Can we remove dependency between FB_S3C and DRM_EXYNOS_FIMD?

>> But I wanted to post anyways to make easier for others to
>> figure out what are the needed options to have the display
>> working on their Exynos machines.
>>
>> In order to test the display panel on the Peach machines,
>> the following patches are also needed:
>>
>> "ARM: dts: Add DT changes for display on peach_pit" [3]
>> "ARM: dts: Add DT changes for display on peach_pi" [4]
>>
> I'll have a look them soon.
The above ones are older versions. Latest ones are here:
1) http://www.spinics.net/lists/linux-samsung-soc/msg35344.html
2) http://www.spinics.net/lists/arm-kernel/msg358324.html
3) http://www.spinics.net/lists/arm-kernel/msg358325.html

Among the above, patch (1) can be merged because corresponding
driver changes are already merged!

Ajay

> - Kukjin
>
>> Best regards,
>> Javier
>>
>> [0]: http://patchwork.ozlabs.org/patch/373792/
>> [1]: http://patchwork.ozlabs.org/patch/373793/
>> [2]: http://patchwork.ozlabs.org/patch/373794/
>> [3]: http://www.spinics.net/lists/arm-kernel/msg350568.html
>> [4]: http://www.spinics.net/lists/arm-kernel/msg350569.html
>>
>>  arch/arm/configs/exynos_defconfig | 14 ++++++++++++++
>>  1 file changed, 14 insertions(+)
>>
>> diff --git a/arch/arm/configs/exynos_defconfig b/arch/arm/configs/exynos_defconfig
>> index 676c744..f69d57e 100644
>> --- a/arch/arm/configs/exynos_defconfig
>> +++ b/arch/arm/configs/exynos_defconfig
>> @@ -101,11 +101,25 @@ CONFIG_REGULATOR_S2MPA01=y
>>  CONFIG_REGULATOR_S2MPS11=y
>>  CONFIG_REGULATOR_S5M8767=y
>>  CONFIG_REGULATOR_TPS65090=y
>> +CONFIG_DRM=y
>> +CONFIG_DRM_BRIDGE=y
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
>> --
>> 2.0.1
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-samsung-soc" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
