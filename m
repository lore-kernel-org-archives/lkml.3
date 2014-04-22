Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758190AbaDVU4u (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Apr 2014 16:56:50 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:36470 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757530AbaDVUWj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Apr 2014 16:22:39 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: "J. Bruce Fields" <bfields@redhat.com>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.8 094/133] nfsd4: session needs room for following op to error out
Date: Tue, 22 Apr 2014 13:13:52 -0700
Message-Id: <1398197671-12786-95-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1398197671-12786-1-git-send-email-kamal@canonical.com>
References: <1398197671-12786-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8.13.22 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: "J. Bruce Fields" <bfields@redhat.com>

commit 4c69d5855a16f7378648c5733632628fa10431db upstream.

Signed-off-by: J. Bruce Fields <bfields@redhat.com>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 fs/nfsd/nfs4proc.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/fs/nfsd/nfs4proc.c b/fs/nfsd/nfs4proc.c
index de60696..0439d65 100644
--- a/fs/nfsd/nfs4proc.c
+++ b/fs/nfsd/nfs4proc.c
@@ -1286,6 +1286,12 @@ nfsd4_proc_compound(struct svc_rqst *rqstp,
 		/* If op is non-idempotent */
 		if (opdesc->op_flags & OP_MODIFIES_SOMETHING) {
 			plen = opdesc->op_rsize_bop(rqstp, op);
+			/*
+			 * If there's still another operation, make sure
+			 * we'll have space to at least encode an error:
+			 */
+			if (resp->opcnt < args->opcnt)
+				plen += COMPOUND_ERR_SLACK_SPACE;
 			op->status = nfsd4_check_resp_size(resp, plen);
 		}
 
-- 
1.9.1

