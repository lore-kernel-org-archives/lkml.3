Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753379AbaKDMxK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Nov 2014 07:53:10 -0500
Received: from mailout2.w1.samsung.com ([210.118.77.12]:9008 "EHLO
	mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753227AbaKDMxH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Nov 2014 07:53:07 -0500
X-AuditID: cbfec7f5-b7f956d000005ed7-d2-5458cc2edb2a
From: Krzysztof Kozlowski <k.kozlowski@samsung.com>
To: "Rafael J. Wysocki" <rjw@rjwysocki.net>, Len Brown <len.brown@intel.com>,
        Pavel Machek <pavel@ucw.cz>, Jonathan Corbet <corbet@lwn.net>,
        Russell King <linux@arm.linux.org.uk>,
        Dan Williams <dan.j.williams@intel.com>,
        Vinod Koul <vinod.koul@intel.com>,
        Ulf Hansson <ulf.hansson@linaro.org>,
        Alan Stern <stern@rowland.harvard.edu>,
        Krzysztof Kozlowski <k.kozlowski@samsung.com>,
        linux-pm@vger.kernel.org, linux-kernel@vger.kernel.org,
        dmaengine@vger.kernel.org, Lars-Peter Clausen <lars@metafoo.de>,
        Michal Simek <michal.simek@xilinx.com>
Cc: Kevin Hilman <khilman@kernel.org>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
Subject: [PATCH v9 0/4] amba/dma: pl330: add Power Management support
Date: Tue, 04 Nov 2014 13:52:46 +0100
Message-id: <1415105570-7871-1-git-send-email-k.kozlowski@samsung.com>
X-Mailer: git-send-email 1.9.1
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrELMWRmVeSWpSXmKPExsVy+t/xq7p6ZyJCDKb/sbDYOGM9q8WTA+2M
	FtOnXmC0WD31L6vF6xeGFk83P2ayONv0ht1iyeT5rBadE5ewW8yaspfJ4vKuOWwWn3uPMFrc
	vsxrsfbIXXaLdy8jLO6eOspmceb0JVaLCb8vsFkcXxtu8bJvP4uDiEdLcw+bx+yOmawei/e8
	ZPLYtKqTzePOtT1sHov7JrN6LHlziNVjy9V2Fo/Zd38wevRtWcXosWL1d3aPz5vkPPZ+/s0S
	wBvFZZOSmpNZllqkb5fAlbFgzyuWgr3iFTeWszYwvhDqYuTkkBAwkZi9ahs7hC0mceHeejYQ
	W0hgKaPExXlBEHYfk8T1ry4gNpuAscTm5UuAarg4RARWsUi82nMdzGEW+MgocXP1RmaQKmEB
	V4njM98zgtgsAqoSB18cALN5BdwkWhdeYoLYJidx8thk1gmM3AsYGVYxiqaWJhcUJ6XnGukV
	J+YWl+al6yXn525ihIT71x2MS49ZHWIU4GBU4uFdER8RIsSaWFZcmXuIUYKDWUmEd9tpoBBv
	SmJlVWpRfnxRaU5q8SFGJg5OqQbGpPLsdWxiz/T8/zpkrOrO0p7a8Zr9+AGNvQdEaq+l2ZV9
	sLo7OfSC08rtOzduO/FjaXRIda/rhK9v97EZTf/hOZnL+7PD/HPNnC5rPj6923DkC9fmz5uV
	9Rr7f5658W6F/tsjTPwiG8Vjnqfpb54pbjmTwc7kr5XLA6fk1rhF+ubpfF1G92+9VmIpzkg0
	1GIuKk4EAMZa9X1VAgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,


Changes since v8:
=================
1. Remove the pm_runtime_is_irq_safe() wrapper (patch 1).
2. Patch 2/4 (amba): Store current irq_safe during runtime suspend.
   Resume will mirror suspend's work. Add a macro for
   safe access of irq_safe if CONFIG_PM_RUNTIME is unset.
   Dropped reviewed-by Ulf Hansson (major changes in patch).

Changes since v7:
=================
1. Add reviewed-by Ulf Hansson (patches 3, 4 and 5).
2. Patch 2/5: Fix missing return in amba_pclk_prepare() (suggested by
   Ulf Hansson).
3. Rebased on next-20141020.

Changes since v6:
=================
1. Add patch 5 removing the amba_pclk_*able macros.
2. Patch 2/5: Remove IS_ERR, use static inline functions instead
   of macros.
3. Patch 4/5: Force runtime suspend/resume in system sleep
   callbacks. Put with autosuspend at end of probe instead of no_idle.
   Suggested by Ulf Hansson.

Changes since v5:
=================
1. Patch 1/4: Add Ulf Hansson's reviewed-by.
2. Patch 4/4: Use PM runtime autosuspend (suggested by Ulf Hansson).
3. Rebase on next-20140922. 

Changes since v4:
1. Patch 3/4: Explicitly initialize amba_device.irq_safe field after
   probing driver (suggested by Russell King).

Changes since v3:
1. Patch 1/4: Document new API in Documentation/power/runtime_pm.txt
   (pointed by Alan Stern).

Changes since v2:
1. Add patch 1 (PM / Runtime: Add getter for querying the IRQ safe option)
2. Add patch 2 (amba: Add helper macros for (un)preparing AMBA clock)
3. Patch 3/4: Rewrite the idea. If IRQ safe runtime PM is set then
   do not unprepare/prepare the clocks. Suggested by Russell King.
4. Patch 4/4: During system sleep unprepare the clock.

Changes since v1:
1. Add patch 1 (amba: Allow AMBA drivers to use their own runtime PM).
2. Patch 2/2: Apply Michal Simek's suggestions.
3. Patch 2/2: Fix atomic context safeness in pl330_issue_pending().


Description:
============
This patchset adds runtime and system PM to the pl330 driver.

The runtime PM of pl330 driver requires interrupt safe suspend/resume
callbacks which is in conflict with current amba bus driver.
The latter also unprepares and prepares the AMBA bus clock which
is not safe for atomic context.

The patchset solves this in patch 2/4 by handling clocks in different
way if device driver set interrupt safe runtime PM.

Any comments are welcome.


Tested on board with pl330 DMA driver:
 - Trats2 (Exynos4212)


Best regards,
Krzysztof Kozlowski


Krzysztof Kozlowski (4):
  amba: Add helpers for (un)preparing AMBA clock
  amba: Don't unprepare the clocks if device driver wants IRQ safe
    runtime PM
  dma: pl330: add Power Management support
  amba: Remove unused amba_pclk_enable/disable macros

 drivers/amba/bus.c       | 15 ++++++--
 drivers/dma/pl330.c      | 94 +++++++++++++++++++++++++++++++++++++++++++++---
 include/linux/amba/bus.h | 13 ++++---
 3 files changed, 111 insertions(+), 11 deletions(-)

-- 
1.9.1

