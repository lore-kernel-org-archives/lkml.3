Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966771Ab3HHViV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Aug 2013 17:38:21 -0400
Received: from mail-bk0-f49.google.com ([209.85.214.49]:53729 "EHLO
	mail-bk0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S966702Ab3HHViT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Aug 2013 17:38:19 -0400
From: Tomasz Figa <tomasz.figa@gmail.com>
To: Rob Herring <robherring2@gmail.com>
Cc: Cho KyongHo <pullip.cho@samsung.com>,
        Linux ARM Kernel <linux-arm-kernel@lists.infradead.org>,
        Linux IOMMU <iommu@lists.linux-foundation.org>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Linux Samsung SOC <linux-samsung-soc@vger.kernel.org>,
        Kukjin Kim <kgene.kim@samsung.com>,
        Hyunwoong Kim <khw0178.kim@samsung.com>,
        Prathyush <prathyush.k@samsung.com>,
        Grant Grundler <grundler@chromium.org>, Joerg Roedel <joro@8bytes.org>,
        Keyyoung Park <keyyoung.park@samsung.com>,
        Subash Patel <supash.ramaswamy@linaro.org>,
        Sachin Kamat <sachin.kamat@linaro.org>,
        Antonios Motakis <a.motakis@virtualopensystems.com>,
        kvmarm@lists.cs.columbia.edu, Rahul Sharma <rahul.sharma@samsung.com>,
        Will Deacon <will.deacon@arm.com>
Subject: Re: [PATCH v8 06/12] ARM: dts: Add description of System MMU of Exynos SoCs
Date: Thu, 08 Aug 2013 23:38:10 +0200
Message-ID: <5354557.DijgoUKjW2@flatron>
User-Agent: KMail/4.10.5 (Linux/3.10.4-gentoo; KDE/4.10.5; x86_64; ; )
In-Reply-To: <CAL_Jsq+_5GekzXpjWrtKZi2jWuxHSJxkPmVC4zmakfjAYai=eA@mail.gmail.com>
References: <003c01ce89f3$3abc4bc0$b034e340$@samsung.com> <003801ce8eb7$d7647f10$862d7d30$@samsung.com> <CAL_Jsq+_5GekzXpjWrtKZi2jWuxHSJxkPmVC4zmakfjAYai=eA@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 08 of August 2013 08:09:49 Rob Herring wrote:
> On Thu, Aug 1, 2013 at 8:05 AM, Cho KyongHo <pullip.cho@samsung.com> 
wrote:
> >> -----Original Message-----
> >> From: Rob Herring [mailto:robherring2@gmail.com]
> >> Sent: Saturday, July 27, 2013 10:55 PM
> >> 
> >> On Fri, Jul 26, 2013 at 6:28 AM, Cho KyongHo <pullip.cho@samsung.com> 
wrote:
> >> > Signed-off-by: Cho KyongHo <pullip.cho@samsung.com>
> >> > ---
> >> > 
> >> >  .../bindings/iommu/samsung,exynos4210-sysmmu.txt   |  103 +++++++
> >> >  arch/arm/boot/dts/exynos4.dtsi                     |  122 ++++++++
> >> >  arch/arm/boot/dts/exynos4210.dtsi                  |   25 ++
> >> >  arch/arm/boot/dts/exynos4x12.dtsi                  |   76 +++++
> >> >  arch/arm/boot/dts/exynos5250.dtsi                  |  291
> >> >  ++++++++++++++++++++ 5 files changed, 617 insertions(+), 0
> >> >  deletions(-)
> >> >  create mode 100644
> >> >  Documentation/devicetree/bindings/iommu/samsung,exynos4210-sysmmu
> >> >  .txt>> > 
> >> > diff --git
> >> > a/Documentation/devicetree/bindings/iommu/samsung,exynos4210-sysmm
> >> > u.txt
> >> > b/Documentation/devicetree/bindings/iommu/samsung,exynos4210-sysmm
> >> > u.txt new file mode 100644
> >> > index 0000000..92f0a33
> >> > --- /dev/null
> >> > +++
> >> > b/Documentation/devicetree/bindings/iommu/samsung,exynos4210-sysmm
> >> > u.txt @@ -0,0 +1,103 @@
> >> > +Samsung Exynos4210 IOMMU H/W, System MMU (System Memory Management
> >> > Unit) +
> >> > +Samsung's Exynos architecture contains System MMU that enables
> >> > scattered +physical memory chunks visible as a contiguous region
> >> > to DMA-capable peripheral +devices like MFC, FIMC, FIMD, GScaler,
> >> > FIMC-IS and so forth.
> >> > +
> >> > +System MMU is a sort of IOMMU and support identical translation
> >> > table format to +ARMv7 translation tables with minimum set of page
> >> > properties including access +permissions, shareability and
> >> > security protection. In addition, System MMU has +another
> >> > capabilities like L2 TLB or block-fetch buffers to minimize
> >> > translation +latency.
> >> > +
> >> > +A System MMU is dedicated to a single master peripheral device. 
> >> > Thus, it is +important to specify the correct System MMU in the
> >> > device node of its master +device. Whereas a System MMU is
> >> > dedicated to a master device, the master device +may have more
> >> > than one System MMU.
> >> 
> >> I don't follow the last sentence. Can you elaborate on the type of
> >> connection you are talking about.
> > 
> > Grant also addressed that.
> > 
> > He corrected the sentence like the following:
> >   " Can I suggest rewriting the last two sentences to:
> >      The master device node must correctly specify at least one
> >      SystemMMU. A master  device may have more than one System MMU. "
> > 
> > I will change the sentence
> > 
> >> Also, please align with the ARM system MMU binding that Will Deacon
> >> has submitted particularly in terms of how master connections are
> >> described.
> > 
> > I didn't check it.
> > 
> > Should this align with ARM System MMU bindings?
> > System MMU in Exynos SoC is different from ARM System MMU.
> > It does not follows the specifications of ARM System MMU.
> 
> I'm not saying the h/w is the same or even the same spec, but how you
> describe a master to iommu connection needs to be done in the same
> way. This should be done in the same way for ALL iommu's. And if what
> is defined does not work for you, then we need to understand that and
> fix the binding now.

+1

All IOMMUs should use a generic IOMMU Device Tree bindings (and in 
general, the same should be true for all Device Tree bindings).

This means that if we already have some bindings for IOMMU, then they 
should be reused if possible or extended if there is anything missing.

Of course there might be things that such generic bindings can't specify. 
In this case device-specific properties can be introduced, but this is 
last resort.

Best regards,
Tomasz

