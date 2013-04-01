Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757745Ab3DAG1W (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Apr 2013 02:27:22 -0400
Received: from nasmtp01.atmel.com ([192.199.1.245]:53621 "EHLO
	DVREDG01.corp.atmel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1757726Ab3DAG1V (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Apr 2013 02:27:21 -0400
From: Josh Wu <josh.wu@atmel.com>
To: <egtvedt@samfundet.no>, <akpm@linux-foundation.org>
CC: <linux-kernel@vger.kernel.org>, <hskinnemoen@gmail.com>,
        <linux-mtd@lists.infradead.org>, <dedekind1@gmail.com>,
        <fengguang.wu@intel.com>, Josh Wu <josh.wu@atmel.com>
Subject: [PATCH v2] avr32: fix build error in atstk1006_defconfig
Date: Mon, 1 Apr 2013 14:26:37 +0800
Message-ID: <1364797597-22005-1-git-send-email-josh.wu@atmel.com>
X-Mailer: git-send-email 1.7.9.5
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

fixed the following compile error when use avr32 atstk1006_defconfig:
  drivers/mtd/nand/atmel_nand.c: In function 'pmecc_err_location':
  drivers/mtd/nand/atmel_nand.c:639: error: implicit declaration of function 'writel_relaxed'

which was introduced by commit:
  1c7b874d33b463f7150b1ab4617f000af9b327fd
  mtd: at91: atmel_nand: add Programmable Multibit ECC controller support
The PMECC for nand flash code uses writel_relaxed(). But in avr32, there is no
macro "writel_relaxed" defined.

This patch add writex_relaxed macro definitions.

Signed-off-by: Josh Wu <josh.wu@atmel.com>
Acked-by: Havard Skinnemoen <havard@skinnemoen.net>
Acked-by: Hans-Christian Egtvedt <egtvedt@samfundet.no>
---
change since v1:
 refined the commit message and wrap it into 80 characters.

 arch/avr32/include/asm/io.h |    4 ++++
 1 file changed, 4 insertions(+)

diff --git a/arch/avr32/include/asm/io.h b/arch/avr32/include/asm/io.h
index cf60d0a..fc6483f 100644
--- a/arch/avr32/include/asm/io.h
+++ b/arch/avr32/include/asm/io.h
@@ -165,6 +165,10 @@ BUILDIO_IOPORT(l, u32)
 #define readw_be			__raw_readw
 #define readl_be			__raw_readl
 
+#define writeb_relaxed			writeb
+#define writew_relaxed			writew
+#define writel_relaxed			writel
+
 #define writeb_be			__raw_writeb
 #define writew_be			__raw_writew
 #define writel_be			__raw_writel
-- 
1.7.9.5

