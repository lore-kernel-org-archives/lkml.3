Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932262AbbAILLO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Jan 2015 06:11:14 -0500
Received: from mail-lb0-f179.google.com ([209.85.217.179]:53813 "EHLO
	mail-lb0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754100AbbAILLM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Jan 2015 06:11:12 -0500
From: Rasmus Villemoes <linux@rasmusvillemoes.dk>
To: David Howells <dhowells@redhat.com>
Cc: Rusty Russell <rusty@rustcorp.com.au>, d.kasatkin@samsung.com,
        keyrings@linux-nfs.org, Rasmus Villemoes <linux@rasmusvillemoes.dk>,
        linux-kernel@vger.kernel.org
Subject: [PATCH] MPILIB: Fix obvious but harmless typo
Date: Fri,  9 Jan 2015 12:10:41 +0100
Message-Id: <1420801841-6721-1-git-send-email-linux@rasmusvillemoes.dk>
X-Mailer: git-send-email 2.1.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The macro MPN_COPY_INCR this occurs in isn't used anywhere.

Signed-off-by: Rasmus Villemoes <linux@rasmusvillemoes.dk>
---
Another small thing I stumbled on.

 lib/mpi/mpi-internal.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/lib/mpi/mpi-internal.h b/lib/mpi/mpi-internal.h
index 60cf765628e9..c65dd1bff45a 100644
--- a/lib/mpi/mpi-internal.h
+++ b/lib/mpi/mpi-internal.h
@@ -84,7 +84,7 @@ static inline int RESIZE_IF_NEEDED(MPI a, unsigned b)
 	do {					\
 		mpi_size_t _i;			\
 		for (_i = 0; _i < (n); _i++)	\
-			(d)[_i] = (d)[_i];	\
+			(d)[_i] = (s)[_i];	\
 	} while (0)
 
 #define MPN_COPY_DECR(d, s, n) \
-- 
2.1.3

