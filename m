Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752250Ab3FQPv0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Jun 2013 11:51:26 -0400
Received: from service87.mimecast.com ([91.220.42.44]:58409 "EHLO
	service87.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751331Ab3FQPvZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Jun 2013 11:51:25 -0400
From: Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>
To: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        devicetree-discuss@lists.ozlabs.org
Cc: Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>,
        Samuel Ortiz <sameo@linux.intel.com>, Olof Johansson <olof@lixom.net>,
        Pawel Moll <pawel.moll@arm.com>,
        Nicolas Pitre <nicolas.pitre@linaro.org>,
        Amit Kucheria <amit.kucheria@linaro.org>,
        Jon Medhurst <tixy@linaro.org>, Achin Gupta <achin.gupta@arm.com>,
        Sudeep KarkadaNagesha <Sudeep.KarkadaNagesha@arm.com>
Subject: [RFC PATCH v4 0/2] drivers: mfd: Versatile Express SPC support
Date: Mon, 17 Jun 2013 16:51:07 +0100
Message-Id: <1371484269-11743-1-git-send-email-lorenzo.pieralisi@arm.com>
X-Mailer: git-send-email 1.8.2.2
X-OriginalArrivalTime: 17 Jun 2013 15:51:20.0049 (UTC) FILETIME=[82848610:01CE6B72]
X-MC-Unique: 113061716512208001
Content-Type: text/plain; charset=WINDOWS-1252
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from quoted-printable to 8bit by mail.home.local id r5HFq8o8022431

This patch is v4 of a previous posting:

http://lists.infradead.org/pipermail/linux-arm-kernel/2013-June/173831.html

v4 changes:
- Applied review comments (trimmed function names, added comments, refactored
  some APIs)
- Added comments throughout the set
- Fixed irq handler bug in checking the transaction status
- Improved commit log to explain early init synchro scheme
- Created a single static structure for variables dynamically allocated to
  remove usage of static
- Improved Kconfig entry

v3 changes:

- added __refdata to spc_check_loaded pointer
- removed some exported symbols
- added node pointer check in vexpress_spc_init()

v2 changes:

- Dropped timeout interface patch
- Converted interfaces to non-timeout ones, integrated and retested
- Removed mutex used at init
- Refactored code to work around init sections warning
- Fixed two minor bugs

This patch series introduces support for the Versatile Express Serial
Power Controller (SPC) present in ARM Versatile Express TC2 core tiles.
SPC driver is a fundamental component of TC2 power management and allows
to carry out C-state management and DVFS for A15 and A7 clusters.

First patch provides changes required by SPC to comply with the
Versatile Express config API, second patch is the SPC driver implementation.

Code extensively exercised through CPUidle and CPUfreq power states and
operating point transitions.

Lorenzo Pieralisi (1):
  drivers: mfd: vexpress: add Serial Power Controller (SPC) support

Pawel Moll (1):
  drivers: mfd: refactor the vexpress config bridge API

 Documentation/devicetree/bindings/mfd/vexpress-spc.txt |  36 +
 drivers/mfd/Kconfig                                    |  13 +
 drivers/mfd/Makefile                                   |   1 +
 drivers/mfd/vexpress-config.c                          |  61 +-
 drivers/mfd/vexpress-spc.c                             | 666 ++++++++++
 drivers/mfd/vexpress-sysreg.c                          |   2 +-
 include/linux/vexpress.h                               |  49 +-
 7 files changed, 800 insertions(+), 28 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/mfd/vexpress-spc.txt
 create mode 100644 drivers/mfd/vexpress-spc.c

-- 
1.8.2.2


