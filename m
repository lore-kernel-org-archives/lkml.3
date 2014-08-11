Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754677AbaHKS3R (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Aug 2014 14:29:17 -0400
Received: from mail-pa0-f42.google.com ([209.85.220.42]:45399 "EHLO
	mail-pa0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754490AbaHKS3N (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Aug 2014 14:29:13 -0400
From: Srikrishan Malik <srikrishanmalik@gmail.com>
To: greg@kroah.com, andreas.dilger@intel.com, oleg.drokin@intel.com
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Srikrishan Malik <srikrishanmalik@gmail.com>
Subject: [PATCH v2 11/13] staging: lustre: move else on the same line as closing brace
Date: Mon, 11 Aug 2014 23:57:37 +0530
Message-Id: <1407781659-728-11-git-send-email-srikrishanmalik@gmail.com>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <1407781659-728-1-git-send-email-srikrishanmalik@gmail.com>
References: <1407781659-728-1-git-send-email-srikrishanmalik@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix the following checkpatch error:

ERROR: else should follow close brace '}'

Signed-off-by: Srikrishan Malik <srikrishanmalik@gmail.com>
---
 drivers/staging/lustre/lustre/mdc/mdc_request.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/staging/lustre/lustre/mdc/mdc_request.c b/drivers/staging/lustre/lustre/mdc/mdc_request.c
index bf2dcf50afd4..5a9a8526dea1 100644
--- a/drivers/staging/lustre/lustre/mdc/mdc_request.c
+++ b/drivers/staging/lustre/lustre/mdc/mdc_request.c
@@ -587,8 +587,7 @@ int mdc_get_lustre_md(struct obd_export *exp, struct ptlrpc_request *req,
 						lustre_swab_mdt_remote_perm);
 		if (!md->remote_perm)
 			GOTO(out, rc = -EPROTO);
-	}
-	else if (md->body->valid & OBD_MD_FLACL) {
+	} else if (md->body->valid & OBD_MD_FLACL) {
 		/* for ACL, it's possible that FLACL is set but aclsize is zero.
 		 * only when aclsize != 0 there's an actual segment for ACL
 		 * in reply buffer.
-- 
1.9.3

