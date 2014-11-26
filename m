Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752806AbaKZObS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Nov 2014 09:31:18 -0500
Received: from mailout2.w1.samsung.com ([210.118.77.12]:45159 "EHLO
	mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752595AbaKZObP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Nov 2014 09:31:15 -0500
X-AuditID: cbfec7f5-b7fc86d0000066b7-a3-5475e4315252
From: Lukasz Pawelczyk <l.pawelczyk@samsung.com>
To: Casey Schaufler <casey@schaufler-ca.com>,
        James Morris <james.l.morris@oracle.com>,
        "Serge E. Hallyn" <serge@hallyn.com>,
        linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Lukasz Pawelczyk <havner@gmail.com>,
        Lukasz Pawelczyk <l.pawelczyk@samsung.com>
Subject: [PATCH 1/2] smack: miscellaneous small fixes in function comments
Date: Wed, 26 Nov 2014 15:31:06 +0100
Message-id: <1417012267-21298-1-git-send-email-l.pawelczyk@samsung.com>
X-Mailer: git-send-email 1.9.3
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrAJMWRmVeSWpSXmKPExsVy+t/xq7qGT0pDDLbv47W4t+0Xm8X/1zoW
	fY+DLM5MWshkcXnXHDaLDz2P2CzOXzjH7sDusXPWXXaPa7sjPT4+vcXi0bdlFaPH0f2L2Dw+
	b5ILYIvisklJzcksSy3St0vgyphw7xFzwRa+ig+9f5kbGBdxdzFyckgImEisfHuUCcIWk7hw
	bz0biC0ksJRRYtF3iS5GLiC7l0li1ZFPrCAJNgEDie8X9jKDJEQEjjNK9D3byQiSYBYIlbg2
	YzoziC0s4CWx78MqsKksAqoSL5e1gdm8Au4SOzZ+YYHYJifRu+0N8wRG7gWMDKsYRVNLkwuK
	k9JzjfSKE3OLS/PS9ZLzczcxQkLl6w7GpcesDjEKcDAq8fDeiCsJEWJNLCuuzD3EKMHBrCTC
	m3qnNESINyWxsiq1KD++qDQntfgQIxMHp1QDY89ia681biulJnXo2Hx/vUr0ZDDPnTUf1C/z
	PH0klC+jd9ffSOEfW/q71xOlitI7Z35yrpdzFVDr99MQOtL4546bfF5F7cPsrc33HILWvZTK
	XaLWV8sX9/tZ/99ojUrnFaVpn5u7nuZLOb1rLjkz88ahrddqv2eFHxU5LLFPau/To3oSUhGn
	lViKMxINtZiLihMB9a1Nd/MBAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Lukasz Pawelczyk <l.pawelczyk@samsung.com>
---
 security/smack/smack_lsm.c | 14 +++++++++-----
 1 file changed, 9 insertions(+), 5 deletions(-)

diff --git a/security/smack/smack_lsm.c b/security/smack/smack_lsm.c
index 2717cdd..d1b14d5 100644
--- a/security/smack/smack_lsm.c
+++ b/security/smack/smack_lsm.c
@@ -202,6 +202,7 @@ static int smk_bu_credfile(const struct cred *cred, struct file *file,
 
 /**
  * smk_fetch - Fetch the smack label from a file.
+ * @name: type of the label (attribute)
  * @ip: a pointer to the inode
  * @dp: a pointer to the dentry
  *
@@ -254,7 +255,9 @@ struct inode_smack *new_inode_smack(struct smack_known *skp)
 
 /**
  * new_task_smack - allocate a task security blob
- * @smack: a pointer to the Smack label to use in the blob
+ * @task: a pointer to the Smack label for the running task
+ * @forked: a pointer to the Smack label for the forked task
+ * @gfp: type of the memory for the allocation
  *
  * Returns the new blob or NULL if there's no memory available
  */
@@ -277,8 +280,9 @@ static struct task_smack *new_task_smack(struct smack_known *task,
 
 /**
  * smk_copy_rules - copy a rule set
- * @nhead - new rules header pointer
- * @ohead - old rules header pointer
+ * @nhead: new rules header pointer
+ * @ohead: old rules header pointer
+ * @gfp: type of the memory for the allocation
  *
  * Returns 0 on success, -ENOMEM on error
  */
@@ -3835,11 +3839,11 @@ static void smack_key_free(struct key *key)
 	key->security = NULL;
 }
 
-/*
+/**
  * smack_key_permission - Smack access on a key
  * @key_ref: gets to the object
  * @cred: the credentials to use
- * @perm: unused
+ * @perm: requested key permissions
  *
  * Return 0 if the task has read and write to the object,
  * an error code otherwise
-- 
1.9.3

