Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756647Ab3HLNVf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Aug 2013 09:21:35 -0400
Received: from mail2-relais-roc.national.inria.fr ([192.134.164.83]:49649 "EHLO
	mail2-relais-roc.national.inria.fr" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756570Ab3HLNV2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Aug 2013 09:21:28 -0400
X-IronPort-AV: E=Sophos;i="4.89,862,1367964000"; 
   d="scan'208";a="29143415"
From: Julia Lawall <Julia.Lawall@lip6.fr>
To: Michal Marek <mmarek@suse.cz>
Cc: kernel-janitors@vger.kernel.org, Gilles Muller <Gilles.Muller@lip6.fr>,
        Nicolas Palix <nicolas.palix@imag.fr>, cocci@systeme.lip6.fr,
        linux-kernel@vger.kernel.org
Subject: [PATCH] scripts/coccinelle/misc/warn.cocci: use WARN
Date: Mon, 12 Aug 2013 15:21:23 +0200
Message-Id: <1376313683-32276-1-git-send-email-Julia.Lawall@lip6.fr>
X-Mailer: git-send-email 1.7.8.6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Julia Lawall <Julia.Lawall@lip6.fr>

Use WARN(1,...) rather than printk followed by WARN(1).

Signed-off-by: Julia Lawall <Julia.Lawall@lip6.fr>

---
 scripts/coccinelle/misc/warn.cocci |  109 +++++++++++++++++++++++++++++++++++++
 1 file changed, 109 insertions(+)

diff --git a/scripts/coccinelle/misc/warn.cocci b/scripts/coccinelle/misc/warn.cocci
new file mode 100644
index 0000000..fda8c35
--- /dev/null
+++ b/scripts/coccinelle/misc/warn.cocci
@@ -0,0 +1,109 @@
+/// Use WARN(1,...) rather than printk followed by WARN_ON(1)
+///
+// Confidence: High
+// Copyright: (C) 2012 Julia Lawall, INRIA/LIP6.  GPLv2.
+// Copyright: (C) 2012 Gilles Muller, INRIA/LiP6.  GPLv2.
+// URL: http://coccinelle.lip6.fr/
+// Comments:
+// Options: -no_includes -include_headers
+
+virtual patch
+virtual context
+virtual org
+virtual report
+
+@bad1@
+position p;
+@@
+
+printk(...);
+printk@p(...);
+WARN_ON(1);
+
+@r1 depends on context || report || org@
+position p != bad1.p;
+@@
+
+ printk@p(...);
+*WARN_ON(1);
+
+@script:python depends on org@
+p << r1.p;
+@@
+
+cocci.print_main("printk + WARN_ON can be just WARN",p)
+
+@script:python depends on report@
+p << r1.p;
+@@
+
+msg = "SUGGESTION: printk + WARN_ON can be just WARN"
+coccilib.report.print_report(p[0],msg)
+
+@ok1 depends on patch@
+expression list es;
+position p != bad1.p;
+@@
+
+-printk@p(
++WARN(1,
+  es);
+-WARN_ON(1);
+
+@depends on patch@
+expression list ok1.es;
+@@
+
+if (...)
+- {
+  WARN(1,es);
+- }
+
+// --------------------------------------------------------------------
+
+@bad2@
+position p;
+@@
+
+printk(...);
+printk@p(...);
+WARN_ON_ONCE(1);
+
+@r2 depends on context || report || org@
+position p != bad1.p;
+@@
+
+ printk@p(...);
+*WARN_ON_ONCE(1);
+
+@script:python depends on org@
+p << r2.p;
+@@
+
+cocci.print_main("printk + WARN_ON_ONCE can be just WARN_ONCE",p)
+
+@script:python depends on report@
+p << r2.p;
+@@
+
+msg = "SUGGESTION: printk + WARN_ON_ONCE can be just WARN_ONCE"
+coccilib.report.print_report(p[0],msg)
+
+@ok2 depends on patch@
+expression list es;
+position p != bad2.p;
+@@
+
+-printk@p(
++WARN_ONCE(1,
+  es);
+-WARN_ON_ONCE(1);
+
+@depends on patch@
+expression list ok2.es;
+@@
+
+if (...)
+- {
+  WARN_ONCE(1,es);
+- }

