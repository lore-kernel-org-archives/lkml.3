Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932305AbaD1N4c (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Apr 2014 09:56:32 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:36186 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932261AbaD1N4a (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Apr 2014 09:56:30 -0400
X-AuditID: cbfee61a-b7f2b6d000006c4d-88-535e5e0cf7b7
From: Robert Baldyga <r.baldyga@samsung.com>
To: sameo@linux.intel.com, lee.jones@linaro.org
Cc: a.zummo@towertech.it, linux-kernel@vger.kernel.org,
        rtc-linux@googlegroups.com, m.szyprowski@samsung.com,
        k.kozlowski@samsung.com, Robert Baldyga <r.baldyga@samsung.com>
Subject: [PATCH v4 0/3] mfd: max8997: add regmap support
Date: Mon, 28 Apr 2014 15:55:55 +0200
Message-id: <1398693358-28336-1-git-send-email-r.baldyga@samsung.com>
X-Mailer: git-send-email 1.9.1
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFmpiluLIzCtJLcpLzFFi42I5/e+xoC5PXFywwa09ZhZLLl5lt3j9wtDi
	/tejjBaXd81hs1h75C67xYPDO9kt9nd2MFqc7mZ14PDYM/Ekm8eda3vYPOadDPTo27KK0WP6
	vJ9MHp83yQWwRXHZpKTmZJalFunbJXBlLD53lqWgg6/i9eeTzA2M/7m6GDk5JARMJP697mWH
	sMUkLtxbzwZiCwlMZ5SYfku7i5ELyG5nkljz6BsLSIJNQEdiy/cJjCC2iIC+xIcdV5lBipgF
	NjJKTJz5Ecjh4BAWsJC4cVcXpIZFQFWisfcSWC+vgKvEm++bmCCWyUmcPDaZdQIj9wJGhlWM
	oqkFyQXFSem5hnrFibnFpXnpesn5uZsYwSHzTGoH48oGi0OMAhyMSjy8BlFxwUKsiWXFlbmH
	GCU4mJVEeKe7AoV4UxIrq1KL8uOLSnNSiw8xSnOwKInzHmi1DhQSSE8sSc1OTS1ILYLJMnFw
	SjUwFqfKnJC/WSsT/HP3nDO2Lg+fbTC/uPr9YqZtlgxLpY9Yq+3Rens/f/VZpq2PbWRSxS6/
	sd5ufcSsKmTvn4XGx5+4m4VIBrWKrO3dsGOLYv2GDakHtsz5xOsj47GS0/LLasPjzItXnfJ2
	5jebdbNy79nCjKXtwjM0jnR+WJ07q40h+Zr52t8LVymxFGckGmoxFxUnAgDL4ITXFQIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

This patchset modifies max8997 driver and associated function drivers to use
register maps instead of operating directly on i2c bus. This change allowed
to simplify irq handling, and to move some initializations to individual
function drivers. Hence now when some functions are not enabled, their i2c
clients, regmaps and irqs are not registered.

Best regards
Robert Baldyga
Samsung R&D Institute Poland

Changelog:

v4:
- remove patch moving regmap handling to function drivers

v3: https://lkml.org/lkml/2014/3/13/101
- fix error handling
- fix deinitializations order
- move muic irq enum values renaming to separate patch

v2: https://lkml.org/lkml/2014/3/12/237
- rebase patches on Lee Jones' MFD tree
- add missing selects in Kconfig
- add missing deinitializations
- add interrupt disabling when suspend
- few minor changes and typo fixes

v1: https://lkml.org/lkml/2014/3/11/291

Robert Baldyga (3):
  mfd: max8997: use regmap to access registers
  mfd: max8997: handle IRQs using regmap
  mfd: max8997: change irq names to upper case

 drivers/extcon/extcon-max8997.c     |  66 +++---
 drivers/input/misc/max8997_haptic.c |  34 ++--
 drivers/leds/leds-max8997.c         |  13 +-
 drivers/mfd/Kconfig                 |   3 +-
 drivers/mfd/Makefile                |   2 +-
 drivers/mfd/max8997-irq.c           | 387 ------------------------------------
 drivers/mfd/max8997.c               | 245 +++++++++++++++--------
 drivers/power/max8997_charger.c     |  33 +--
 drivers/regulator/max8997.c         |  87 ++++----
 drivers/rtc/rtc-max8997.c           |  58 +++---
 include/linux/mfd/max8997-private.h |  82 ++++++--
 11 files changed, 381 insertions(+), 629 deletions(-)
 delete mode 100644 drivers/mfd/max8997-irq.c

-- 
1.9.1

