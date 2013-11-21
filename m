Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754880Ab3KULdg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Nov 2013 06:33:36 -0500
Received: from arroyo.ext.ti.com ([192.94.94.40]:50528 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753861Ab3KUL30 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Nov 2013 06:29:26 -0500
From: Ivan Khoronzhuk <ivan.khoronzhuk@ti.com>
To: Santosh Shilimkar <santosh.shilimkar@ti.com>,
        Rob Landley <rob@landley.net>, Russell King <linux@arm.linux.org.uk>
CC: <devicetree@vger.kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Rob Herring <rob.herring@calxeda.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Kumar Gala <galak@kernel.crashing.org>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        <linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <linux-mtd@lists.infradead.org>, <grygorii.strashko@ti.com>,
        Ivan Khoronzhuk <ivan.khoronzhuk@ti.com>
Subject: [PATCH v2 00/10] Reuse davinci-nand driver for Keystone arch
Date: Thu, 21 Nov 2013 13:28:15 +0200
Message-ID: <1385033305-13179-1-git-send-email-ivan.khoronzhuk@ti.com>
X-Mailer: git-send-email 1.7.9.5
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This series contains fixes and updates of Davinci nand driver in
order to reuse it for Keystone platform.

The series is combination of two following series:
- Davinci nand driver fixes and updates:
  https://lkml.org/lkml/2013/11/20/271
- Reuse davinci-nand driver for Keystone arch
  https://lkml.org/lkml/2013/11/20/315

Ivan Khoronzhuk (10):
  mtd: nand: davinci: fix driver registration
  mtd: nand: davinci: return ENOMEM if memory allocation is failed
  mtd: nand: davinci: check required ti,davinci-chipselect property
  mtd: nand: davinci: simplify error handling
  mtd: nand: davinci: move bindings under mtd
  mtd: nand: davinci: extend description of bindings
  mtd: nand: davinci: adjust DT properties to MTD generic
  mtd: nand: davinci: reuse driver for Keystone arch
  mtd: nand: davinci: don't set timings if AEMIF is used
  mtd: nand: davinci: don't request AEMIF address range

 .../devicetree/bindings/arm/davinci/nand.txt       |   46 --------
 .../devicetree/bindings/mtd/davinci-nand.txt       |   94 ++++++++++++++++
 drivers/mtd/nand/Kconfig                           |    6 +-
 drivers/mtd/nand/davinci_nand.c                    |  117 +++++++++++---------
 4 files changed, 164 insertions(+), 99 deletions(-)
 delete mode 100644 Documentation/devicetree/bindings/arm/davinci/nand.txt
 create mode 100644 Documentation/devicetree/bindings/mtd/davinci-nand.txt

-- 
1.7.9.5

