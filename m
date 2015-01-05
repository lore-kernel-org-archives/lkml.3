Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753309AbbAEIsW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Jan 2015 03:48:22 -0500
Received: from mailout3.w1.samsung.com ([210.118.77.13]:31520 "EHLO
	mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753283AbbAEIsU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Jan 2015 03:48:20 -0500
MIME-version: 1.0
Content-type: text/plain; charset=UTF-8
X-AuditID: cbfec7f4-b7f126d000001e9a-f3-54aa4fcce425
Content-transfer-encoding: 8BIT
Message-id: <1420447691.3918.2.camel@AMDC1943>
Subject: Re: [PATCH RESEND] ARM: exynos_defconfig: Enable options for display
 panel support
From: Krzysztof Kozlowski <k.kozlowski@samsung.com>
To: Javier Martinez Canillas <javier.martinez@collabora.co.uk>
Cc: Kukjin Kim <kgene.kim@samsung.com>, Doug Anderson <dianders@chromium.org>,
        Kevin Hilman <khilman@linaro.org>, Olof Johansson <olof@lixom.net>,
        linux-samsung-soc@vger.kernel.org,
        Vivek Gautam <gautam.vivek@samsung.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Date: Mon, 05 Jan 2015 09:48:11 +0100
In-reply-to: <1420215089-2093-1-git-send-email-javier.martinez@collabora.co.uk>
References: <1420215089-2093-1-git-send-email-javier.martinez@collabora.co.uk>
X-Mailer: Evolution 3.10.4-0ubuntu2
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrLLMWRmVeSWpSXmKPExsVy+t/xa7pn/FeFGDzsVLE4u+wgm0XblYPs
	Fkd/F1j0LrjKZvH18ApGi02Pr7FaXN41h81ixvl9TBanrn9mc+D0mN1wkcXj7/PrLB53ru1h
	89i8pN7jyokmVo++LasYPT5vkgtgj+KySUnNySxLLdK3S+DK2PfnBFvBQrGKy1cfMzUw7hbq
	YuTkkBAwkfi2ZRczhC0mceHeerYuRi4OIYGljBJ9a/rZQBK8AoISPybfY+li5OBgFpCXOHIp
	GyTMLKAuMWneIrBeIYHPjBJ/J5hClOtJtL1bwApiCwvESqxbdI0dxGYTMJbYvHwJ2EgRATuJ
	G6sfMoPsYhZYziTx8dtEsEEsAqoSN2bOZgSxOQX8JS7d+MACscBPYvPZxWA3SAgoSzT2u01g
	FJiF5LpZCNfNQnLdAkbmVYyiqaXJBcVJ6bmGesWJucWleel6yfm5mxghUfBlB+PiY1aHGAU4
	GJV4eD1OrAwRYk0sK67MPcQowcGsJMK77hZQiDclsbIqtSg/vqg0J7X4ECMTB6dUA2O/8sOX
	V9kninD2snzSV546b9Z3saZZh09/NNi7n5n57YTPm9IW9QadCoze3WY/9eJiO73DPJ6Tjm5o
	1uJe56/OwDmnKygn6RrTsipLrxfTV2ZXFnry+R7sCd515F3/Ie3XN9qN1HiWdCasLtrms9lB
	rlN+556p/6Iny/4JVLhyZmlKfNKR5kwlluKMREMt5qLiRADuX/y4YAIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On pią, 2015-01-02 at 17:11 +0100, Javier Martinez Canillas wrote:
> Many Exynos devices have a display panel. Most of them just have
> a simple panel while others have more complex configurations that
> requires an embedded DisplayPort (eDP) to LVDS bridges.
> 
> This patch enables the following features to be built in the kernel
> image to support both setups:
> 
> - Direct Rendering Manager (DRM)
> - DRM bridge registration and lookup framework
> - Parade ps8622/ps8625 eDP/LVDS bridge
> - NXP ptn3460 eDP/LVDS bridge
> - Exynos Fully Interactive Mobile Display controller (FIMD)
> - Panel registration and lookup framework
> - Simple panels
> - Backlight & LCD device support
> 
> Signed-off-by: Javier Martinez Canillas <javier.martinez@collabora.co.uk>
> Tested-by: Kevin Hilman <khilman@linaro.org>
> Signed-off-by: Kukjin Kim <kgene.kim@samsung.com>
> ---
> 
> Hello Kukjin,
> 
> You dropped this patch since exynos drm was causing boot hangs on some
> platforms but the fix for that issue is already in linux-next (commit:
> f1e9203 clk: samsung: Fix Exynos 5420 pinctrl setup and clock disable
> failure due to domain being gated) so I think it makes sense to enable
> the display options again.

I think these issues were unrelated to each other. DRM was disabled
because of infinite deferred probing of DRM components. I saw Inki was
sending some patches for it but I am not sure if they were merged.

Best regards,
Krzysztof


> 
> NOTE: Display panel is still not working since patch "arm: dts: Exynos5:
> Use pmu_system_controller phandle for dp phy" is needed [0] but I think
> we should enable display options to catch the regressions easier.
> 
> Best regards,
> Javier
> 
> [0]: https://lkml.org/lkml/2014/11/24/10
> 
>  arch/arm/configs/exynos_defconfig | 15 +++++++++++++++
>  1 file changed, 15 insertions(+)
> 
> diff --git a/arch/arm/configs/exynos_defconfig b/arch/arm/configs/exynos_defconfig
> index 22beed3..27cdd52 100644
> --- a/arch/arm/configs/exynos_defconfig
> +++ b/arch/arm/configs/exynos_defconfig
> @@ -111,11 +111,26 @@ CONFIG_REGULATOR_S2MPA01=y
>  CONFIG_REGULATOR_S2MPS11=y
>  CONFIG_REGULATOR_S5M8767=y
>  CONFIG_REGULATOR_TPS65090=y
> +CONFIG_DRM=y
> +CONFIG_DRM_BRIDGE=y
> +CONFIG_DRM_PTN3460=y
> +CONFIG_DRM_PS8622=y
> +CONFIG_DRM_EXYNOS=y
> +CONFIG_DRM_EXYNOS_FIMD=y
> +CONFIG_DRM_EXYNOS_DP=y
> +CONFIG_DRM_PANEL=y
> +CONFIG_DRM_PANEL_SIMPLE=y
>  CONFIG_FB=y
>  CONFIG_FB_MODE_HELPERS=y
>  CONFIG_FB_SIMPLE=y
>  CONFIG_EXYNOS_VIDEO=y
>  CONFIG_EXYNOS_MIPI_DSI=y
> +CONFIG_BACKLIGHT_LCD_SUPPORT=y
> +CONFIG_LCD_CLASS_DEVICE=y
> +CONFIG_LCD_PLATFORM=y
> +CONFIG_BACKLIGHT_CLASS_DEVICE=y
> +CONFIG_BACKLIGHT_GENERIC=y
> +CONFIG_BACKLIGHT_PWM=y
>  CONFIG_FRAMEBUFFER_CONSOLE=y
>  CONFIG_FONTS=y
>  CONFIG_FONT_7x14=y

