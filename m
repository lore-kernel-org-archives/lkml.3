Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753482AbaB1SLB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Feb 2014 13:11:01 -0500
Received: from devils.ext.ti.com ([198.47.26.153]:50732 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751978AbaB1SKj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Feb 2014 13:10:39 -0500
From: Ivan Khoronzhuk <ivan.khoronzhuk@ti.com>
To: <santosh.shilimkar@ti.com>
CC: <olof@lixom.net>, <w-kwok2@ti.com>, <grygorii.strashko@ti.com>,
        <anton@enomsg.org>, <catalin.marinas@arm.com>, <sboyd@codeaurora.org>,
        <ksankaran@apm.com>, <abhimany@codeaurora.org>, <ldewangan@nvidia.com>,
        <lho@apm.com>, <fkan@apm.com>, <devicetree@vger.kernel.org>,
        <linux-doc@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>,
        Ivan Khoronzhuk <ivan.khoronzhuk@ti.com>,
        Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>,
        David Woodhouse <dwmw2@infradead.org>,
        Grant Likely <grant.likely@linaro.org>,
        Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>, Rob Landley <rob@landley.net>,
        Russell King <linux@arm.linux.org.uk>
Subject: [PATCH 0/5] Introduce keystone reset driver
Date: Fri, 28 Feb 2014 20:07:40 +0200
Message-ID: <1393610865-23630-1-git-send-email-ivan.khoronzhuk@ti.com>
X-Mailer: git-send-email 1.8.3.2
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

These patches introduce keystone reset driver.

The keystone SoC can be rebooted in several ways. By external reset
pin, by soft and by watchdogs. This driver allows software reset or reset
by one of the watchdogs. Also added opportunity to set soft/hard reset type.

Based on v3.14-rc4

CC: Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>
CC: David Woodhouse <dwmw2@infradead.org>
CC: Grant Likely <grant.likely@linaro.org>
CC: Rob Herring <robh+dt@kernel.org>
CC: Pawel Moll <pawel.moll@arm.com>
CC: Mark Rutland <mark.rutland@arm.com>
CC: Ian Campbell <ijc+devicetree@hellion.org.uk>
CC: Kumar Gala <galak@codeaurora.org>
CC: Rob Landley <rob@landley.net>
CC: Santosh Shilimkar <santosh.shilimkar@ti.com>
CC: Russell King <linux@arm.linux.org.uk>

Ivan Khoronzhuk (5):
  Power: reset: keystone-reset: introduce keystone reset driver
  Power: reset: add bindings for keystone reset driver
  ARM: keystone: remove redundant reset stuff
  ARM: dts: keystone: update reset node to work with reset driver
  ARM: keystone: enable reset driver support

 .../bindings/power/reset/keystone-reset.txt        |  59 +++++++
 arch/arm/boot/dts/keystone.dtsi                    |   4 +-
 arch/arm/configs/keystone_defconfig                |   3 +
 arch/arm/mach-keystone/keystone.c                  |  35 -----
 drivers/power/reset/Kconfig                        |   7 +
 drivers/power/reset/Makefile                       |   1 +
 drivers/power/reset/keystone-reset.c               | 171 +++++++++++++++++++++
 7 files changed, 244 insertions(+), 36 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/power/reset/keystone-reset.txt
 create mode 100644 drivers/power/reset/keystone-reset.c

-- 
1.8.3.2

