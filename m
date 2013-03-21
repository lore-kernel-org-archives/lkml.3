Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752613Ab3CUSXh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Mar 2013 14:23:37 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:35839 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752709Ab3CUSXc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Mar 2013 14:23:32 -0400
From: Stephen Warren <swarren@wwwdotorg.org>
To: Michal Marek <mmarek@suse.cz>, Grant Likely <glikely@secretlab.ca>,
        Rob Herring <robherring2@gmail.com>
Cc: arm@kernel.org, Shawn Guo <shawn.guo@linaro.org>,
        Hiroshi Doyu <hdoyu@nvidia.com>, linux-kbuild@vger.kernel.org,
        devicetree-discuss@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        Stephen Warren <swarren@nvidia.com>
Subject: [PATCH REPOST 7/7] ARM: dt: create a DT header for the GIC
Date: Thu, 21 Mar 2013 12:23:14 -0600
Message-Id: <1363890194-31538-7-git-send-email-swarren@wwwdotorg.org>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1363890194-31538-1-git-send-email-swarren@wwwdotorg.org>
References: <1363890194-31538-1-git-send-email-swarren@wwwdotorg.org>
X-NVConfidentiality: public
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Stephen Warren <swarren@nvidia.com>

The ARM GIC binding defines a few custom cells and flags for its IRQ
specifier. Provide names for those.

Signed-off-by: Stephen Warren <swarren@nvidia.com>
---
v2: Moved header. Added include guard.
---
 include/dt-bindings/interrupt-controller/arm-gic.h |   22 ++++++++++++++++++++
 1 file changed, 22 insertions(+)
 create mode 100644 include/dt-bindings/interrupt-controller/arm-gic.h

diff --git a/include/dt-bindings/interrupt-controller/arm-gic.h b/include/dt-bindings/interrupt-controller/arm-gic.h
new file mode 100644
index 0000000..1ea1b70
--- /dev/null
+++ b/include/dt-bindings/interrupt-controller/arm-gic.h
@@ -0,0 +1,22 @@
+/*
+ * This header provides constants for the ARM GIC.
+ */
+
+#ifndef _DT_BINDINGS_INTERRUPT_CONTROLLER_ARM_GIC_H
+#define _DT_BINDINGS_INTERRUPT_CONTROLLER_ARM_GIC_H
+
+#include <dt-bindings/interrupt-controller/irq.h>
+
+/* interrupt specific cell 0 */
+
+#define GIC_SPI 0
+#define GIC_PPI 1
+
+/*
+ * Interrupt specifier cell 2.
+ * The flaggs in irq.h are valid, plus those below.
+ */
+#define GIC_CPU_MASK_RAW(x) ((x) << 8)
+#define GIC_CPU_MASK_SIMPLE(num) GIC_CPU_MASK_RAW((1 << (num)) - 1)
+
+#endif
-- 
1.7.10.4

