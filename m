Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752718AbaD0A36 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Apr 2014 20:29:58 -0400
Received: from mail-we0-f182.google.com ([74.125.82.182]:39863 "EHLO
	mail-we0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752607AbaD0A34 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Apr 2014 20:29:56 -0400
From: Javier Martinez Canillas <javier@dowhile0.org>
To: Julia Lawall <Julia.Lawall@lip6.fr>
Cc: Gilles Muller <Gilles.Muller@lip6.fr>,
        Nicolas Palix <nicolas.palix@imag.fr>, Michal Marek <mmarek@suse.cz>,
        cocci@systeme.lip6.fr, linux-kernel@vger.kernel.org,
        Javier Martinez Canillas <javier@dowhile0.org>
Subject: [PATCH 1/1] scripts/coccinelle: use BIT() macro if possible
Date: Sun, 27 Apr 2014 02:29:46 +0200
Message-Id: <1398558586-28931-1-git-send-email-javier@dowhile0.org>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Using the BIT() macro instead of manually shifting bits
makes the code less error prone and also more readable.

Signed-off-by: Javier Martinez Canillas <javier@dowhile0.org>
---

An example of the patches that can be obtained with this spatch:

http://www.mail-archive.com/linux-gpio@vger.kernel.org/msg02722.html

 scripts/coccinelle/api/bit.cocci | 25 +++++++++++++++++++++++++
 1 file changed, 25 insertions(+)
 create mode 100644 scripts/coccinelle/api/bit.cocci

diff --git a/scripts/coccinelle/api/bit.cocci b/scripts/coccinelle/api/bit.cocci
new file mode 100644
index 0000000..a5df73a
--- /dev/null
+++ b/scripts/coccinelle/api/bit.cocci
@@ -0,0 +1,25 @@
+// Use the macro BIT() macro if possible
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
+@depends on hasbitops@
+expression E;
+@@
+
+- 1 << E
++ BIT(E)
+
+@depends on hasbitops@
+expression E;
+@@
+
+- BIT((E))
++ BIT(E)
-- 
1.9.1

