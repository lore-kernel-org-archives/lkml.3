Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752991Ab3FFVkK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Jun 2013 17:40:10 -0400
Received: from mail-we0-f181.google.com ([74.125.82.181]:42291 "EHLO
	mail-we0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751326Ab3FFVkJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Jun 2013 17:40:09 -0400
From: Nicolas Palix <nicolas.palix@imag.fr>
To: Julia Lawall <Julia.Lawall@lip6.fr>, Gilles Muller <Gilles.Muller@lip6.fr>,
        Nicolas Palix <nicolas.palix@imag.fr>, Michal Marek <mmarek@suse.cz>,
        Brice Goglin <Brice.Goglin@inria.fr>, cocci@systeme.lip6.fr,
        linux-kernel@vger.kernel.org
Subject: [PATCH 1/2] Coccinelle: Make 'report' the default mode
Date: Thu,  6 Jun 2013 23:39:52 +0200
Message-Id: <1370554793-9152-1-git-send-email-nicolas.palix@imag.fr>
X-Mailer: git-send-email 1.8.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It appears that the 'report' mode is the one always
provided by the semantic patches included in the kernel.
It is thus more natural to select it by default.

The 'chain' mode is however kept and the 'patch' mode
is still the first tried in that case.

Signed-off-by: Nicolas Palix <nicolas.palix@imag.fr>
---

I forgot to sign the previous emails. 

 scripts/coccicheck | 14 +++++++++++---
 1 file changed, 11 insertions(+), 3 deletions(-)

diff --git a/scripts/coccicheck b/scripts/coccicheck
index 06fcb33..9d8780c 100755
--- a/scripts/coccicheck
+++ b/scripts/coccicheck
@@ -44,11 +44,19 @@ fi
 
 if [ "$MODE" = "" ] ; then
     if [ "$ONLINE" = "0" ] ; then
-	echo 'You have not explicitly specified the mode to use. Using default "chain" mode.'
-	echo 'All available modes will be tried (in that order): patch, report, context, org'
+	echo 'You have not explicitly specified the mode to use. Using default "report" mode.'
+	echo 'Available modes are the following: patch, report, context, org'
 	echo 'You can specify the mode with "make coccicheck MODE=<mode>"'
+	echo 'Note however that some modes are not implemented by some semantic patches.'
+    fi
+    MODE="report"
+fi
+
+if [ "$MODE" = "chain" ] ; then
+    if [ "$ONLINE" = "0" ] ; then
+	echo 'You have selected the "chain" mode.'
+	echo 'All available modes will be tried (in that order): patch, report, context, org'
     fi
-    MODE="chain"
 elif [ "$MODE" = "report" -o "$MODE" = "org" ] ; then
     FLAGS="$FLAGS -no_show_diff"
 fi
-- 
1.8.1.2

