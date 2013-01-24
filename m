Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754552Ab3AXK4g (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jan 2013 05:56:36 -0500
Received: from us02smtp1.synopsys.com ([198.182.60.75]:47264 "EHLO
	vaxjo.synopsys.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753065Ab3AXKyw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jan 2013 05:54:52 -0500
From: Vineet Gupta <Vineet.Gupta1@synopsys.com>
To: <linux-arch@vger.kernel.org>, <linux-kernel@vger.kernel.org>
CC: <arnd@arndb.de>, Vineet Gupta <Vineet.Gupta1@synopsys.com>
Subject: [PATCH v3 70/71] ARC: Provide a default serial.h for uart drivers needing BASE_BAUD
Date: Thu, 24 Jan 2013 16:20:39 +0530
Message-ID: <1359024639-21915-26-git-send-email-vgupta@synopsys.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1359024639-21915-1-git-send-email-vgupta@synopsys.com>
References: <1359024639-21915-1-git-send-email-vgupta@synopsys.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.12.197.205]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Vineet Gupta <vgupta@synopsys.com>
---
 arch/arc/include/asm/serial.h |   25 +++++++++++++++++++++++++
 1 files changed, 25 insertions(+), 0 deletions(-)
 create mode 100644 arch/arc/include/asm/serial.h

diff --git a/arch/arc/include/asm/serial.h b/arch/arc/include/asm/serial.h
new file mode 100644
index 0000000..4dff5a1
--- /dev/null
+++ b/arch/arc/include/asm/serial.h
@@ -0,0 +1,25 @@
+/*
+ * Copyright (C) 2012 Synopsys, Inc. (www.synopsys.com)
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+
+#ifndef _ASM_ARC_SERIAL_H
+#define _ASM_ARC_SERIAL_H
+
+/*
+ * early-8250 requires BASE_BAUD to be defined and includes this header.
+ * We put in a typical value:
+ * 	(core clk / 16) - i.e. UART samples 16 times per sec.
+ * Athough in multi-platform-image this might not work, specially if the
+ * clk driving the UART is different.
+ * We can't use DeviceTree as this is typically for early serial.
+ */
+
+#include <asm/clk.h>
+
+#define BASE_BAUD	(arc_get_core_freq() / 16)
+
+#endif /* _ASM_ARC_SERIAL_H */
-- 
1.7.4.1

