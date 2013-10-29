Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752226Ab3J2Tvr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Oct 2013 15:51:47 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:59363 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751380Ab3J2Tvc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Oct 2013 15:51:32 -0400
X-AuditID: cbfee61b-b7fd56d000001fc6-ad-527011c3d33e
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
To: linux-arm-kernel@lists.infradead.org, mturquette@linaro.org
Cc: linux@arm.linux.org.uk, jiada_wang@mentor.com, kyungmin.park@samsung.com,
        laurent.pinchart@ideasonboard.com, linux-kernel@vger.kernel.org,
        uclinux-dist-devel@blackfin.uclinux.org, linux-mips@linux-mips.org,
        linux-sh@vger.kernel.org, Sylwester Nawrocki <s.nawrocki@samsung.com>
Subject: [PATCH v7 0/5] clk: clock deregistration support
Date: Tue, 29 Oct 2013 20:51:03 +0100
Message-id: <1383076268-8984-1-git-send-email-s.nawrocki@samsung.com>
X-Mailer: git-send-email 1.7.9.5
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprHLMWRmVeSWpSXmKPExsVy+t9jAd3DggVBBvf2sFv0/Km0ONv0ht2i
	c+ISdotNj6+xWlzeNYfNYsLUSewWc/5MYba4fZnX4umEi2wWh9+0s1osbPjC7sDt0dLcw+ax
	crq3x+yOmawed67tYfM4unItk8fmJfUeu782MXr0bVnF6PF5k1wAZxSXTUpqTmZZapG+XQJX
	xuT/S5gKbvBX/J46hb2B8T93FyMnh4SAicTXyZ/YIWwxiQv31rN1MXJxCAksYpTYMf0JM0hC
	SKCDSWLOzHQQm03AUKL3aB8jiC0iYC/xY8JLFpAGZoF5QDUfDrCBJIQFLCWWtj1g6mLk4GAR
	UJXoeuUFEuYVcJVYPmUiWFhCQEFiziSbCYzcCxgZVjGKphYkFxQnpeca6RUn5haX5qXrJefn
	bmIEh9oz6R2MqxosDjEKcDAq8fAaPMgPEmJNLCuuzD3EKMHBrCTCO/04UIg3JbGyKrUoP76o
	NCe1+BCjNAeLkjjvwVbrQCGB9MSS1OzU1ILUIpgsEwenVANjsmCr9tZYWYcjFe+9xKPOzjG8
	KSVc/Fs8IaijR1WCX1jo3HuDZc5e36TTsm6rqidH64eUzOy7nHUq0eISt5Cs/DeBNZPPOgkI
	Lp5g2/KtyWz/RPZVpVPbjyXNtr6wb29E9o2ZJmIP1Ds7QjNObztfJH/6uu+O5KVHDnklm0gz
	6s86sPW7D4MSS3FGoqEWc1FxIgCsB1PXMQIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch series implements clock deregistration in the common clock
framework. Detailed changes are listed at each patch. I have included
an additional patch in this series for the omap3isp driver, required 
to avoid regressions.

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
  omap3isp: Modify clocks registration to avoid circular references
  clk: Provide not locked variant of of_clk_get_from_provider()
  clkdev: Fix race condition in clock lookup from device tree
  clk: Add common __clk_get(), __clk_put() implementations
  clk: Implement clk_unregister()

 arch/arm/include/asm/clkdev.h         |    2 +
 arch/blackfin/include/asm/clkdev.h    |    2 +
 arch/mips/include/asm/clkdev.h        |    2 +
 arch/sh/include/asm/clkdev.h          |    2 +
 drivers/clk/clk.c                     |  185 +++++++++++++++++++++++++++++++--
 drivers/clk/clk.h                     |   16 +++
 drivers/clk/clkdev.c                  |   12 ++-
 drivers/media/platform/omap3isp/isp.c |   22 ++--
 drivers/media/platform/omap3isp/isp.h |    1 +
 include/linux/clk-private.h           |    5 +
 include/linux/clkdev.h                |    5 +
 11 files changed, 235 insertions(+), 19 deletions(-)
 create mode 100644 drivers/clk/clk.h

-- 
1.7.9.5

