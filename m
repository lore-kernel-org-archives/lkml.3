Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752089Ab3LLN2h (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Dec 2013 08:28:37 -0500
Received: from hqemgate16.nvidia.com ([216.228.121.65]:2178 "EHLO
	hqemgate16.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751929Ab3LLN2a (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Dec 2013 08:28:30 -0500
X-PGP-Universal: processed;
	by hqnvupgp07.nvidia.com on Thu, 12 Dec 2013 05:31:09 -0800
From: Laxman Dewangan <ldewangan@nvidia.com>
To: <robh+dt@kernel.org>, <pawel.moll@arm.com>, <mark.rutland@arm.com>,
        <grant.likely@linaro.org>
CC: <ijc+devicetree@hellion.org.uk>, <galak@codeaurora.org>,
        <linux-kernel@vger.kernel.org>, <devicetree@vger.kernel.org>,
        <swarren@nvidia.com>, <kerwinw@nvidia.com>,
        Laxman Dewangan <ldewangan@nvidia.com>
Subject: [PATCH 2/2] dt-binding: add header to define types and conversion
Date: Thu, 12 Dec 2013 18:54:53 +0530
Message-ID: <1386854693-10871-2-git-send-email-ldewangan@nvidia.com>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1386854693-10871-1-git-send-email-ldewangan@nvidia.com>
References: <1386854693-10871-1-git-send-email-ldewangan@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add a header file to define the macros for type conversion
to be used by DTS file.

Add macro for the S32 to U32 conversion by using 2's complement.

Signed-off-by: Laxman Dewangan <ldewangan@nvidia.com>
---
 include/dt-bindings/types.h |   18 ++++++++++++++++++
 1 files changed, 18 insertions(+), 0 deletions(-)
 create mode 100644 include/dt-bindings/types.h

diff --git a/include/dt-bindings/types.h b/include/dt-bindings/types.h
new file mode 100644
index 0000000..2b7ea75
--- /dev/null
+++ b/include/dt-bindings/types.h
@@ -0,0 +1,18 @@
+/*
+ * This header provides macros for different types and conversions
+ */
+
+#ifndef _DT_BINDINGS_TYPES_H_
+#define _DT_BINDINGS_TYPES_H_
+
+/*
+ * S32_TO_U32: This macro converts the signed number to 2's complement
+ * unisgned number. E.g. S32_TO_U32(-3) will be 0xfffffffd and
+ * S32_TO_U32(3) will be 0x3;
+ * Use of_property_read_s32() for getting back the correct signed value
+ * in driver.
+ */
+#define S32_TO_U32(x) (((x) < 0) ? (((-(x)) ^ 0xFFFFFFFFU) + 1) : (x))
+
+#endif
+
-- 
1.7.0.4

