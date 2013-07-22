Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933345Ab3GVVlH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Jul 2013 17:41:07 -0400
Received: from mail-wi0-f177.google.com ([209.85.212.177]:45906 "EHLO
	mail-wi0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932388Ab3GVVlG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Jul 2013 17:41:06 -0400
From: Julien Grall <julien.grall@linaro.org>
To: stefano.stabellini@eu.citrix.com, konrad.wilk@oracle.com
Cc: ian.campbell@citrix.com, patches@linaro.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        xen-devel@lists.xen.org, mark.rutland@arm.com, Catalin.Marinas@arm.com,
        Julien Grall <julien.grall@linaro.org>
Subject: [PATCH] xen/arm64: Don't compile cpu hotplug
Date: Mon, 22 Jul 2013 22:40:58 +0100
Message-Id: <1374529258-12866-1-git-send-email-julien.grall@linaro.org>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On ARM64, when CONFIG_XEN=y, the compilation will fail because CPU hotplug is
not yet supported with XEN. For now, disable it.

Signed-off-by: Julien Grall <julien.grall@linaro.org>
---
 drivers/xen/Makefile |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/xen/Makefile b/drivers/xen/Makefile
index 2bf461a..a609353 100644
--- a/drivers/xen/Makefile
+++ b/drivers/xen/Makefile
@@ -1,4 +1,4 @@
-ifneq ($(CONFIG_ARM),y)
+ifeq ($(filter y, $(CONFIG_ARM) $(CONFIG_ARM64)),)
 obj-y	+= manage.o
 obj-$(CONFIG_HOTPLUG_CPU)		+= cpu_hotplug.o
 endif
-- 
1.7.10.4

