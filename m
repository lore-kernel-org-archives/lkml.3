Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754624AbaJ1L14 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Oct 2014 07:27:56 -0400
Received: from mailapp01.imgtec.com ([195.59.15.196]:25399 "EHLO
	mailapp01.imgtec.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754341AbaJ1L1g (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Oct 2014 07:27:36 -0400
From: Qais Yousef <qais.yousef@imgtec.com>
To: <linux-kernel@vger.kernel.org>
CC: Qais Yousef <qais.yousef@imgtec.com>, Arnd Bergmann <arnd@arndb.de>,
        "Greg Kroah-Hartman" <gregkh@linuxfoundation.org>,
        <alsa-devel@alsa-project.org>
Subject: [PATCH 11/11] drivers: char: axd: add Kconfig and Makefile
Date: Tue, 28 Oct 2014 11:26:29 +0000
Message-ID: <1414495589-8579-12-git-send-email-qais.yousef@imgtec.com>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <1414495589-8579-1-git-send-email-qais.yousef@imgtec.com>
References: <1414495589-8579-1-git-send-email-qais.yousef@imgtec.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [192.168.154.94]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Now all necessary files are added, allow AXD to be selected through
Kconfig and compiled.

NOTE: at the moment AXD can only work on MIPS but this restrictions
should be lifted in the future as it evolves.

Signed-off-by: Qais Yousef <qais.yousef@imgtec.com>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: <alsa-devel@alsa-project.org>
---
 drivers/char/Kconfig      |  2 ++
 drivers/char/Makefile     |  2 ++
 drivers/char/axd/Kconfig  | 19 +++++++++++++++++++
 drivers/char/axd/Makefile | 20 ++++++++++++++++++++
 4 files changed, 43 insertions(+)
 create mode 100644 drivers/char/axd/Kconfig
 create mode 100644 drivers/char/axd/Makefile

diff --git a/drivers/char/Kconfig b/drivers/char/Kconfig
index efefd12a0f7b..7800a72cf771 100644
--- a/drivers/char/Kconfig
+++ b/drivers/char/Kconfig
@@ -602,5 +602,7 @@ config TILE_SROM
 
 source "drivers/char/xillybus/Kconfig"
 
+source "drivers/char/axd/Kconfig"
+
 endmenu
 
diff --git a/drivers/char/Makefile b/drivers/char/Makefile
index d06cde26031b..6c1769d8abf3 100644
--- a/drivers/char/Makefile
+++ b/drivers/char/Makefile
@@ -62,3 +62,5 @@ js-rtc-y = rtc.o
 
 obj-$(CONFIG_TILE_SROM)		+= tile-srom.o
 obj-$(CONFIG_XILLYBUS)		+= xillybus/
+
+obj-$(CONFIG_AXD)		+= axd/
diff --git a/drivers/char/axd/Kconfig b/drivers/char/axd/Kconfig
new file mode 100644
index 000000000000..a1a94b12c04a
--- /dev/null
+++ b/drivers/char/axd/Kconfig
@@ -0,0 +1,19 @@
+config AXD
+	tristate "AXD Audio Processing IP"
+	depends on MIPS && COMMON_CLK && CMA
+	---help---
+	  Say Y here if you want to use AXD Audio Processing IP.
+
+config AXD_DEBUG_DIAG
+	bool "AXD diagnostics"
+	depends on AXD
+	---help---
+	  Say Y if you want AXD driver to print some diagnostics after playing
+	  a stream.
+
+config AXD_DEBUG_VERBOSE
+	bool "AXD verbose debug"
+	depends on AXD
+	---help---
+	  Say Y if you want AXD driver to print verbose debug information.
+	  The output is extensive.
diff --git a/drivers/char/axd/Makefile b/drivers/char/axd/Makefile
new file mode 100644
index 000000000000..3b367721073d
--- /dev/null
+++ b/drivers/char/axd/Makefile
@@ -0,0 +1,20 @@
+obj-$(CONFIG_AXD) := axd.o
+
+axd-objs = axd_buffers.o \
+	   axd_cmds.o \
+	   axd_cmds_codec_internal.o \
+	   axd_cmds_config.o \
+	   axd_cmds_decoder_config.o \
+	   axd_cmds_encoder_config.o \
+	   axd_cmds_info.o \
+	   axd_cmds_internal.o \
+	   axd_cmds_pipes.o \
+	   axd_hdr.o \
+	   axd_module.o \
+	   axd_platform_mips.o \
+	   axd_sysfs_ctrl.o \
+	   axd_sysfs_input.o \
+	   axd_sysfs_output.o
+
+ccflags-$(CONFIG_AXD_DEBUG_DIAG) += -DDEBUG_DIAG
+ccflags-$(CONFIG_AXD_DEBUG_VERBOSE) += -DDEBUG_BUFFERS
-- 
2.1.0

