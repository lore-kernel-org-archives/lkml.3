Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752406AbaJOL60 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Oct 2014 07:58:26 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:21784 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751732AbaJOL6X (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Oct 2014 07:58:23 -0400
X-AuditID: cbfee68e-f79b46d000002b74-a1-543e615c26d7
From: Rohit <rohit.kr@samsung.com>
To: akpm@linux-foundation.org, casey@schaufler-ca.com,
        james.l.morris@oracle.com, serge@hallyn.com,
        linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: cpgs@samsung.com, pintu.k@samsung.com, rohit.kr@samsung.com,
        vishnu.ps@samsung.com, iqbal.ams@samsung.com, ed.savinay@samsung.com
Subject: [PATCH v2] Security: smack: replace kzalloc with kmem_cache for
 inode_smack
Date: Wed, 15 Oct 2014 17:40:41 +0530
Message-id: <1413375041-29741-1-git-send-email-rohit.kr@samsung.com>
X-Mailer: git-send-email 1.7.9.5
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrALMWRmVeSWpSXmKPExsWyRsSkRjc20S7E4OxKVos569ewWdzb9ovN
	4uUhTYtFuxcwWcz+NYnJou9xkMXlXXPYLD70PGKz6Pt+mN3ieXMri8X5C+fYLab03WV04PG4
	tjvS48SM3yweH5/eYvHo27KK0ePo/kVsHp83yQWwRXHZpKTmZJalFunbJXBlrDo/nangpVDF
	kb2/2BsY//F1MXJySAiYSHSe62CGsMUkLtxbz9bFyMUhJLCUUWLS6gWMMEVHn35ih0hMZ5Ro
	/LiLFcLpZZJYdv0hWBWbgJLE/1dzwdpFBFYzSnx8+x+shVmgnVHizbO3YEuEBcIkFu08ANbB
	IqAqsbR5PxOIzSvgIrHlyy0gmwNon4LEnEk2IL0SAuvYJfaveMAKUS8g8W3yIRaIGlmJTQeg
	7paUOLjiBssERsEFjAyrGEVTC5ILipPSi4z0ihNzi0vz0vWS83M3MQID/vS/Z307GG8esD7E
	KMDBqMTDy3HANkSINbGsuDL3EKMp0IaJzFKiyfnAuMoriTc0NjOyMDUxNTYytzRTEudNkPoZ
	LCSQnliSmp2aWpBaFF9UmpNafIiRiYNTqoFR+XTvoZXRxw5fjjh+9LrzPm9r4fmOTbs6G9+V
	CfjZzxOs2hHxqL7b6azTHqH5kgq65kJaZseqmp0n7mzjFel2TOie++5Gn+CLXOEPi3OeerFU
	zY71+VC9uvHeTNHdDTW9/VUSClcnz67SMuvV5LpgOzN8l5Nd7bms+rc7NXPmF0sWVOjbLlJi
	Kc5INNRiLipOBABc4BIucwIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrFIsWRmVeSWpSXmKPExsVy+t9jQd2YRLsQg6s7LCzmrF/DZnFv2y82
	i5eHNC0W7V7AZDH71yQmi77HQRaXd81hs/jQ84jNou/7YXaL582tLBbnL5xjt5jSd5fRgcfj
	2u5IjxMzfrN4fHx6i8Wjb8sqRo+j+xexeXzeJBfAFtXAaJORmpiSWqSQmpecn5KZl26r5B0c
	7xxvamZgqGtoaWGupJCXmJtqq+TiE6DrlpkDdKKSQlliTilQKCCxuFhJ3w7ThNAQN10LmMYI
	Xd+QILgeIwM0kLCGMWPV+elMBS+FKo7s/cXewPiPr4uRk0NCwETi6NNP7BC2mMSFe+vZuhi5
	OIQEpjNKNH7cxQrh9DJJLLv+kBGkik1ASeL/q7lgVSICqxklPr79zw7iMAu0M0q8efaWGaRK
	WCBMYtHOA2AdLAKqEkub9zOB2LwCLhJbvtwCsjmA9ilIzJlkM4GRewEjwypG0dSC5ILipPRc
	I73ixNzi0rx0veT83E2M4Hh6Jr2DcVWDxSFGAQ5GJR5ejgO2IUKsiWXFlbmHGCU4mJVEeG3C
	7UKEeFMSK6tSi/Lji0pzUosPMZoCLZ/ILCWanA+M9bySeENjE3NTY1NLEwsTM0slcd6DrdaB
	QgLpiSWp2ampBalFMH1MHJxSDYwctXcKXL97XjZ/9cJg44ra8lvvth5PEHF9fssn1uNZy+2e
	zBtf8u56y4hOZfaL6+s6N8Oy5M/X3NeZFnK/t6svKuTPKov7/WCWG/ep9xMfvV4yN9PG/cS1
	VQtPVaZdNDj9Q9ziQI90tMOT2zO6PJasOjTtqNQK1qudujrdaxpcvp1b8uvHvQVOSizFGYmG
	WsxFxYkAumuUQ70CAAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The patch use kmem_cache to allocate/free inode_smack since they are
alloced in high volumes making it a perfect case for kmem_cache.

As per analysis, 24 bytes of memory is wasted per allocation due
to internal fragmentation. With kmem_cache, this can be avoided.

Accounting of memory allocation is below :
 total       slack            net      count-alloc/free        caller
Before (with kzalloc)
1919872      719952          1919872      29998/0          new_inode_smack+0x14

After (with kmem_cache)
1201680          0           1201680      30042/0          new_inode_smack+0x18

>From above data, we found that 719952 bytes(~700 KB) of memory is
saved on allocation of 29998 smack inodes.

Signed-off-by: Rohit <rohit.kr@samsung.com>
---
Added static in kmem_cache object declaration noted by Andrew Morton <akpm@
linux-foundation.org> . Also updated commit message.
 security/smack/smack_lsm.c |   13 ++++++++++---
 1 file changed, 10 insertions(+), 3 deletions(-)

diff --git a/security/smack/smack_lsm.c b/security/smack/smack_lsm.c
index d515ec2..15d985c 100644
--- a/security/smack/smack_lsm.c
+++ b/security/smack/smack_lsm.c
@@ -53,6 +53,7 @@
 #define SMK_SENDING	2
 
 LIST_HEAD(smk_ipv6_port_list);
+static struct kmem_cache *smack_inode_cache;
 
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

