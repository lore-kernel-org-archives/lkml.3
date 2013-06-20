Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965445Ab3FTLMx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Jun 2013 07:12:53 -0400
Received: from mail-we0-f172.google.com ([74.125.82.172]:58539 "EHLO
	mail-we0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965138Ab3FTLMw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Jun 2013 07:12:52 -0400
From: Nicolas Palix <nicolas.palix@imag.fr>
To: Julia Lawall <Julia.Lawall@lip6.fr>, Gilles Muller <Gilles.Muller@lip6.fr>,
        Nicolas Palix <nicolas.palix@imag.fr>, Michal Marek <mmarek@suse.cz>,
        cocci@systeme.lip6.fr, linux-kernel@vger.kernel.org,
        Rob Landley <rob@landley.net>, linux-doc@vger.kernel.org
Subject: [PATCH 2/3] Coccinelle: Update the documentation
Date: Thu, 20 Jun 2013 13:11:41 +0200
Message-Id: <1371726701-24970-1-git-send-email-nicolas.palix@imag.fr>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

 - The new default mode is 'report'.
 - The available modes are detailed a bit more.
 - Some information about the use of spatch options are
   also given concerning the use of indexing tools.

Signed-off-by: Nicolas Palix <nicolas.palix@imag.fr>
---
 Documentation/coccinelle.txt |   39 ++++++++++++++++++++++++++-------------
 1 file changed, 26 insertions(+), 13 deletions(-)

diff --git a/Documentation/coccinelle.txt b/Documentation/coccinelle.txt
index 408439d..1aa9a40 100644
--- a/Documentation/coccinelle.txt
+++ b/Documentation/coccinelle.txt
@@ -48,7 +48,7 @@ A Coccinelle-specific target is defined in the top level
 Makefile. This target is named 'coccicheck' and calls the 'coccicheck'
 front-end in the 'scripts' directory.
 
-Four modes are defined: patch, report, context, and org. The mode to
+Four basic modes are defined: patch, report, context, and org. The mode to
 use is specified by setting the MODE variable with 'MODE=<mode>'.
 
 'patch' proposes a fix, when possible.
@@ -62,18 +62,24 @@ diff-like style.Lines of interest are indicated with '-'.
 'org' generates a report in the Org mode format of Emacs.
 
 Note that not all semantic patches implement all modes. For easy use
-of Coccinelle, the default mode is "chain" which tries the previous
-modes in the order above until one succeeds.
+of Coccinelle, the default mode is "report".
 
-To make a report for every semantic patch, run the following command:
+Two other modes provide some common combinaisons of these modes.
 
-	make coccicheck MODE=report
+'chain' tries the previous modes in the order above until one succeeds.
 
-NB: The 'report' mode is the default one.
+'rep+ctxt' runs successively the report mode and the context mode.
+	   It should be used with the C option (described later)
+	   which checks the code on a file basis.
 
-To produce patches, run:
+Examples:
+	To make a report for every semantic patch, run the following command:
 
-	make coccicheck MODE=patch
+		make coccicheck MODE=report
+
+	To produce patches, run:
+
+		make coccicheck MODE=patch
 
 
 The coccicheck target applies every semantic patch available in the
@@ -129,26 +135,33 @@ To check only newly edited code, use the value 2 for the C flag, i.e.
 
     make C=2 CHECK="scripts/coccicheck"
 
+In these modes, which works on a file basis, there is no information
+about semantic patches displayed, and no commit message proposed.
+
 This runs every semantic patch in scripts/coccinelle by default. The
 COCCI variable may additionally be used to only apply a single
 semantic patch as shown in the previous section.
 
-The "chain" mode is the default. You can select another one with the
+The "report" mode is the default. You can select another one with the
 MODE variable explained above.
 
-In this mode, there is no information about semantic patches
-displayed, and no commit message proposed.
-
  Additional flags
 ~~~~~~~~~~~~~~~~~~
 
 Additional flags can be passed to spatch through the SPFLAGS
 variable.
 
-    make SPFLAGS=--use_glimpse coccicheck
+    make SPFLAGS=--use-glimpse coccicheck
+    make SPFLAGS=--use-idutils coccicheck
 
 See spatch --help to learn more about spatch options.
 
+Note that the '--use-glimpse' and '--use-idutils' options
+require external tools for indexing the code. None of them is
+thus active by default. However, by indexing the code with
+one of these tools, and according to the cocci file used,
+spatch could proceed the entire code base more quickly.
+
  Proposing new semantic patches
 ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
 
-- 
1.7.9.5

