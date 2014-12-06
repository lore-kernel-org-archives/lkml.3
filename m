Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752351AbaLFAA6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Dec 2014 19:00:58 -0500
Received: from mail-lb0-f181.google.com ([209.85.217.181]:55311 "EHLO
	mail-lb0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751183AbaLFAA5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Dec 2014 19:00:57 -0500
From: Rasmus Villemoes <linux@rasmusvillemoes.dk>
To: David Howells <dhowells@redhat.com>, Rusty Russell <rusty@rustcorp.com.au>
Cc: Rasmus Villemoes <linux@rasmusvillemoes.dk>, linux-kernel@vger.kernel.org
Subject: [PATCH 1/2] MPILIB: Fix comparison of negative MPIs
Date: Sat,  6 Dec 2014 01:00:41 +0100
Message-Id: <1417824042-539-1-git-send-email-linux@rasmusvillemoes.dk>
X-Mailer: git-send-email 2.1.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If u and v both represent negative integers and their limb counts
happen to differ, mpi_cmp will always return a positive value - this
is obviously bogus. u is smaller than v if and only if it is larger in
absolute value.

Signed-off-by: Rasmus Villemoes <linux@rasmusvillemoes.dk>
---
 lib/mpi/mpi-cmp.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/lib/mpi/mpi-cmp.c b/lib/mpi/mpi-cmp.c
index 1871e7b61ca0..3801694240d8 100644
--- a/lib/mpi/mpi-cmp.c
+++ b/lib/mpi/mpi-cmp.c
@@ -57,7 +57,7 @@ int mpi_cmp(MPI u, MPI v)
 	if (usize != vsize && !u->sign && !v->sign)
 		return usize - vsize;
 	if (usize != vsize && u->sign && v->sign)
-		return vsize + usize;
+		return vsize - usize;
 	if (!usize)
 		return 0;
 	cmp = mpihelp_cmp(u->d, v->d, usize);
-- 
2.1.3

