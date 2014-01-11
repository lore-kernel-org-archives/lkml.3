Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753231AbaAKUCA (ORCPT <rfc822;w@1wt.eu>);
	Sat, 11 Jan 2014 15:02:00 -0500
Received: from mail-pa0-f46.google.com ([209.85.220.46]:56102 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751072AbaAKUB5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 11 Jan 2014 15:01:57 -0500
From: Monam Agarwal <monamagarwal123@gmail.com>
To: gregkh@linuxfoundation.org, bergwolf@gmail.com, andreas.dilger@intel.com,
        keith.mannthey@intel.com, oleg.drokin@intel.com,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: [PATCH v2 1/3] Staging: lustre: Fix return does not need parantheses
Date: Sun, 12 Jan 2014 01:31:41 +0530
Message-Id: <1389470502-26243-1-git-send-email-monamagarwal123@gmail.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The patch fixes the following checkpatch.pl error in
lustre/ldlm/ldlm_flock.c
ERROR: return is not a function, parentheses are not required 

Signed-off-by: Monam Agarwal <monamagarwal123@gmail.com>
---
 drivers/staging/lustre/lustre/ldlm/ldlm_flock.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/staging/lustre/lustre/ldlm/ldlm_flock.c b/drivers/staging/lustre/lustre/ldlm/ldlm_flock.c
index c9aae13..07a2c33 100644
--- a/drivers/staging/lustre/lustre/ldlm/ldlm_flock.c
+++ b/drivers/staging/lustre/lustre/ldlm/ldlm_flock.c
@@ -81,18 +81,18 @@ int ldlm_flock_blocking_ast(struct ldlm_lock *lock, struct ldlm_lock_desc *desc,
 static inline int
 ldlm_same_flock_owner(struct ldlm_lock *lock, struct ldlm_lock *new)
 {
-	return((new->l_policy_data.l_flock.owner ==
+	return (new->l_policy_data.l_flock.owner ==
 		lock->l_policy_data.l_flock.owner) &&
-	       (new->l_export == lock->l_export));
+	       (new->l_export == lock->l_export);
 }

 static inline int
 ldlm_flocks_overlap(struct ldlm_lock *lock, struct ldlm_lock *new)
 {
-	return((new->l_policy_data.l_flock.start <=
+	return (new->l_policy_data.l_flock.start <=
 		lock->l_policy_data.l_flock.end) &&
 	       (new->l_policy_data.l_flock.end >=
-		lock->l_policy_data.l_flock.start));
+		lock->l_policy_data.l_flock.start);
 }

 static inline void ldlm_flock_blocking_link(struct ldlm_lock *req,
-- 
1.7.9.5

