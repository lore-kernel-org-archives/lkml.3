Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755472Ab3HXS1g (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 Aug 2013 14:27:36 -0400
Received: from mail-ea0-f180.google.com ([209.85.215.180]:50128 "EHLO
	mail-ea0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755245Ab3HXS1e (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 Aug 2013 14:27:34 -0400
From: Sylwester Nawrocki <sylvester.nawrocki@gmail.com>
To: linux-arm-kernel@lists.infradead.org
Cc: linux@arm.linux.org.uk, mturquette@linaro.org, jiada_wang@mentor.com,
        linux-kernel@vger.kernel.org, uclinux-dist-devel@blackfin.uclinux.org,
        linux-mips@linux-mips.org, linux-sh@vger.kernel.org,
        s.nawrocki@samsung.com
Subject: [PATCH v5 0/5] clk: clock deregistration support
Date: Sat, 24 Aug 2013 20:27:00 +0200
Message-Id: <1377368825-30715-1-git-send-email-s.nawrocki@samsung.com>
X-Mailer: git-send-email 1.7.4.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch series implements clock deregistration in the common clock
framework.  This is required for proper support of clock suppliers as
loadable modules.  Previous version of this series can be found at [1].

Comparing to v4 only a stray struct module forward declaration has been 
removed from patch 3/5. My apologies for spamming.

Changes since v3:
 - replaced WARN_ON() with WARN_ON_ONCE() in clk_nodrv_disable_unprepare()
   callback.

Changes since v2:
 - reordered the patches so the race condition is fixed before it can
   actually cause any issues,
 - fixed handling of NULL clock pointers in __clk_get(), __clk_put(),
 - added patch adding actual asignment of clk->owner; more details are
   discussed in that specific patch.

Changes since v1:
 - moved of_clk_{lock, unlock}, __of_clk_get_from_provider() function
   declaractions to a local header,
 - renamed clk_dummy_* to clk_nodrv_*.

[1] https://lkml.org/lkml/2013/8/24/43

Sylwester Nawrocki (5):
  clk: Provide not locked variant of of_clk_get_from_provider()
  clkdev: Fix race condition in clock lookup from device tree
  clk: Add common __clk_get(), __clk_put() implementations
  clk: Assign module owner of a clock being registered
  clk: Implement clk_unregister

 arch/arm/include/asm/clkdev.h      |    2 +
 arch/blackfin/include/asm/clkdev.h |    2 +
 arch/mips/include/asm/clkdev.h     |    2 +
 arch/sh/include/asm/clkdev.h       |    2 +
 drivers/clk/clk.c                  |  187 +++++++++++++++++++++++++++++++++--
 drivers/clk/clk.h                  |   16 +++
 drivers/clk/clkdev.c               |   12 ++-
 include/linux/clk-private.h        |    5 +
 include/linux/clkdev.h             |    5 +
 9 files changed, 220 insertions(+), 13 deletions(-)
 create mode 100644 drivers/clk/clk.h

-- 
1.7.4.1

