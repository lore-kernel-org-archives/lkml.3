Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758652Ab3AQDNW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jan 2013 22:13:22 -0500
Received: from smtp.outflux.net ([198.145.64.163]:43961 "EHLO smtp.outflux.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758564Ab3AQCyi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jan 2013 21:54:38 -0500
From: Kees Cook <keescook@chromium.org>
To: linux-kernel@vger.kernel.org
Cc: Kees Cook <keescook@chromium.org>, Ralf Baechle <ralf@linux-mips.org>,
        Manuel Lauss <manuel.lauss@googlemail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: [PATCH 45/86] drivers/i2c: remove depends on CONFIG_EXPERIMENTAL
Date: Wed, 16 Jan 2013 18:53:37 -0800
Message-Id: <1358391258-1771-46-git-send-email-keescook@chromium.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1358391258-1771-1-git-send-email-keescook@chromium.org>
References: <1358391258-1771-1-git-send-email-keescook@chromium.org>
X-HELO: www.outflux.net
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The CONFIG_EXPERIMENTAL config item has not carried much meaning for a
while now and is almost always enabled by default. As agreed during the
Linux kernel summit, remove it from any "depends on" lines in Kconfigs.

CC: Ralf Baechle <ralf@linux-mips.org>
CC: Manuel Lauss <manuel.lauss@googlemail.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Kees Cook <keescook@chromium.org>
---
 drivers/i2c/Kconfig        |    2 +-
 drivers/i2c/busses/Kconfig |   16 +++++++---------
 2 files changed, 8 insertions(+), 10 deletions(-)

diff --git a/drivers/i2c/Kconfig b/drivers/i2c/Kconfig
index 2f8c76b..46cde09 100644
--- a/drivers/i2c/Kconfig
+++ b/drivers/i2c/Kconfig
@@ -89,7 +89,7 @@ source drivers/i2c/busses/Kconfig
 
 config I2C_STUB
 	tristate "I2C/SMBus Test Stub"
-	depends on EXPERIMENTAL && m
+	depends on m
 	default 'n'
 	help
 	  This module may be useful to developers of SMBus client drivers,
diff --git a/drivers/i2c/busses/Kconfig b/drivers/i2c/busses/Kconfig
index bdca511..9b94a78 100644
--- a/drivers/i2c/busses/Kconfig
+++ b/drivers/i2c/busses/Kconfig
@@ -22,7 +22,7 @@ config I2C_ALI1535
 
 config I2C_ALI1563
 	tristate "ALI 1563"
-	depends on PCI && EXPERIMENTAL
+	depends on PCI
 	help
 	  If you say yes to this option, support will be included for the SMB
 	  Host controller on Acer Labs Inc. (ALI) M1563 South Bridges.  The SMB
@@ -56,7 +56,7 @@ config I2C_AMD756
 
 config I2C_AMD756_S4882
 	tristate "SMBus multiplexing on the Tyan S4882"
-	depends on I2C_AMD756 && X86 && EXPERIMENTAL
+	depends on I2C_AMD756 && X86
 	help
 	  Enabling this option will add specific SMBus support for the Tyan
 	  S4882 motherboard.  On this 4-CPU board, the SMBus is multiplexed
@@ -164,7 +164,7 @@ config I2C_NFORCE2
 
 config I2C_NFORCE2_S4985
 	tristate "SMBus multiplexing on the Tyan S4985"
-	depends on I2C_NFORCE2 && X86 && EXPERIMENTAL
+	depends on I2C_NFORCE2 && X86
 	help
 	  Enabling this option will add specific SMBus support for the Tyan
 	  S4985 motherboard.  On this 4-CPU board, the SMBus is multiplexed
@@ -215,7 +215,7 @@ config I2C_SIS96X
 
 config I2C_VIA
 	tristate "VIA VT82C586B"
-	depends on PCI && EXPERIMENTAL
+	depends on PCI
 	select I2C_ALGOBIT
 	help
 	  If you say yes to this option, support will be included for the VIA
@@ -267,7 +267,7 @@ comment "Mac SMBus host controller drivers"
 
 config I2C_HYDRA
 	tristate "CHRP Apple Hydra Mac I/O I2C interface"
-	depends on PCI && PPC_CHRP && EXPERIMENTAL
+	depends on PCI && PPC_CHRP
 	select I2C_ALGOBIT
 	help
 	  This supports the use of the I2C interface in the Apple Hydra Mac
@@ -293,7 +293,7 @@ comment "I2C system bus drivers (mostly embedded / system-on-chip)"
 
 config I2C_AT91
 	tristate "Atmel AT91 I2C Two-Wire interface (TWI)"
-	depends on ARCH_AT91 && EXPERIMENTAL
+	depends on ARCH_AT91
 	help
 	  This supports the use of the I2C interface on Atmel AT91
 	  processors.
@@ -519,7 +519,6 @@ config I2C_NUC900
 
 config I2C_OCORES
 	tristate "OpenCores I2C Controller"
-	depends on EXPERIMENTAL
 	help
 	  If you say yes to this option, support will be included for the
 	  OpenCores I2C controller. For details see
@@ -712,7 +711,7 @@ config I2C_OCTEON
 
 config I2C_XILINX
 	tristate "Xilinx I2C Controller"
-	depends on EXPERIMENTAL && HAS_IOMEM
+	depends on HAS_IOMEM
 	help
 	  If you say yes to this option, support will be included for the
 	  Xilinx I2C controller.
@@ -803,7 +802,6 @@ config I2C_PARPORT_LIGHT
 
 config I2C_TAOS_EVM
 	tristate "TAOS evaluation module"
-	depends on EXPERIMENTAL
 	select SERIO
 	select SERIO_SERPORT
 	default n
-- 
1.7.9.5

