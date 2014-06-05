Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753424AbaFEEzx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jun 2014 00:55:53 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:43965 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752641AbaFEEUr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jun 2014 00:20:47 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        fanchaoting <fanchaoting@cn.fujitsu.com>,
        "J. Bruce Fields" <bfields@redhat.com>,
        Ben Hutchings <ben@decadent.org.uk>, Rui Xiang <rui.xiang@huawei.com>
Subject: [PATCH 3.4 090/214] nfsd: dont run get_file if nfs4_preprocess_stateid_op return error
Date: Wed,  4 Jun 2014 21:17:33 -0700
Message-Id: <20140605041651.734917421@linuxfoundation.org>
X-Mailer: git-send-email 2.0.0
In-Reply-To: <20140605041639.638675216@linuxfoundation.org>
References: <20140605041639.638675216@linuxfoundation.org>
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: fanchaoting <fanchaoting@cn.fujitsu.com>

commit b022032e195ffca83d7002d6b84297d796ed443b upstream.

we should return error status directly when nfs4_preprocess_stateid_op
return error.

Signed-off-by: fanchaoting <fanchaoting@cn.fujitsu.com>
Signed-off-by: J. Bruce Fields <bfields@redhat.com>
[bwh: Backported to 3.2: adjust context]
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
Cc: Rui Xiang <rui.xiang@huawei.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/nfsd/nfs4proc.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

--- a/fs/nfsd/nfs4proc.c
+++ b/fs/nfsd/nfs4proc.c
@@ -904,14 +904,14 @@ nfsd4_write(struct svc_rqst *rqstp, stru
 
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


