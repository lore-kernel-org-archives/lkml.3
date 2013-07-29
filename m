Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755541Ab3G2Hca (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Jul 2013 03:32:30 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:37219 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752206Ab3G2Hc2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Jul 2013 03:32:28 -0400
X-AuditID: cbfee690-b7f6f6d00000740c-ca-51f61a8abab0
From: Cho KyongHo <pullip.cho@samsung.com>
To: "'Grant Grundler'" <grundler@chromium.org>
Cc: "'Linux ARM Kernel'" <linux-arm-kernel@lists.infradead.org>,
        "'Linux IOMMU'" <iommu@lists.linux-foundation.org>,
        "'Linux Kernel'" <linux-kernel@vger.kernel.org>,
        "'Linux Samsung SOC'" <linux-samsung-soc@vger.kernel.org>,
        "'Hyunwoong Kim'" <khw0178.kim@samsung.com>,
        "'Joerg Roedel'" <joro@8bytes.org>,
        "'Kukjin Kim'" <kgene.kim@samsung.com>,
        "'Prathyush'" <prathyush.k@samsung.com>,
        "'Rahul Sharma'" <rahul.sharma@samsung.com>,
        "'Subash Patel'" <supash.ramaswamy@linaro.org>,
        "'Keyyoung Park'" <keyyoung.park@samsung.com>,
        "'Antonios Motakis'" <a.motakis@virtualopensystems.com>,
        kvmarm@lists.cs.columbia.edu,
        "'Sachin Kamat'" <sachin.kamat@linaro.org>
References: <003e01ce89f3$4cdb45e0$e691d1a0$@samsung.com>
 <CANEJEGtWTZHZEr=XzPXHFbJtP7U5JFD-o58kRjLe23XaTzv=fA@mail.gmail.com>
In-reply-to: <CANEJEGtWTZHZEr=XzPXHFbJtP7U5JFD-o58kRjLe23XaTzv=fA@mail.gmail.com>
Subject: RE: [PATCH v8 08/12] iommu/exynos: remove prefetch buffer setting when
 enabling System MMU
Date: Mon, 29 Jul 2013 16:32:25 +0900
Message-id: <003d01ce8c2d$c5c349d0$5149dd70$@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=utf-8
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Outlook 14.0
Content-language: ko
Thread-index: AQLS0WPwDAfdACUd5r8gehP/s+f24AJfHaepl1++R0A=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprFKsWRmVeSWpSXmKPExsVy+t8zQ90uqW+BBn/3yFrcuXuO1eLVkR9M
	Fgv2W1t0zt7AbrH54DoWi94FV9ksGu9NYLP4eOo4u8Wmx9dYLS7vmsNmMeP8PiaLCys2sltM
	WXSY1eLkn15Gi5brvUwO/B5PDs5j8pjdcJHF4861PWwe5zetYfbYvKTeY/KN5YwefVtWMXp8
	3iTnceXoGaYAzigum5TUnMyy1CJ9uwSujPfbvrEWnJGtOLZhNXsD4w6RLkZODgkBE4nVV3vY
	IGwxiQv31gPZXBxCAssYJe5+mMYGU9T9rIkdIrGIUaLj6wFmCOcvo8SjidcYQarYBLQkVs89
	DmRzcIgI6EjMX2IPUsMs0MUq8XPmYrBJQgINjBKPJwaB2JwCwRJ9PzazgtjCAqkSvRdbWEF6
	WQRUJbZtrQMJ8wpYSmz7tIkZwhaU+DH5HgtICbOAusSUKbkgYWYBeYnNa94yQ9ypILHj7GtG
	iLiIxL4X78BsEQEricd3v4KdLCFwgkOipb2JCSTBIiAg8W3yIbCZEgKyEpsOQM2RlDi44gbL
	BEaJWUg2z0LYPAvJ5llIti1gZFnFKJpakFxQnJReZKJXnJhbXJqXrpecn7uJEZIuJuxgvHfA
	+hBjMtD2icxSosn5wHSTVxJvaGxmZGFqYmpsZG5pRpqwkjiveot1oJBAemJJanZqakFqUXxR
	aU5q8SFGJg5OqQbGaUHvDM7sLXxqcnJx/MfTKvbu99/IyW+Y8a/oYe++38VRrAUFPP49CX+F
	CqbsrjxU9PrL+b/OM4Q6/U6X+BpEXrzlu3PCl7RJLTMr+qSed1VnRYSzKRkmR246c+yg1TLX
	LyvLF8Xe1BEOEL/302D7/7R5fcfTGk80fMuIM/iSG5AWKHRzpqG+EktxRqKhFnNRcSIAsnl8
	nC0DAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrOKsWRmVeSWpSXmKPExsVy+t9jAd0uqW+BBjNui1vcuXuO1eLVkR9M
	Fgv2W1t0zt7AbrH54DoWi94FV9ksGu9NYLP4eOo4u8Wmx9dYLS7vmsNmMeP8PiaLCys2sltM
	WXSY1eLkn15Gi5brvUwO/B5PDs5j8pjdcJHF4861PWwe5zetYfbYvKTeY/KN5YwefVtWMXp8
	3iTnceXoGaYAzqgGRpuM1MSU1CKF1Lzk/JTMvHRbJe/geOd4UzMDQ11DSwtzJYW8xNxUWyUX
	nwBdt8wcoA+UFMoSc0qBQgGJxcVK+naYJoSGuOlawDRG6PqGBMH1GBmggYR1jBnvt31jLTgj
	W3Fsw2r2BsYdIl2MnBwSAiYS3c+a2CFsMYkL99azdTFycQgJLGKU6Ph6gBnC+cso8WjiNUaQ
	KjYBLYnVc48D2RwcIgI6EvOX2IPUMAt0sUr8nLmYDaRGSKCBUeLxxCAQm1MgWKLvx2ZWEFtY
	IFWi92ILK0gvi4CqxLatdSBhXgFLiW2fNjFD2IISPybfYwEpYRZQl5gyJRckzCwgL7F5zVtm
	iDsVJHacfc0IEReR2PfiHZgtImAl8fjuV+YJjEKzkEyahTBpFpJJs5B0L2BkWcUomlqQXFCc
	lJ5rqFecmFtcmpeul5yfu4kRnIyeSe1gXNlgcYhRgINRiYf3odOXQCHWxLLiytxDjBIczEoi
	vBxGXwOFeFMSK6tSi/Lji0pzUosPMSYDvTmRWUo0OR+YKPNK4g2NTcyMLI3MLIxMzM1JE1YS
	5z3Qah0oJJCeWJKanZpakFoEs4WJg1OqgTEuLuXpgw9ztrhFBTOEvr9/invGCh6fTcbOr4rD
	8nM7ztgcN3ydaSF3+8j20AWdC0NcePusKi8nlhpyqbRmrCv9cvX5AVG3w/r3bCKu5cbe7VzD
	kHAwb/+hSUtLNqXeEHpnXp1pW78l4nd6F991Uc6Izq8BHvk3udPdEz4UFyps7Ev50R3zUoml
	OCPRUIu5qDgRAKMjNfOKAwAA
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> -----Original Message-----
> From: grundler@google.com [mailto:grundler@google.com] On Behalf Of Grant Grundler
> Sent: Saturday, July 27, 2013 2:36 AM
> 
> On Fri, Jul 26, 2013 at 4:28 AM, Cho KyongHo <pullip.cho@samsung.com> wrote:
> > Prefetch buffer must be handled accurately, exact range of a buffer,
> > frame by frame manually. Otherwise, it may causes page fault or
> > deadlock in System MMU.
> > Thus this patch removes prefetch buffer setting when System MMU is
> > initialized(enabled).
> >
> > Signed-off-by: Cho KyongHo <pullip.cho@samsung.com>
> 
> Reviewed-by: Grant Grundler <grundler@chromium.org>
> 
> BTW, cscope doesn't find any callers of exynos_sysmmu_enable().
> Want to submit another patch to remove it?
> 
> (Note I'm talking about exynos_sysmmu_enable() without "__" prefix).

Oh, I missed removing that function.

Thank you.

> 
> cheers,
> grant
> 
> > ---
> >  drivers/iommu/exynos-iommu.c |   32 +++++++++++++++++++++++++++-----
> >  1 files changed, 27 insertions(+), 5 deletions(-)
> >
> > diff --git a/drivers/iommu/exynos-iommu.c b/drivers/iommu/exynos-iommu.c
> > index cfc02ed..87f6bb7 100644
> > --- a/drivers/iommu/exynos-iommu.c
> > +++ b/drivers/iommu/exynos-iommu.c
> > @@ -80,6 +80,8 @@
> >  #define CTRL_BLOCK     0x7
> >  #define CTRL_DISABLE   0x0
> >
> > +#define CFG_FLPDCACHE  (1 << 20) /* System MMU 3.2+ only */
> > +
> >  #define REG_MMU_CTRL           0x000
> >  #define REG_MMU_CFG            0x004
> >  #define REG_MMU_STATUS         0x008
> > @@ -96,6 +98,9 @@
> >
> >  #define REG_MMU_VERSION                0x034
> >
> > +#define MMU_MAJ_VER(reg)       (reg >> 28)
> > +#define MMU_MIN_VER(reg)       ((reg >> 21) & 0x7F)
> > +
> >  #define REG_PB0_SADDR          0x04C
> >  #define REG_PB0_EADDR          0x050
> >  #define REG_PB1_SADDR          0x054
> > @@ -200,6 +205,22 @@ static bool is_sysmmu_active(struct sysmmu_drvdata *data)
> >         return data->activations > 0;
> >  }
> >
> > +static unsigned int __sysmmu_version(struct sysmmu_drvdata *data,
> > +                                    int idx, unsigned int *minor)
> > +{
> > +       unsigned long major;
> > +
> > +       major = readl(data->sfrbases[idx] + REG_MMU_VERSION);
> > +
> > +       if (minor)
> > +               *minor = MMU_MIN_VER(major);
> > +
> > +       if (MMU_MAJ_VER(major) > 3)
> > +               return 1;
> > +
> > +       return MMU_MAJ_VER(major);
> > +}
> > +
> >  static void sysmmu_unblock(void __iomem *sfrbase)
> >  {
> >         __raw_writel(CTRL_ENABLE, sfrbase + REG_MMU_CTRL);
> > @@ -460,14 +481,15 @@ static int __exynos_sysmmu_enable(struct sysmmu_drvdata *data,
> >         data->pgtable = pgtable;
> >
> >         for (i = 0; i < data->nsfrs; i++) {
> > +               unsigned int min;
> > +
> >                 __sysmmu_set_ptbase(data->sfrbases[i], pgtable);
> >
> > -               if ((readl(data->sfrbases[i] + REG_MMU_VERSION) >> 28) == 3) {
> > -                       /* System MMU version is 3.x */
> > -                       __raw_writel((1 << 12) | (2 << 28),
> > +               if ((__sysmmu_version(data, i, &min) == 3) && (min > 1)) {
> > +                       unsigned long cfg;
> > +                       cfg = __raw_readl(data->sfrbases[i] + REG_MMU_CFG);
> > +                       __raw_writel(cfg | CFG_FLPDCACHE,
> >                                         data->sfrbases[i] + REG_MMU_CFG);
> > -                       __sysmmu_set_prefbuf(data->sfrbases[i], 0, -1, 0);
> > -                       __sysmmu_set_prefbuf(data->sfrbases[i], 0, -1, 1);
> >                 }
> >
> >                 __raw_writel(CTRL_ENABLE, data->sfrbases[i] + REG_MMU_CTRL);
> > --
> > 1.7.2.5
> >
> >

