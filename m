Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752823Ab3AVNel (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jan 2013 08:34:41 -0500
Received: from mailgw1.uni-kl.de ([131.246.120.220]:34299 "EHLO
	mailgw1.uni-kl.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751703Ab3AVNej (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jan 2013 08:34:39 -0500
Subject: [PATCH 1/2] coccicheck: Allow the user to give a VERBOSE= argument
To: linux-kernel@vger.kernel.org
From: Bernd Schubert <bernd.schubert@itwm.fraunhofer.de>
Cc: Julia Lawall <Julia.Lawall@lip6.fr>, Nicolas Palix <nicolas.palix@imag.fr>,
        cocci@systeme.lip6.fr
Date: Tue, 22 Jan 2013 14:34:34 +0100
Message-ID: <20130122133434.2543274.86646.stgit@fsdevel3>
User-Agent: StGit/0.15
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-ITWM-CharSet: utf-8
X-ITWM-Scanned-By: mail2.itwm.fhg.de
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Simply running "make coccicheck" returns very verbose output and warnings
might not be noticed.  Allow the user to set the verbosity level.


Signed-off-by: Bernd Schubert <bernd.schubert@itwm.fraunhofer.de>
CC: Julia Lawall <Julia.Lawall@lip6.fr>
CC: Nicolas Palix <nicolas.palix@imag.fr>
CC: cocci@systeme.lip6.fr
---
 scripts/coccicheck |    8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/scripts/coccicheck b/scripts/coccicheck
index 1a49d1c..eab0b00 100755
--- a/scripts/coccicheck
+++ b/scripts/coccicheck
@@ -2,6 +2,12 @@
 
 SPATCH="`which ${SPATCH:=spatch}`"
 
+if [ -z "$VERBOSE" ] ; then
+	RUN_VERBOSE=0
+else
+	RUN_VERBOSE=$VERBOSE
+fi
+
 if [ "$C" = "1" -o "$C" = "2" ]; then
     ONLINE=1
 
@@ -55,7 +61,7 @@ coccinelle () {
 #
 #    $SPATCH -D $MODE $FLAGS -parse_cocci $COCCI $OPT > /dev/null
 
-    if [ "$ONLINE" = "0" ] ; then
+    if [ "$RUN_VERBOSE" != "0" ] ; then
 
 	FILE=`echo $COCCI | sed "s|$srctree/||"`
 

