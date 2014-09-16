Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755551AbaIPUx2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Sep 2014 16:53:28 -0400
Received: from mail-la0-f45.google.com ([209.85.215.45]:50433 "EHLO
	mail-la0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755459AbaIPUwX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Sep 2014 16:52:23 -0400
From: Rasmus Villemoes <linux@rasmusvillemoes.dk>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Rasmus Villemoes <linux@rasmusvillemoes.dk>,
        Jason Wessel <jason.wessel@windriver.com>,
        kgdb-bugreport@lists.sourceforge.net
Subject: [PATCH 22/22] kdb: Replace strnicmp with strncasecmp
Date: Tue, 16 Sep 2014 22:51:36 +0200
Message-Id: <1410900696-6481-23-git-send-email-linux@rasmusvillemoes.dk>
X-Mailer: git-send-email 2.0.4
In-Reply-To: <1410900696-6481-1-git-send-email-linux@rasmusvillemoes.dk>
References: <1410900696-6481-1-git-send-email-linux@rasmusvillemoes.dk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The kernel used to contain two functions for length-delimited,
case-insensitive string comparison, strnicmp with correct semantics
and a slightly buggy strncasecmp. The latter is the POSIX name, so
strnicmp was renamed to strncasecmp, and strnicmp made into a wrapper
for the new strncasecmp to avoid breaking existing users.

To allow the compat wrapper strnicmp to be removed at some point in
the future, and to avoid the extra indirection cost, do
s/strnicmp/strncasecmp/g.

Cc: Jason Wessel <jason.wessel@windriver.com>
Cc: kgdb-bugreport@lists.sourceforge.net
Signed-off-by: Rasmus Villemoes <linux@rasmusvillemoes.dk>
---
 kernel/debug/kdb/kdb_bp.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/kernel/debug/kdb/kdb_bp.c b/kernel/debug/kdb/kdb_bp.c
index 70a5046..b20d544 100644
--- a/kernel/debug/kdb/kdb_bp.c
+++ b/kernel/debug/kdb/kdb_bp.c
@@ -52,11 +52,11 @@ static int kdb_parsebp(int argc, const char **argv, int *nextargp, kdb_bp_t *bp)
 
 	bp->bph_length = 1;
 	if ((argc + 1) != nextarg) {
-		if (strnicmp(argv[nextarg], "datar", sizeof("datar")) == 0)
+		if (strncasecmp(argv[nextarg], "datar", sizeof("datar")) == 0)
 			bp->bp_type = BP_ACCESS_WATCHPOINT;
-		else if (strnicmp(argv[nextarg], "dataw", sizeof("dataw")) == 0)
+		else if (strncasecmp(argv[nextarg], "dataw", sizeof("dataw")) == 0)
 			bp->bp_type = BP_WRITE_WATCHPOINT;
-		else if (strnicmp(argv[nextarg], "inst", sizeof("inst")) == 0)
+		else if (strncasecmp(argv[nextarg], "inst", sizeof("inst")) == 0)
 			bp->bp_type = BP_HARDWARE_BREAKPOINT;
 		else
 			return KDB_ARGCOUNT;
-- 
2.0.4

