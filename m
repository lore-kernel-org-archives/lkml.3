Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757964AbaFZSBq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jun 2014 14:01:46 -0400
Received: from mail-pa0-f48.google.com ([209.85.220.48]:37547 "EHLO
	mail-pa0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757879AbaFZSBp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jun 2014 14:01:45 -0400
From: Pranith Kumar <bobby.prani@gmail.com>
To: trivial@kernel.org, jkosina@suse.cz, Randy Dunlap <rdunlap@infradead.org>,
        linux-doc@vger.kernel.org (open list:DOCUMENTATION),
        linux-kernel@vger.kernel.org (open list)
Subject: [PATCH 1/1] doc: atomic-ops.txt: correct return value info about atomic_add_unless
Date: Thu, 26 Jun 2014 11:00:49 -0700
Message-Id: <1403805649-9830-1-git-send-email-bobby.prani@gmail.com>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Pranith Kumar <bobby.prani@gmail.com>
---
 Documentation/atomic_ops.txt | 9 +++------
 1 file changed, 3 insertions(+), 6 deletions(-)

diff --git a/Documentation/atomic_ops.txt b/Documentation/atomic_ops.txt
index 68542fe..d3ad657 100644
--- a/Documentation/atomic_ops.txt
+++ b/Documentation/atomic_ops.txt
@@ -271,16 +271,13 @@ Finally:
 
 	int atomic_add_unless(atomic_t *v, int a, int u);
 
-If the atomic value v is not equal to u, this function adds a to v, and
-returns non zero. If v is equal to u then it returns zero. This is done as
-an atomic operation.
+If the atomic value v is not equal to u, this function adds a to v.
+It returns the old value of v. It is done as an atomic operation.
 
-atomic_add_unless requires explicit memory barriers around the operation
-unless it fails (returns 0).
+atomic_add_unless requires explicit memory barriers around the operation.
 
 atomic_inc_not_zero, equivalent to atomic_add_unless(v, 1, 0)
 
-
 If a caller requires memory barrier semantics around an atomic_t
 operation which does not return a value, a set of interfaces are
 defined which accomplish this:
-- 
1.9.1

