Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753396AbaD0KuM (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Apr 2014 06:50:12 -0400
Received: from mail-wg0-f46.google.com ([74.125.82.46]:52448 "EHLO
	mail-wg0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751430AbaD0KuK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Apr 2014 06:50:10 -0400
From: Javier Martinez Canillas <javier@dowhile0.org>
To: Julia Lawall <Julia.Lawall@lip6.fr>
Cc: Michal Marek <mmarek@suse.cz>, Wolfram Sang <wsa@the-dreams.de>,
        cocci@systeme.lip6.fr, linux-kernel@vger.kernel.org,
        Javier Martinez Canillas <javier@dowhile0.org>
Subject: [PATCH v2 1/1] scripts/coccinelle: use BIT macro if used
Date: Sun, 27 Apr 2014 12:50:00 +0200
Message-Id: <1398595800-6683-1-git-send-email-javier@dowhile0.org>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Using the BIT() macro instead of manually shifting bits
makes the code less error prone.

If is more readable is a matter of taste so only replace
if the file is already using this macro.

Signed-off-by: Javier Martinez Canillas <javier@dowhile0.org>
---

Changes since v1:
 - Add a rule that checks if the file is already using this macro
   as suggested by Julia Lawall

 scripts/coccinelle/api/bit.cocci | 30 ++++++++++++++++++++++++++++++
 1 file changed, 30 insertions(+)
 create mode 100644 scripts/coccinelle/api/bit.cocci

diff --git a/scripts/coccinelle/api/bit.cocci b/scripts/coccinelle/api/bit.cocci
new file mode 100644
index 0000000..a02cfd3
--- /dev/null
+++ b/scripts/coccinelle/api/bit.cocci
@@ -0,0 +1,30 @@
+// Use the BIT() macro if is already used
+//
+// Confidence: High
+// Copyright (C) 2014 Javier Martinez Canillas.  GPLv2.
+// URL: http://coccinelle.lip6.fr/
+// Options: --include-headers
+
+@hasbitops@
+@@
+
+#include <linux/bitops.h>
+
+@usesbit@
+@@
+
+BIT(...)
+
+@depends on hasbitops && usesbit@
+expression E;
+@@
+
+- 1 << E
++ BIT(E)
+
+@depends on hasbitops && usesbit@
+expression E;
+@@
+
+- BIT((E))
++ BIT(E)
-- 
1.9.1

