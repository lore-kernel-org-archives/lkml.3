Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754784AbaD2FtH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Apr 2014 01:49:07 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:18260 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754486AbaD2FtE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Apr 2014 01:49:04 -0400
X-AuditID: cbfee61b-b7f766d00000646c-c1-535f3d48ce29
From: Robert Baldyga <r.baldyga@samsung.com>
To: sameo@linux.intel.com, lee.jones@linaro.org
Cc: a.zummo@towertech.it, linux-kernel@vger.kernel.org,
        rtc-linux@googlegroups.com, m.szyprowski@samsung.com,
        k.kozlowski@samsung.com, Robert Baldyga <r.baldyga@samsung.com>
Subject: [PATCH v2 0/2] mfd: max77693: improve regmap support
Date: Tue, 29 Apr 2014 07:48:45 +0200
Message-id: <1398750527-20715-1-git-send-email-r.baldyga@samsung.com>
X-Mailer: git-send-email 1.9.1
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFmpmluLIzCtJLcpLzFFi42I5/e+xoK6HbXywQfcnGYslF6+yW7x+YWhx
	/+tRRovLu+awWaw9cpfd4sHhnewW+zs7GC1Od7M6cHjsmXiSzePOtT1sHvNOBnr0bVnF6DF9
	3k8mj8+b5ALYorhsUlJzMstSi/TtErgy7l2Yylqwl7Ni159+lgbGrexdjJwcEgImEq/f90LZ
	YhIX7q1n62Lk4hASmM4o8WfJGiinnUmi+/RaZpAqNgEdiS3fJzCC2CIC+hIfdlxlBiliFtjI
	KDFx5kcgh4NDWMBW4t8udZAaFgFViYW7HoD18gq4Ssy6384MsU1O4uSxyawTGLkXMDKsYhRN
	LUguKE5KzzXSK07MLS7NS9dLzs/dxAgOmmfSOxhXNVgcYhTgYFTi4e2IiQsWYk0sK67MPcQo
	wcGsJMKbbxUfLMSbklhZlVqUH19UmpNafIhRmoNFSZz3YKt1oJBAemJJanZqakFqEUyWiYNT
	qoFx5uEflzMeHrI5+or/lrLJ+WlL1nI0yfTM/uRys4jnbNBH5cQbVzJOLxHoasw3093IoPgh
	Qmfn78OTGL+x31t4zHuPmuqFiSKv+VXLmxV6OPa3lc8+3hmt2Ljg64oT0xQFL0yYsmn2BMav
	avpfJly6syvrxtorMkzR3/+E3Nyl9Ny7b4/AHhULMSWW4oxEQy3mouJEADrcfiAWAgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patchset modifies max77693 driver and associated function drivers
to improve regmap support. It removes unnecessary wrapper functions,
which make code more clean, and modifies IRQ handling to use regmap irq.

Best regards
Robert Baldyga
Samsung R&D Institute Poland

Changelog:

v2:
- change type of array given to regmap_bulk_read() from unsigned int to u8
- remove mfd_remove_devices() call from error handling, since it's not needed
- call disable_irq()/enable_irq() in suspend/resume regardless of wakeup source

v1: https://lkml.org/lkml/2014/4/28/298

Robert Baldyga (2):
  mfd: max77693: remove unnecessary wrapper functions
  mfd: max77693: handle IRQs using regmap

 drivers/extcon/extcon-max77693.c     |  35 ++--
 drivers/mfd/Kconfig                  |   1 +
 drivers/mfd/Makefile                 |   2 +-
 drivers/mfd/max77693-irq.c           | 336 -----------------------------------
 drivers/mfd/max77693.c               | 203 ++++++++++++++-------
 drivers/regulator/max77693.c         |  12 +-
 include/linux/mfd/max77693-private.h |  55 ++++--
 7 files changed, 213 insertions(+), 431 deletions(-)
 delete mode 100644 drivers/mfd/max77693-irq.c

-- 
1.9.1

