Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757826AbaHFROl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Aug 2014 13:14:41 -0400
Received: from mail-pd0-f180.google.com ([209.85.192.180]:55571 "EHLO
	mail-pd0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757750AbaHFROi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Aug 2014 13:14:38 -0400
From: Srikrishan Malik <srikrishanmalik@gmail.com>
To: greg@kroah.com, andreas.dilger@intel.com, oleg.drokin@intel.com
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Srikrishan Malik <srikrishanmalik@gmail.com>
Subject: [PATCH 11/12] staging: lustre: move else on the same line as closing brace
Date: Wed,  6 Aug 2014 22:43:01 +0530
Message-Id: <1407345182-709-11-git-send-email-srikrishanmalik@gmail.com>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <1407345182-709-1-git-send-email-srikrishanmalik@gmail.com>
References: <1407345182-709-1-git-send-email-srikrishanmalik@gmail.com>
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
index 205eeade9fdd..7ccee06fd447 100644
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

