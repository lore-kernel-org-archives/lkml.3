Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756381Ab3JJPpe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Oct 2013 11:45:34 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:52696 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755878Ab3JJPpb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Oct 2013 11:45:31 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: "Passion,Zhao" <passion.zhao@intel.com>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 053/104] Smack: Fix the bug smackcipso can't set CIPSO correctly
Date: Thu, 10 Oct 2013 08:41:41 -0700
Message-Id: <1381419752-29733-54-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1381419752-29733-1-git-send-email-kamal@canonical.com>
References: <1381419752-29733-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8.13.11 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: "Passion,Zhao" <passion.zhao@intel.com>

commit 0fcfee61d63b82c1eefb5b1a914240480f17d63f upstream.

Bug report: https://tizendev.org/bugs/browse/TDIS-3891

The reason is userspace libsmack only use "smackfs/cipso2" long-label interface,
but the code's logical is still for orginal fixed length label. Now update
smack_cipso_apply() to support flexible label (<=256 including tailing '\0')

There is also a bug in kernel/security/smack/smackfs.c:
When smk_set_cipso() parsing the CIPSO setting from userspace, the offset of
CIPSO level should be "strlen(label)+1" instead of "strlen(label)"

Signed-off-by: Passion,Zhao <passion.zhao@intel.com>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 security/smack/smackfs.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/security/smack/smackfs.c b/security/smack/smackfs.c
index 76a5dca..c4fe705 100644
--- a/security/smack/smackfs.c
+++ b/security/smack/smackfs.c
@@ -818,7 +818,7 @@ static ssize_t smk_set_cipso(struct file *file, const char __user *buf,
 	if (format == SMK_FIXED24_FMT)
 		rule += SMK_LABELLEN;
 	else
-		rule += strlen(skp->smk_known);
+		rule += strlen(skp->smk_known) + 1;
 
 	ret = sscanf(rule, "%d", &maplevel);
 	if (ret != 1 || maplevel > SMACK_CIPSO_MAXLEVEL)
-- 
1.8.1.2

