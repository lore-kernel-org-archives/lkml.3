Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753730AbaIANhu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Sep 2014 09:37:50 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:33345 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751500AbaIANhr convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Sep 2014 09:37:47 -0400
X-AuditID: cbfee68f-f797f6d000001173-c7-540476a9610c
MIME-version: 1.0
Content-type: text/plain; charset=UTF-8
Content-transfer-encoding: 8BIT
Message-id: <540476A8.8030502@samsung.com>
Date: Mon, 01 Sep 2014 22:37:44 +0900
From: Inki Dae <inki.dae@samsung.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130803
 Thunderbird/17.0.8
To: Marek Szyprowski <m.szyprowski@samsung.com>
Cc: iommu@lists.linux-foundation.org, linux-samsung-soc@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linaro-mm-sig@lists.linaro.org, Arnd Bergmann <arnd@arndb.de>,
        Shaik Ameer Basha <shaik.ameer@samsung.com>,
        Cho KyongHo <pullip.cho@samsung.com>, Joerg Roedel <joro@8bytes.org>,
        Thierry Reding <treding@nvidia.com>, Olof Johansson <olof@lixom.net>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Rob Herring <robh@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Kukjin Kim <kgene.kim@samsung.com>,
        Sylwester Nawrocki <s.nawrocki@samsung.com>,
        Tomasz Figa <tomasz.figa@gmail.com>,
        Kyungmin Park <kyungmin.park@samsung.com>
Subject: Re: [PATCH 12/29] DRM: Exynos: fix window clear code
References: <1407235677-26324-1-git-send-email-m.szyprowski@samsung.com>
 <1407235677-26324-13-git-send-email-m.szyprowski@samsung.com>
In-reply-to: <1407235677-26324-13-git-send-email-m.szyprowski@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA02SfSzUcRzH973f0yH6dU6+brHYmk7z/NC3VOsf+tVma2P9IaNLv2F5uN0d
	sv4g5uE06U4znWdJ3ESOLSEPl4kOWYgxJKYSKsxE6M6t5b/Xvp/P+/v5vLYPF+NVEQJuVKyM
	lcSKoh1IU7yW7yVzrknAg9yKM2zQjrKHQmlP6klU1uGL5IUvKJRTNkqigdQlCskVlRRaH5nl
	IM3cRwINtxSRqOB9Owc9756i0LuxNRLt5nQB1K/7QKC9tmYKvVnKJFD3bCuF1C1/AJrctrjI
	Z+a7SjjM9pYSMK9UUxRTmPWYYDRqOcl0FNdSTGNlMjO5O4cxeePPADPSm0owOWkrJNM0mokz
	D5rUgFnT2F21CDY9d4uNjkpgJa4XbphG1kyFipv4d0p/3SNSQD6dDUy4kPaCPX1dwMhH4dB0
	PZkNTLk8+imA5YpJ8K+poEZHGQsVAOb2FeGGgjl9BG7mTe8zRjtCZUkFlg24eubD4Sp/4/Mp
	WFX+HTNmFwFsW/1BGbNOsEi+yTEwTp+ACw17hIFJPSuqZ0gDW9HX4NfFFszAfNoV3s8YAYaP
	MPobAdUTW/sBS/o87E+vIowTsgDUjmv2J5jQV6BO0bPvA+l1LlyumwXGcTTcyNPihlUhbQs1
	nZhR0wZ2VY/jD4G16oCc6oCc6r+c6oBcGcDVwIoVh4ulNyMkni5SUYw0PjbCJTwuRgP056Pb
	XchtBlOdvlpAc4HDIfNPKiyIR4gSpEkxWuCtX0iBCazC4/QXFysLc/f08UDeXt6eHqfP+DhY
	m5cLfgfy6AiRjL3NsmJWEiaJj2alWsDhmghSgDJF/NpW2Plyez60gRz0q9so+rIiJ5p1IS3J
	wrD2RxUbl4QDZmU9Q2rZ0GJuYO9EoFAb/bb8XGKHz+eQAP801/SzO572y5FuhU1qx4bkn92r
	Y9edSpUnL5u1+tkdG71rEbISfjjF+fhMsmWwGd+7L79xOjFpcE8isBcvB2zkLic54NJIkbsT
	JpGK/gLgZrBcOQMAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrJKsWRmVeSWpSXmKPExsVy+t9jAd2VZSwhBs/28Vn8nXSM3aJ58Xo2
	iwX7rS06Z29gt+hdcJXN4mzTG3aLzolL2C2+XHnIZLHp8TVWi8u75rBZzDi/j8li7ZG77Ban
	rn9ms/jXe5DR4szpS6wW//fsYLc4/Kad1eLIw93sFqt2/WG0uP2bz0HE48nBeUwev39NYvTY
	Oesuu8fsjpmsHptWdbJ57J+7ht1j85J6j9v/HjN7TL6xnNHjyokmVo/e5ndsHluutrN49G1Z
	xejxeZNcAF9UA6NNRmpiSmqRQmpecn5KZl66rZJ3cLxzvKmZgaGuoaWFuZJCXmJuqq2Si0+A
	rltmDtDLSgpliTmlQKGAxOJiJX07TBNCQ9x0LWAaI3R9Q4LgeowM0EDCGsaMg6fusxS0iFTc
	6z3B1sD4jL+LkZNDQsBEYsbK0+wQtpjEhXvr2boYuTiEBBYxSvSfnMMCkuAVEJT4MfkekM3B
	wSwgL3HkUjZImFlAXWLSvEXMEPWvGCX2fHrPDlGvJTGn8wcTiM0ioCrxbON/VhCbDcieuOI+
	G4gtKhAm8eLVLmYQW0RAX6K77QojyCBmgZesEqtu/QJrEBawlTjTuowVYkMHo8ShG5vANnAK
	eEmcnniMbQKjwCwkB85COHAWkgMXMDKvYhRNLUguKE5KzzXSK07MLS7NS9dLzs/dxAhOVs+k
	dzCuarA4xCjAwajEw/tgFnOIEGtiWXFl7iFGCQ5mJRHe1AyWECHelMTKqtSi/Pii0pzU4kOM
	pkDvTWSWEk3OBybSvJJ4Q2MTMyNLI3NDCyNjcyVx3oOt1oFCAumJJanZqakFqUUwfUwcnFIN
	jKIBi/5+OuJosPZbebCb/bFJi1TbZgfF6T5d+U57n/TeIxvlwooFFyvJnbuy5lxpKWMYx3S7
	+qT7c8V+Zyntevbn/ufJH85zVM+M50wRuiEYIMXo+kbee9PE3Tz5r98Xd/27abmBWzrh3BPV
	I+e9Td/8lqqNUoh2VHd4yNedcuHiXubQ8sVfvyqxFGckGmoxFxUnAgCWeZkzbAMAAA==
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Marek,

