Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757288Ab3A2QDr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jan 2013 11:03:47 -0500
Received: from mailgw1.uni-kl.de ([131.246.120.220]:48998 "EHLO
	mailgw1.uni-kl.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754251Ab3A2QDp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jan 2013 11:03:45 -0500
Subject: [PATCH 2 2/2] coccicheck: Allow to show the executed command line
To: linux-kernel@vger.kernel.org
From: Bernd Schubert <bernd.schubert@itwm.fraunhofer.de>
Cc: Michal Marek <mmarek@suse.cz>, Julia Lawall <Julia.Lawall@lip6.fr>,
        Nicolas Palix <nicolas.palix@imag.fr>, cocci@systeme.lip6.fr
Date: Tue, 29 Jan 2013 17:03:42 +0100
Message-ID: <20130129160342.28754.96853.stgit@localhost.localdomain>
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
CC: Michal Marek <mmarek@suse.cz>
---
 scripts/coccicheck |   28 +++++++++++++++++++++-------
 1 file changed, 21 insertions(+), 7 deletions(-)

diff --git a/scripts/coccicheck b/scripts/coccicheck
index f8f15a2..85d3189 100755
--- a/scripts/coccicheck
+++ b/scripts/coccicheck
@@ -55,6 +55,14 @@ if [ "$ONLINE" = "0" ] ; then
     echo ''
 fi
 
+run_cmd() {
+	if [ $VERBOSE -ne 0 ] ; then
+		echo "Running: $@"
+	fi
+	eval $@
+}
+
+
 coccinelle () {
     COCCI="$1"
 
@@ -100,15 +108,21 @@ coccinelle () {
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

