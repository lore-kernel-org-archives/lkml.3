Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755686AbaIPUzz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Sep 2014 16:55:55 -0400
Received: from mail-lb0-f173.google.com ([209.85.217.173]:42985 "EHLO
	mail-lb0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755370AbaIPUwO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Sep 2014 16:52:14 -0400
From: Rasmus Villemoes <linux@rasmusvillemoes.dk>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Rasmus Villemoes <linux@rasmusvillemoes.dk>,
        Roland Dreier <roland@kernel.org>,
        Nicholas Bellinger <nab@linux-iscsi.org>, linux-rdma@vger.kernel.org
Subject: [PATCH 14/22] ib_srpt: Replace strnicmp with strncasecmp
Date: Tue, 16 Sep 2014 22:51:28 +0200
Message-Id: <1410900696-6481-15-git-send-email-linux@rasmusvillemoes.dk>
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

Cc: Roland Dreier <roland@kernel.org>
Cc: Nicholas Bellinger <nab@linux-iscsi.org>
Cc: linux-rdma@vger.kernel.org
Signed-off-by: Rasmus Villemoes <linux@rasmusvillemoes.dk>
---
 drivers/infiniband/ulp/srpt/ib_srpt.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/infiniband/ulp/srpt/ib_srpt.c b/drivers/infiniband/ulp/srpt/ib_srpt.c
index d28a8c2..7206547 100644
--- a/drivers/infiniband/ulp/srpt/ib_srpt.c
+++ b/drivers/infiniband/ulp/srpt/ib_srpt.c
@@ -3574,7 +3574,7 @@ static int srpt_parse_i_port_id(u8 i_port_id[16], const char *name)
 	int ret, rc;
 
 	p = name;
-	if (strnicmp(p, "0x", 2) == 0)
+	if (strncasecmp(p, "0x", 2) == 0)
 		p += 2;
 	ret = -EINVAL;
 	len = strlen(p);
-- 
2.0.4

