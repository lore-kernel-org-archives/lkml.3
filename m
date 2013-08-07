Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756229Ab3HGQVK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Aug 2013 12:21:10 -0400
Received: from mail-ob0-f172.google.com ([209.85.214.172]:37560 "EHLO
	mail-ob0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751992Ab3HGQVI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Aug 2013 12:21:08 -0400
MIME-Version: 1.0
In-Reply-To: <001b01ce9366$9f7427a0$de5c76e0$@samsung.com>
References: <003c01ce89f3$3abc4bc0$b034e340$@samsung.com>
	<27536111.odlCO093Zi@amdc1032>
	<003c01ce91cd$427fad70$c77f0850$@samsung.com>
	<1429191.3FDem6vW0S@amdc1032>
	<002001ce928a$f5a7f390$e0f7dab0$@samsung.com>
	<5200F781.9020300@samsung.com>
	<CANEJEGtQuKG5err-R7SxD6m+aJWVmn47X9NJLx7UzaRkKhUMoQ@mail.gmail.com>
	<001b01ce9366$9f7427a0$de5c76e0$@samsung.com>
Date: Wed, 7 Aug 2013 09:21:07 -0700
X-Google-Sender-Auth: T9CcaEWG4_U38Jp1MzzXZSp_YZQ
Message-ID: <CANEJEGtDm6FYvx8DdiGofk5ViU8kWK-3QvTvtU66Mvhfn+sDCQ@mail.gmail.com>
Subject: Re: [PATCH v8 06/12] ARM: dts: Add description of System MMU of
 Exynos SoCs
From: Grant Grundler <grundler@chromium.org>
To: Cho KyongHo <pullip.cho@samsung.com>
Cc: Grant Grundler <grundler@chromium.org>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        Linux ARM Kernel <linux-arm-kernel@lists.infradead.org>,
        Linux IOMMU <iommu@lists.linux-foundation.org>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Linux Samsung SOC <linux-samsung-soc@vger.kernel.org>,
        Hyunwoong Kim <khw0178.kim@samsung.com>,
        Joerg Roedel <joro@8bytes.org>, Kukjin Kim <kgene.kim@samsung.com>,
        Prathyush <prathyush.k@samsung.com>,
        Rahul Sharma <rahul.sharma@samsung.com>,
        Subash Patel <supash.ramaswamy@linaro.org>,
        Keyyoung Park <keyyoung.park@samsung.com>,
        Antonios Motakis <a.motakis@virtualopensystems.com>,
        kvmarm@lists.cs.columbia.edu, Sachin Kamat <sachin.kamat@linaro.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 7, 2013 at 5:07 AM, Cho KyongHo <pullip.cho@samsung.com> wrote:
...
>> I don't understand how this is possible. Can someone explain this
>> better in the IOMMU documentation please?
>
> System MMU is dedicated to a master H/W such as FIMD and FIMC.

Sory - Exynos 5250 documentation I have (confidential version) uses
FIMD and FIMC but never explains what they are nor identifies them in
a diagram. Based on the references, they are related to the video
mixer but I don't know exactly what function FIMD/FIMC serve.


> Thus, attaching a master H/W to an iommu domain can be thought as
> attaching a System MMU to an iommu domain even though such thinking
> is not correct view of the relationship between iommu domain and
> System MMU.

This almost makes sense. I understand the above to mean the System MMU
is a proxy for the FIMD and FIMC.

>> I can understand we might have multiple MMUs in a system...e.g. every
>> range of memory might have it's own MMU. But they share the same
>> physical address space and generally live under one page table.
>> Because of "one page table" I would consider them one entity from the
>> the IOMMUs perspective.
>
> Sorry, I don't understand.
> Do you mean you are thinking that it is better to share one page table
> by all IOMMUs in a system?

No. This is how the previous IOMMUs I worked on functioned. It doesn't
mean this is how current ones should.

My example above was referring to CPU MMUs in the case of NUMA
architectures. Each NUMA CPU socket can have it's own MMU (and TLB)
and corresponding memory controller. All CPUs in an SMP system map
process and kernel virtual addresses to one common "physical" address
space. This means allocation and use of "physical address space" has
to be managed as one entity (even if several page tables exist in the
implementation - e.g. NUMA).


Back to the original comment that started my question (pulled out of
context now...sorry):
   "Just make sure that it will be possible to attach more than one
sysmmu controller to one iommu domain."

Does that mean the IOMMU now has to map to multiple "physical address
spaces" or am I completely missing what a SysMMU does?

The "SysMMU" is the System Memory Management Unit, right?

I still thinking one IOMMU domain maps one (IO) virtual address space
to one (common with CPU and other IOMMU) physical address space.

cheers,
grant

>
> Thank you,
> KyongHo
>>
>> thanks,
>> grant
>
