Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754517AbaEDQkz (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 May 2014 12:40:55 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:36036 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754041AbaEDPlm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 May 2014 11:41:42 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        "J. Bruce Fields" <bfields@redhat.com>
Subject: [PATCH 3.14 071/158] nfsd4: session needs room for following op to error out
Date: Sun,  4 May 2014 11:39:40 -0400
Message-Id: <20140504154039.569491714@linuxfoundation.org>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <20140504154029.975081050@linuxfoundation.org>
References: <20140504154029.975081050@linuxfoundation.org>
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: "J. Bruce Fields" <bfields@redhat.com>

commit 4c69d5855a16f7378648c5733632628fa10431db upstream.

Signed-off-by: J. Bruce Fields <bfields@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/nfsd/nfs4proc.c |    6 ++++++
 1 file changed, 6 insertions(+)

--- a/fs/nfsd/nfs4proc.c
+++ b/fs/nfsd/nfs4proc.c
@@ -1359,6 +1359,12 @@ nfsd4_proc_compound(struct svc_rqst *rqs
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
 


