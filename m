Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756499Ab3H3Oxi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Aug 2013 10:53:38 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:44915 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755782Ab3H3Oxg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Aug 2013 10:53:36 -0400
X-AuditID: cbfee61b-b7f776d0000016c8-e8-5220b1ee2af2
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
To: linux-arm-kernel@lists.infradead.org
Cc: linux@arm.linux.org.uk, mturquette@linaro.org, jiada_wang@mentor.com,
        kyungmin.park@samsung.com, myungjoo.ham@samsung.com,
        t.figa@samsung.com, g.liakhovetski@gmx.de,
        laurent.pinchart@ideasonboard.com, linux-kernel@vger.kernel.org,
        linux-mips@linux-mips.org, linux-sh@vger.kernel.org,
        Sylwester Nawrocki <s.nawrocki@samsung.com>
Subject: [PATCH v6 0/5] clk: clock deregistration support
Date: Fri, 30 Aug 2013 16:53:17 +0200
Message-id: <1377874402-2944-1-git-send-email-s.nawrocki@samsung.com>
X-Mailer: git-send-email 1.7.9.5
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrFLMWRmVeSWpSXmKPExsVy+t9jAd13GxWCDPauUrJ4v3Eek0XPn0qL
	s01v2C06Jy5ht9j0+BqrxeVdc9gsJkydxG4x588UZovbl3ktnk64yGZxu3EFm8XhN+2sFutn
	vGZx4PVoae5h8/jwMc5jdsdMVo871/aweRxduZbJY/OSeo/dX5sYPfq2rGL0+LxJLoAzissm
	JTUnsyy1SN8ugSuj9cwlpoL/vBVXZr5kaWB8wNXFyMkhIWAi8f/FdHYIW0ziwr31bF2MXBxC
	AosYJXonrWGEcDqYJN72TmQDqWITMJToPdrHCGKLCGhITOl6zA5SxCxwmUli05cusFHCApYS
	ZzdtYAGxWQRUJfacbwFr4BVwlfi8ah9TFyMH0DoFiTmTbCYwci9gZFjFKJpakFxQnJSea6RX
	nJhbXJqXrpecn7uJERyCz6R3MK5qsDjEKMDBqMTDu3O5QpAQa2JZcWXuIUYJDmYlEd6Pi4FC
	vCmJlVWpRfnxRaU5qcWHGKU5WJTEeQ+2WgcKCaQnlqRmp6YWpBbBZJk4OKUaGGMNts4pUVqw
	7/FXg8ykzD/l309Iqc2tkb/2KbKq03ZRRsn9RU731oRueWSxTLioY1bFXMHj6fsFr6hlzSir
	fRYS3C/Kv5Lznkd5UeCyupKw7AQ2tkNTbxXM3jKj9bHcMSHXJJe9T059nqgiyvnh8Mq4Sf8j
	1K+tdT6qJGLVvXVnqHTnsnyhtUosxRmJhlrMRcWJAN6W2tg9AgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch series implements clock deregistration in the common clock
framework. Comparing to v5 it only includes further corrections of NULL
clock handling.

Changes since v5:
 - fixed NULL clock handling in __clk_get(), __clk_put (patch 5/5).

Changes since v4:
 - removed stray struct module forward declaration in patch 3/5.

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
 drivers/clk/clk.c                  |  188 +++++++++++++++++++++++++++++++++---
 drivers/clk/clk.h                  |   16 +++
 drivers/clk/clkdev.c               |   12 ++-
 include/linux/clk-private.h        |    5 +
 include/linux/clkdev.h             |    5 +
 9 files changed, 221 insertions(+), 13 deletions(-)
 create mode 100644 drivers/clk/clk.h

--
1.7.9.5

