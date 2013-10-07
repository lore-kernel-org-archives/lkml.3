Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753933Ab3JGBwS (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Oct 2013 21:52:18 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:58690 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751769Ab3JGBwP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Oct 2013 21:52:15 -0400
X-AuditID: cbfee68e-b7f756d000004512-34-525213cd5685
Date: Mon, 07 Oct 2013 10:52:12 +0900
From: Cho KyongHo <pullip.cho@samsung.com>
To: Linux ARM Kernel <linux-arm-kernel@lists.infradead.org>,
        Linux DeviceTree <devicetree@vger.kernel.org>,
        Linux IOMMU <iommu@lists.linux-foundation.org>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Linux Samsung SOC <linux-samsung-soc@vger.kernel.org>
Cc: Antonios Motakis <a.motakis@virtualopensystems.com>,
        Grant Grundler <grundler@chromium.org>, Joerg Roedel <joro@8bytes.org>,
        Kukjin Kim <kgene.kim@samsung.com>,
        Prathyush <prathyush.k@samsung.com>,
        Rahul Sharma <rahul.sharma@samsung.com>,
        Sachin Kamat <sachin.kamat@linaro.org>,
        Subash Patel <supash.ramaswamy@linaro.org>,
        Varun Sethi <Varun.Sethi@freescale.com>,
        Sylwester Nawrocki <s.nawrocki@samsung.com>,
        Tomasz Figa <t.figa@samsung.com>
Subject: [PATCH v10 00/20] iommu/exynos: Fixes and Enhancements of System MMU
 driver with DT
Message-id: <20131007105212.1c2a9e29166ff4b4a33468f8@samsung.com>
X-Mailer: Sylpheed 3.3.0 (GTK+ 2.10.14; i686-pc-mingw32)
MIME-version: 1.0
Content-type: text/plain; charset=US-ASCII
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrKIsWRmVeSWpSXmKPExsVy+t8zQ92zwkFBBgdWsFrcuXuO1WL+ESDx
	6sgPJosF+60tOmdvYLfoXXCVzWLT42usFpd3zWGzmHF+H5PFhRUb2S2mLDrManH4TTurxck/
	vYwWLdd7mSzWz3jNYjHz1hoWBwGPJwfnMXnMbrjI4vHvcD+Tx51re9g8Ni+p95h8YzmjR9+W
	VYwenzfJeVw5eoYpgDOKyyYlNSezLLVI3y6BK+Pkjl3sBV8cKu4cncfUwLjOpIuRg0NCwERi
	7Z+ALkZOIFNM4sK99WwgtpDAMkaJYzdqIeImEvf+zmbtYuQCii9ilNh5ZgUThDOJSeJU0yFG
	kCoWAVWJ20/mgtlsAloSq+ceZwQpEhFoY5L42niIBcRhFjjNLLFq9wpmkCphgTiJ0+v3gu3j
	FXCUODJpKQvEPguJC00d7BBxQYkfk++BxZmBpm7e1sQKYctLbF7zlhmifiKHRO95HogrBCS+
	TQZZBvKarMSmA1AlkhIHV9xgmcAoMgvJ1FlIps5CMnUBI/MqRtHUguSC4qT0IiO94sTc4tK8
	dL3k/NxNjJAo7tvBePOA9SHGZKCVE5mlRJPzgUkgryTe0NjMyMLUxNTYyNzSjDRhJXFetRbr
	QCGB9MSS1OzU1ILUovii0pzU4kOMTBycUg2MPRPLb1c+ezVx6ZIXh8O+n7zd2Khtr54b8WRq
	sLve51c9FlL85fMt1yeU3n7O9J5d/ljp/40bVpUvuv6A8VbH11DR+duWHdIIfHEwt/Tf+67p
	085oelbvWpKSvud8/tz3L3n+daXbiaYYld7ijiyd2L7jVMzXWxOPxp98lb6pnGVx74yj8cwX
	nyuxFGckGmoxFxUnAgCGKTDP+AIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrKKsWRmVeSWpSXmKPExsVy+t9jAd0zwkFBBr/mWlvcuXuO1WL+ESDx
	6sgPJosF+60tOmdvYLfoXXCVzWLT42usFpd3zWGzmHF+H5PFhRUb2S2mLDrManH4TTurxck/
	vYwWLdd7mSzWz3jNYjHz1hoWBwGPJwfnMXnMbrjI4vHvcD+Tx51re9g8Ni+p95h8YzmjR9+W
	VYwenzfJeVw5eoYpgDOqgdEmIzUxJbVIITUvOT8lMy/dVsk7ON453tTMwFDX0NLCXEkhLzE3
	1VbJxSdA1y0zB+gNJYWyxJxSoFBAYnGxkr4dpgmhIW66FjCNEbq+IUFwPUYGaCBhHWPGyR27
	2Au+OFTcOTqPqYFxnUkXIyeHhICJxL2/s1khbDGJC/fWs3UxcnEICSxilNh5ZgUThDOJSeJU
	0yFGkCoWAVWJ20/mgtlsAloSq+ceZwQpEhFoY5L42niIBcRhFjjNLLFq9wpmkCphgTiJ0+v3
	soHYvAKOEkcmLWWB2GchcaGpgx0iLijxY/I9sDgz0NTN25pYIWx5ic1r3jJPYOSbhaRsFpKy
	WUjKFjAyr2IUTS1ILihOSs810itOzC0uzUvXS87P3cQIThTPpHcwrmqwOMQowMGoxMO7435g
	kBBrYllxZe4hRgkOZiUR3kt1QCHelMTKqtSi/Pii0pzU4kOMyUB/T2SWEk3OByaxvJJ4Q2MT
	MyNLIzMLIxNzc9KElcR5D7ZaBwoJpCeWpGanphakFsFsYeLglGpgXCv+5PimO4tT+lq63AK/
	6U16evr40XczDNnthA+57hDefKU8qDF49q+oP67u6oLX+u6p3w3cM4PvUm8Tx5yDFZ+OK/ms
	DeIQYf41ZU+lxUmxlWGXH3d8uxXmWOos0/7ULirJRPOrTcvJdPVlC+I/Mu1R3WKhtemF8FST
	Zd/FDTI2L2GpPrj2lhJLcUaioRZzUXEiAEe0rqFYAwAA
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The current exynos-iommu(System MMU) driver does not work autonomously
since it is lack of support for power management of peripheral blocks.
For example, MFC device driver must ensure that its System MMU is disabled
before MFC block is power-down not to invalidate IOTLB in the System MMU
when I/O memory mapping is changed. Because a System MMU resides in the
same H/W block, access to control registers of System MMU while the H/W
block is turned off must be prohibited.

This set of changes solves the above problem with setting each System MMUs
as the parent of the device which owns the System MMU to receive the
information when the device is turned off or turned on.

Another big change to the driver is the support for devicetree.
The bindings for System MMU is described in
Documentation/devicetree/bindings/arm/samsung/system-mmu.txt

In addition, this patchset also includes several bug fixes and enhancements
of the current driver.

Change log:
v10:
- Rebased on the following branches
  git.linaro.org/git-ro/people/mturquette/linux.git/clk-next
  git.kernel.org/pub/scm/linux/kernel/git/kgene/linux-samsung.git/for-next
  git.kernel.org/pub/scm/linux/kernel/git/joro/iommu.git/next
  git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/master (3.12-rc3)
- Set parent clock to all System MMU clocks.
- Add clock and DT descriptos for Exynos5420
- Modified error handling in exynos_iommu_init()
- Split "iommu/exynos: support for device tree" patch into the following 6 patches
  iommu/exynos: handle only one instance of System MMU
  iommu/exynos: always enable runtime PM
  iommu/exynos: always use a single clock descriptor
  iommu/exynos: remove dbgname from drvdata of a System MMU
  iommu/exynos: use managed driver helper functions
  iommu/exynos: support for device tree
- Remove 'interrupt-names' and 'status' properties from DT
- Change n:1 relationship between master:System MMU into 1:1 relationship.
- Removed custom fault handler and print the status of System MMU
  whenever System MMU fault is occurred.
- Post Antonios Motakis's commit together:
  "iommu/exynos: add devices attached to the System MMU to an IOMMU group"

v9:
- Rebased on the following branches
  git.linaro.org/git-ro/people/mturquette/linux.git/clk-next
  git.kernel.org/pub/scm/linux/kernel/git/kgene/linux-samsung.git/samsung-next
  git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/master (3.11-rc4)
- Split "add bus notifier for registering System MMU" into 5 patches
- Call clk_prepare() that was missing in v8.
- Fixed base address of sysmmu_tv in exynos4210.dtsi
- BUG_ON() instead of return -EADDRINUSE when trying mapping on an mapped area
- Moved camif_top to 317 in drivers/clk/samsung/clk-exynos5250.c
- Removed 'iommu' property from 'codec'(mfc) node
- Does not make 'master' clock to be the parent of 'sysmmu' clock.
   'master' clock is enabled before accessing control registers of System MMU
   and disabled after the access.

v8:
- Reordered patch list: moved "change rwloc to spinlock" to the last.
- Fixed remained bug in "fix page table maintenance".
- Always return 0 from exynos_iommu_attach_device().
- Removed prefetch buffer setting when System MMU is enabled
  due to the restriction of prefetch buffers:
  A prefetch buffer must not hit from more than one DMA.
  For instance with GScalers, if a single prefetch buffer is initialized
  with 0x0 ~ 0xFFFFFFFF and a GScaler works on source buffer at 0x10000000
  and target buffer @ 0x20000000, the System MMU may be got deadlock.
  Clients must initialize prefetch buffers with custom function defined
  in exynos-iommu drivers whenever they need to enable prefetch buffers.
- The clock of System MMU has no relationship with the clock of its master H/W.
  The clock of master H/W is always enabled when exynos-iommu driver needs to
  access MMIO area and disabled as soon as the access finishes.
- Removed err_page variable used in exynos_iommu_unmap() in the previous patch
  "fix page table maintenance".
- Split a big patch "add bus notifier for registering System MMU".
   Extracted the following 2 patches: 9/12 and 10/12.
- And some additional fixes...

v7:
- Rebased on the stable 3.10
- Registered PM domains and gate clocks with DT
- Changed connection method between a System MMU and its master H/W
   'mmu-master' property in the node of System MMU
   --> 'iommu' property in the node of master H/W
- Marking device descriptor of master H/W of a System MMU with bus notifier.
- Power management (PM_RUNTIME, PM_SLEEP) of System MMUs with gpd_dev_ops
   of Generic IO Powerdomain. gpd_dev_ops are set to the master H/Ws
   before they are probed in the bus notifier.
- Removed additional debugging features like debugfs entries and
   version names.
- Removed support for advanced features of System MMU 3.2 and 3.3
   the current IOMMU API cannot handle the feature
  (A kind of L2 TLB that fetches several consequence page table entries.
   It must be initialized by the driver of master H/W whenever it works.)

v6:
- Rebased on the branch, next/iommu-exynos of
  git.kernel.org/pub/scm/linux/kernel/git/kgene/linux-samsung.git

v5:
- new bugfix: patch 01
- Reordered patches
  * patch 01 ~ 05: Bugfix and enhancements of the existing driver
  * patch 06 ~ 10: Device Tree support and callbacks for power management
  * patch 11     : System MMU 3.2 and 3.3 support
  * patch 12 ~ 14: Debugging features
- Additional code compaction

v4:
- Remove Change-Id from v3 patches
- Change the order of the third and the first patch
  Thanks to Kukjin Kim.
- Fix memory leak when allocating and assigning exynos_iommu_owner to client
  device if the client device has multiple System MMUs.
  Thanks to Rahul Sharma.

v3:
- Fix prefetch buffer flag definition for System MMU 3.3 (patch 10/12)
- Fix incorrect setting for SET_RUNTIME_PM_OPS (patch 09/12)
  Thanks to Prathyush.

v2:
- Split the patch to iommu/exynos into 9 patches
- Support for System MMU 3.3
- Some code compaction

Patch summary:
[PATCH 01/20] iommu/exynos: do not include removed header
[PATCH 02/20] iommu/exynos: add missing cache flush for removed page table entries
[PATCH 03/20] iommu/exynos: change error handling when page table update is failed
[PATCH 04/20] iommu/exynos: fix L2TLB invalidation
[PATCH 05/20] iommu/exynos: allocate lv2 page table from own slab
[PATCH 06/20] iommu/exynos: always enable runtime PM
[PATCH 07/20] iommu/exynos: always use a single clock descriptor
[PATCH 08/20] iommu/exynos: remove dbgname from drvdata of a System MMU
[PATCH 09/20] iommu/exynos: use managed device helper functions
[PATCH 10/20] clk: exynos: add gate clock descriptions of System MMU
[PATCH 11/20] ARM: dts: Add description of System MMU of Exynos SoCs
[PATCH 12/20] iommu/exynos: support for device tree
[PATCH 13/20] iommu/exynos: gating clocks of master H/W
[PATCH 14/20] iommu/exynos: remove custom fault handler
[PATCH 15/20] iommu/exynos: remove calls to Runtime PM API functions
[PATCH 16/20] iommu/exynos: turn on useful configuration options
[PATCH 17/20] iommu/exynos: add support for power management subsystems.
[PATCH 18/20] iommu/exynos: change rwlock to spinlock
[PATCH 19/20] iommu/exynos: return 0 if iommu_attach_device() successes
[PATCH 20/20] iommu/exynos: add devices attached to the System MMU to an IOMMU group

Diffstats:
 .../devicetree/bindings/clock/exynos5250-clock.txt |   28 +
 .../devicetree/bindings/clock/exynos5420-clock.txt |    3 +
 .../bindings/iommu/samsung,exynos4210-sysmmu.txt   |   76 ++
 arch/arm/boot/dts/exynos4.dtsi                     |  105 ++
 arch/arm/boot/dts/exynos4210.dtsi                  |   21 +
 arch/arm/boot/dts/exynos4x12.dtsi                  |   82 ++
 arch/arm/boot/dts/exynos5250.dtsi                  |  262 +++++
 arch/arm/boot/dts/exynos5420.dtsi                  |  296 ++++++
 drivers/clk/samsung/clk-exynos5250.c               |   49 +-
 drivers/clk/samsung/clk-exynos5420.c               |   12 +-
 drivers/iommu/Kconfig                              |    5 +-
 drivers/iommu/exynos-iommu.c                       | 1033 +++++++++++++-------
 12 files changed, 1585 insertions(+), 387 deletions(-)
