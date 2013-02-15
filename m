Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161939Ab3BOM7T (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Feb 2013 07:59:19 -0500
Received: from mail-wi0-f178.google.com ([209.85.212.178]:62743 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161896Ab3BOM63 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Feb 2013 07:58:29 -0500
From: Lee Jones <lee.jones@linaro.org>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        sameo@linux.intel.com
Cc: arnd@arndb.de, linus.walleij@stericsson.com,
        Lee Jones <lee.jones@linaro.org>
Subject: [PATCH 33/35] mfd: ab8500-debug: Add explicit dependencies
Date: Fri, 15 Feb 2013 12:57:04 +0000
Message-Id: <1360933026-30325-34-git-send-email-lee.jones@linaro.org>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1360933026-30325-1-git-send-email-lee.jones@linaro.org>
References: <1360933026-30325-1-git-send-email-lee.jones@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Linus Walleij <linus.walleij@stericsson.com>

As I am working on SPARSE_IRQ a number of implicit resource
grabs in the kernel become evident. For example, some includes
like <linux/irqs.h> would implicitly include <mach/irqs.h>
and then from there <mach/db8500-regs.h>.

In many cases it is masking the fact that drivers do not
properly use resources to pass their dependencies, base
addresses etc. So write explicit #include statements with
TODO items to have this fixed the proper way to all drivers
doing this.

Signed-off-by: Linus Walleij <linus.walleij@stericsson.com>
Signed-off-by: Lee Jones <lee.jones@linaro.org>
Reviewed-by: Philippe LANGLAIS <philippe.langlais@stericsson.com>
---
 drivers/mfd/ab8500-debugfs.c |    3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/mfd/ab8500-debugfs.c b/drivers/mfd/ab8500-debugfs.c
index b5af8be..37f595d 100644
--- a/drivers/mfd/ab8500-debugfs.c
+++ b/drivers/mfd/ab8500-debugfs.c
@@ -90,6 +90,9 @@
 #include <linux/ctype.h>
 #endif
 
+/* TODO: this file should not reference IRQ_DB8500_AB8500! */
+#include <mach/irqs.h>
+
 static u32 debug_bank;
 static u32 debug_address;
 
-- 
1.7.10.4

