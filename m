Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753965AbaIOKOn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Sep 2014 06:14:43 -0400
Received: from mailout1.w1.samsung.com ([210.118.77.11]:25369 "EHLO
	mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753740AbaIOKOj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Sep 2014 06:14:39 -0400
X-AuditID: cbfec7f4-b7f156d0000063c7-cf-5416bc0ca985
From: Krzysztof Kozlowski <k.kozlowski@samsung.com>
To: Russell King <linux@arm.linux.org.uk>,
        Dan Williams <dan.j.williams@intel.com>,
        Vinod Koul <vinod.koul@intel.com>, linux-kernel@vger.kernel.org,
        dmaengine@vger.kernel.org, Ulf Hansson <ulf.hansson@linaro.org>,
        Grant Likely <grant.likely@linaro.org>,
        Lars-Peter Clausen <lars@metafoo.de>,
        Michal Simek <michal.simek@xilinx.com>, linux-pm@vger.kernel.org
Cc: Kyungmin Park <kyungmin.park@samsung.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        Krzysztof Kozlowski <k.kozlowski@samsung.com>
Subject: [PATCH v3 0/4] amba/dma: pl330: add Power Management support
Date: Mon, 15 Sep 2014 12:13:49 +0200
Message-id: <1410776033-22156-1-git-send-email-k.kozlowski@samsung.com>
X-Mailer: git-send-email 1.9.1
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFupkluLIzCtJLcpLzFFi42I5/e/4FV2ePWIhBu9vslpsnLGe1WL61AuM
	Fqun/mW1OPBnB6PF6xeGFmeb3rBbLJk8n9Xi8q45bBafe48wWty+zGux9shddot3LyMsjq8N
	t3jZt5/Fgc+jpbmHzWPxnpdMHneu7WHzWPLmEKtH35ZVjB6fN8l57P38myWAPYrLJiU1J7Ms
	tUjfLoEr48Pp04wFnXwVy87NZWpgnMLdxcjJISFgInHw7Ac2CFtM4sK99UA2F4eQwFJGiYVn
	n7FDOH1MEtt7J4JVsQkYS2xevgSsSkTgHZPEre2nWEAcZoGjjBLTe98ygVQJC7hKTJqzhR3E
	ZhFQlXg76xRYN6+Au8SlA72sEPvkJE4em8w6gZF7ASPDKkbR1NLkguKk9FxDveLE3OLSvHS9
	5PzcTYyQ4Puyg3HxMatDjAIcjEo8vAxXhEOEWBPLiitzDzFKcDArifBO3SoWIsSbklhZlVqU
	H19UmpNafIiRiYNTqoGRYUrlglIBW9O0jvkFZeLBaV8P/o7p2lne1flsNfMdtkD9yd63jzDf
	4F75KviQftCte1Fph5cYzDtts//WxOyVeSYHZ5/3WPlpe8qVIxYxW2NVW2XmLKo93rnystsF
	z/CNFw+6spo98+E7LnhpUlzRj0TO51I8B6a8ydrqay7KLNBd8Zj9dVaiEktxRqKhFnNRcSIA
	sYhmwxwCAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,


This is third version of patches adding runtime PM to the pl330
driver.

The runtime PM of pl330 driver requires interrupt safe suspend/resume
callbacks which is in conflict with current amba bus driver.
The latter also unprepares and prepares the AMBA bus clock which
is not safe for atomic context.

The patchset solves this in patch 3/4 by handling clocks in different
way if device driver set interrupt safe runtime PM.

Any comments are welcome.

Tested on boards with pl330 DMA driver:
 - Trats2 (Exynos4212)
 - Samsung Gear2-like development board (Exynos3250)


Changes since v2:
=================
1. Add patch 1 (PM / Runtime: Add getter for quering the IRQ safe option)
2. Add patch 2 (amba: Add helper macros for (un)preparing AMBA clock)
3. Patch 3/4: Rewrite the idea. If IRQ safe runtime PM is set then
   do not unprepare/prepare the clocks. Suggested by Russell King.
4. Patch 4/4: During system sleep unprepare the clock.

Changes since v1:
=================
1. Add patch 1 (amba: Allow AMBA drivers to use their own runtime PM).
2. Patch 2/2: Apply Michal Simek's suggestions.
3. Patch 2/2: Fix atomic context safeness in pl330_issue_pending().


Best regards,
Krzysztof Kozlowski


Krzysztof Kozlowski (4):
  PM / Runtime: Add getter for quering the IRQ safe option
  amba: Add helper macros for (un)preparing AMBA clock
  amba: Don't unprepare the clocks if device driver wants IRQ safe
    runtime PM
  dma: pl330: add Power Management support

 drivers/amba/bus.c         | 30 +++++++++++++++---
 drivers/dma/pl330.c        | 77 +++++++++++++++++++++++++++++++++++++++++++---
 include/linux/amba/bus.h   |  7 +++++
 include/linux/pm_runtime.h |  6 ++++
 4 files changed, 112 insertions(+), 8 deletions(-)

-- 
1.9.1

