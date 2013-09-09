Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752357Ab3IIDsp (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Sep 2013 23:48:45 -0400
Received: from top.free-electrons.com ([176.31.233.9]:52618 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751788Ab3IIDso (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Sep 2013 23:48:44 -0400
From: Michael Opdenacker <michael.opdenacker@free-electrons.com>
To: josh@joshtriplett.org, paul.mckenney@linaro.org, akpm@linux-foundation.org,
        decot@googlers.com, amirv@mellanox.com
Cc: linux-kernel@vger.kernel.org,
        Michael Opdenacker <michael.opdenacker@free-electrons.com>
Subject: [RFC][PATCH] genirq: add IRQF_NONE
Date: Mon,  9 Sep 2013 05:48:39 +0200
Message-Id: <1378698519-4780-1-git-send-email-michael.opdenacker@free-electrons.com>
X-Mailer: git-send-email 1.8.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

What about adding an IRQF_NONE flag as in the below patch?

I'm currently working on removing the use of the deprecated
IRQF_DISABLED flag, and frequently have to replace
IRQF_DISABLED by 0, typically in request_irq() arguments.

Using IRQF_NONE instead of 0 would make the code more readable,
at least for people reading driver code for the first time.

Would it worth it?

I'm sure this kind of idea has come up many times before...

Signed-off-by: Michael Opdenacker <michael.opdenacker@free-electrons.com>
---
 include/linux/interrupt.h | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/include/linux/interrupt.h b/include/linux/interrupt.h
index 5fa5afe..e289525 100644
--- a/include/linux/interrupt.h
+++ b/include/linux/interrupt.h
@@ -40,6 +40,7 @@
  * These flags used only by the kernel as part of the
  * irq handling routines.
  *
+ * IRQF_NONE - No irq flag bit is set.
  * IRQF_DISABLED - keep irqs disabled when calling the action handler.
  *                 DEPRECATED. This flag is a NOOP and scheduled to be removed
  * IRQF_SHARED - allow sharing the irq among several devices
@@ -59,6 +60,7 @@
  * IRQF_EARLY_RESUME - Resume IRQ early during syscore instead of at device
  *                resume time.
  */
+#define IRQF_NONE		0x00000000
 #define IRQF_DISABLED		0x00000020
 #define IRQF_SHARED		0x00000080
 #define IRQF_PROBE_SHARED	0x00000100
-- 
1.8.1.2

