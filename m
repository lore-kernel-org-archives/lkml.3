Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755336Ab3EXMx1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 May 2013 08:53:27 -0400
Received: from service87.mimecast.com ([91.220.42.44]:42150 "EHLO
	service87.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755190Ab3EXMxW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 May 2013 08:53:22 -0400
From: Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>
To: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Cc: devicetree-discuss@lists.ozlabs.org,
        Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>,
        Samuel Ortiz <sameo@linux.intel.com>, Pawel Moll <pawel.moll@arm.com>,
        Nicolas Pitre <nicolas.pitre@linaro.org>,
        Amit Kucheria <amit.kucheria@linaro.org>,
        Jon Medhurst <tixy@linaro.org>, Achin Gupta <achin.gupta@arm.com>,
        Sudeep KarkadaNagesha <Sudeep.KarkadaNagesha@arm.com>
Subject: [RFC PATCH 0/3] drivers: mfd: Versatile Express SPC support
Date: Fri, 24 May 2013 13:53:03 +0100
Message-Id: <1369399986-15649-1-git-send-email-lorenzo.pieralisi@arm.com>
X-Mailer: git-send-email 1.8.2.2
X-OriginalArrivalTime: 24 May 2013 12:53:20.0290 (UTC) FILETIME=[AAF8A020:01CE587D]
X-MC-Unique: 113052413532003901
Content-Type: text/plain; charset=WINDOWS-1252
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from quoted-printable to 8bit by mail.home.local id r4OCs39n011963

This patch series introduces support for the Versatile Express Serial
Power Controller (SPC) present in ARM Versatile Express TC2 core tiles.
SPC driver is a fundamental component of TC2 power management and allows
to carry out C-state management and DVFS for A15 and A7 clusters.

First two patches provide changes required by SPC to comply with the
Versatile Express config API, third patch is the SPC driver implementation.

Code extensively exercised through CPUidle and CPUfreq power states and
operating point transitions.

Lorenzo Pieralisi (2):
  drivers: mfd: vexpress: add timeout API to vexpress config interface
  drivers: mfd: vexpress: add Serial Power Controller (SPC) support

Pawel Moll (1):
  drivers: mfd: refactor the vexpress config bridge API

 Documentation/devicetree/bindings/mfd/vexpress-spc.txt |  35 +
 drivers/mfd/Kconfig                                    |   7 +
 drivers/mfd/Makefile                                   |   1 +
 drivers/mfd/vexpress-config.c                          |  87 +-
 drivers/mfd/vexpress-spc.c                             | 626 ++++++++++
 drivers/mfd/vexpress-sysreg.c                          |   2 +-
 include/linux/vexpress.h                               |  82 +-
 7 files changed, 800 insertions(+), 40 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/mfd/vexpress-spc.txt
 create mode 100644 drivers/mfd/vexpress-spc.c

-- 
1.8.2.2


