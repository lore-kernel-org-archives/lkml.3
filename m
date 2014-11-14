Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934943AbaKNCxT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Nov 2014 21:53:19 -0500
Received: from mailout2.samsung.com ([203.254.224.25]:22679 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933080AbaKNCxR convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Nov 2014 21:53:17 -0500
X-AuditID: cbfee691-f79b86d000004a5a-3c-54656e9a755e
MIME-version: 1.0
Content-type: text/plain; charset=UTF-8
Content-transfer-encoding: 8BIT
Message-id: <54656E9A.8040702@samsung.com>
Date: Fri, 14 Nov 2014 11:53:14 +0900
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
Subject: Re: [PATCH v2 2/2] drm/exynos/dsi: Add runtime PM so LCD power domain
 could be turned off
References: <1415368439-23642-1-git-send-email-k.kozlowski@samsung.com>
 <1415368439-23642-3-git-send-email-k.kozlowski@samsung.com>
In-reply-to: <1415368439-23642-3-git-send-email-k.kozlowski@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrFIsWRmVeSWpSXmKPExsWyRsSkWHdWXmqIQftuQ4tb686xWvSeO8lk
	sXHGelaLK1/fs1msnMJi8eLeRRaL1y8MLXoXXGWzeLr5MZPF2aY37BabHl9jtbi8aw6bxYzz
	+5gs1h65y24xY/JLNgd+j02rOtk8tn97wOpxv/s4k8fmJfUefVtWMXocv7GdyePzJrkA9igu
	m5TUnMyy1CJ9uwSujM6VaxkL3klUfGpey97AuFW4i5GTQ0LARGLTsvmMELaYxIV769m6GLk4
	hASWMko8XbuFCaZo987f7BCJ6YwS12bsYwNJ8AoISvyYfI8FxGYWUJeYNG8RcxcjB5AtInH4
	pAZEWFti2cLXzBC9rxglvtz5xAZSwyugJTF5ezpIDYuAqsS+f6fARrIB2RNX3AezRQXCJF68
	2sUMYosIGEoc3L2dCWQOs8BWFondn7+xgySEBVIkDr55yAixoJVR4tuRhWDdnAIeEtMetLCC
	JCQE5nJITG9tZ4ZYJyDxbfIhFpArJARkJTYdYIb4UlLi4IobLBMYxWch+W0Wkt9mIfw2C8lv
	CxhZVjGKphYkFxQnpReZ6hUn5haX5qXrJefnbmIEJoHT/55N3MF4/4D1IUYBDkYlHl4Gt9QQ
	IdbEsuLK3EOMpkAHTWSWEk3OB6aavJJ4Q2MzIwtTE1NjI3NLMyVxXh3pn8FCAumJJanZqakF
	qUXxRaU5qcWHGJk4OKUaGO36E8NmzGp8pXV548ZFeVf+v8q5+rZob/aifU/NBTnuXHriMXVh
	9kyFU+8q1l8XV/P0ua5nLqIurfVS8+s158B1IuG7Fv/bO7egqMwib/5U9vbpFk1SJ80kK0sV
	n6c/eF75hNNPp+5ywL1FKwXmrdheUC3z6HO9gKJUNsttL8aZE9+8zHi0X1OJpTgj0VCLuag4
	EQAQX/7q/QIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprDKsWRmVeSWpSXmKPExsVy+t9jQd1ZeakhBqv2qVvcWneO1aL33Ekm
	i40z1rNaXPn6ns1i5RQWixf3LrJYvH5haNG74CqbxdPNj5kszja9YbfY9Pgaq8XlXXPYLGac
	38dksfbIXXaLGZNfsjnwe2xa1cnmsf3bA1aP+93HmTw2L6n36NuyitHj+I3tTB6fN8kFsEc1
	MNpkpCampBYppOYl56dk5qXbKnkHxzvHm5oZGOoaWlqYKynkJeam2iq5+AToumXmAJ2tpFCW
	mFMKFApILC5W0rfDNCE0xE3XAqYxQtc3JAiux8gADSSsYcy4vKeFteCGRMXJ51+ZGhjnC3cx
	cnJICJhI7N75mx3CFpO4cG89WxcjF4eQwHRGiWsz9rGBJHgFBCV+TL7H0sXIwcEsIC9x5FI2
	SJhZQF1i0rxFzBD1rxglvtz5xAZSwyugJTF5ezpIDYuAqsS+f6fAxrAB2RNX3AezRQXCJF68
	2sUMYosIGEoc3L2dCWQOs8BWFondn7+BHSQskCJx8M1DRogFrYwS344sBOvmFPCQmPaghXUC
	o8AsJPfNQrhvFpL7FjAyr2IUTS1ILihOSs810itOzC0uzUvXS87P3cQIThnPpHcwrmqwOMQo
	wMGoxMPL6JYaIsSaWFZcmXuIUYKDWUmEtzUTKMSbklhZlVqUH19UmpNafIjRFOi9icxSosn5
	wHSWVxJvaGxiZmRpZG5oYWRsriTOe7DVOlBIID2xJDU7NbUgtQimj4mDU6qBsfjN0uJ9ZcJ/
	yw5/+BTt0s7+xjdp7rnSqdl3c91YPx/LONY7/80mZsPXRifPmkcuKxC4dqevRNfpwtt+/n9H
	HhUJ3dXdu8TirJq4hOmXt6pvpbPb9ydI8fGZ+qycaO253/Dv86PTVqy+/GrfvYL+ddLfrtVF
	hexaKvdUatdr4TLx+xqL9+no3FZiKc5INNRiLipOBADkGfj7LwMAAA==
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2014년 11월 07일 22:53, Krzysztof Kozlowski wrote:
> Add runtime Power Management to the Exynos DSI driver so the LCD power
> domain could be turned off.
> 
> This slightly reduces the energy consumption when screen is completely
> turned off. On Trats2 board when the system was idle the energy
> consumption dropped by 1% (from 92.2 mA to 91.1 mA).
> 
> Before the patch:
> $ cat cat /sys/kernel/debug/pm_genpd/pm_genpd_summary
> lcd0-power-domain               on
>     /devices/11c00000.fimd                              suspended
>     /devices/11c80000.dsi                               unsupported
> 
> After applying the patch:
> lcd0-power-domain               off
>     /devices/11c00000.fimd                              suspended
>     /devices/11c80000.dsi                               suspended

Reasonable but this patch incurs page flip test timeout like below,
# modetest -v -s 15@12:720x1280
trying to open device 'i915'...failed.
trying to open device 'radeon'...failed.
trying to open device 'nouveau'...failed.
trying to open device 'vmwgfx'...failed.
trying to open device 'omapdrm'...failed.
trying to open device 'exynos'...success.
setting mode 720x1280-0Hz@XR24 on connectors 15, crtc 12
select timed out or error (ret 0)

I'm not sure why this issue is incurred with this patch even through
this patch is reasonable and correct. So we need more checking.

P.S. I tested it on exynos-drm-next and m0 board.

Thanks,
Inki Dae

> 
> Signed-off-by: Krzysztof Kozlowski <k.kozlowski@samsung.com>
> ---
>  drivers/gpu/drm/exynos/exynos_drm_dsi.c | 9 +++++++++
>  1 file changed, 9 insertions(+)
> 
> diff --git a/drivers/gpu/drm/exynos/exynos_drm_dsi.c b/drivers/gpu/drm/exynos/exynos_drm_dsi.c
> index 24741d8758e8..19ed36d2d557 100644
> --- a/drivers/gpu/drm/exynos/exynos_drm_dsi.c
> +++ b/drivers/gpu/drm/exynos/exynos_drm_dsi.c
> @@ -21,6 +21,7 @@
>  #include <linux/of_device.h>
>  #include <linux/of_gpio.h>
>  #include <linux/phy/phy.h>
> +#include <linux/pm_runtime.h>
>  #include <linux/regulator/consumer.h>
>  #include <linux/component.h>
>  
> @@ -1356,6 +1357,8 @@ static int exynos_dsi_enable(struct exynos_dsi *dsi)
>  	if (dsi->state & DSIM_STATE_ENABLED)
>  		return 0;
>  
> +	pm_runtime_get_sync(dsi->dev);
> +
>  	ret = exynos_dsi_poweron(dsi);
>  	if (ret < 0)
>  		return ret;
> @@ -1392,6 +1395,8 @@ static void exynos_dsi_disable(struct exynos_dsi *dsi)
>  	drm_panel_unprepare(dsi->panel);
>  	exynos_dsi_poweroff(dsi);
>  
> +	pm_runtime_put_sync(dsi->dev);
> +
>  	dsi->state &= ~DSIM_STATE_ENABLED;
>  }
>  
> @@ -1772,6 +1777,8 @@ static int exynos_dsi_probe(struct platform_device *pdev)
>  	if (ret)
>  		goto err_del_component;
>  
> +	pm_runtime_enable(&pdev->dev);
> +
>  	return ret;
>  
>  err_del_component:
> @@ -1781,6 +1788,8 @@ err_del_component:
>  
>  static int exynos_dsi_remove(struct platform_device *pdev)
>  {
> +	pm_runtime_disable(&pdev->dev);
> +
>  	component_del(&pdev->dev, &exynos_dsi_component_ops);
>  	exynos_drm_component_del(&pdev->dev, EXYNOS_DEVICE_TYPE_CONNECTOR);
>  
> 

