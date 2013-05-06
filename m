Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932401Ab3EFXOH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 May 2013 19:14:07 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:36943 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760658Ab3EFXOE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 May 2013 19:14:04 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        fanchaoting <fanchaoting@cn.fujitsu.com>,
        "J. Bruce Fields" <bfields@redhat.com>
Subject: [ 086/104] nfsd: dont run get_file if nfs4_preprocess_stateid_op return error
Date: Mon,  6 May 2013 16:12:45 -0700
Message-Id: <20130506230052.484970773@linuxfoundation.org>
X-Mailer: git-send-email 1.8.3.rc0.20.gb99dd2e
In-Reply-To: <20130506230043.526528358@linuxfoundation.org>
References: <20130506230043.526528358@linuxfoundation.org>
User-Agent: quilt/0.60-5.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8-stable review patch.  If anyone has any objections, please let me know.

------------------

From: fanchaoting <fanchaoting@cn.fujitsu.com>

commit b022032e195ffca83d7002d6b84297d796ed443b upstream.

we should return error status directly when nfs4_preprocess_stateid_op
return error.

Signed-off-by: fanchaoting <fanchaoting@cn.fujitsu.com>
Signed-off-by: J. Bruce Fields <bfields@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/nfsd/nfs4proc.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

--- a/fs/nfsd/nfs4proc.c
+++ b/fs/nfsd/nfs4proc.c
@@ -931,14 +931,14 @@ nfsd4_write(struct svc_rqst *rqstp, stru
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


