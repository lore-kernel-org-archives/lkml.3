Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932925Ab3LDRMY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Dec 2013 12:12:24 -0500
Received: from mailout2.samsung.com ([203.254.224.25]:55733 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753968Ab3LDRMV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Dec 2013 12:12:21 -0500
X-AuditID: cbfee61a-b7f796d000004313-3f-529f6274031f
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
To: mturquette@linaro.org, linux-arm-kernel@lists.infradead.org
Cc: linux@arm.linux.org.uk, linux-media@vger.kernel.org,
        linux-kernel@vger.kernel.org, jiada_wang@mentor.com,
        laurent.pinchart@ideasonboard.com, kyungmin.park@samsung.com,
        Sylwester Nawrocki <s.nawrocki@samsung.com>
Subject: [RESEND PATCH v7 0/5] clk: clock deregistration support
Date: Wed, 04 Dec 2013 18:12:02 +0100
Message-id: <1386177127-2894-1-git-send-email-s.nawrocki@samsung.com>
X-Mailer: git-send-email 1.7.9.5
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFuphluLIzCtJLcpLzFFi42I5/e+xgG5J0vwgg60nJSx6/lRanG16w27R
	OXEJu8Wmx9dYLS7vmsNm0bNhK6vF7cu8Fk8nXGSzOPymndWB06OluYfNY3bHTFaPO9f2sHls
	XlLvsftrE6NH35ZVjB6fN8kFsEdx2aSk5mSWpRbp2yVwZbQ+jSs4IVixb+cCpgbGY7xdjJwc
	EgImEmv7NjFD2GISF+6tZ+ti5OIQEljEKHH/73FGCKeDSWLJ+YOsIFVsAoYSvUf7GEFsEQF7
	ifaWF2AdzAJ3GSWen3sIlhAWcJDo37eICcRmEVCVaP57HayZV8BV4vKczUDrOIDWKUjMmWQz
	gZF7ASPDKkbR1ILkguKk9FxDveLE3OLSvHS95PzcTYzgMHomtYNxZYPFIUYBDkYlHt4XifOD
	hFgTy4orcw8xSnAwK4nwTg4ECvGmJFZWpRblxxeV5qQWH2KU5mBREuc90GodKCSQnliSmp2a
	WpBaBJNl4uCUamCU2LDJ8d8aqdURWsJqC1p1pwvqX7wZfV399fXPTb2NLUWaKbWss4wWXxBK
	fxZruKb2Tkr5FoMn1+af37tse823ZZ4/BH798F5vo+PMOt/XLSLYIuSwzJbdlw722If0Pix1
	Pq94N/riI069zJNP3x9Q0k0sX3HVa81xhv9lb6PaF25ST1vxaHqKEktxRqKhFnNRcSIA98Qe
	AB8CAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch series implements clock deregistration in the common clock
framework. Detailed changes are listed at each patch. There is
included an additional patch for the omap3isp driver, required to avoid
regressions.

These patches were rebased on top of 3.13-rc1 and re-retested, are
also available in git repository:

git://linuxtv.org/snawrocki/samsung.git clk/clk-unregister

Changes since v6:
 - further fixes of NULL clock handling, minor error log changes.

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
  clk: Implement clk_unregister

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

