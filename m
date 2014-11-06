Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752037AbaKFIhG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Nov 2014 03:37:06 -0500
Received: from mailout4.w1.samsung.com ([210.118.77.14]:46681 "EHLO
	mailout4.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751779AbaKFIhC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Nov 2014 03:37:02 -0500
X-AuditID: cbfec7f4-b7f6c6d00000120b-af-545b332bf874
From: Krzysztof Kozlowski <k.kozlowski@samsung.com>
To: "Rafael J. Wysocki" <rjw@rjwysocki.net>, Len Brown <len.brown@intel.com>,
        Pavel Machek <pavel@ucw.cz>, Russell King <linux@arm.linux.org.uk>,
        Dan Williams <dan.j.williams@intel.com>,
        Vinod Koul <vinod.koul@intel.com>,
        Ulf Hansson <ulf.hansson@linaro.org>,
        Alan Stern <stern@rowland.harvard.edu>, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org, dmaengine@vger.kernel.org,
        Lars-Peter Clausen <lars@metafoo.de>,
        Michal Simek <michal.simek@xilinx.com>
Cc: Kevin Hilman <khilman@kernel.org>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        Krzysztof Kozlowski <k.kozlowski@samsung.com>
Subject: [PATCH v10 0/5] amba/dmaengine: pl330: add Power Management support
Date: Thu, 06 Nov 2014 09:36:45 +0100
Message-id: <1415263010-7992-1-git-send-email-k.kozlowski@samsung.com>
X-Mailer: git-send-email 1.9.1
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrOLMWRmVeSWpSXmKPExsVy+t/xK7raxtEhBlNWslhsnLGe1WL61AuM
	Fqun/mW1eP3C0OLp5sdMFmeb3rBbLJk8n9Wic+ISdotZU/YyWVzeNYfN4nPvEUaL25d5LdYe
	uctu8e5lhMXdU0fZLM6cvsRqMeH3BTaL42vDLV727WdxEPZoae5h85jdMZPVY/Gel0wem1Z1
	snncubaHzWPJm0OsHluutrN4zL77g9Gjb8sqRo8Vq7+ze3zeJOex9/NvlgCeKC6blNSczLLU
	In27BK6MPb3mBYelKn5s0WlgnC7axcjJISFgIrFr8lo2CFtM4sK99UA2F4eQwFJGiT8P/rBC
	OH1MEieuX2QEqWITMJbYvHwJWJWIwHVmie7H/SwgCWaBRUwSTVMVQWxhAR+Jpu5f7CA2i4Cq
	xP9pu4FsDg5eATeJ01P9ILbJSZw8Npl1AiP3AkaGVYyiqaXJBcVJ6bmGesWJucWleel6yfm5
	mxghgf1lB+PiY1aHGAU4GJV4eDdwRocIsSaWFVfmHmKU4GBWEuGN0AMK8aYkVlalFuXHF5Xm
	pBYfYmTi4JRqYAw8e8GnSuh6a82i+Pe3N29xZed5bMj9qmhXfVX0ubXlnAbLPQRu+qbctJo3
	yzRz9iL/jGMBCyRSXZSfVX2+ytsRsubFlX5W9+VzPDbcW+UReSYrpltkxfJwnVeBQSaW3ZtZ
	pGM6JzSe1loX2hTHlHLfMMrdd6orw8OlLNP11ma1FzVs+VCsqsRSnJFoqMVcVJwIADQxyUZK	AgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,


Changes since v9:
=================
1. Add patch 1/5: Move dev->power.irq_safe out of CONFIG_PM_RUNTIME.
   If CONFIG_PM_RUNTIME is not set, amba bus driver must still know
   whether child driver set irq_safe or not. Suggested by Ulf Hansson.

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

The patchset solves this in patch 3/5 by handling clocks in different
way if device driver set interrupt safe runtime PM.

Comments are welcome.


Tested on board with pl330 DMA driver:
 - Trats2 (Exynos4212)


Best regards,
Krzysztof Kozlowski


Krzysztof Kozlowski (5):
  PM / Runtime: Allow accessing irq_safe if no PM_RUNTIME
  amba: Add helpers for (un)preparing AMBA clock
  amba: Don't unprepare the clocks if device driver wants IRQ safe
    runtime PM
  dmaengine: pl330: add Power Management support
  amba: Remove unused amba_pclk_enable/disable macros

 drivers/amba/bus.c         | 17 ++++++--
 drivers/dma/pl330.c        | 96 ++++++++++++++++++++++++++++++++++++++++++++--
 include/linux/amba/bus.h   | 13 +++++--
 include/linux/pm.h         |  2 +-
 include/linux/pm_runtime.h |  4 +-
 5 files changed, 118 insertions(+), 14 deletions(-)

-- 
1.9.1

