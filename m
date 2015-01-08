Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757277AbbAHRxE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Jan 2015 12:53:04 -0500
Received: from mailout2.w1.samsung.com ([210.118.77.12]:9252 "EHLO
	mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750781AbbAHRxC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Jan 2015 12:53:02 -0500
X-AuditID: cbfec7f5-b7fc86d0000066b7-a8-54aec3fca83a
From: Rafal Krypa <r.krypa@samsung.com>
To: Casey Schaufler <casey@schaufler-ca.com>
Cc: James Morris <james.l.morris@oracle.com>,
        "Serge E. Hallyn" <serge@hallyn.com>,
        linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org,
        Rafal Krypa <r.krypa@samsung.com>
Subject: [PATCH] smack: Add missing logging in bidirectional UDS connect check
Date: Thu, 08 Jan 2015 18:52:45 +0100
Message-id: <1420739565-11392-1-git-send-email-r.krypa@samsung.com>
X-Mailer: git-send-email 2.1.4
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrBJMWRmVeSWpSXmKPExsVy+t/xy7p/Dq8LMZi91tri3rZfbBZ9j4Ms
	Lu+aw2bxoecRm8XbSSuYLc5fOMfuwOZxbXekx8ent1g8+rasYvQ4un8Rm8fnTXIBrFFcNimp
	OZllqUX6dglcGVf/zWEueMFW8WHBKeYGxn2sXYycHBICJhIrnuyBssUkLtxbz9bFyMUhJLCU
	UWJbVzMLhNPLJPHqy00mkCo2AXWJpfN72UBsEQEdiX17nrODFDEL7GOUOLFnPwtIQljAT6L3
	7EqwBhYBVYn76w6CreAVcJb42gDRLCEgJ3H++E/mCYzcCxgZVjGKppYmFxQnpeca6RUn5haX
	5qXrJefnbmKEhMbXHYxLj1kdYhTgYFTi4f1wf22IEGtiWXFl7iFGCQ5mJRFeHc91IUK8KYmV
	ValF+fFFpTmpxYcYmTg4pRoYNYU73A63n/cSlpPmMl9U/uLAjJNhnj05Yuu/LLSxstR8yGez
	UzlWq+nTu+unH7ZIbwxcdn6a5ar1s3TFcu2eTLhfsjRvyVzlvDdW0nJzbY2/L97j5/JaQb1E
	YUXUvNJqrR13NL98SD4QHrKkZdpkhsDu7Z3n3s2sUT4fvnlZXY6iVkaqtVarEktxRqKhFnNR
	cSIAdFO7N+sBAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

During UDS connection check, both sides are checked for write access to
the other side. But only the first check is performed with audit support.
The second one didn't produce any audit logs. This simple patch fixes that.

Signed-off-by: Rafal Krypa <r.krypa@samsung.com>
---
 security/smack/smack_lsm.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/security/smack/smack_lsm.c b/security/smack/smack_lsm.c
index 8716ade..a688f7b 100644
--- a/security/smack/smack_lsm.c
+++ b/security/smack/smack_lsm.c
@@ -3333,7 +3333,7 @@ static int smack_unix_stream_connect(struct sock *sock,
 		if (rc == 0) {
 			okp = osp->smk_out;
 			skp = ssp->smk_in;
-			rc = smk_access(okp, skp, MAY_WRITE, NULL);
+			rc = smk_access(okp, skp, MAY_WRITE, &ad);
 			rc = smk_bu_note("UDS connect", okp, skp,
 						MAY_WRITE, rc);
 		}
-- 
2.1.4

