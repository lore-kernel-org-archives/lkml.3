Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755349AbaCRNBd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Mar 2014 09:01:33 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:14043 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755148AbaCRNBa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Mar 2014 09:01:30 -0400
X-AuditID: cbfee68d-b7fcd6d00000315b-6f-532843a9b48f
Date: Tue, 18 Mar 2014 22:01:28 +0900
From: Cho KyongHo <pullip.cho@samsung.com>
To: Tomasz Figa <t.figa@samsung.com>
Cc: Linux ARM Kernel <linux-arm-kernel@lists.infradead.org>,
        Linux DeviceTree <devicetree@vger.kernel.org>,
        Linux IOMMU <iommu@lists.linux-foundation.org>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Linux Samsung SOC <linux-samsung-soc@vger.kernel.org>,
        Antonios Motakis <a.motakis@virtualopensystems.com>,
        Grant Grundler <grundler@chromium.org>, Joerg Roedel <joro@8bytes.org>,
        Kukjin Kim <kgene.kim@samsung.com>,
        Prathyush <prathyush.k@samsung.com>,
        Rahul Sharma <rahul.sharma@samsung.com>,
        Sachin Kamat <sachin.kamat@linaro.org>,
        Sylwester Nawrocki <s.nawrocki@samsung.com>,
        Varun Sethi <Varun.Sethi@freescale.com>
Subject: Re: [PATCH v11 20/27] iommu/exynos: allow having multiple System MMUs
 for a master H/W
Message-id: <20140318220128.564740c88d06b86c9c5c10e3@samsung.com>
In-reply-to: <53232A53.4040708@samsung.com>
References: <20140314141050.c8bedcb66532d277c496796d@samsung.com>
 <53232A53.4040708@samsung.com>
X-Mailer: Sylpheed 3.3.0 (GTK+ 2.10.14; i686-pc-mingw32)
MIME-version: 1.0
Content-type: text/plain; charset=US-ASCII
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrBIsWRmVeSWpSXmKPExsVy+t8zY92VzhrBBrOOs1jcuXuO1WL+ESDx
	6sgPJosF+60tOmdvYLfoXXCVzWLT42usFpd3zWGzmHF+H5PFhRUb2S2mLDrManH4TTurxck/
	vYwW62e8ZrGYeWsNiwO/x5OD85g8ZjdcZPH4d7ifyePOtT1sHpuX1HtMvrGc0aNvyypGj8+b
	5DyuHD3DFMAZxWWTkpqTWZZapG+XwJVxaHU7e8F8gYo/KyayNTB+4uli5OSQEDCR6H3Tzgxh
	i0lcuLeerYuRi0NIYBmjxLK1nSwwRVfm/mSESCxilFj5vJ8JwpnMJHF0zxEgh4ODRUBV4n2X
	P0gDm4CWxOq5xxlBbBEBFYnLp6aDNTMLNLJKPLq/jB0kISyQKPHw0yQmEJtXwFFizuZ/rCA2
	p4C2xP1d05lBZgoJJEm0f06EOMJC4kJTBztEuaDEj8n3wI5jBtq1eVsTK4QtL7F5zVtmkF0S
	Aks5JOYs/w32GouAgMS3yYdYQGZKCMhKbDoA9bGkxMEVN1gmMIrNQjJ2FpKxs5CMXcDIvIpR
	NLUguaA4Kb3IUK84Mbe4NC9dLzk/dxMjJNZ7dzDePmB9iDEZaOVEZinR5HxgqsgriTc0NjOy
	MDUxNTYytzQjTVhJnDfpYVKQkEB6YklqdmpqQWpRfFFpTmrxIUYmDk6pBsYtURV2yluX1xbu
	tetzFfim6ZT1QCegd8bamz0e9fYLHRU+KC78wvB/aW1kk7a4u9fBM2qPP8d9tHy+0bHAuzjv
	75fI44vkTjsXhu88uGbP30kMK5wteLQCmkye7z1y1H/XnCfxPFycl3VXvjCYeFtSZMODGKnz
	f853zq+77u65mrOi+cbH9U1KLMUZiYZazEXFiQCmkDfECwMAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrKKsWRmVeSWpSXmKPExsVy+t9jAd0VzhrBBseOWVvcuXuO1WL+ESDx
	6sgPJosF+60tOmdvYLfoXXCVzWLT42usFpd3zWGzmHF+H5PFhRUb2S2mLDrManH4TTurxck/
	vYwW62e8ZrGYeWsNiwO/x5OD85g8ZjdcZPH4d7ifyePOtT1sHpuX1HtMvrGc0aNvyypGj8+b
	5DyuHD3DFMAZ1cBok5GamJJapJCal5yfkpmXbqvkHRzvHG9qZmCoa2hpYa6kkJeYm2qr5OIT
	oOuWmQP0gZJCWWJOKVAoILG4WEnfDtOE0BA3XQuYxghd35AguB4jAzSQsI4x49DqdvaC+QIV
	f1ZMZGtg/MTTxcjJISFgInFl7k9GCFtM4sK99WxdjFwcQgKLGCVWPu9ngnAmM0kc3XMEyOHg
	YBFQlXjf5Q/SwCagJbF67nGwZhEBFYnLp6YzgtQzCzSySjy6v4wdJCEskCjx8NMkJhCbV8BR
	Ys7mf6wgNqeAtsT9XdOZQWYKCSRJtH9OhDjCQuJCUwc7RLmgxI/J91hAbGagXZu3NbFC2PIS
	m9e8ZZ7AKDALSdksJGWzkJQtYGRexSiaWpBcUJyUnmuoV5yYW1yal66XnJ+7iRGcSJ5J7WBc
	2WBxiFGAg1GJh/cFm3qwEGtiWXFl7iFGCQ5mJRFediuNYCHelMTKqtSi/Pii0pzU4kOMycDA
	mMgsJZqcD0xyeSXxhsYmZkaWRmYWRibm5qQJK4nzHmi1DhQSSE8sSc1OTS1ILYLZwsTBKdXA
	ONdZpphHSqA6QPHiGrGjM5WOr61OyOrkCQxSe3dEbue58sKZPCEftoUy5O75Xtk/QSQgTi0x
	VpvRtspz+f1toZI9Ey35lt69/0qDwWPORTfuy9Ozgo43K07+YHftUEy7mIO+4YezksmJwrJH
	Xfeb1k5PenVYpkVbonaZVuklVT+Trx8vX7unxFKckWioxVxUnAgAj0DST2gDAAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 14 Mar 2014 17:12:03 +0100, Tomasz Figa wrote:
