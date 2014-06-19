Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758237AbaFSQaF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jun 2014 12:30:05 -0400
Received: from mail-pd0-f176.google.com ([209.85.192.176]:52536 "EHLO
	mail-pd0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757533AbaFSQaD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jun 2014 12:30:03 -0400
Date: Thu, 19 Jun 2014 21:59:54 +0530
From: Himangi Saraogi <himangi774@gmail.com>
To: Julia Lawall <Julia.Lawall@lip6.fr>, Gilles Muller <Gilles.Muller@lip6.fr>,
        Nicolas Palix <nicolas.palix@imag.fr>, Michal Marek <mmarek@suse.cz>,
        cocci@systeme.lip6.fr, linux-kernel@vger.kernel.org
Cc: benoit.taine@lip6.fr
Subject: [PATCH] Coccinelle: Script to drop parenthesis in the return
 statements
Message-ID: <20140619162954.GA4698@himangi-Dell>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This script detects the use of a parenthesis around return value ot the
return statements and removes them as they are unnecessary and against
the CodingStyle. A new directory called checkpatch is added for semantic
patches that just make patches for what checkpatch does. This will help
developers having checkpatch problems, to run the semantic patches in this
directory on their code and fix some of them automatically.

Signed-off-by: Himangi Saraogi <himangi774@gmail.com>
Acked-by: Julia Lawall <julia.lawall@lip6.fr>
---
 .../coccinelle/checkpatch/drop_parenthesis.cocci   | 33 ++++++++++++++++++++++
 1 file changed, 33 insertions(+)
 create mode 100644 scripts/coccinelle/checkpatch/drop_parenthesis.cocci

diff --git a/scripts/coccinelle/checkpatch/drop_parenthesis.cocci b/scripts/coccinelle/checkpatch/drop_parenthesis.cocci
new file mode 100644
index 0000000..49c0538
--- /dev/null
+++ b/scripts/coccinelle/checkpatch/drop_parenthesis.cocci
@@ -0,0 +1,33 @@
+/// Remove parenthesis around return value in return statements
+///
+//# This makes an effort to find cases of parenthesis in the return
+//# statements when returning an identifier or a constant and removes
+//# the parenthesis as they are not required.
+//
+// Confidence: High
+// Copyright: 2014, Himangi Saraogi  GPLv2.
+// Comments:
+// Options: --no-includes --include-headers
+//
+
+virtual patch
+
+//----------------------------------------------------------
+//  For patch mode
+//----------------------------------------------------------
+
+@depends on patch disable paren@
+identifier a;
+constant C;
+@@
+ return
+-(
+(
+C
+|
+a
+)
+-)
+ ;
+
-- 
1.9.1

