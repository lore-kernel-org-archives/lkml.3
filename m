Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932299Ab3ERDCf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 May 2013 23:02:35 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:5799 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758825Ab3ERDAc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 May 2013 23:00:32 -0400
X-Authority-Analysis: v=2.0 cv=DKcNElxb c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=Ciwy3NGCPMMA:10 a=KusJ2IuDDp0A:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=4kVBcZI7m_sA:10 a=omOdbC7AAAAA:8 a=VwQbUJbxAAAA:8 a=20KFwNOVAAAA:8 a=aCPqOQJ_S1qBLZ7JjQ4A:9 a=jEp0ucaQiEUA:10 a=jeBq3FmKZ4MA:10 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Message-Id: <20130518021652.761261329@goodmis.org>
User-Agent: quilt/0.60-1
Date: Fri, 17 May 2013 22:17:05 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: fanchaoting <fanchaoting@cn.fujitsu.com>,
        "J. Bruce Fields" <bfields@redhat.com>
Subject: [ 068/136 ] nfsd: dont run get_file if nfs4_preprocess_stateid_op return error
References: <20130518021557.139113314@goodmis.org>
Content-Disposition: inline; filename=0068-nfsd-don-t-run-get_file-if-nfs4_preprocess_stateid_o.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.6.11.4 stable review patch.
If anyone has any objections, please let me know.

------------------

From: fanchaoting <fanchaoting@cn.fujitsu.com>

[ Upstream commit b022032e195ffca83d7002d6b84297d796ed443b ]

we should return error status directly when nfs4_preprocess_stateid_op
return error.

Signed-off-by: fanchaoting <fanchaoting@cn.fujitsu.com>
Cc: stable@vger.kernel.org
Signed-off-by: J. Bruce Fields <bfields@redhat.com>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 fs/nfsd/nfs4proc.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/fs/nfsd/nfs4proc.c b/fs/nfsd/nfs4proc.c
index c9c1c0a..4445c66 100644
--- a/fs/nfsd/nfs4proc.c
+++ b/fs/nfsd/nfs4proc.c
@@ -893,14 +893,14 @@ nfsd4_write(struct svc_rqst *rqstp, struct nfsd4_compound_state *cstate,
 	nfs4_lock_state();
 	status = nfs4_preprocess_stateid_op(SVC_NET(rqstp),
 					cstate, stateid, WR_STATE, &filp);
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
1.7.10.4


