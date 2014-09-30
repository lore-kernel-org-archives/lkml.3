Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752961AbaI3Kiw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Sep 2014 06:38:52 -0400
Received: from ozlabs.org ([103.22.144.67]:55053 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751028AbaI3Kfl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Sep 2014 06:35:41 -0400
From: Michael Neuling <mikey@neuling.org>
To: greg@kroah.com, arnd@arndb.de, mpe@ellerman.id.au,
        benh@kernel.crashing.org
Cc: mikey@neuling.org, anton@samba.org, linux-kernel@vger.kernel.org,
        linuxppc-dev@ozlabs.org, jk@ozlabs.org, imunsie@au.ibm.com,
        cbe-oss-dev@lists.ozlabs.org,
        "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: [PATCH v2 07/17] cxl: Add new header for call backs and structs
Date: Tue, 30 Sep 2014 20:34:56 +1000
Message-Id: <1412073306-13812-8-git-send-email-mikey@neuling.org>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1412073306-13812-1-git-send-email-mikey@neuling.org>
References: <1412073306-13812-1-git-send-email-mikey@neuling.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Ian Munsie <imunsie@au1.ibm.com>

This new header add defines for callbacks and structs needed by the rest of the
kernel to hook into the cxl infrastructure.

Empty functions are provided when CONFIG CXL_BASE is not enabled.

Signed-off-by: Ian Munsie <imunsie@au1.ibm.com>
Signed-off-by: Michael Neuling <mikey@neuling.org>
---
 include/misc/cxl.h | 34 ++++++++++++++++++++++++++++++++++
 1 file changed, 34 insertions(+)
 create mode 100644 include/misc/cxl.h

diff --git a/include/misc/cxl.h b/include/misc/cxl.h
new file mode 100644
index 0000000..bde46a3
--- /dev/null
+++ b/include/misc/cxl.h
@@ -0,0 +1,34 @@
+/*
+ * Copyright 2014 IBM Corp.
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License
+ * as published by the Free Software Foundation; either version
+ * 2 of the License, or (at your option) any later version.
+ */
+
+#ifndef _MISC_ASM_CXL_H
+#define _MISC_ASM_CXL_H
+
+#define CXL_IRQ_RANGES 4
+
+struct cxl_irq_ranges {
+	irq_hw_number_t offset[CXL_IRQ_RANGES];
+	irq_hw_number_t range[CXL_IRQ_RANGES];
+};
+
+#ifdef CONFIG_CXL_BASE
+
+void cxl_slbia(struct mm_struct *mm);
+void cxl_ctx_get(void);
+void cxl_ctx_put(void);
+bool cxl_ctx_in_use(void);
+
+#else /* CONFIG_CXL_BASE */
+
+#define cxl_slbia(...) do { } while (0)
+#define cxl_ctx_in_use(...) false
+
+#endif /* CONFIG_CXL_BASE */
+
+#endif
-- 
1.9.1

