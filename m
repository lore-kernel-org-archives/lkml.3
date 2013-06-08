Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752286Ab3FHQV6 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Jun 2013 12:21:58 -0400
Received: from mail3-relais-sop.national.inria.fr ([192.134.164.104]:22569
	"EHLO mail3-relais-sop.national.inria.fr" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751815Ab3FHQV5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Jun 2013 12:21:57 -0400
X-IronPort-AV: E=Sophos;i="4.87,828,1363129200"; 
   d="scan'208";a="17215918"
From: Julia Lawall <Julia.Lawall@lip6.fr>
To: cocci@systeme.lip6.fr, mmarek@suse.cz
Cc: kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] scripts/coccinelle: check for field address argument to kfree
Date: Sat,  8 Jun 2013 18:21:42 +0200
Message-Id: <1370708502-21907-1-git-send-email-Julia.Lawall@lip6.fr>
X-Mailer: git-send-email 1.7.8.6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Julia Lawall <Julia.Lawall@lip6.fr>

The argument to kfree should not be the address of a structure field.

Signed-off-by: Julia Lawall <Julia.Lawall@lip6.fr>

---
 scripts/coccinelle/free/kfreeaddr.cocci |   32 ++++++++++++++++++++++++++++++++
 1 file changed, 32 insertions(+)

diff --git a/scripts/coccinelle/free/kfreeaddr.cocci b/scripts/coccinelle/free/kfreeaddr.cocci
new file mode 100644
index 0000000..662e997
--- /dev/null
+++ b/scripts/coccinelle/free/kfreeaddr.cocci
@@ -0,0 +1,32 @@
+/// Free of a structure field
+///
+// Confidence: High
+// Copyright: (C) 2013 Julia Lawall, INRIA/LIP6.  GPLv2.
+// URL: http://coccinelle.lip6.fr/
+// Comments:
+// Options: -no_includes -include_headers
+
+virtual org
+virtual report
+virtual context
+
+@r depends on context || report || org @
+expression e;
+identifier f;
+position p;
+@@
+
+* kfree@p(&e->f)
+
+@script:python depends on org@
+p << r.p;
+@@
+
+cocci.print_main("kfree",p)
+
+@script:python depends on report@
+p << r.p;
+@@
+
+msg = "ERROR: kfree of structure field"
+coccilib.report.print_report(p[0],msg)

