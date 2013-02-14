Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161075Ab3BNW23 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Feb 2013 17:28:29 -0500
Received: from moutng.kundenserver.de ([212.227.17.8]:50552 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030272Ab3BNW1O (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Feb 2013 17:27:14 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: linux-arm-kernel@lists.infradead.org
Cc: linux-kernel@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Ajay Kumar <ajaykumar.rs@samsung.com>,
        Florian Tobias Schandinat <FlorianSchandinat@gmx.de>
Subject: [PATCH 2/9] fb/exynos: include platform_device.h
Date: Thu, 14 Feb 2013 23:26:51 +0100
Message-Id: <1360880818-4071454-3-git-send-email-arnd@arndb.de>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1360880818-4071454-1-git-send-email-arnd@arndb.de>
References: <1360880818-4071454-1-git-send-email-arnd@arndb.de>
X-Provags-ID: V02:K0:M65LsxyMx59PMB8bpKwRAz8K2UipDSwvVdWyELWcE37
 8mviFLmFiXAequLi+sMVmMGz4xzl6JDwxLfYlrLDlCtVPAzF6f
 7RxsjBZ0lX34KAwwvhW2KHweemsKfK44xoGTrfLbYOhH5exzIW
 BlbJtDaFqzyeOkYZMf2X7U7DihCaguUpIxn4Ec+SScKCu3TFdU
 V5bOb2/I+wQ2ANKNKL/KJjc87ULh402F8hMtOPQ6SOOU119DR0
 eUghUN18kzRHndNi0OG/5xvL/8ekrZocEpJY1SI/AHR5+L/BiV
 UODS9q2qcG7xs4mAafjFA8rorCczQLk+yIAvscDDA3QVRvy+bm
 dePDGwELjEol49rsszaQdZp8HH6rQxJvSXAAoHN4f
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Patch 16559ae "kgdb: remove #include <linux/serial_8250.h> from kgdb.h"
removed an implicit inclusion of linux/platform_device.h
from the exynos framebuffer driver. This adds back the required
explicit header file inclusions.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Ajay Kumar <ajaykumar.rs@samsung.com>
Cc: Florian Tobias Schandinat <FlorianSchandinat@gmx.de>
---
 drivers/video/exynos/exynos_mipi_dsi_common.c   | 1 +
 drivers/video/exynos/exynos_mipi_dsi_lowlevel.c | 1 +
 2 files changed, 2 insertions(+)

diff --git a/drivers/video/exynos/exynos_mipi_dsi_common.c b/drivers/video/exynos/exynos_mipi_dsi_common.c
index 3cd29a4..c70cb89 100644
--- a/drivers/video/exynos/exynos_mipi_dsi_common.c
+++ b/drivers/video/exynos/exynos_mipi_dsi_common.c
@@ -25,6 +25,7 @@
 #include <linux/io.h>
 #include <linux/memory.h>
 #include <linux/delay.h>
+#include <linux/irqreturn.h>
 #include <linux/kthread.h>
 
 #include <video/mipi_display.h>
diff --git a/drivers/video/exynos/exynos_mipi_dsi_lowlevel.c b/drivers/video/exynos/exynos_mipi_dsi_lowlevel.c
index 0ef38ce..95cb99a 100644
--- a/drivers/video/exynos/exynos_mipi_dsi_lowlevel.c
+++ b/drivers/video/exynos/exynos_mipi_dsi_lowlevel.c
@@ -21,6 +21,7 @@
 #include <linux/fs.h>
 #include <linux/mm.h>
 #include <linux/ctype.h>
+#include <linux/platform_device.h>
 #include <linux/io.h>
 
 #include <video/exynos_mipi_dsim.h>
-- 
1.8.1.2

