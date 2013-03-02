Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752837Ab3CBVgz (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Mar 2013 16:36:55 -0500
Received: from mail-we0-f182.google.com ([74.125.82.182]:33548 "EHLO
	mail-we0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752790Ab3CBVgx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Mar 2013 16:36:53 -0500
From: Nicolas Palix <nicolas.palix@imag.fr>
To: Julia Lawall <Julia.Lawall@lip6.fr>, Gilles Muller <Gilles.Muller@lip6.fr>,
        Nicolas Palix <nicolas.palix@imag.fr>, cocci@systeme.lip6.fr,
        linux-kernel@vger.kernel.org, Michal Marek <mmarek@suse.cz>
Subject: [PATCH 3/4] Coccinelle: Add support to the SPFLAGS variable
Date: Sat,  2 Mar 2013 22:36:27 +0100
Message-Id: <1362260188-14138-3-git-send-email-nicolas.palix@imag.fr>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1362260188-14138-1-git-send-email-nicolas.palix@imag.fr>
References: <1362260188-14138-1-git-send-email-nicolas.palix@imag.fr>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The SPFLAGS variable allows to pass additional options
to spatch, e.g. -use_glimpse.

Signed-off-by: Nicolas Palix <nicolas.palix@imag.fr>
---
 Documentation/coccinelle.txt |   11 ++++++++++-
 scripts/coccicheck           |    2 +-
 2 files changed, 11 insertions(+), 2 deletions(-)

diff --git a/Documentation/coccinelle.txt b/Documentation/coccinelle.txt
index dffa2d6..18de785 100644
--- a/Documentation/coccinelle.txt
+++ b/Documentation/coccinelle.txt
@@ -114,7 +114,7 @@ To apply Coccinelle to a specific directory, M= can be used.
 For example, to check drivers/net/wireless/ one may write:
 
     make coccicheck M=drivers/net/wireless/
-    
+
 To apply Coccinelle on a file basis, instead of a directory basis, the
 following command may be used:
 
@@ -134,6 +134,15 @@ MODE variable explained above.
 In this mode, there is no information about semantic patches
 displayed, and no commit message proposed.
 
+ Additional flags
+~~~~~~~~~~~~~~~~~~
+
+Additional flags can be passed to spatch through the SPFLAGS
+variable.
+
+    make SPFLAGS=--use_glimpse coccicheck
+
+See spatch --help to learn more about spatch options.
 
  Proposing new semantic patches
 ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
diff --git a/scripts/coccicheck b/scripts/coccicheck
index cdde8e0..6d492c0 100755
--- a/scripts/coccicheck
+++ b/scripts/coccicheck
@@ -11,7 +11,7 @@ else
 	VERBOSE=0
 fi
 
-FLAGS="-very_quiet"
+FLAGS="$SPFLAGS -very_quiet"
 
 # spatch only allows include directories with the syntax "-I include"
 # while gcc also allows "-Iinclude" and "-include include"
-- 
1.7.10.4

