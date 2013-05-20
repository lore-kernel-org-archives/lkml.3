Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755529Ab3ETKwe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 May 2013 06:52:34 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:55940 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754873Ab3ETKwO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 May 2013 06:52:14 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: fanchaoting <fanchaoting@cn.fujitsu.com>,
        "J. Bruce Fields" <bfields@redhat.com>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 004/115] nfsd: don't run get_file if nfs4_preprocess_stateid_op return error
Date: Mon, 20 May 2013 11:50:04 +0100
Message-Id: <1369047116-9378-5-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1369047116-9378-1-git-send-email-luis.henriques@canonical.com>
References: <1369047116-9378-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.13 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: fanchaoting <fanchaoting@cn.fujitsu.com>

commit b022032e195ffca83d7002d6b84297d796ed443b upstream.

we should return error status directly when nfs4_preprocess_stateid_op
return error.

Signed-off-by: fanchaoting <fanchaoting@cn.fujitsu.com>
Signed-off-by: J. Bruce Fields <bfields@redhat.com>
[ luis: adjust context ]
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 fs/nfsd/nfs4proc.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/fs/nfsd/nfs4proc.c b/fs/nfsd/nfs4proc.c
index dd0308d..7e97d93 100644
--- a/fs/nfsd/nfs4proc.c
+++ b/fs/nfsd/nfs4proc.c
@@ -893,14 +893,14 @@ nfsd4_write(struct svc_rqst *rqstp, struct nfsd4_compound_state *cstate,
 
 	nfs4_lock_state();
 	status = nfs4_preprocess_stateid_op(cstate, stateid, WR_STATE, &filp);
-	if (filp)
-		get_file(filp);
-	nfs4_unlock_state();
-
 	if (status) {
+		nfs4_unlock_state();
 		dprintk("NFSD: nfsd4_write: couldn't process stateid!\n");
 		return status;
 	}
+	if (filp)
+		get_file(filp);
+	nfs4_unlock_state();
 
 	cnt = write->wr_buflen;
 	write->wr_how_written = write->wr_stable_how;
-- 
1.8.1.2

