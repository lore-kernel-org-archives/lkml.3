Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763010Ab3DDQTv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Apr 2013 12:19:51 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:22302 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762953Ab3DDQTt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Apr 2013 12:19:49 -0400
X-AuditID: cbfee61b-b7f076d0000034b6-a1-515da823ac43
From: Tomasz Figa <t.figa@samsung.com>
To: linux-kernel@vger.kernel.org
Cc: devicetree-discuss@lists.ozlabs.org, linux-samsung-soc@vger.kernel.org,
        kyungmin.park@samsung.com, lrg@ti.com,
        broonie@opensource.wolfsonmicro.com, m.szyprowski@samsung.com,
        kgene.kim@samsung.com, Tomasz Figa <t.figa@samsung.com>
Subject: [PATCH 0/3] regulator: max8998: Add support for Device Tree
Date: Thu, 04 Apr 2013 18:19:20 +0200
Message-id: <1365092363-12763-1-git-send-email-t.figa@samsung.com>
X-Mailer: git-send-email 1.7.10
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFmpjluLIzCtJLcpLzFFi42I5/e+xgK7yithAgx9dJhb/Zp9iszgw+yGr
	Re+Cq2wWZ5vesFtc3jWHzWLG+X1MFk3bJ7BbrD1yl91i/YzXLA6cHudnLGT0eDnxN5tH35ZV
	jB7Hb2xn8vi8SS6ANYrLJiU1J7MstUjfLoEr4/Qlk4K/XBVvmmexNDDeZ+9i5OSQEDCReHRq
	DjOELSZx4d56ti5GLg4hgUWMEk8uLmSEcLqYJF697GMCqWITUJP43PCIDcQWEVCQ2Nz7jBWk
	iFngPaPElScvWUESwgIuEms+/AMrYhFQlXh//THYCl4BJ4nbW9+yQqyTl3h6v49tAiP3AkaG
	VYyiqQXJBcVJ6blGesWJucWleel6yfm5mxjBofNMegfjqgaLQ4wCHIxKPLwZfbGBQqyJZcWV
	uYcYJTiYlUR4j7YAhXhTEiurUovy44tKc1KLDzFKc7AoifMebLUOFBJITyxJzU5NLUgtgsky
	cXBKNTD6mb56MVPlkEDvR6/6t27Kn3wnMV7iFN/Yca8h+FBYe9yEruUpDhMPTT1462SE36nd
	wQcZy4LaMpdf8M3xCykxn/x85+4lkfmxfXcs792o3rNi7pN/aszHmxQqPzN4a7dFJv/0nVbf
	XtLAWPoq3pP75nHD4GqJgjTby6fLV/w1/+p0v2rSs24lluKMREMt5qLiRAAgn00cGQIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This series adds Device Tree support to max8998 MFD driver.

First patch reworks max8998-irq driver to use IRQ domains. Second patch
prepares platform data structure to ease generating it at runtime from
data parsed from device tree. Third patch implements Device Tree
binding and adds necessary documentation.

Tested on Universal C210 board.

Tomasz Figa (3):
  mfd: Add irq domain support for max8998 interrupts
  regulator: max8998: Use arrays for specifying voltages in platform
    data
  mfd: max8998: Add support for Device Tree

 Documentation/devicetree/bindings/mfd/max8998.txt | 111 ++++++++++
 arch/arm/mach-exynos/mach-universal_c210.c        |   8 +-
 arch/arm/mach-s5pv210/mach-aquila.c               |   8 +-
 arch/arm/mach-s5pv210/mach-goni.c                 |   8 +-
 drivers/mfd/Kconfig                               |   1 +
 drivers/mfd/max8998-irq.c                         |  61 +++---
 drivers/mfd/max8998.c                             |  76 ++++++-
 drivers/regulator/max8998.c                       | 254 ++++++++++++++++------
 drivers/rtc/rtc-max8998.c                         |  17 +-
 include/linux/mfd/max8998-private.h               |   6 +-
 include/linux/mfd/max8998.h                       |  20 +-
 11 files changed, 435 insertions(+), 135 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/mfd/max8998.txt

-- 
1.8.1.5

