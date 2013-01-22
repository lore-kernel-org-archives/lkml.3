Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753052Ab3AVNes (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jan 2013 08:34:48 -0500
Received: from mailgw1.uni-kl.de ([131.246.120.220]:34308 "EHLO
	mailgw1.uni-kl.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751703Ab3AVNem (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jan 2013 08:34:42 -0500
Subject: [PATCH 2/2] coccicheck: Allow to show the executed command line
To: linux-kernel@vger.kernel.org
From: Bernd Schubert <bernd.schubert@itwm.fraunhofer.de>
Cc: Julia Lawall <Julia.Lawall@lip6.fr>, Nicolas Palix <nicolas.palix@imag.fr>,
        cocci@systeme.lip6.fr
Date: Tue, 22 Jan 2013 14:34:39 +0100
Message-ID: <20130122133439.2543274.56232.stgit@fsdevel3>
In-Reply-To: <20130122133434.2543274.86646.stgit@fsdevel3>
References: <20130122133434.2543274.86646.stgit@fsdevel3>
User-Agent: StGit/0.15
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-ITWM-CharSet: utf-8
X-ITWM-Scanned-By: mail1.itwm.fhg.de
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On my system one of the tests failed with
"Fatal error: exception Failure("No OCaml compiler found! Install either ocamlopt or ocamlopt.opt")".

Investigating such issues is easier if the executed command line is being shown.

Signed-off-by: Bernd Schubert <bernd.schubert@itwm.fraunhofer.de>
CC: Julia Lawall <Julia.Lawall@lip6.fr>
CC: Nicolas Palix <nicolas.palix@imag.fr>
CC: cocci@systeme.lip6.fr
---
 scripts/coccicheck |   28 +++++++++++++++++++++-------
 1 file changed, 21 insertions(+), 7 deletions(-)

diff --git a/scripts/coccicheck b/scripts/coccicheck
index eab0b00..fb98534 100755
--- a/scripts/coccicheck
+++ b/scripts/coccicheck
@@ -52,6 +52,14 @@ if [ "$ONLINE" = "0" ] ; then
     echo ''
 fi
 
+run_cmd() {
+	if [ "$RUN_VERBOSE" != "0" ] ; then
+		echo "Running: $@"
+	fi
+	eval $@
+}
+
+
 coccinelle () {
     COCCI="$1"
 
@@ -97,15 +105,21 @@ coccinelle () {
     fi
 
     if [ "$MODE" = "chain" ] ; then
-	$SPATCH -D patch   $FLAGS -sp_file $COCCI $OPT $OPTIONS               || \
-	$SPATCH -D report  $FLAGS -sp_file $COCCI $OPT $OPTIONS -no_show_diff || \
-	$SPATCH -D context $FLAGS -sp_file $COCCI $OPT $OPTIONS               || \
-	$SPATCH -D org     $FLAGS -sp_file $COCCI $OPT $OPTIONS -no_show_diff || exit 1
+	run_cmd $SPATCH -D patch   \
+		$FLAGS -sp_file $COCCI $OPT $OPTIONS               || \
+	run_cmd $SPATCH -D report  \
+		$FLAGS -sp_file $COCCI $OPT $OPTIONS -no_show_diff || \
+	run_cmd $SPATCH -D context \
+		$FLAGS -sp_file $COCCI $OPT $OPTIONS               || \
+	run_cmd $SPATCH -D org     \
+		$FLAGS -sp_file $COCCI $OPT $OPTIONS -no_show_diff || exit 1
     elif [ "$MODE" = "rep+ctxt" ] ; then
-	$SPATCH -D report  $FLAGS -sp_file $COCCI $OPT $OPTIONS -no_show_diff && \
-	$SPATCH -D context $FLAGS -sp_file $COCCI $OPT $OPTIONS || exit 1
+	run_cmd $SPATCH -D report  \
+		$FLAGS -sp_file $COCCI $OPT $OPTIONS -no_show_diff && \
+	run_cmd $SPATCH -D context \
+		$FLAGS -sp_file $COCCI $OPT $OPTIONS || exit 1
     else
-	$SPATCH -D $MODE   $FLAGS -sp_file $COCCI $OPT $OPTIONS || exit 1
+	run_cmd $SPATCH -D $MODE   $FLAGS -sp_file $COCCI $OPT $OPTIONS || exit 1
     fi
 
 }

