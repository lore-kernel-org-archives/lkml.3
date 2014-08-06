Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754880AbaHFONs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Aug 2014 10:13:48 -0400
Received: from mail-pa0-f52.google.com ([209.85.220.52]:64733 "EHLO
	mail-pa0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751770AbaHFONr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Aug 2014 10:13:47 -0400
Date: Wed, 6 Aug 2014 19:43:43 +0530
From: Himangi Saraogi <himangi774@gmail.com>
To: Dave Chinner <david@fromorbit.com>, xfs@oss.sgi.com,
        linux-kernel@vger.kernel.org
Cc: Julia Lawall <julia.lawall@lip6.fr>
Subject: [PATCH] xfs: Remove typedef xfs_uu_t
Message-ID: <20140806141343.GA15659@himangi-Dell>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The Linux kernel coding style guidelines suggest not using typedefs
for structure types. This patch gets rid of the typedef for xfs_uu_t.
Also the names of the struct is changed to drop the _t, to make the
name look less typedef-like.

The following Coccinelle semantic patch detects the case.

@tn1@
type td;
@@

typedef struct { ... } td;

@script:python tf@
td << tn1.td;
tdres;
@@

coccinelle.tdres = td;

@@
type tn1.td;
identifier tf.tdres;
@@

-typedef
 struct 
+  tdres
   { ... }
-td
 ;

@@
type tn1.td;
identifier tf.tdres;
@@

(
-td
+ struct tdres
|
 const
- td
+ struct tdres
)

Signed-off-by: Himangi Saraogi <himangi774@gmail.com>
Acked-by: Julia Lawall <julia.lawall@lip6.fr>
---
 fs/xfs/uuid.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/fs/xfs/uuid.c b/fs/xfs/uuid.c
index b83f76b..1f21d8f 100644
--- a/fs/xfs/uuid.c
+++ b/fs/xfs/uuid.c
@@ -18,13 +18,13 @@
 #include <xfs.h>
 
 /* IRIX interpretation of an uuid_t */
-typedef struct {
+struct xfs_uu {
 	__be32	uu_timelow;
 	__be16	uu_timemid;
 	__be16	uu_timehi;
 	__be16	uu_clockseq;
 	__be16	uu_node[3];
-} xfs_uu_t;
+};
 
 /*
  * uuid_getnodeuniq - obtain the node unique fields of a UUID.
@@ -35,7 +35,7 @@ typedef struct {
 void
 uuid_getnodeuniq(uuid_t *uuid, int fsid [2])
 {
-	xfs_uu_t *uup = (xfs_uu_t *)uuid;
+	struct xfs_uu *uup = (struct xfs_uu *)uuid;
 
 	fsid[0] = (be16_to_cpu(uup->uu_clockseq) << 16) |
 		   be16_to_cpu(uup->uu_timemid);
-- 
1.9.1

