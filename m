Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932941Ab3GPM4s (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Jul 2013 08:56:48 -0400
Received: from mail-gh0-f180.google.com ([209.85.160.180]:57833 "EHLO
	mail-gh0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932354Ab3GPM4p (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Jul 2013 08:56:45 -0400
From: Otavio Salvador <otavio@ossystems.com.br>
To: Jonathan Cameron <jic23@kernel.org>, linux-kernel@vger.kernel.org
Cc: Otavio Salvador <otavio@ossystems.com.br>,
        Shawn Guo <shawn.guo@linaro.org>, Jonathan Cameron <jic23@cam.ac.uk>,
        linux-iio@vger.kernel.org
Subject: [PATCH v2 4/4] iio: add configuration option for debug support
Date: Tue, 16 Jul 2013 09:56:15 -0300
Message-Id: <1373979376-31583-4-git-send-email-otavio@ossystems.com.br>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1373979376-31583-1-git-send-email-otavio@ossystems.com.br>
References: <1373979376-31583-1-git-send-email-otavio@ossystems.com.br>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Otavio Salvador <otavio@ossystems.com.br>
---
Changes in v2:
- Rework Kconfig help (Lars-Peter Clausen)

 drivers/iio/Kconfig  | 7 +++++++
 drivers/iio/Makefile | 2 ++
 2 files changed, 9 insertions(+)

diff --git a/drivers/iio/Kconfig b/drivers/iio/Kconfig
index 9af763a..e5d1cfc 100644
--- a/drivers/iio/Kconfig
+++ b/drivers/iio/Kconfig
@@ -12,6 +12,13 @@ menuconfig IIO
 
 if IIO
 
+config IIO_DEBUG
+	boolean "Debug support for Industrial I/O"
+	depends on DEBUG_KERNEL
+	help
+	  Say "yes" to enable debug messaging (like dev_dbg and pr_debug)
+	  support in Industrial I/O subsystem and drivers.
+
 config IIO_BUFFER
 	bool "Enable buffer support within IIO"
 	help
diff --git a/drivers/iio/Makefile b/drivers/iio/Makefile
index 7a3866c..6e43e5b 100644
--- a/drivers/iio/Makefile
+++ b/drivers/iio/Makefile
@@ -2,6 +2,8 @@
 # Makefile for the industrial I/O core.
 #
 
+ccflags-$(CONFIG_IIO_DEBUG) := -DDEBUG
+
 obj-$(CONFIG_IIO) += industrialio.o
 industrialio-y := industrialio-core.o industrialio-event.o inkern.o
 industrialio-$(CONFIG_IIO_BUFFER) += industrialio-buffer.o
-- 
1.8.3.2

