Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752883Ab3CBVg5 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Mar 2013 16:36:57 -0500
Received: from mail-wg0-f52.google.com ([74.125.82.52]:42861 "EHLO
	mail-wg0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752791Ab3CBVgz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Mar 2013 16:36:55 -0500
From: Nicolas Palix <nicolas.palix@imag.fr>
To: Julia Lawall <Julia.Lawall@lip6.fr>, Gilles Muller <Gilles.Muller@lip6.fr>,
        Nicolas Palix <nicolas.palix@imag.fr>, cocci@systeme.lip6.fr,
        linux-kernel@vger.kernel.org, Michal Marek <mmarek@suse.cz>
Subject: [PATCH 4/4] Coccinelle: Fix patch output when coccicheck is used with M= and C=
Date: Sat,  2 Mar 2013 22:36:28 +0100
Message-Id: <1362260188-14138-4-git-send-email-nicolas.palix@imag.fr>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1362260188-14138-1-git-send-email-nicolas.palix@imag.fr>
References: <1362260188-14138-1-git-send-email-nicolas.palix@imag.fr>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When the M variable is used, the -patch option should be given
to spatch. This patch fixes the case where C is used.

Signed-off-by: Nicolas Palix <nicolas.palix@imag.fr>
---
 scripts/coccicheck |    6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/scripts/coccicheck b/scripts/coccicheck
index 6d492c0..06fcb33 100755
--- a/scripts/coccicheck
+++ b/scripts/coccicheck
@@ -29,10 +29,14 @@ else
     if [ "$KBUILD_EXTMOD" = "" ] ; then
         OPTIONS="-dir $srctree $COCCIINCLUDE"
     else
-        OPTIONS="-dir $KBUILD_EXTMOD -patch $srctree $COCCIINCLUDE"
+        OPTIONS="-dir $KBUILD_EXTMOD $COCCIINCLUDE"
     fi
 fi
 
+if [ "$KBUILD_EXTMOD" != "" ] ; then
+    OPTIONS="-patch $srctree $OPTIONS"
+fi
+
 if [ ! -x "$SPATCH" ]; then
     echo 'spatch is part of the Coccinelle project and is available at http://coccinelle.lip6.fr/'
     exit 1
-- 
1.7.10.4

