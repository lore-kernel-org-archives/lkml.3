Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753436Ab3FXMkW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Jun 2013 08:40:22 -0400
Received: from mailout3.w1.samsung.com ([210.118.77.13]:41062 "EHLO
	mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751169Ab3FXMkF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Jun 2013 08:40:05 -0400
X-AuditID: cbfec7f5-b7f376d000001ec6-b9-51c83e221e21
From: Tomasz Figa <t.figa@samsung.com>
To: linux-kernel@vger.kernel.org
Cc: linux-samsung-soc@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Kukjin Kim <kgene.kim@samsung.com>,
        Alessandro Zummo <a.zummo@towertech.it>,
        Grant Likely <grant.likely@linaro.org>, Jiri Kosina <jkosina@suse.cz>,
        Liam Girdwood <lgirdwood@gmail.com>, Mark Brown <broonie@kernel.org>,
        Masanari Iida <standby24x7@gmail.com>,
        Rob Herring <rob.herring@calxeda.com>, Rob Landley <rob@landley.net>,
        rtc-linux@googlegroups.com, Russell King <linux@arm.linux.org.uk>,
        Samuel Ortiz <sameo@linux.intel.com>,
        Rasmus Villemoes <linux@rasmusvillemoes.dk>,
        Tomasz Figa <t.figa@samsung.com>
Subject: [PATCH v3 0/3] regulator: max8998: Add support for Device Tree
Date: Mon, 24 Jun 2013 14:39:51 +0200
Message-id: <1372077594-17052-1-git-send-email-t.figa@samsung.com>
X-Mailer: git-send-email 1.8.2.1
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrBLMWRmVeSWpSXmKPExsVy+t/xK7pKdicCDVomq1gsuXiV3WLqwyds
	Fgf+7GC02D1nMYtF74KrbBbfrnQwWWx6fI3V4vKuOWwWM87vY7K4fZnX4vGseWwWh1ccYLJY
	93I6i8X+zg5Gi9PdrBaXZlxnt1g/4zWLg6BHS3MPm8eCz1fYPXbOusvusWfiSTaPTas62Txe
	rZ7J6nHn2h42j3knAz02L6n3uNCV7dG3ZRWjx5kFR9g9ps/7yeTxeZNcAF8Ul01Kak5mWWqR
	vl0CV8bDJquCM7wV695PYG5gfMrZxcjJISFgInHqwExWCFtM4sK99WxdjFwcQgJLGSU6j1xk
	hXD6mCTW/OtjBKliE1CT+NzwiA3EFhFQkNjc+wysiFngBotEx+FmdpCEsIC7xOSZC8FsFgFV
	iT/nV7OA2LwCThLz/89ngVinIHF8+zbGCYzcCxgZVjGKppYmFxQnpeca6RUn5haX5qXrJefn
	bmKEhPbXHYxLj1kdYhTgYFTi4f1heTxQiDWxrLgy9xCjBAezkghvqMiJQCHelMTKqtSi/Pii
	0pzU4kOMTBycUg2ME2UTfjA/8Jfffezw4c3/N+TV8Uct25XhJ2KtKlctu+xYloas9PU5hdvP
	CNm/7cwI7ZZNVbFbxdHGt+BCVdVb13/V5rfOTFp+PJOls+G32Bcz+4Wx31vZ+AuyDZ3c3n3W
	v3enMa9fV4DfYY6Wubpr3aNTKpLPlGYu21XlLlMTzneE85pLX5oSS3FGoqEWc1FxIgC+ej4/
	SwIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This series adds Device Tree support to max8998 MFD driver.

First patch reworks max8998-irq driver to use IRQ domains. Second patch
prepares platform data structure to ease generating it at runtime from
data parsed from device tree. Third patch implements Device Tree
binding and adds necessary documentation.

Tested on Universal C210 board.

Changes since v2:
 - switched to simple domains to retain compatibility with platforms
   that do not support Device Tree
 - removed clocks from DT regulator bindings (will be moved to common
   clock framework in further patch)
 - beautified the code a bit
Changes since v1:
 - rebased to current for-next of regulator tree

Tomasz Figa (3):
  mfd: Add irq domain support for max8998 interrupts
  regulator: max8998: Use arrays for specifying voltages in platform
    data
  mfd: max8998: Add support for Device Tree

 Documentation/devicetree/bindings/mfd/max8998.txt | 108 ++++++++++
 arch/arm/mach-exynos/mach-universal_c210.c        |   8 +-
 arch/arm/mach-s5pv210/mach-aquila.c               |   8 +-
 arch/arm/mach-s5pv210/mach-goni.c                 |   8 +-
 drivers/mfd/Kconfig                               |   1 +
 drivers/mfd/max8998-irq.c                         |  65 +++---
 drivers/mfd/max8998.c                             |  75 ++++++-
 drivers/regulator/max8998.c                       | 239 +++++++++++++++-------
 drivers/rtc/rtc-max8998.c                         |  14 +-
 include/linux/mfd/max8998-private.h               |   7 +-
 include/linux/mfd/max8998.h                       |  20 +-
 11 files changed, 421 insertions(+), 132 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/mfd/max8998.txt

-- 
1.8.2.1

