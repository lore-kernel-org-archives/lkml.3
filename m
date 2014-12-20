Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753074AbaLTMcJ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Dec 2014 07:32:09 -0500
Received: from mail-wg0-f44.google.com ([74.125.82.44]:61439 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752773AbaLTMcH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Dec 2014 07:32:07 -0500
From: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
To: Sage Weil <sage@inktank.com>, "David S. Miller" <davem@davemloft.net>
Cc: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>,
        ceph-devel@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] net: ceph: ceph_strings.c:  Remove unused function
Date: Sat, 20 Dec 2014 13:34:53 +0100
Message-Id: <1419078894-31656-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove the function ceph_pool_op_name() that is not used anywhere.

This was partially found by using a static code analysis program called cppcheck.

Signed-off-by: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
---
 include/linux/ceph/ceph_fs.h |    2 --
 net/ceph/ceph_strings.c      |   14 --------------
 2 files changed, 16 deletions(-)

diff --git a/include/linux/ceph/ceph_fs.h b/include/linux/ceph/ceph_fs.h
index 3c97d5e..0684f9e 100644
--- a/include/linux/ceph/ceph_fs.h
+++ b/include/linux/ceph/ceph_fs.h
@@ -191,8 +191,6 @@ struct ceph_mon_statfs_reply {
 	struct ceph_statfs st;
 } __attribute__ ((packed));
 
-const char *ceph_pool_op_name(int op);
-
 struct ceph_mon_poolop {
 	struct ceph_mon_request_header monhdr;
 	struct ceph_fsid fsid;
diff --git a/net/ceph/ceph_strings.c b/net/ceph/ceph_strings.c
index 3056020..139a9cb 100644
--- a/net/ceph/ceph_strings.c
+++ b/net/ceph/ceph_strings.c
@@ -42,17 +42,3 @@ const char *ceph_osd_state_name(int s)
 		return "???";
 	}
 }
-
-const char *ceph_pool_op_name(int op)
-{
-	switch (op) {
-	case POOL_OP_CREATE: return "create";
-	case POOL_OP_DELETE: return "delete";
-	case POOL_OP_AUID_CHANGE: return "auid change";
-	case POOL_OP_CREATE_SNAP: return "create snap";
-	case POOL_OP_DELETE_SNAP: return "delete snap";
-	case POOL_OP_CREATE_UNMANAGED_SNAP: return "create unmanaged snap";
-	case POOL_OP_DELETE_UNMANAGED_SNAP: return "delete unmanaged snap";
-	}
-	return "???";
-}
-- 
1.7.10.4

