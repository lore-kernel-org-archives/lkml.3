Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752638Ab3CBVgv (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Mar 2013 16:36:51 -0500
Received: from mail-we0-f170.google.com ([74.125.82.170]:65323 "EHLO
	mail-we0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752461Ab3CBVgu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Mar 2013 16:36:50 -0500
From: Nicolas Palix <nicolas.palix@imag.fr>
To: Julia Lawall <Julia.Lawall@lip6.fr>, Gilles Muller <Gilles.Muller@lip6.fr>,
        Nicolas Palix <nicolas.palix@imag.fr>, cocci@systeme.lip6.fr,
        linux-kernel@vger.kernel.org, Michal Marek <mmarek@suse.cz>
Subject: [PATCH 1/4] Coccinelle: Restore coccicheck verbosity in ONLINE mode (C=1 or C=2)
Date: Sat,  2 Mar 2013 22:36:25 +0100
Message-Id: <1362260188-14138-1-git-send-email-nicolas.palix@imag.fr>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

A recent patch have introduce the VERBOSE variable and comments
now depend on it. However, the message printed for each cocci file
such not be printed when the ONLINE mode is active, whatever is
the value of VERBOSE.

Signed-off-by: Nicolas Palix <nicolas.palix@imag.fr>
---
 scripts/coccicheck |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/scripts/coccicheck b/scripts/coccicheck
index 85d3189..7f0d6a6 100755
--- a/scripts/coccicheck
+++ b/scripts/coccicheck
@@ -72,7 +72,7 @@ coccinelle () {
 #
 #    $SPATCH -D $MODE $FLAGS -parse_cocci $COCCI $OPT > /dev/null
 
-    if [ $VERBOSE -ne 0 ] ; then
+    if [ $VERBOSE -ne 0 -a $ONLINE -eq 0 ] ; then
 
 	FILE=`echo $COCCI | sed "s|$srctree/||"`
 
-- 
1.7.10.4

