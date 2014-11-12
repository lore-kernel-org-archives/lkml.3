Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752799AbaKLOcj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Nov 2014 09:32:39 -0500
Received: from mailout3.w1.samsung.com ([210.118.77.13]:60986 "EHLO
	mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752462AbaKLOch (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Nov 2014 09:32:37 -0500
X-AuditID: cbfec7f5-b7f956d000005ed7-1d-54636f81f25b
From: Krzysztof Kozlowski <k.kozlowski@samsung.com>
To: "Rafael J. Wysocki" <rjw@rjwysocki.net>, Len Brown <len.brown@intel.com>,
        Pavel Machek <pavel@ucw.cz>, Russell King <linux@arm.linux.org.uk>,
        Dan Williams <dan.j.williams@intel.com>,
        Vinod Koul <vinod.koul@intel.com>,
        Ulf Hansson <ulf.hansson@linaro.org>,
        Alan Stern <stern@rowland.harvard.edu>, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org, dmaengine@vger.kernel.org
Cc: Kevin Hilman <khilman@kernel.org>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        Krzysztof Kozlowski <k.kozlowski@samsung.com>
Subject: [PATCH v11 0/6] amba/dmaengine: pl330: add Power Management support
Date: Wed, 12 Nov 2014 15:32:22 +0100
Message-id: <1415802748-30530-1-git-send-email-k.kozlowski@samsung.com>
X-Mailer: git-send-email 1.9.1
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrOLMWRmVeSWpSXmKPExsVy+t/xq7qN+ckhBm/uS1lsnLGe1WL61AuM
	Fqun/mW1eP3C0OLp5sdMFmeb3rBbdE5cwm4xa8peJovLu+awWXzuPcJocfsyr8XaI3fZLe6e
	Ospmceb0JVaLCb8vsFkcXxtu8bJvP4uDoEdLcw+bx+yOmawei/e8ZPLYtKqTzePOtT1sHluu
	trN4zL77g9Gjb8sqRo8Vq7+ze3zeJBfAFcVlk5Kak1mWWqRvl8CV0bP7AlvBSeWKrTN2Mzcw
	TpXpYuTkkBAwkXj5aCEzhC0mceHeerYuRi4OIYGljBJfTjUwQzh9TBIPHq9jAaliEzCW2Lx8
	CViViEA7s0TfuqlsIAlmgUVMEk1TFUFsYQEfiRtzzoKNZRFQleh6/JcVxOYVcJdo7mlnhVgn
	J3Hy2GTWCYzcCxgZVjGKppYmFxQnpeca6RUn5haX5qXrJefnbmKEBO7XHYxLj1kdYhTgYFTi
	4f2glRwixJpYVlyZe4hRgoNZSYR3Vw5QiDclsbIqtSg/vqg0J7X4ECMTB6dUA6O/TqLDOt1m
	69Cw/+/+Rn3awfJgCVPfin0u+oXS/7PL89gq5b4ppfz/lT3Rsqx47dzrv/aFvdPek1PKq7Wj
	9qlx5Om5B2cXm6TITI6qEO4O8140Y/mmh8ymmW0/sl32PHgUwPN3w8EXAnWhPiLfjFgsV1wT
	e/zXqn3C3Kv6ATc6VAR9w657RSqxFGckGmoxFxUnAgCEgNbaOgIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Changes since v10:
==================
1. Bring back wrapper pm_runtime_is_irq_safe() (patch 1/6). This
   replaces patch 1/5 from v9 (moving dev->power.irq_safe out of
   CONFIG_PM_RUNTIME).
2. Patch 3/6 amba: Don't store current irq_safe during runtime suspend
   (suggested by Rafael J. Wysocki).
   Because of this change I dropped reviewed-by tags from this patch.
3. Patch 4/6 pl330: Add only runtime PM, without system PM (minor
   changes to the patch so I retained the revewed/acked tags).
   Add ack from Vinod.
4. Add patch 5/6 pl330: Add system PM to the pl330 which *does not*
   depends on runtime PM. I followed the discusions on LKML trying to
   reach consensus.
   Reasons tosplit previous patch into two patches (1st: runtime,
   2nd: system PM):
    - easier review,
    - the first part (runtime PM) could be applied independently to
      system PM support.
6. Patch 6/6 amba: reworked the amba_pclk_* macros into inlines. Previously
   they were not used but now patch 5/6 depends on them.
7. Rebase on next-20141112.

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

The patchset solves this in patch 3/6 by handling clocks in different
way if device driver set interrupt safe runtime PM.

Comments are welcome.


Tested on board with pl330 DMA driver:
 - Trats2 (Exynos4212)


Best regards,
Krzysztof Kozlowski

Krzysztof Kozlowski (6):
  PM / Runtime: Add getter for querying the IRQ safe option
  amba: Add helpers for (un)preparing AMBA clock
  amba: Don't unprepare the clocks if device driver wants IRQ safe
    runtime PM
  dmaengine: pl330: Add runtime Power Management support
  dmaengine: pl330: Add PM sleep support
  amba: Use inlines instead of macros for amba_pclk_enable/disable

 Documentation/power/runtime_pm.txt |  4 ++
 drivers/amba/bus.c                 | 15 ++++--
 drivers/dma/pl330.c                | 95 ++++++++++++++++++++++++++++++++++++--
 include/linux/amba/bus.h           | 22 +++++++--
 include/linux/pm_runtime.h         |  6 +++
 5 files changed, 130 insertions(+), 12 deletions(-)

-- 
1.9.1

