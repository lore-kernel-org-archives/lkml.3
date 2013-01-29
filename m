Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755349Ab3A2QDp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jan 2013 11:03:45 -0500
Received: from mailgw1.uni-kl.de ([131.246.120.220]:48989 "EHLO
	mailgw1.uni-kl.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752022Ab3A2QDn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jan 2013 11:03:43 -0500
Subject: [PATCH 2 1/2] coccicheck: Allow the user to give a V= (verbose)
 argument
To: linux-kernel@vger.kernel.org
From: Bernd Schubert <bernd.schubert@itwm.fraunhofer.de>
Cc: Michal Marek <mmarek@suse.cz>, Julia Lawall <Julia.Lawall@lip6.fr>,
        Nicolas Palix <nicolas.palix@imag.fr>, cocci@systeme.lip6.fr
Date: Tue, 29 Jan 2013 17:03:37 +0100
Message-ID: <20130129160337.28754.31558.stgit@localhost.localdomain>
User-Agent: StGit/0.15
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-ITWM-CharSet: utf-8
X-ITWM-Scanned-By: mail2.itwm.fhg.de
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Do not run with verbosity on/off depending on the ONLINE variable,
which gets set with C=1 or C=2, but allow the user to set the
verbosity using kernel default make V= paramemter.
Verbosity is off by default now.


Signed-off-by: Bernd Schubert <bernd.schubert@itwm.fraunhofer.de>
CC: Julia Lawall <Julia.Lawall@lip6.fr>
CC: Nicolas Palix <nicolas.palix@imag.fr>
CC: cocci@systeme.lip6.fr
CC: Michal Marek <mmarek@suse.cz>
---
 Documentation/coccinelle.txt |    4 ++++
 scripts/coccicheck           |   11 ++++++++++-
 2 files changed, 14 insertions(+), 1 deletion(-)

diff --git a/Documentation/coccinelle.txt b/Documentation/coccinelle.txt
index cf44eb6..dffa2d6 100644
--- a/Documentation/coccinelle.txt
+++ b/Documentation/coccinelle.txt
@@ -87,6 +87,10 @@ As any static code analyzer, Coccinelle produces false
 positives. Thus, reports must be carefully checked, and patches
 reviewed.
 
+To enable verbose messages set the V= variable, for example:
+
+   make coccicheck MODE=report V=1
+
 
  Using Coccinelle with a single semantic patch
 ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
diff --git a/scripts/coccicheck b/scripts/coccicheck
index 1a49d1c..f8f15a2 100755
--- a/scripts/coccicheck
+++ b/scripts/coccicheck
@@ -2,6 +2,15 @@
 
 SPATCH="`which ${SPATCH:=spatch}`"
 
+# The verbosity may be set by the environmental parameter V=
+# as for example with 'make V=1 coccicheck'
+
+if [ -n "$V" -a "$V" != "0" ]; then
+	VERBOSE=1
+else
+	VERBOSE=0
+fi
+
 if [ "$C" = "1" -o "$C" = "2" ]; then
     ONLINE=1
 
@@ -55,7 +64,7 @@ coccinelle () {
 #
 #    $SPATCH -D $MODE $FLAGS -parse_cocci $COCCI $OPT > /dev/null
 
-    if [ "$ONLINE" = "0" ] ; then
+    if [ $VERBOSE -ne 0 ] ; then
 
 	FILE=`echo $COCCI | sed "s|$srctree/||"`
 

