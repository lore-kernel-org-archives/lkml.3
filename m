Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934987AbaKNC43 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Nov 2014 21:56:29 -0500
Received: from mailout4.samsung.com ([203.254.224.34]:62521 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933665AbaKNC40 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Nov 2014 21:56:26 -0500
MIME-version: 1.0
Content-type: text/plain; charset=UTF-8
X-AuditID: cbfee68d-f79296d000004278-34-54656f58f008
Content-transfer-encoding: 8BIT
Message-id: <54656F58.6030706@samsung.com>
Date: Fri, 14 Nov 2014 11:56:24 +0900
From: Inki Dae <inki.dae@samsung.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130803
 Thunderbird/17.0.8
To: Krzysztof Kozlowski <k.kozlowski@samsung.com>
Cc: Joonyoung Shim <jy0922.shim@samsung.com>,
        Seung-Woo Kim <sw0312.kim@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        David Airlie <airlied@linux.ie>, Kukjin Kim <kgene.kim@samsung.com>,
        dri-devel@lists.freedesktop.org, linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org, linux-kernel@vger.kernel.org,
        Andrzej Hajda <a.hajda@samsung.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        Grygorii Strashko <grygorii.strashko@ti.com>,
        Kevin Hilman <khilman@kernel.org>
Subject: Re: [PATCH v2 1/2] drm/exynos: Fix DSI resuming fail because power
 domain being off
References: <1415368439-23642-1-git-send-email-k.kozlowski@samsung.com>
 <1415368439-23642-2-git-send-email-k.kozlowski@samsung.com>
In-reply-to: <1415368439-23642-2-git-send-email-k.kozlowski@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrIIsWRmVeSWpSXmKPExsWyRsSkUDcyPzXE4P1VNotb686xWvSeO8lk
	sXHGelaLK1/fs1msnMJi8eLeRRaL1y8MLXoXAFU93fyYyeJs0xt2i02Pr7FaXN41h81ixvl9
	TBZrj9xlt5gx+SWbA7/HplWdbB7bvz1g9bjffZzJY/OSeo++LasYPY7f2M7k8XmTXAB7FJdN
	SmpOZllqkb5dAlfGzsuXWQseylS8XV7XwHhNvIuRk0NCwERiVvdFdghbTOLCvfVsXYxcHEIC
	Sxkl1i14yAJTNKmjmRkisYhR4sHqL2AJXgFBiR+T7wHZHBzMAvISRy5lg4SZBdQlJs1bBFX/
	ilHi9LNd7CA1vAJaEscuaYPUsAioStw8MIcRxGYDsieuuM8GYosKhEm8eLWLGcQWETCUOLh7
	OxPIHGaBrSwSuz9/A7tUWCBO4tq/NUwQC1oZJU6eXwiW4BTwkDj4/y0rSEJCYCaHxNk7f5gg
	1glIfJt8COxSCQFZiU0HmCE+k5Q4uOIGywRGsVlI/pmF8M8sJP8sYGRexSiaWpBcUJyUXmSo
	V5yYW1yal66XnJ+7iREY06f/PevdwXj7gPUhRgEORiUeXga31BAh1sSy4srcQ4ymQEdMZJYS
	Tc4HJo68knhDYzMjC1MTU2Mjc0szJXFeRamfwUIC6YklqdmpqQWpRfFFpTmpxYcYmTg4pRoY
	d4n0/P2/oHf5i5RlX0o3nDR0l6ljW6h+UUh09/z8y41GuucfWPDfr3ja22N5+/HqJzFnY693
	T14U438hQVWFq+g96yM3rSNnsgMzNqgfv2Ah7L5FYdvWiq+3rJP0BYwV3ytaJsm9Lby2LOfs
	/bdlqustG1KOS9xq3XL5ypuSzA8lixguJTSsUWIpzkg01GIuKk4EAD2Wp6rkAgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprNKsWRmVeSWpSXmKPExsVy+t9jAd2I/NQQg4bvlha31p1jteg9d5LJ
	YuOM9awWV76+Z7NYOYXF4sW9iywWr18YWvQuuMpm8XTzYyaLs01v2C02Pb7GanF51xw2ixnn
	9zFZrD1yl91ixuSXbA78HptWdbJ5bP/2gNXjfvdxJo/NS+o9+rasYvQ4fmM7k8fnTXIB7FEN
	jDYZqYkpqUUKqXnJ+SmZeem2St7B8c7xpmYGhrqGlhbmSgp5ibmptkouPgG6bpk5QGcrKZQl
	5pQChQISi4uV9O0wTQgNcdO1gGmM0PUNCYLrMTJAAwlrGDN2Xr7MWvBQpuLt8roGxmviXYyc
	HBICJhKTOpqZIWwxiQv31rN1MXJxCAksYpR4sPoLC0iCV0BQ4sfke0A2BwezgLzEkUvZIGFm
	AXWJSfMWMUPUv2KUOP1sFztIDa+AlsSxS9ogNSwCqhI3D8xhBLHZgOyJK+6zgdiiAmESL17t
	AtsrImAocXD3diaQOcwCW1kkdn/+xg6SEBaIk7j2bw0TxIJWRomT5xeCJTgFPCQO/n/LOoFR
	YBaS+2Yh3DcLyX0LGJlXMYqmFiQXFCel5xrpFSfmFpfmpesl5+duYgQnjGfSOxhXNVgcYhTg
	YFTi4WV0Sw0RYk0sK67MPcQowcGsJMLbmgkU4k1JrKxKLcqPLyrNSS0+xGgK9N5EZinR5Hxg
	MssriTc0NjEzsjQyN7QwMjZXEuc92GodKCSQnliSmp2aWpBaBNPHxMEp1cDYzMS8KsDf+37Z
	pJuPs/miZyX2cSVvqpnic1vJlVtol/Mpdu2uY3dKlTbPUWnweLvsokOa/P47N/jVvLfsPc/4
	803dYUZJFRu1n6s6ZFcEbZ93QCvc5v66ORNCVaaI7Fr4+83/X+uMn6YJvmsPiVy20vzSlQn1
	x5zWlaxdk7Rj840LL6cfeF2ToMRSnJFoqMVcVJwIALgpnQguAwAA
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2014년 11월 07일 22:53, Krzysztof Kozlowski wrote:
> During system resume from suspend to RAM the Exynos DRM driver forced
> CRTC mode thus turning display on (DPMS_ON). This lead to runtime resuming
> of DSI which failed because whole LCD power domain was off and it was
> not allowed to turn on because of system resume in progress.
> 
> Forcing mode should not be needed and removing it solves this particular
> problem.

only this patch, Applied.

Thanks,
Inki Dae

> 
> This necessary fix for following scenario reproduced on Exynos DRM:
> 1. Power domain is off before suspending the system.
> 2. System is suspended to RAM.
> 3. Resuming starts. The Exynos DRM driver resume callback is called.
> 4. The Exynos DRM driver calls drm_helper_resume_force_mode() which turns
>    on the screen by calling exynos_dsi_dpms with DRM_MODE_DPMS_ON.
> 5. The Exynos DSI driver calls pm_runtime_get. The driver runtime
>    resumes and this should turn LCD power domain on.
> 6. Unfortunately the domain cannot be turned on because system resume is
>    in progress and genpd->prepared_count is positive.
> 
> Steps to reproduce:
> 1. Add runtime PM to Exynos DSI driver.
> 2. Build Exynos DRM/FB without FRAMEBUFFER_CONSOLE.
> 3. Enable the connector and screen (e.g. with modeset-vsync).
> 4. echo 3 > /sys/devices/platform/exynos-drm/graphics/fb0/blank
> 5. echo mem > /sys/power/state
> 6. Resume.
> [   77.712469] PM: early resume of devices complete after 3.854 msecs
> [   77.712739] exynos-dsi 11c80000.dsi: pm_genpd_resume()
> [   77.712758] exynos4-fimc 11800000.fimc: pm_genpd_resume()
> [   77.712774] exynos4-fimc 11810000.fimc: pm_genpd_resume()
> [   77.712787] exynos-drm-fimc 11820000.fimc: pm_genpd_resume()
> [   77.712802] exynos-drm-fimc 11830000.fimc: pm_genpd_resume()
> [   77.712815] s5p-mipi-csis 11880000.csis: pm_genpd_resume()
> [   77.712829] s5p-mipi-csis 11890000.csis: pm_genpd_resume()
> [   77.712843] exynos-fimc-lite 12390000.fimc-lite: pm_genpd_resume()
> [   77.712856] exynos-fimc-lite 123a0000.fimc-lite: pm_genpd_resume()
> [   77.713788] exynos4-fb 11c00000.fimd: pm_genpd_resume()
> [   77.713912] wake disabled for irq 184
> [   77.713923] wake disabled for irq 185
> [   77.714082] wake disabled for irq 173
> [   77.715676] wake disabled for irq 176
> [   77.718540] exynos4-fb 11c00000.fimd: pm_genpd_runtime_resume()
> [   77.718567] exynos4-fb 11c00000.fimd: state restore latency exceeded, new value 1708 ns
> [   77.718636] exynos-dsi 11c80000.dsi: pm_genpd_runtime_resume()
> [   77.892366] exynos-dsi 11c80000.dsi: PLL failed to stabilize
> [   77.892377] exynos-dsi 11c80000.dsi: failed to configure DSI PLL
> [   78.192168] exynos-dsi 11c80000.dsi: timeout waiting for reset
> [   78.211578] exynos-dsi 11c80000.dsi: waiting for bus lanes timed out
> [   78.307173] exynos-dsi 11c80000.dsi: xfer timed out: d1 00 (null)
> [   78.307190] panel_s6e8aa0 11c80000.dsi.0: error -110 reading dcs seq(0xd1)
> [   78.307199] panel_s6e8aa0 11c80000.dsi.0: read id failed
> 
> Signed-off-by: Krzysztof Kozlowski <k.kozlowski@samsung.com>
> ---
>  drivers/gpu/drm/exynos/exynos_drm_drv.c | 2 --
>  1 file changed, 2 deletions(-)
> 
> diff --git a/drivers/gpu/drm/exynos/exynos_drm_drv.c b/drivers/gpu/drm/exynos/exynos_drm_drv.c
> index d32165a7f862..8f7110c9d21f 100644
> --- a/drivers/gpu/drm/exynos/exynos_drm_drv.c
> +++ b/drivers/gpu/drm/exynos/exynos_drm_drv.c
> @@ -200,8 +200,6 @@ static int exynos_drm_resume(struct drm_device *dev)
>  	}
>  	drm_modeset_unlock_all(dev);
>  
> -	drm_helper_resume_force_mode(dev);
> -
>  	return 0;
>  }
>  
> 

