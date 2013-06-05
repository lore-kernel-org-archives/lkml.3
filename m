Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754853Ab3FELq0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Jun 2013 07:46:26 -0400
Received: from service87.mimecast.com ([91.220.42.44]:56281 "EHLO
	service87.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754332Ab3FELqZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Jun 2013 07:46:25 -0400
From: Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>
To: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        devicetree-discuss@lists.ozlabs.org
Cc: Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>,
        Samuel Ortiz <sameo@linux.intel.com>, Pawel Moll <pawel.moll@arm.com>,
        Nicolas Pitre <nicolas.pitre@linaro.org>,
        Amit Kucheria <amit.kucheria@linaro.org>,
        Jon Medhurst <tixy@linaro.org>, Achin Gupta <achin.gupta@arm.com>,
        Sudeep KarkadaNagesha <Sudeep.KarkadaNagesha@arm.com>
Subject: [RFC PATCH v2 0/2] drivers: mfd: Versatile Express SPC support
Date: Wed,  5 Jun 2013 12:46:05 +0100
Message-Id: <1370432767-6620-1-git-send-email-lorenzo.pieralisi@arm.com>
X-Mailer: git-send-email 1.8.2.2
X-OriginalArrivalTime: 05 Jun 2013 11:46:21.0788 (UTC) FILETIME=[4CB6E1C0:01CE61E2]
X-MC-Unique: 113060512462302001
Content-Type: text/plain; charset=WINDOWS-1252
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from quoted-printable to 8bit by mail.home.local id r55Bl7JC028330

This patch is v2 of a previous posting:

http://lists.infradead.org/pipermail/linux-arm-kernel/2013-May/170624.html

V2 changes:

- Dropped timeout interface patch
- Converted interfaces to non-timeout ones, integrated and retested
- Removed mutex used at init
- Refactored code to work around init sections warning
- Fixed interface type enumeration init
- Fixed data write in SYSCFG write commands

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

 .../devicetree/bindings/mfd/vexpress-spc.txt       |  35 ++
 drivers/mfd/Kconfig                                |   7 +
 drivers/mfd/Makefile                               |   1 +
 drivers/mfd/vexpress-config.c                      |  61 +-
 drivers/mfd/vexpress-spc.c                         | 630 +++++++++++++++++++++
 drivers/mfd/vexpress-sysreg.c                      |   2 +-
 include/linux/vexpress.h                           |  59 +-
 7 files changed, 767 insertions(+), 28 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/mfd/vexpress-spc.txt
 create mode 100644 drivers/mfd/vexpress-spc.c

-- 
1.8.2.2


