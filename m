Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030252Ab3FTLMc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Jun 2013 07:12:32 -0400
Received: from mail-wg0-f46.google.com ([74.125.82.46]:47571 "EHLO
	mail-wg0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965288Ab3FTLMN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Jun 2013 07:12:13 -0400
From: Nicolas Palix <nicolas.palix@imag.fr>
To: Julia Lawall <Julia.Lawall@lip6.fr>, Gilles Muller <Gilles.Muller@lip6.fr>,
        Nicolas Palix <nicolas.palix@imag.fr>, Michal Marek <mmarek@suse.cz>,
        cocci@systeme.lip6.fr, linux-kernel@vger.kernel.org
Subject: [PATCH 3/3] Coccinelle: Update the options used to the new option scheme
Date: Thu, 20 Jun 2013 13:10:56 +0200
Message-Id: <1371726656-24928-2-git-send-email-nicolas.palix@imag.fr>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1371726656-24928-1-git-send-email-nicolas.palix@imag.fr>
References: <1371726656-24928-1-git-send-email-nicolas.palix@imag.fr>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

spatch has changed its option scheme.
E.g., --no_show_diff is now --no-show-diff

This patch updates:
 - scripts/coccicheck
 - Semantic patches under scripts/coccinelle/

Signed-off-by: Nicolas Palix <nicolas.palix@imag.fr>
---
 scripts/coccicheck                                 |   28 ++++++++++----------
 .../coccinelle/api/alloc/drop_kmalloc_cast.cocci   |    2 +-
 scripts/coccinelle/api/alloc/kzalloc-simple.cocci  |    2 +-
 scripts/coccinelle/api/d_find_alias.cocci          |    2 +-
 .../coccinelle/api/devm_request_and_ioremap.cocci  |    2 +-
 scripts/coccinelle/api/kstrdup.cocci               |    2 +-
 scripts/coccinelle/api/memdup.cocci                |    2 +-
 scripts/coccinelle/api/memdup_user.cocci           |    2 +-
 scripts/coccinelle/api/ptr_ret.cocci               |    2 +-
 scripts/coccinelle/api/simple_open.cocci           |    2 +-
 scripts/coccinelle/free/devm_free.cocci            |    2 +-
 scripts/coccinelle/free/kfree.cocci                |    2 +-
 scripts/coccinelle/free/kfreeaddr.cocci            |    2 +-
 scripts/coccinelle/iterators/fen.cocci             |    2 +-
 scripts/coccinelle/iterators/itnull.cocci          |    2 +-
 .../coccinelle/iterators/list_entry_update.cocci   |    2 +-
 scripts/coccinelle/iterators/use_after_iter.cocci  |    2 +-
 scripts/coccinelle/locks/call_kern.cocci           |    2 +-
 scripts/coccinelle/locks/double_lock.cocci         |    2 +-
 scripts/coccinelle/locks/flags.cocci               |    2 +-
 scripts/coccinelle/locks/mini_lock.cocci           |    2 +-
 scripts/coccinelle/misc/boolinit.cocci             |    2 +-
 scripts/coccinelle/misc/cstptr.cocci               |    2 +-
 scripts/coccinelle/misc/doubleinit.cocci           |    2 +-
 scripts/coccinelle/misc/ifaddr.cocci               |    2 +-
 scripts/coccinelle/misc/ifcol.cocci                |    2 +-
 scripts/coccinelle/misc/noderef.cocci              |    2 +-
 scripts/coccinelle/misc/orplus.cocci               |    2 +-
 scripts/coccinelle/misc/warn.cocci                 |    2 +-
 scripts/coccinelle/null/eno.cocci                  |    2 +-
 scripts/coccinelle/null/kmerr.cocci                |    2 +-
 scripts/coccinelle/tests/doublebitand.cocci        |    2 +-
 scripts/coccinelle/tests/doubletest.cocci          |    2 +-
 scripts/coccinelle/tests/odd_ptr_err.cocci         |    2 +-
 34 files changed, 47 insertions(+), 47 deletions(-)

diff --git a/scripts/coccicheck b/scripts/coccicheck
index ad8e8ff..d3757ad 100755
--- a/scripts/coccicheck
+++ b/scripts/coccicheck
@@ -20,7 +20,7 @@ else
 	NPROC="$J"
 fi
 
-FLAGS="$SPFLAGS -very_quiet"
+FLAGS="$SPFLAGS --very-quiet"
 
 # spatch only allows include directories with the syntax "-I include"
 # while gcc also allows "-Iinclude" and "-include include"
@@ -36,14 +36,14 @@ if [ "$C" = "1" -o "$C" = "2" ]; then
 else
     ONLINE=0
     if [ "$KBUILD_EXTMOD" = "" ] ; then
-        OPTIONS="-dir $srctree $COCCIINCLUDE"
+        OPTIONS="--dir $srctree $COCCIINCLUDE"
     else
-        OPTIONS="-dir $KBUILD_EXTMOD $COCCIINCLUDE"
+        OPTIONS="--dir $KBUILD_EXTMOD $COCCIINCLUDE"
     fi
 fi
 
 if [ "$KBUILD_EXTMOD" != "" ] ; then
-    OPTIONS="-patch $srctree $OPTIONS"
+    OPTIONS="--patch $srctree $OPTIONS"
 fi
 
 if [ ! -x "$SPATCH" ]; then
@@ -67,7 +67,7 @@ if [ "$MODE" = "chain" ] ; then
 	echo 'All available modes will be tried (in that order): patch, report, context, org'
     fi
 elif [ "$MODE" = "report" -o "$MODE" = "org" ] ; then
-    FLAGS="$FLAGS -no_show_diff"
+    FLAGS="$FLAGS --no-show-diff"
 fi
 
 if [ "$ONLINE" = "0" ] ; then
@@ -83,7 +83,7 @@ run_cmd() {
 		echo "Running ($NPROC in parallel): $@"
 	fi
 	for i in $(seq 0 $(( NPROC - 1)) ); do
-		eval "$@ -max $NPROC -index $i &"
+		eval "$@ --max $NPROC --index $i &"
 		SPATCH_PID[$i]=$!
 		if [ $VERBOSE -eq 2 ] ; then
 			echo "${SPATCH_PID[$i]} running"
@@ -106,7 +106,7 @@ coccinelle () {
 
     OPT=`grep "Option" $COCCI | cut -d':' -f2`
 
-#   The option '-parse_cocci' can be used to syntactically check the SmPL files.
+#   The option '--parse-cocci' can be used to syntactically check the SmPL files.
 #
 #    $SPATCH -D $MODE $FLAGS -parse_cocci $COCCI $OPT > /dev/null
 
@@ -147,20 +147,20 @@ coccinelle () {
 
     if [ "$MODE" = "chain" ] ; then
 	run_cmd $SPATCH -D patch   \
-		$FLAGS -sp_file $COCCI $OPT $OPTIONS               || \
+		$FLAGS --cocci-file $COCCI $OPT $OPTIONS               || \
 	run_cmd $SPATCH -D report  \
-		$FLAGS -sp_file $COCCI $OPT $OPTIONS -no_show_diff || \
+		$FLAGS --cocci-file $COCCI $OPT $OPTIONS --no-show-diff || \
 	run_cmd $SPATCH -D context \
-		$FLAGS -sp_file $COCCI $OPT $OPTIONS               || \
+		$FLAGS --cocci-file $COCCI $OPT $OPTIONS               || \
 	run_cmd $SPATCH -D org     \
-		$FLAGS -sp_file $COCCI $OPT $OPTIONS -no_show_diff || exit 1
+		$FLAGS --cocci-file $COCCI $OPT $OPTIONS --no-show-diff || exit 1
     elif [ "$MODE" = "rep+ctxt" ] ; then
 	run_cmd $SPATCH -D report  \
-		$FLAGS -sp_file $COCCI $OPT $OPTIONS -no_show_diff && \
+		$FLAGS --cocci-file $COCCI $OPT $OPTIONS --no-show-diff && \
 	run_cmd $SPATCH -D context \
-		$FLAGS -sp_file $COCCI $OPT $OPTIONS || exit 1
+		$FLAGS --cocci-file $COCCI $OPT $OPTIONS || exit 1
     else
-	run_cmd $SPATCH -D $MODE   $FLAGS -sp_file $COCCI $OPT $OPTIONS || exit 1
+	run_cmd $SPATCH -D $MODE   $FLAGS --cocci-file $COCCI $OPT $OPTIONS || exit 1
     fi
 
 }
diff --git a/scripts/coccinelle/api/alloc/drop_kmalloc_cast.cocci b/scripts/coccinelle/api/alloc/drop_kmalloc_cast.cocci
index 7d4771d..bd5d08b 100644
--- a/scripts/coccinelle/api/alloc/drop_kmalloc_cast.cocci
+++ b/scripts/coccinelle/api/alloc/drop_kmalloc_cast.cocci
@@ -5,7 +5,7 @@
 // Confidence: High
 // Copyright: 2009,2010 Nicolas Palix, DIKU.  GPLv2.
 // URL: http://coccinelle.lip6.fr/
-// Options: -no_includes -include_headers
+// Options: --no-includes --include-headers
 //
 // Keywords: kmalloc, kzalloc, kcalloc
 // Version min: < 2.6.12 kmalloc
diff --git a/scripts/coccinelle/api/alloc/kzalloc-simple.cocci b/scripts/coccinelle/api/alloc/kzalloc-simple.cocci
index 046b9b1..52c55e4 100644
--- a/scripts/coccinelle/api/alloc/kzalloc-simple.cocci
+++ b/scripts/coccinelle/api/alloc/kzalloc-simple.cocci
@@ -9,7 +9,7 @@
 // Copyright: (C) 2009-2010 Julia Lawall, Nicolas Palix, DIKU.  GPLv2.
 // Copyright: (C) 2009-2010 Gilles Muller, INRIA/LiP6.  GPLv2.
 // URL: http://coccinelle.lip6.fr/rules/kzalloc.html
-// Options: -no_includes -include_headers
+// Options: --no-includes --include-headers
 //
 // Keywords: kmalloc, kzalloc
 // Version min: < 2.6.12 kmalloc
diff --git a/scripts/coccinelle/api/d_find_alias.cocci b/scripts/coccinelle/api/d_find_alias.cocci
index a9694a8..9594c9f 100644
--- a/scripts/coccinelle/api/d_find_alias.cocci
+++ b/scripts/coccinelle/api/d_find_alias.cocci
@@ -4,7 +4,7 @@
 //
 // Confidence: Moderate
 // URL: http://coccinelle.lip6.fr/
-// Options: -include_headers
+// Options: --include-headers
 
 virtual context
 virtual org
diff --git a/scripts/coccinelle/api/devm_request_and_ioremap.cocci b/scripts/coccinelle/api/devm_request_and_ioremap.cocci
index 46beb81..562ec88 100644
--- a/scripts/coccinelle/api/devm_request_and_ioremap.cocci
+++ b/scripts/coccinelle/api/devm_request_and_ioremap.cocci
@@ -10,7 +10,7 @@
 // Copyright: (C) 2011 Gilles Muller, INRIA/LiP6.  GPLv2.
 // URL: http://coccinelle.lip6.fr/
 // Comments:
-// Options: -no_includes -include_headers
+// Options: --no-includes --include-headers
 
 virtual patch
 virtual org
diff --git a/scripts/coccinelle/api/kstrdup.cocci b/scripts/coccinelle/api/kstrdup.cocci
index 07a74b2..09cba54 100644
--- a/scripts/coccinelle/api/kstrdup.cocci
+++ b/scripts/coccinelle/api/kstrdup.cocci
@@ -6,7 +6,7 @@
 // Copyright: (C) 2010-2012 Gilles Muller, INRIA/LiP6.  GPLv2.
 // URL: http://coccinelle.lip6.fr/
 // Comments:
-// Options: -no_includes -include_headers
+// Options: --no-includes --include-headers
 
 virtual patch
 virtual context
diff --git a/scripts/coccinelle/api/memdup.cocci b/scripts/coccinelle/api/memdup.cocci
index 4dceab6..3d1aa71 100644
--- a/scripts/coccinelle/api/memdup.cocci
+++ b/scripts/coccinelle/api/memdup.cocci
@@ -6,7 +6,7 @@
 // Copyright: (C) 2010-2012 Gilles Muller, INRIA/LiP6.  GPLv2.
 // URL: http://coccinelle.lip6.fr/
 // Comments:
-// Options: -no_includes -include_headers
+// Options: --no-includes --include-headers
 
 virtual patch
 virtual context
diff --git a/scripts/coccinelle/api/memdup_user.cocci b/scripts/coccinelle/api/memdup_user.cocci
index 2b131a8..c606231 100644
--- a/scripts/coccinelle/api/memdup_user.cocci
+++ b/scripts/coccinelle/api/memdup_user.cocci
@@ -7,7 +7,7 @@
 // Copyright: (C) 2010-2012 Gilles Muller, INRIA/LiP6.  GPLv2.
 // URL: http://coccinelle.lip6.fr/
 // Comments:
-// Options: -no_includes -include_headers
+// Options: --no-includes --include-headers
 
 virtual patch
 virtual context
diff --git a/scripts/coccinelle/api/ptr_ret.cocci b/scripts/coccinelle/api/ptr_ret.cocci
index 15f076f..2274638 100644
--- a/scripts/coccinelle/api/ptr_ret.cocci
+++ b/scripts/coccinelle/api/ptr_ret.cocci
@@ -5,7 +5,7 @@
 // Copyright: (C) 2012 Julia Lawall, INRIA/LIP6.  GPLv2.
 // Copyright: (C) 2012 Gilles Muller, INRIA/LiP6.  GPLv2.
 // URL: http://coccinelle.lip6.fr/
-// Options: -no_includes -include_headers
+// Options: --no-includes --include-headers
 //
 // Keywords: ERR_PTR, PTR_ERR, PTR_RET
 // Version min: 2.6.39
diff --git a/scripts/coccinelle/api/simple_open.cocci b/scripts/coccinelle/api/simple_open.cocci
index 05962f7..b67e174 100644
--- a/scripts/coccinelle/api/simple_open.cocci
+++ b/scripts/coccinelle/api/simple_open.cocci
@@ -4,7 +4,7 @@
 ///
 // Confidence: High
 // Comments:
-// Options: -no_includes -include_headers
+// Options: --no-includes --include-headers
 
 virtual patch
 virtual report
diff --git a/scripts/coccinelle/free/devm_free.cocci b/scripts/coccinelle/free/devm_free.cocci
index 0a1e361..3d93490 100644
--- a/scripts/coccinelle/free/devm_free.cocci
+++ b/scripts/coccinelle/free/devm_free.cocci
@@ -18,7 +18,7 @@
 // Copyright: (C) 2011 Gilles Muller, INRIA/LiP6.  GPLv2.
 // URL: http://coccinelle.lip6.fr/
 // Comments:
-// Options: -no_includes -include_headers
+// Options: --no-includes --include-headers
 
 virtual org
 virtual report
diff --git a/scripts/coccinelle/free/kfree.cocci b/scripts/coccinelle/free/kfree.cocci
index d9ae6d8..577b780 100644
--- a/scripts/coccinelle/free/kfree.cocci
+++ b/scripts/coccinelle/free/kfree.cocci
@@ -10,7 +10,7 @@
 // Copyright: (C) 2010-2012 Gilles Muller, INRIA/LiP6.  GPLv2.
 // URL: http://coccinelle.lip6.fr/
 // Comments:
-// Options: -no_includes -include_headers
+// Options: --no-includes --include-headers
 
 virtual org
 virtual report
diff --git a/scripts/coccinelle/free/kfreeaddr.cocci b/scripts/coccinelle/free/kfreeaddr.cocci
index 662e997..ce8aacc 100644
--- a/scripts/coccinelle/free/kfreeaddr.cocci
+++ b/scripts/coccinelle/free/kfreeaddr.cocci
@@ -4,7 +4,7 @@
 // Copyright: (C) 2013 Julia Lawall, INRIA/LIP6.  GPLv2.
 // URL: http://coccinelle.lip6.fr/
 // Comments:
-// Options: -no_includes -include_headers
+// Options: --no-includes --include-headers
 
 virtual org
 virtual report
diff --git a/scripts/coccinelle/iterators/fen.cocci b/scripts/coccinelle/iterators/fen.cocci
index 0a40af8..48c152f 100644
--- a/scripts/coccinelle/iterators/fen.cocci
+++ b/scripts/coccinelle/iterators/fen.cocci
@@ -7,7 +7,7 @@
 // Copyright: (C) 2010-2012 Gilles Muller, INRIA/LiP6.  GPLv2.
 // URL: http://coccinelle.lip6.fr/
 // Comments:
-// Options: -no_includes -include_headers
+// Options: --no-includes --include-headers
 
 virtual patch
 virtual context
diff --git a/scripts/coccinelle/iterators/itnull.cocci b/scripts/coccinelle/iterators/itnull.cocci
index 259899f..f58732b 100644
--- a/scripts/coccinelle/iterators/itnull.cocci
+++ b/scripts/coccinelle/iterators/itnull.cocci
@@ -11,7 +11,7 @@
 // Copyright: (C) 2010-2012 Gilles Muller, INRIA/LiP6.  GPLv2.
 // URL: http://coccinelle.lip6.fr/
 // Comments:
-// Options: -no_includes -include_headers
+// Options: --no-includes --include-headers
 
 virtual patch
 virtual context
diff --git a/scripts/coccinelle/iterators/list_entry_update.cocci b/scripts/coccinelle/iterators/list_entry_update.cocci
index b296747..873f444 100644
--- a/scripts/coccinelle/iterators/list_entry_update.cocci
+++ b/scripts/coccinelle/iterators/list_entry_update.cocci
@@ -9,7 +9,7 @@
 // Copyright: (C) 2010 Gilles Muller, INRIA/LiP6.  GPLv2.
 // URL: http://coccinelle.lip6.fr/
 // Comments:
-// Options: -no_includes -include_headers
+// Options: --no-includes --include-headers
 
 virtual context
 virtual org
diff --git a/scripts/coccinelle/iterators/use_after_iter.cocci b/scripts/coccinelle/iterators/use_after_iter.cocci
index 06284c5..f085f59 100644
--- a/scripts/coccinelle/iterators/use_after_iter.cocci
+++ b/scripts/coccinelle/iterators/use_after_iter.cocci
@@ -11,7 +11,7 @@
 // Copyright: (C) 2012 Gilles Muller, INRIA/LIP6.  GPLv2.
 // URL: http://coccinelle.lip6.fr/
 // Comments:
-// Options: -no_includes -include_headers
+// Options: --no-includes --include-headers
 
 virtual context
 virtual org
diff --git a/scripts/coccinelle/locks/call_kern.cocci b/scripts/coccinelle/locks/call_kern.cocci
index 8f10b49..669b244 100644
--- a/scripts/coccinelle/locks/call_kern.cocci
+++ b/scripts/coccinelle/locks/call_kern.cocci
@@ -9,7 +9,7 @@
 // Copyright: (C) 2012 Gilles Muller, INRIA/LiP6.  GPLv2.
 // URL: http://coccinelle.lip6.fr/
 // Comments:
-// Options: -no_includes -include_headers
+// Options: --no-includes --include-headers
 
 virtual patch
 virtual context
diff --git a/scripts/coccinelle/locks/double_lock.cocci b/scripts/coccinelle/locks/double_lock.cocci
index 63b24e6..002752f 100644
--- a/scripts/coccinelle/locks/double_lock.cocci
+++ b/scripts/coccinelle/locks/double_lock.cocci
@@ -8,7 +8,7 @@
 // Copyright: (C) 2010 Gilles Muller, INRIA/LiP6.  GPLv2.
 // URL: http://coccinelle.lip6.fr/
 // Comments:
-// Options: -no_includes -include_headers
+// Options: --no-includes --include-headers
 
 virtual org
 virtual report
diff --git a/scripts/coccinelle/locks/flags.cocci b/scripts/coccinelle/locks/flags.cocci
index 1c4ffe6..debd70e 100644
--- a/scripts/coccinelle/locks/flags.cocci
+++ b/scripts/coccinelle/locks/flags.cocci
@@ -6,7 +6,7 @@
 // Copyright: (C) 2010-2012 Gilles Muller, INRIA/LiP6.  GPLv2.
 // URL: http://coccinelle.lip6.fr/
 // Comments:
-// Options: -no_includes -include_headers
+// Options: --no-includes --include-headers
 
 virtual context
 virtual org
diff --git a/scripts/coccinelle/locks/mini_lock.cocci b/scripts/coccinelle/locks/mini_lock.cocci
index 3267d74..47f649b 100644
--- a/scripts/coccinelle/locks/mini_lock.cocci
+++ b/scripts/coccinelle/locks/mini_lock.cocci
@@ -11,7 +11,7 @@
 // Copyright: (C) 2010-2012 Gilles Muller, INRIA/LiP6.  GPLv2.
 // URL: http://coccinelle.lip6.fr/
 // Comments:
-// Options: -no_includes -include_headers
+// Options: --no-includes --include-headers
 
 virtual context
 virtual org
diff --git a/scripts/coccinelle/misc/boolinit.cocci b/scripts/coccinelle/misc/boolinit.cocci
index 97ce41c..b9abed4 100644
--- a/scripts/coccinelle/misc/boolinit.cocci
+++ b/scripts/coccinelle/misc/boolinit.cocci
@@ -6,7 +6,7 @@
 // Copyright: (C) 2012 Julia Lawall, INRIA/LIP6.  GPLv2.
 // Copyright: (C) 2012 Gilles Muller, INRIA/LiP6.  GPLv2.
 // URL: http://coccinelle.lip6.fr/
-// Options: -include_headers
+// Options: --include-headers
 
 virtual patch
 virtual context
diff --git a/scripts/coccinelle/misc/cstptr.cocci b/scripts/coccinelle/misc/cstptr.cocci
index d425644..f0368b3 100644
--- a/scripts/coccinelle/misc/cstptr.cocci
+++ b/scripts/coccinelle/misc/cstptr.cocci
@@ -6,7 +6,7 @@
 // Copyright: (C) 2012 Gilles Muller, INRIA/LiP6.  GPLv2.
 // URL: http://coccinelle.lip6.fr/
 // Comments:
-// Options: -no_includes -include_headers
+// Options: --no-includes --include-headers
 
 virtual org
 virtual report
diff --git a/scripts/coccinelle/misc/doubleinit.cocci b/scripts/coccinelle/misc/doubleinit.cocci
index cf74a00..c0c3371 100644
--- a/scripts/coccinelle/misc/doubleinit.cocci
+++ b/scripts/coccinelle/misc/doubleinit.cocci
@@ -8,7 +8,7 @@
 // Copyright: (C) 2010-2012 Gilles Muller, INRIA/LiP6.  GPLv2.
 // URL: http://coccinelle.lip6.fr/
 // Comments: requires at least Coccinelle 0.2.4, lex or parse error otherwise
-// Options: -no_includes -include_headers
+// Options: --no-includes --include-headers
 
 virtual org
 virtual report
diff --git a/scripts/coccinelle/misc/ifaddr.cocci b/scripts/coccinelle/misc/ifaddr.cocci
index 3e4089a..8aebd18 100644
--- a/scripts/coccinelle/misc/ifaddr.cocci
+++ b/scripts/coccinelle/misc/ifaddr.cocci
@@ -6,7 +6,7 @@
 // Copyright: (C) 2012 Gilles Muller, INRIA/LiP6.  GPLv2.
 // URL: http://coccinelle.lip6.fr/
 // Comments:
-// Options: -no_includes -include_headers
+// Options: --no-includes --include-headers
 
 virtual org
 virtual report
diff --git a/scripts/coccinelle/misc/ifcol.cocci b/scripts/coccinelle/misc/ifcol.cocci
index b7ed91d..d0d00ef 100644
--- a/scripts/coccinelle/misc/ifcol.cocci
+++ b/scripts/coccinelle/misc/ifcol.cocci
@@ -13,7 +13,7 @@
 // Copyright: (C) 2010 Gilles Muller, INRIA/LiP6.  GPLv2.
 // URL: http://coccinelle.lip6.fr/
 // Comments:
-// Options: -no_includes -include_headers
+// Options: --no-includes --include-headers
 
 virtual org
 virtual report
diff --git a/scripts/coccinelle/misc/noderef.cocci b/scripts/coccinelle/misc/noderef.cocci
index c170721..80a831c 100644
--- a/scripts/coccinelle/misc/noderef.cocci
+++ b/scripts/coccinelle/misc/noderef.cocci
@@ -6,7 +6,7 @@
 // Copyright: (C) 2012 Gilles Muller, INRIA/LiP6.  GPLv2.
 // URL: http://coccinelle.lip6.fr/
 // Comments:
-// Options: -no_includes -include_headers
+// Options: --no-includes --include-headers
 
 virtual org
 virtual report
diff --git a/scripts/coccinelle/misc/orplus.cocci b/scripts/coccinelle/misc/orplus.cocci
index 4a28cef..81fabf3 100644
--- a/scripts/coccinelle/misc/orplus.cocci
+++ b/scripts/coccinelle/misc/orplus.cocci
@@ -7,7 +7,7 @@
 // Copyright: (C) 2013 Gilles Muller, INRIA/LIP6.  GPLv2.
 // URL: http://coccinelle.lip6.fr/
 // Comments:
-// Options: -no_includes -include_headers
+// Options: --no-includes --include-headers
 
 virtual org
 virtual report
diff --git a/scripts/coccinelle/misc/warn.cocci b/scripts/coccinelle/misc/warn.cocci
index fda8c35..d2e5b6c 100644
--- a/scripts/coccinelle/misc/warn.cocci
+++ b/scripts/coccinelle/misc/warn.cocci
@@ -5,7 +5,7 @@
 // Copyright: (C) 2012 Gilles Muller, INRIA/LiP6.  GPLv2.
 // URL: http://coccinelle.lip6.fr/
 // Comments:
-// Options: -no_includes -include_headers
+// Options: --no-includes --include-headers
 
 virtual patch
 virtual context
diff --git a/scripts/coccinelle/null/eno.cocci b/scripts/coccinelle/null/eno.cocci
index ed961a1..9bd29aa 100644
--- a/scripts/coccinelle/null/eno.cocci
+++ b/scripts/coccinelle/null/eno.cocci
@@ -6,7 +6,7 @@
 // Copyright: (C) 2010-2012 Gilles Muller, INRIA/LiP6.  GPLv2.
 // URL: http://coccinelle.lip6.fr/
 // Comments:
-// Options: -no_includes -include_headers
+// Options: --no-includes --include-headers
 
 virtual patch
 virtual context
diff --git a/scripts/coccinelle/null/kmerr.cocci b/scripts/coccinelle/null/kmerr.cocci
index 949bf65..5354a79 100644
--- a/scripts/coccinelle/null/kmerr.cocci
+++ b/scripts/coccinelle/null/kmerr.cocci
@@ -10,7 +10,7 @@
 // Copyright: (C) 2010 Gilles Muller, INRIA/LiP6.  GPLv2.
 // URL: http://coccinelle.lip6.fr/
 // Comments:
-// Options: -no_includes -include_headers
+// Options: --no-includes --include-headers
 
 virtual context
 virtual org
diff --git a/scripts/coccinelle/tests/doublebitand.cocci b/scripts/coccinelle/tests/doublebitand.cocci
index 9ba73d0..72f1572a 100644
--- a/scripts/coccinelle/tests/doublebitand.cocci
+++ b/scripts/coccinelle/tests/doublebitand.cocci
@@ -10,7 +10,7 @@
 // Copyright: (C) 2010 Gilles Muller, INRIA/LiP6.  GPLv2.
 // URL: http://coccinelle.lip6.fr/
 // Comments:
-// Options: -no_includes -include_headers
+// Options: --no-includes --include-headers
 
 virtual context
 virtual org
diff --git a/scripts/coccinelle/tests/doubletest.cocci b/scripts/coccinelle/tests/doubletest.cocci
index 13a2c0e..78d74c2 100644
--- a/scripts/coccinelle/tests/doubletest.cocci
+++ b/scripts/coccinelle/tests/doubletest.cocci
@@ -8,7 +8,7 @@
 // Copyright: (C) 2010 Gilles Muller, INRIA/LiP6.  GPLv2.
 // URL: http://coccinelle.lip6.fr/
 // Comments:
-// Options: -no_includes -include_headers
+// Options: --no-includes --include-headers
 
 virtual context
 virtual org
diff --git a/scripts/coccinelle/tests/odd_ptr_err.cocci b/scripts/coccinelle/tests/odd_ptr_err.cocci
index e8dd8a6..cfe0a35 100644
--- a/scripts/coccinelle/tests/odd_ptr_err.cocci
+++ b/scripts/coccinelle/tests/odd_ptr_err.cocci
@@ -7,7 +7,7 @@
 // Copyright: (C) 2012 Gilles Muller, INRIA.  GPLv2.
 // URL: http://coccinelle.lip6.fr/
 // Comments:
-// Options: -no_includes -include_headers
+// Options: --no-includes --include-headers
 
 virtual patch
 virtual context
-- 
1.7.9.5

