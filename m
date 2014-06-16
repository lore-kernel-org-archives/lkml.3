Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756004AbaFPULO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jun 2014 16:11:14 -0400
Received: from mail-pa0-f41.google.com ([209.85.220.41]:47874 "EHLO
	mail-pa0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755912AbaFPULM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jun 2014 16:11:12 -0400
Date: Tue, 17 Jun 2014 01:41:05 +0530
From: Himangi Saraogi <himangi774@gmail.com>
To: Paul Moore <paul@paul-moore.com>, Stephen Smalley <sds@tycho.nsa.gov>,
        Eric Paris <eparis@parisplace.org>,
        James Morris <james.l.morris@oracle.com>, selinux@tycho.nsa.gov,
        linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: julia.lawall@lip6.fr
Subject: [PATCH] SELinux: use ARRAY_SIZE
Message-ID: <20140616201104.GA18288@himangi-Dell>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

ARRAY_SIZE is more concise to use when the size of an array is divided
by the size of its type or the size of its first element.

The Coccinelle semantic patch that makes this change is as follows:

// <smpl>
@@
type T;
T[] E;
@@

- (sizeof(E)/sizeof(E[...]))
+ ARRAY_SIZE(E)
// </smpl>

Signed-off-by: Himangi Saraogi <himangi774@gmail.com>
---
 security/selinux/ss/policydb.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/security/selinux/ss/policydb.c b/security/selinux/ss/policydb.c
index 9c5cdc2..56eb65f 100644
--- a/security/selinux/ss/policydb.c
+++ b/security/selinux/ss/policydb.c
@@ -2608,7 +2608,7 @@ static int mls_write_range_helper(struct mls_range *r, void *fp)
 	if (!eq)
 		buf[2] = cpu_to_le32(r->level[1].sens);
 
-	BUG_ON(items > (sizeof(buf)/sizeof(buf[0])));
+	BUG_ON(items > ARRAY_SIZE(buf));
 
 	rc = put_entry(buf, sizeof(u32), items, fp);
 	if (rc)
@@ -2990,7 +2990,7 @@ static int role_write(void *vkey, void *datum, void *ptr)
 	if (p->policyvers >= POLICYDB_VERSION_BOUNDARY)
 		buf[items++] = cpu_to_le32(role->bounds);
 
-	BUG_ON(items > (sizeof(buf)/sizeof(buf[0])));
+	BUG_ON(items > ARRAY_SIZE(buf));
 
 	rc = put_entry(buf, sizeof(u32), items, fp);
 	if (rc)
@@ -3040,7 +3040,7 @@ static int type_write(void *vkey, void *datum, void *ptr)
 	} else {
 		buf[items++] = cpu_to_le32(typdatum->primary);
 	}
-	BUG_ON(items > (sizeof(buf) / sizeof(buf[0])));
+	BUG_ON(items > ARRAY_SIZE(buf));
 	rc = put_entry(buf, sizeof(u32), items, fp);
 	if (rc)
 		return rc;
@@ -3069,7 +3069,7 @@ static int user_write(void *vkey, void *datum, void *ptr)
 	buf[items++] = cpu_to_le32(usrdatum->value);
 	if (p->policyvers >= POLICYDB_VERSION_BOUNDARY)
 		buf[items++] = cpu_to_le32(usrdatum->bounds);
-	BUG_ON(items > (sizeof(buf) / sizeof(buf[0])));
+	BUG_ON(items > ARRAY_SIZE(buf));
 	rc = put_entry(buf, sizeof(u32), items, fp);
 	if (rc)
 		return rc;
-- 
1.9.1

