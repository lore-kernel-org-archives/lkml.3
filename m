Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760406Ab3GSNK1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Jul 2013 09:10:27 -0400
Received: from mail-wi0-f182.google.com ([209.85.212.182]:42109 "EHLO
	mail-wi0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751804Ab3GSNK0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Jul 2013 09:10:26 -0400
From: Julien Grall <julien.grall@linaro.org>
To: stefano.stabellini@eu.citrix.com, konrad.wilk@oracle.com
Cc: ian.campbell@citrix.com, patches@linaro.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        xen-devel@lists.xen.org, Julien Grall <julien.grall@linaro.org>
Subject: [PATCH v2] xen/arm: enable PV control for ARM
Date: Fri, 19 Jul 2013 14:09:59 +0100
Message-Id: <1374239399-2498-1-git-send-email-julien.grall@linaro.org>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Enable power management from the toolstack for ARM guest.

Signed-off-by: Julien Grall <julien.grall@linaro.org>

---
    Changes in v2:
        - Don't compile xen/cpu_hotplug.o with ARM64
---
 drivers/xen/Makefile |    5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/xen/Makefile b/drivers/xen/Makefile
index 2bf461a..b550a94 100644
--- a/drivers/xen/Makefile
+++ b/drivers/xen/Makefile
@@ -1,9 +1,8 @@
-ifneq ($(CONFIG_ARM),y)
-obj-y	+= manage.o
+ifneq ($(filter y, ($CONFIG_ARM) $(CONFIG_ARM64)),)
 obj-$(CONFIG_HOTPLUG_CPU)		+= cpu_hotplug.o
 endif
 obj-$(CONFIG_X86)			+= fallback.o
-obj-y	+= grant-table.o features.o events.o balloon.o time.o
+obj-y	+= grant-table.o features.o events.o balloon.o time.o manage.o
 obj-y	+= xenbus/
 
 nostackp := $(call cc-option, -fno-stack-protector)
-- 
1.7.10.4

