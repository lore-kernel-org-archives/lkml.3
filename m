Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932232AbaDHPsa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Apr 2014 11:48:30 -0400
Received: from mailout2.w1.samsung.com ([210.118.77.12]:34317 "EHLO
	mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756121AbaDHPs1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Apr 2014 11:48:27 -0400
X-AuditID: cbfec7f5-b7fc96d000004885-0f-53441a488a9e
Message-id: <53441A45.5080506@samsung.com>
Date: Tue, 08 Apr 2014 17:48:21 +0200
From: Tomasz Figa <t.figa@samsung.com>
Organization: Samsung R&D Institute Poland
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101
 Thunderbird/24.4.0
MIME-version: 1.0
To: Tomasz Stanislawski <t.stanislaws@samsung.com>,
        linux-kernel@vger.kernel.org, linux-samsung-soc@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, devicetree@vger.kernel.org,
        dri-devel@lists.freedesktop.org
Cc: mturquette@linaro.org, kgene.kim@samsung.com, inki.dae@samsung.com,
        sw0312.kim@samsung.com, kyungmin.park@samsung.com, airlied@linux.ie,
        rob.herring@calxeda.com, sylvester.nawrocki@gmail.com,
        a.hajda@samsung.com, kishon@ti.com
Subject: Re: [PATCH 2/4] clk: exynos4: export sclk_hdmiphy clock
References: <1396623201-26000-1-git-send-email-t.stanislaws@samsung.com>
 <1396623201-26000-3-git-send-email-t.stanislaws@samsung.com>
In-reply-to: <1396623201-26000-3-git-send-email-t.stanislaws@samsung.com>
Content-type: text/plain; charset=ISO-8859-1; format=flowed
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFuplkeLIzCtJLcpLzFFi42I5/e/4NV0PKZdgg8uLFSxurTvHatF77iST
	xfwjQNaVr+/ZLCbdn8Bi0bvgKpvFhac9bBZnm96wW2x6fI3V4vKuOWwWM87vY7J4OuEim8Xh
	FQeYLGZMfslmMe/zTiaLee0vWR0EPBZ8vsLusXPWXXaPO9f2sHls//aA1eN+93Emj81L6j36
	tqxi9Dh+YzuTx+dNcgGcUVw2Kak5mWWpRfp2CVwZe5p2sRV84604/GIOYwPjce4uRk4OCQET
	iW2PD7ND2GISF+6tZ+ti5OIQEljKKDHz6VJmCOczo8SaB5dZQKp4BbQkpqyfywhiswioSlyZ
	0MsMYrMJqEl8bnjEBmLzA9WsaboOVi8qECFxr/EwK0SvoMSPyfdYQIaKCNxhlFja+AlsHbPA
	G0aJN7M/gk0SFnCQOPV5NyvE6nZGibMzloO1cwp4Sky5dQBsLLOAtcTKSdsYIWx5ic1r3jJP
	YBSchWTLLCRls5CULWBkXsUomlqaXFCclJ5rpFecmFtcmpeul5yfu4kREoVfdzAuPWZ1iFGA
	g1GJh7fyiFOwEGtiWXFl7iFGCQ5mJRHev3wuwUK8KYmVValF+fFFpTmpxYcYmTg4pRoYb7AY
	WGXwqjJI3XdWOPl6vVxhCHdw7vHboql7o1SWqjy4kPt//pFVRYEMT43bFc2+HHdO+dU/7cCk
	dx09nW+14nyUly032xl5tmxHRettk6ux9luNjT113kj82vP5wOSwjhl/uHNvKng+kqzwS/q1
	+ha75OEFn5ymPXgiGCOnUC+w3D+Y++JXJZbijERDLeai4kQAnFhUDqACAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Tomasz,

On 04.04.2014 16:53, Tomasz Stanislawski wrote:
> Export sclk_hdmiphy clock to be usable from DT.
>
> Signed-off-by: Tomasz Stanislawski <t.stanislaws@samsung.com>
> ---
>   drivers/clk/samsung/clk-exynos4.c   |    2 +-
>   include/dt-bindings/clock/exynos4.h |    1 +
>   2 files changed, 2 insertions(+), 1 deletion(-)
>
> diff --git a/drivers/clk/samsung/clk-exynos4.c b/drivers/clk/samsung/clk-exynos4.c
> index b4f9672..528f8eb 100644
> --- a/drivers/clk/samsung/clk-exynos4.c
> +++ b/drivers/clk/samsung/clk-exynos4.c
> @@ -428,7 +428,7 @@ static struct samsung_fixed_rate_clock exynos4_fixed_rate_ext_clks[] __initdata
>   /* fixed rate clocks generated inside the soc */
>   static struct samsung_fixed_rate_clock exynos4_fixed_rate_clks[] __initdata = {
>   	FRATE(0, "sclk_hdmi24m", NULL, CLK_IS_ROOT, 24000000),
> -	FRATE(0, "sclk_hdmiphy", NULL, CLK_IS_ROOT, 27000000),
> +	FRATE(CLK_SCLK_HDMIPHY, "sclk_hdmiphy", NULL, CLK_IS_ROOT, 27000000),
>   	FRATE(0, "sclk_usbphy0", NULL, CLK_IS_ROOT, 48000000),
>   };
>
> diff --git a/include/dt-bindings/clock/exynos4.h b/include/dt-bindings/clock/exynos4.h
> index 75aff33..0e245eb 100644
> --- a/include/dt-bindings/clock/exynos4.h
> +++ b/include/dt-bindings/clock/exynos4.h
> @@ -33,6 +33,7 @@
>   #define CLK_MOUT_MPLL_USER_C	18 /* Exynos4x12 only */
>   #define CLK_MOUT_CORE		19
>   #define CLK_MOUT_APLL		20
> +#define CLK_SCLK_HDMIPHY	22
>
>   /* gate for special clocks (sclk) */
>   #define CLK_SCLK_FIMC0		128
>

I believe this clock should be properly abstracted as an output of HDMI 
PHY, but I don't see any way to do this with existing infrastructure, so 
probably for now such workaround is fine.

Will apply, if nobody opposes.

Best regards,
Tomasz