On 2014년 08월 05일 19:47, Marek Szyprowski wrote:
> To correctly disable hardware window during driver init, both enable bits
> (WINCONx_ENWIN in WINCON and SHADOWCON_CHx_ENABLE in SHADOWCON) must be
> cleared, otherwise hardware fails to re-enable such window later.
> 
> While touching this function, also temporarily disable ctx->suspended flag
> to let fimd_wait_for_vblank function really to do its job.
> 
> Signed-off-by: Marek Szyprowski <m.szyprowski@samsung.com>
> ---
>  drivers/gpu/drm/exynos/exynos_drm_fimd.c | 25 ++++++++++++++++++-------
>  1 file changed, 18 insertions(+), 7 deletions(-)
> 
> diff --git a/drivers/gpu/drm/exynos/exynos_drm_fimd.c b/drivers/gpu/drm/exynos/exynos_drm_fimd.c
> index 41904df..7a363d2 100644
> --- a/drivers/gpu/drm/exynos/exynos_drm_fimd.c
> +++ b/drivers/gpu/drm/exynos/exynos_drm_fimd.c
> @@ -165,27 +165,38 @@ static void fimd_wait_for_vblank(struct exynos_drm_manager *mgr)
>  		DRM_DEBUG_KMS("vblank wait timed out.\n");
>  }
>  
> -
>  static void fimd_clear_channel(struct exynos_drm_manager *mgr)
>  {
>  	struct fimd_context *ctx = mgr->ctx;
> -	int win, ch_enabled = 0;
> +	int state, win, ch_enabled = 0;

It doesn't need to declare state variable here because this variable is
used only when ch_enabled is 1.

>  
>  	DRM_DEBUG_KMS("%s\n", __FILE__);
>  
>  	/* Check if any channel is enabled. */
>  	for (win = 0; win < WINDOWS_NR; win++) {
> -		u32 val = readl(ctx->regs + SHADOWCON);
> -		if (val & SHADOWCON_CHx_ENABLE(win)) {
> -			val &= ~SHADOWCON_CHx_ENABLE(win);
> -			writel(val, ctx->regs + SHADOWCON);
> +		u32 val = readl(ctx->regs + WINCON(win));

WARNING: Missing a blank line after declarations

> +		if (val & WINCONx_ENWIN) {
> +			/* wincon */
> +			val &= ~WINCONx_ENWIN;
> +			writel(val, ctx->regs + WINCON(win));
> +
> +			/* unprotect windows */
> +			if (ctx->driver_data->has_shadowcon) {
> +				val = readl(ctx->regs + SHADOWCON);
> +				val &= ~SHADOWCON_CHx_ENABLE(win);
> +				writel(val, ctx->regs + SHADOWCON);
> +			}
>  			ch_enabled = 1;
>  		}
>  	}
>  
>  	/* Wait for vsync, as disable channel takes effect at next vsync */
> -	if (ch_enabled)
> +	if (ch_enabled) {
> +		state = ctx->suspended;

int state = ctx->suspended;

> +		ctx->suspended = 0;
>  		fimd_wait_for_vblank(mgr);
> +		ctx->suspended = state;
> +	}
>  }
>  
>  static int fimd_mgr_initialize(struct exynos_drm_manager *mgr,
> 

Above is trivial so I fixed them. Picked it up.

Thanks,
Inki Dae