> Hi KyongHo,
> 
> On 14.03.2014 06:10, Cho KyongHo wrote:
> > Some master device descriptor like fimc-is which is an abstraction
> > of very complex H/W may have multiple System MMUs. For those devices,
> > the design of the link between System MMU and its master H/W is needed
> > to be reconsidered.
> >
> > A link structure, sysmmu_list_data is introduced that provides a link
> > to master H/W and that has a pointer to the device descriptor of a
> > System MMU. Given a device descriptor of a master H/W, it is possible
> > to traverse all System MMUs that must be controlled along with the
> > master H/W.
> 
> NAK.
> 
> A device driver should handle particular hardware instances separately, 
> without abstracting a virtual hardware instance consisting of multiple 
> physical ones.
> 
> If such abstraction is needed, it should be done above the exynos-iommu 
> driver, e.g. by something like iommu-composite driver that would 
> aggregate several IOMMUs. Keep in mind that such IOMMUs in a group could 
> be different, e.g. different Exynos SysMMU versions or even completely 
> different IPs handled by different drivers.
> 
> Still, I don't think there is a real need for such abstraction. Instead, 
> related drivers shall be fixed to properly handle multiple memory 
> masters and their IOMMUs.
> 

G2D, Scalers and FIMD of Exynos5420 has 2 System MMUs while aother SoC like
Exynos5250 does not.

I don't understand why you are negative to this approach.
This is the simplest than the others.

Let me show you an example.
FIMC-IS driver just controls MCU in FIMC-IS subsystem and the firmware of
the MCU controls all other peripherals in the subsystem. Each peripherals
have their own System MMU. Moreover, the configuration of the peripherals
varies according to the SoCs.

If System MMU driver accepts multiple masters, everything is done in DT.
But I worry that it is not easy if System MMU driver does not support
multiple masters. 

Thank you.

KyongHo
