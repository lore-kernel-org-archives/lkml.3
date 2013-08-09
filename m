Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S967789Ab3HIHvd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Aug 2013 03:51:33 -0400
Received: from mail-bk0-f52.google.com ([209.85.214.52]:37651 "EHLO
	mail-bk0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S967449Ab3HIHvb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Aug 2013 03:51:31 -0400
From: Tomasz Figa <tomasz.figa@gmail.com>
To: Cho KyongHo <pullip.cho@samsung.com>
Cc: Tomasz Figa <t.figa@samsung.com>,
        "'Linux ARM Kernel'" <linux-arm-kernel@lists.infradead.org>,
        "'Linux IOMMU'" <iommu@lists.linux-foundation.org>,
        "'Linux Kernel'" <linux-kernel@vger.kernel.org>,
        "'Linux Samsung SOC'" <linux-samsung-soc@vger.kernel.org>,
        devicetree@vger.kernel.org, "'Joerg Roedel'" <joro@8bytes.org>,
        "'Kukjin Kim'" <kgene.kim@samsung.com>,
        "'Prathyush'" <prathyush.k@samsung.com>,
        "'Rahul Sharma'" <rahul.sharma@samsung.com>,
        "'Subash Patel'" <supash.ramaswamy@linaro.org>,
        "'Grant Grundler'" <grundler@chromium.org>,
        "'Antonios Motakis'" <a.motakis@virtualopensystems.com>,
        kvmarm@lists.cs.columbia.edu,
        "'Sachin Kamat'" <sachin.kamat@linaro.org>
Subject: Re: [PATCH v9 00/16] iommu/exynos: Fixes and Enhancements of System MMU driver with DT
Date: Fri, 09 Aug 2013 09:51:22 +0200
Message-ID: <4157684.uh6jPsifpa@flatron>
User-Agent: KMail/4.10.5 (Linux/3.10.4-gentoo; KDE/4.10.5; x86_64; ; )
In-Reply-To: <20130809100016.a22e5938a829f229eb5df00f@samsung.com>
References: <002401ce941a$dad907c0$908b1740$@samsung.com> <2763595.7SYUCgBHXZ@amdc1227> <20130809100016.a22e5938a829f229eb5df00f@samsung.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi KyongHo,

On Friday 09 of August 2013 10:00:16 Cho KyongHo wrote:
> On Thu, 08 Aug 2013 14:13:57 +0200, Tomasz Figa wrote:
> > Hi KyongHo,
> > 
> > Just a little hint for future:
> > 
> > To make reviewing your patches easier, please send all patches (01 and
> > further) as a follow up (reply) to cover letter of the series (patch
> > 00).
> > 
> > This can be achieved by using --thread switch of git send-email for
> > example.
> 
> Thank you for advice.
> However, git send-email and something like that is prohibitted by the
> security policy of my company :(

Oh, that's not nice, but well, such things happen, so I can understand 
this.

> I used an email client in windows O/S.
> 
> I need more consideration to the patches are sent in the order of
> patches.

OK. It should be still possible to send the cover letter first and then 
remaining patches are replies to the cover letter. This would be really 
appreciated by reviewers and maintainer applying such series afterwards.

Best regards,
Tomasz

> Thank you.
> 
> KyongHo.
> 
> > Best regards,
> > Tomasz
> > 
> > On Thursday 08 of August 2013 18:37:10 Cho KyongHo wrote:
> > > The current exynos-iommu(System MMU) driver does not work
> > > autonomously
> > > since it is lack of support for power management of peripheral
> > > blocks.
> > > For example, MFC device driver must ensure that its System MMU is
> > > disabled before MFC block is power-down not to invalidate IOTLB in
> > > the
> > > System MMU when I/O memory mapping is changed. Because a System MMU
> > > resides in the same H/W block, access to control registers of System
> > > MMU while the H/W block is turned off must be prohibited.
> > > 
> > > This set of changes solves the above problem with setting each
> > > System
> > > MMUs as the parent of the device which owns the System MMU to
> > > receive
> > > the information when the device is turned off or turned on.
> > > 
> > > Another big change to the driver is the support for devicetree.
> > > The bindings for System MMU is described in
> > > Documentation/devicetree/bindings/arm/samsung/system-mmu.txt
> > > 
> > > In addition, this patchset also includes several bug fixes and
> > > enhancements of the current driver.
> > > 
> > > Change log:
> > > v9:
> > > - Rebased on the following branches
> > > 
> > >   git.linaro.org/git-ro/people/mturquette/linux.git/clk-next
> > > 
> > > git.kernel.org/pub/scm/linux/kernel/git/kgene/linux-samsung.git/sams
> > > ung- next
> > > git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/master
> > > (3.11-rc4) - Split "add bus notifier for registering System MMU"
> > > into 5 patches - Call clk_prepare() that was missing in v8.
> > > - Fixed base address of sysmmu_tv in exynos4210.dtsi
> > > - BUG_ON() instead of return -EADDRINUSE when trying mapping on an
> > > mapped area - Moved camif_top to 317 in
> > > drivers/clk/samsung/clk-exynos5250.c - Removed 'iommu' property
> > > from 'codec'(mfc) node
> > > - Does not make 'master' clock to be the parent of 'sysmmu' clock.
> > > 
> > >    'master' clock is enabled before accessing control registers of
> > >    System
> > > 
> > > MMU and disabled after the access.
> > > 
> > > v8:
> > > - Reordered patch list: moved "change rwloc to spinlock" to the
> > > last.
> > > - Fixed remained bug in "fix page table maintenance".
> > > - Always return 0 from exynos_iommu_attach_device().
> > > - Removed prefetch buffer setting when System MMU is enabled
> > > 
> > >   due to the restriction of prefetch buffers:
> > >   A prefetch buffer must not hit from more than one DMA.
> > >   For instance with GScalers, if a single prefetch buffer is
> > >   initialized
> > >   with 0x0 ~ 0xFFFFFFFF and a GScaler works on source buffer at
> > > 
> > > 0x10000000 and target buffer @ 0x20000000, the System MMU may be got
> > > deadlock. Clients must initialize prefetch buffers with custom
> > > function
> > > defined in exynos-iommu drivers whenever they need to enable
> > > prefetch
> > > buffers. - The clock of System MMU has no relationship with the
> > > clock of its master H/W. The clock of master H/W is always enabled
> > > when exynos-iommu driver needs to access MMIO area and disabled as
> > > soon as the access finishes. - Removed err_page variable used in
> > > exynos_iommu_unmap() in the previous patch "fix page table
> > > maintenance". - Split a big patch "add bus notifier for registering
> > > System MMU".> > 
> > >    Extracted the following 2 patches: 9/12 and 10/12.
> > > 
> > > - And some additional fixes...
> > > 
> > > v7:
> > > - Rebased on the stable 3.10
> > > - Registered PM domains and gate clocks with DT
> > > - Changed connection method between a System MMU and its master H/W
> > > 
> > >    'mmu-master' property in the node of System MMU
> > >    --> 'iommu' property in the node of master H/W
> > > 
> > > - Marking device descriptor of master H/W of a System MMU with bus
> > > notifier. - Power management (PM_RUNTIME, PM_SLEEP) of System MMUs
> > > with
> > > gpd_dev_ops of Generic IO Powerdomain. gpd_dev_ops are set to the
> > > master H/Ws before they are probed in the bus notifier.
> > > - Removed additional debugging features like debugfs entries and
> > > 
> > >    version names.
> > > 
> > > - Removed support for advanced features of System MMU 3.2 and 3.3
> > > 
> > >    the current IOMMU API cannot handle the feature
> > >   
> > >   (A kind of L2 TLB that fetches several consequence page table
> > >   entries.
> > >   
> > >    It must be initialized by the driver of master H/W whenever it
> > >    works.)
> > > 
> > > v6:
> > > - Rebased on the branch, next/iommu-exynos of
> > > 
> > >   git.kernel.org/pub/scm/linux/kernel/git/kgene/linux-samsung.git
> > > 
> > > v5:
> > > - new bugfix: patch 01
> > > - Reordered patches
> > > 
> > >   * patch 01 ~ 05: Bugfix and enhancements of the existing driver
> > >   * patch 06 ~ 10: Device Tree support and callbacks for power
> > >   management
> > > 
> > > * patch 11     : System MMU 3.2 and 3.3 support
> > > 
> > >   * patch 12 ~ 14: Debugging features
> > > 
> > > - Additional code compaction
> > > 
> > > v4:
> > > - Remove Change-Id from v3 patches
> > > - Change the order of the third and the first patch
> > > 
> > >   Thanks to Kukjin Kim.
> > > 
> > > - Fix memory leak when allocating and assigning exynos_iommu_owner
> > > to
> > > client device if the client device has multiple System MMUs.
> > > 
> > >   Thanks to Rahul Sharma.
> > > 
> > > v3:
> > > - Fix prefetch buffer flag definition for System MMU 3.3 (patch
> > > 10/12)
> > > - Fix incorrect setting for SET_RUNTIME_PM_OPS (patch 09/12)
> > > 
> > >   Thanks to Prathyush.
> > > 
> > > v2:
> > > - Split the patch to iommu/exynos into 9 patches
> > > - Support for System MMU 3.3
> > > - Some code compaction
> > > 
> > > Patch summary:
> > > 
> > > Diffstats:
> > >  .../devicetree/bindings/clock/exynos5250-clock.txt |   26 +
> > >  .../bindings/iommu/samsung,exynos4210-sysmmu.txt   |  103 ++
> > >  arch/arm/boot/dts/exynos4.dtsi                     |  122 +++
> > >  arch/arm/boot/dts/exynos4210.dtsi                  |   25 +
> > >  arch/arm/boot/dts/exynos4x12.dtsi                  |   82 ++
> > >  arch/arm/boot/dts/exynos5250.dtsi                  |  290 ++++++
> > >  drivers/clk/samsung/clk-exynos4.c                  |   27 +-
> > >  drivers/clk/samsung/clk-exynos5250.c               |   57 +-
> > >  drivers/iommu/Kconfig                              |    5 +-
> > >  drivers/iommu/exynos-iommu.c                       | 1061
> > > 
> > > +++++++++++++------- 10 files changed, 1423 insertions(+), 375
> > > deletions(-)
> > > 
> > > --
> > > To unsubscribe from this list: send the line "unsubscribe
> > > linux-samsung-soc" in the body of a message to
> > > majordomo@vger.kernel.org More majordomo info at 
> > > http://vger.kernel.org/majordomo-info.html
> --
> To unsubscribe from this list: send the line "unsubscribe devicetree" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
