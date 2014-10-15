Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751201AbaJOFjZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Oct 2014 01:39:25 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:58711 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750737AbaJOFjW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Oct 2014 01:39:22 -0400
X-AuditID: cbfee68e-f79b46d000002b74-d3-543e088893d3
From: Rohit Kumar <rohit.kr@samsung.com>
To: akpm@linux-foundation.org, casey@schaufler-ca.com,
        james.l.morris@oracle.com, serge@hallyn.com,
        linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: cpgs@samsung.com, pintu.k@samsung.com, rohit.kr@samsung.com,
        vishnu.ps@samsung.com, iqbal.ams@samsung.com, ed.savinay@samsung.com
Subject: [PATCH 1/1] Security : smack : Use kmem_cache for allocation and
 freeing of inode_smack
Date: Wed, 15 Oct 2014 11:26:16 +0530
Message-id: <1413352576-30356-1-git-send-email-rohit.kr@samsung.com>
X-Mailer: git-send-email 1.7.9.5
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrALMWRmVeSWpSXmKPExsWyRsSkRreDwy7EYM4ZKYs569ewWdzb9ovN
	4uUhTYtFuxcwWcz+NYnJou9xkMXlXXPYLD70PGKz6Pt+mN3ieXMri8X5C+fYLab03WV04PG4
	tjvS48SM3yweH5/eYvHo27KK0ePo/kVsHp83yQWwRXHZpKTmZJalFunbJXBlPFv9lK1ggkDF
	6fkv2BsYb/J0MXJySAiYSOz5O4sZwhaTuHBvPVsXIxeHkMBSRom5L+4xwhRNed3GCJFYxCjx
	b+5VJginl0mi4dtsJpAqNgENiV2vV4IlRARWM0p8fPufHcRhFmhnlHjz7C3YEmGBJInuj30s
	IDaLgKrE9V/72UBsXgEXieP33gF1cwDtU5CYM8kGpFdCYB27xNbOI+wQ9QIS3yYfYoGokZXY
	dADqbkmJgytusExgFFzAyLCKUTS1ILmgOCm9yEivODG3uDQvXS85P3cTIzDgT/971reD8eYB
	60OMAhyMSjy8HAdsQ4RYE8uKK3MPMZoCbZjILCWanA+Mq7ySeENjMyMLUxNTYyNzSzMlcd4E
	qZ/BQgLpiSWp2ampBalF8UWlOanFhxiZODilGhgXFsR6rLfdwNDxnCXEYPqH18/Obnj/sHrR
	giZV9dtH9dMu2F593tgsvWvqjHutX59dMEgSenlcwOvq7t7vvIpNaZW7uN++6ShJ3tWUsHRe
	gfjF0+0aa+Te7Lwuz1ty7OhOZ9Ve/53KgW43nKT0Nq2bWm4x2W/7g5Ulq9IjTweYS++2j6+2
	ehWtxFKckWioxVxUnAgAGgwggXMCAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrFIsWRmVeSWpSXmKPExsVy+t9jAd0ODrsQg8Xv+CzmrF/DZnFv2y82
	i5eHNC0W7V7AZDH71yQmi77HQRaXd81hs/jQ84jNou/7YXaL582tLBbnL5xjt5jSd5fRgcfj
	2u5IjxMzfrN4fHx6i8Wjb8sqRo+j+xexeXzeJBfAFtXAaJORmpiSWqSQmpecn5KZl26r5B0c
	7xxvamZgqGtoaWGupJCXmJtqq+TiE6DrlpkDdKKSQlliTilQKCCxuFhJ3w7ThNAQN10LmMYI
	Xd+QILgeIwM0kLCGMePZ6qdsBRMEKk7Pf8HewHiTp4uRk0NCwERiyus2RghbTOLCvfVsXYxc
	HEICixgl/s29ygTh9DJJNHybzQRSxSagIbHr9UqwhIjAakaJj2//s4M4zALtjBJvnr1lBqkS
	FkiS6P7YxwJiswioSlz/tZ8NxOYVcJE4fu8dUDcH0D4FiTmTbCYwci9gZFjFKJpakFxQnJSe
	a6RXnJhbXJqXrpecn7uJERxPz6R3MK5qsDjEKMDBqMTDy3HANkSINbGsuDL3EKMEB7OSCG/a
	UaAQb0piZVVqUX58UWlOavEhRlOg5ROZpUST84GxnlcSb2hsYm5qbGppYmFiZqkkznuw1TpQ
	SCA9sSQ1OzW1ILUIpo+Jg1OqgdEy6IDBrhenEsu+2JQv+6aqsbVJo6wikYXh7LqIfVIC7332
	C97kXDiRoeNJwtTdNzqiFx3aojw3942x+BnrCH7J1V2tHo83fVpxoTrb60xMzabysILA5ecF
	MlZ4//2ypXTO7Edum3VbW4umWHKccD2w/3mz8o8nb18nx/xLFJjetMzgfemCO6uVWIozEg21
	mIuKEwFlWynxvQIAAA==
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rohit <rohit.kr@samsung.com>

Use kmem_cache to allocate/free inode_smack since they are
alloced in high volumes making it a perfect case for kmem_cache.

Accounting of memory allocation is below :
 total           slack            net      count-alloc/free        caller
Before (with kzalloc)
1919872           719952          1919872      29998/0          new_inode_smack+0x14
After (with kmem_cache)
1201680                0          1201680      30042/0          new_inode_smack+0x18

Signed-off-by: Rohit <rohit.kr@samsung.com>
---
 security/smack/smack_lsm.c |   13 ++++++++++---
 1 file changed, 10 insertions(+), 3 deletions(-)

diff --git a/security/smack/smack_lsm.c b/security/smack/smack_lsm.c
index d515ec2..58a5c92 100644
--- a/security/smack/smack_lsm.c
+++ b/security/smack/smack_lsm.c
@@ -53,6 +53,7 @@
 #define SMK_SENDING	2
 
 LIST_HEAD(smk_ipv6_port_list);
+struct kmem_cache *smack_inode_cache;
 
 #ifdef CONFIG_SECURITY_SMACK_BRINGUP
 static void smk_bu_mode(int mode, char *s)
@@ -240,7 +241,7 @@ struct inode_smack *new_inode_smack(struct smack_known *skp)
 {
 	struct inode_smack *isp;
 
-	isp = kzalloc(sizeof(struct inode_smack), GFP_NOFS);
+	isp = kmem_cache_zalloc(smack_inode_cache, GFP_NOFS);
 	if (isp == NULL)
 		return NULL;
 
@@ -767,7 +768,7 @@ static int smack_inode_alloc_security(struct inode *inode)
  */
 static void smack_inode_free_security(struct inode *inode)
 {
-	kfree(inode->i_security);
+	kmem_cache_free(smack_inode_cache, inode->i_security);
 	inode->i_security = NULL;
 }
 
@@ -4264,10 +4265,16 @@ static __init int smack_init(void)
 	if (!security_module_enable(&smack_ops))
 		return 0;
 
+	smack_inode_cache = KMEM_CACHE(inode_smack, 0);
+	if (!smack_inode_cache)
+		return -ENOMEM;
+
 	tsp = new_task_smack(&smack_known_floor, &smack_known_floor,
 				GFP_KERNEL);
-	if (tsp == NULL)
+	if (tsp == NULL) {
+		kmem_cache_destroy(smack_inode_cache);
 		return -ENOMEM;
+	}
 
 	printk(KERN_INFO "Smack:  Initializing.\n");
 
-- 
1.7.9.5

