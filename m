Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161343Ab3FUMeD (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Jun 2013 08:34:03 -0400
Received: from mailout1.w1.samsung.com ([210.118.77.11]:62912 "EHLO
	mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161083Ab3FUMeA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Jun 2013 08:34:00 -0400
X-AuditID: cbfec7f5-b7f376d000001ec6-94-51c448369aae
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
        Samuel Ortiz <sameo@linux.intel.com>, Tomasz Figa <t.figa@samsung.com>
Subject: [PATCH v2 0/3] regulator: max8998: Add support for Device Tree
Date: Fri, 21 Jun 2013 14:33:34 +0200
Message-id: <1371818017-5215-1-git-send-email-t.figa@samsung.com>
X-Mailer: git-send-email 1.8.2.1
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrPLMWRmVeSWpSXmKPExsVy+t/xq7pmHkcCDVqbGS2WXLzKbjH14RM2
	iwN/djBa7J6zmMWid8FVNotvVzqYLDY9vsZqcXnXHDaLGef3MVncvsxrcXjFASaLdS+ns1js
	7+xgtDjdzWpxacZ1dov1M16zOAh4tDT3sHks+HyF3WPnrLvsHnsmnmTz2LSqk83j1eqZrB53
	ru1h85h3MtBj85J6j74tqxg9ziw4wu4xfd5PJo/Pm+QCeKO4bFJSczLLUov07RK4Mtr6N7MU
	HOGu2Nd8iaWBcRpHFyMnh4SAicTyr+dYIGwxiQv31rN1MXJxCAksZZS49vcSlNPHJDH3xzKw
	KjYBNYnPDY/YQGwRAQWJzb3PWEFsZoHVLBLvVxSB2MIC7hJTHh9jArFZBFQlfp67wghi8wo4
	SlzubGGD2KYgcXz7NsYJjNwLGBlWMYqmliYXFCel5xrpFSfmFpfmpesl5+duYoQE8tcdjEuP
	WR1iFOBgVOLhDVQ6HCjEmlhWXJl7iFGCg1lJhDf4DlCINyWxsiq1KD++qDQntfgQIxMHp1QD
	Y8SFhfFp/9MbuHY27yv5su133QRn6b1iOw3OPtg878vWprPxs/8YMj4JOnTm/ZuU9Cv9Yfds
	eiY/uJW/RXl23htD8W1vt79TvphYJv1H/wTDHrcbCu7GBWE/K9aKZrvLvM4TChMy3O0f8vLj
	tVilpyWmj+TWPalrfSW/n+dZsPWiyuqNO65O4VRiKc5INNRiLipOBACBQwxzQgIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This series adds Device Tree support to max8998 MFD driver.

First patch reworks max8998-irq driver to use IRQ domains. Second patch
prepares platform data structure to ease generating it at runtime from
data parsed from device tree. Third patch implements Device Tree
binding and adds necessary documentation.

Tested on Universal C210 board.

Changes since v1:
 - rebased to current for-next of regulator tree

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
 drivers/rtc/rtc-max8998.c                         |  14 +-
 include/linux/mfd/max8998-private.h               |   6 +-
 include/linux/mfd/max8998.h                       |  20 +-
 11 files changed, 433 insertions(+), 134 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/mfd/max8998.txt

-- 
1.8.2.1

