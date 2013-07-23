Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932890Ab3GWPVg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Jul 2013 11:21:36 -0400
Received: from mail-wi0-f178.google.com ([209.85.212.178]:34401 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932148Ab3GWPVf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Jul 2013 11:21:35 -0400
From: Julien Grall <julien.grall@linaro.org>
To: stefano.stabellini@eu.citrix.com, konrad.wilk@oracle.com
Cc: ian.campbell@citrix.com, patches@linaro.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        xen-devel@lists.xen.org, Julien Grall <julien.grall@linaro.org>
Subject: [PATCH v5] xen/arm: enable PV control for ARM
Date: Tue, 23 Jul 2013 16:21:28 +0100
Message-Id: <1374592888-5520-1-git-send-email-julien.grall@linaro.org>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Enable lifecyle management (reboot, shutdown...) from the toolstack
for ARM guest.

Signed-off-by: Julien Grall <julien.grall@linaro.org>

---
    Changes in v5:
        - Rework commit message
    Changes in v4:
        - Divide the patch in 2 distinct parts
    Changes in v3:
        - Fix condition to compile cpu_hotplug.o
    Changes in v2:
        - Don't compile xen/cpu_hotplug.o with ARM64
---
 drivers/xen/Makefile |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/xen/Makefile b/drivers/xen/Makefile
index a609353..f185e8d 100644
--- a/drivers/xen/Makefile
+++ b/drivers/xen/Makefile
@@ -1,9 +1,8 @@
 ifeq ($(filter y, $(CONFIG_ARM) $(CONFIG_ARM64)),)
-obj-y	+= manage.o
 obj-$(CONFIG_HOTPLUG_CPU)		+= cpu_hotplug.o
 endif
 obj-$(CONFIG_X86)			+= fallback.o
-obj-y	+= grant-table.o features.o events.o balloon.o time.o
+obj-y	+= grant-table.o features.o events.o balloon.o time.o manage.o
 obj-y	+= xenbus/
 
 nostackp := $(call cc-option, -fno-stack-protector)
-- 
1.7.10.4

