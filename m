Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758791AbaIOVAp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Sep 2014 17:00:45 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:54594 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755001AbaIOT1C (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Sep 2014 15:27:02 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Paul Burton <paul.burton@imgtec.com>,
        Markos Chandras <markos.chandras@imgtec.com>,
        James Hogan <james.hogan@imgtec.com>
Subject: [PATCH 3.16 074/158] MIPS: EVA: Add new EVA header
Date: Mon, 15 Sep 2014 12:25:13 -0700
Message-Id: <20140915192545.119468264@linuxfoundation.org>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <20140915192542.872134685@linuxfoundation.org>
References: <20140915192542.872134685@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.16-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Markos Chandras <markos.chandras@imgtec.com>

commit f85b71ceabb9d8d8a9e34b045b5c43ffde3623b3 upstream.

Generic code may need to perform certain operations when EVA is
enabled, for example, configure the segmentation registers during
boot. In order to avoid using more CONFIG_EVA ifdefs in the arch code,
such functions will be added in this header instead.
Initially this header contains a macro which will be used by generic
code later on during VPEs configuration on secondary cores.
All it does is to call the platform specific EVA init code in case
EVA is enabled.

Reviewed-by: Paul Burton <paul.burton@imgtec.com>
Signed-off-by: Markos Chandras <markos.chandras@imgtec.com>
Patchwork: http://patchwork.linux-mips.org/patch/7422/
Signed-off-by: James Hogan <james.hogan@imgtec.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/mips/include/asm/eva.h |   43 +++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 43 insertions(+)

--- /dev/null
+++ b/arch/mips/include/asm/eva.h
@@ -0,0 +1,43 @@
+/*
+ * This file is subject to the terms and conditions of the GNU General Public
+ * License.  See the file "COPYING" in the main directory of this archive
+ * for more details.
+ *
+ * Copyright (C) 2014, Imagination Technologies Ltd.
+ *
+ * EVA functions for generic code
+ */
+
+#ifndef _ASM_EVA_H
+#define _ASM_EVA_H
+
+#include <kernel-entry-init.h>
+
+#ifdef __ASSEMBLY__
+
+#ifdef CONFIG_EVA
+
+/*
+ * EVA early init code
+ *
+ * Platforms must define their own 'platform_eva_init' macro in
+ * their kernel-entry-init.h header. This macro usually does the
+ * platform specific configuration of the segmentation registers,
+ * and it is normally called from assembly code.
+ *
+ */
+
+.macro eva_init
+platform_eva_init
+.endm
+
+#else
+
+.macro eva_init
+.endm
+
+#endif /* CONFIG_EVA */
+
+#endif /* __ASSEMBLY__ */
+
+#endif


