Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754817Ab3ARLr1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jan 2013 06:47:27 -0500
Received: from mail-ea0-f182.google.com ([209.85.215.182]:39273 "EHLO
	mail-ea0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751858Ab3ARLr0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jan 2013 06:47:26 -0500
From: Fabio Baltieri <fabio.baltieri@linaro.org>
To: linux-watchdog@vger.kernel.org, Samuel Ortiz <sameo@linux.intel.com>,
        Wim Van Sebroeck <wim@iguana.be>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Linus Walleij <linus.walleij@linaro.org>,
        Lee Jones <lee.jones@linaro.org>,
        Srinidhi Kasagar <srinidhi.kasagar@stericsson.com>,
        Fabio Baltieri <fabio.baltieri@linaro.org>
Subject: [PATCH 0/4] add ux500_wdt support
Date: Fri, 18 Jan 2013 12:40:10 +0100
Message-Id: <1358509214-22407-1-git-send-email-fabio.baltieri@linaro.org>
X-Mailer: git-send-email 1.7.12.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

this set adds support for the ux500_wdt timer, implemented in the PRCMU
unit of ST-Ericsson ux500 architecture.

The first two patches add the necessary definitions and function export
to the PRCMU driver currently in mainline, while the third an fourth
patches add the actual watchdog driver and mfd_cell definition to make
it probe when PRCMU is compiled in.

As the patches touches files in both mfd and watchdog subsystems, what do
you think is the best way to handle this set?

Thanks,
Fabio


Fabio Baltieri (4):
  mfd: dbx500-prcmu: add watchdog ID definitions
  mfd: dbx500-prcmu: export a9wdog functions
  watchdog: add support for ux500_wdt watchdog
  mfd: db8500-prcmu: add ux500_wdt mfd_cell

 drivers/mfd/db8500-prcmu.c              |  17 ++++
 drivers/watchdog/Kconfig                |  12 +++
 drivers/watchdog/Makefile               |   1 +
 drivers/watchdog/ux500_wdt.c            | 171 ++++++++++++++++++++++++++++++++
 include/linux/mfd/dbx500-prcmu.h        |  12 +++
 include/linux/platform_data/ux500_wdt.h |  19 ++++
 6 files changed, 232 insertions(+)
 create mode 100644 drivers/watchdog/ux500_wdt.c
 create mode 100644 include/linux/platform_data/ux500_wdt.h

-- 
1.7.12.1

