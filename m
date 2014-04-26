Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751649AbaDZKoT (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Apr 2014 06:44:19 -0400
Received: from mailrelay009.isp.belgacom.be ([195.238.6.176]:59529 "EHLO
	mailrelay009.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750756AbaDZKoR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Apr 2014 06:44:17 -0400
X-Belgacom-Dynamic: yes
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AisQANOMW1NbsljQ/2dsb2JhbABZgwarfgEBAQEBBAGZcgICgQsXdIJTExwjGIECJBOIRQHLDIVaiH+EQAEDjnyKDwGKc4drgzM7
Date: Sat, 26 Apr 2014 12:46:17 +0200
From: Fabian Frederick <fabf@skynet.be>
To: linux-kernel <linux-kernel@vger.kernel.org>
Cc: sage <sage@inktank.com>, akpm <akpm@linux-foundation.org>
Subject: [PATCH 1/1] FS/CEPH: replace pr_warning by pr_warn
Message-Id: <20140426124617.e90d4793ea718ba36c8203fb@skynet.be>
X-Mailer: Sylpheed 3.3.0 (GTK+ 2.24.10; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Update the last pr_warning callsites in fs branch

Cc: Sage Weil <sage@inktank.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Fabian Frederick <fabf@skynet.be>
---
 fs/ceph/addr.c       | 2 +-
 fs/ceph/inode.c      | 2 +-
 fs/ceph/mds_client.c | 6 +++---
 fs/ceph/mdsmap.c     | 2 +-
 4 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/fs/ceph/addr.c b/fs/ceph/addr.c
index b53278c..65a30e8 100644
--- a/fs/ceph/addr.c
+++ b/fs/ceph/addr.c
@@ -694,7 +694,7 @@ static int ceph_writepages_start(struct address_space *mapping,
 	     (wbc->sync_mode == WB_SYNC_ALL ? "ALL" : "HOLD"));
 
 	if (fsc->mount_state == CEPH_MOUNT_SHUTDOWN) {
-		pr_warning("writepage_start %p on forced umount\n", inode);
+		pr_warn("writepage_start %p on forced umount\n", inode);
 		return -EIO; /* we're in a forced umount, don't write! */
 	}
 	if (fsc->mount_options->wsize && fsc->mount_options->wsize < wsize)
diff --git a/fs/ceph/inode.c b/fs/ceph/inode.c
index 0b0728e..6434f75 100644
--- a/fs/ceph/inode.c
+++ b/fs/ceph/inode.c
@@ -822,7 +822,7 @@ no_change:
 			spin_unlock(&ci->i_ceph_lock);
 		}
 	} else if (cap_fmode >= 0) {
-		pr_warning("mds issued no caps on %llx.%llx\n",
+		pr_warn("mds issued no caps on %llx.%llx\n",
 			   ceph_vinop(inode));
 		__ceph_get_fmode(ci, cap_fmode);
 	}
diff --git a/fs/ceph/mds_client.c b/fs/ceph/mds_client.c
index 2b4d093..9a33b98 100644
--- a/fs/ceph/mds_client.c
+++ b/fs/ceph/mds_client.c
@@ -2218,13 +2218,13 @@ static void handle_reply(struct ceph_mds_session *session, struct ceph_msg *msg)
 	/* dup? */
 	if ((req->r_got_unsafe && !head->safe) ||
 	    (req->r_got_safe && head->safe)) {
-		pr_warning("got a dup %s reply on %llu from mds%d\n",
+		pr_warn("got a dup %s reply on %llu from mds%d\n",
 			   head->safe ? "safe" : "unsafe", tid, mds);
 		mutex_unlock(&mdsc->mutex);
 		goto out;
 	}
 	if (req->r_got_safe && !head->safe) {
-		pr_warning("got unsafe after safe on %llu from mds%d\n",
+		pr_warn("got unsafe after safe on %llu from mds%d\n",
 			   tid, mds);
 		mutex_unlock(&mdsc->mutex);
 		goto out;
@@ -3525,7 +3525,7 @@ static void peer_reset(struct ceph_connection *con)
 	struct ceph_mds_session *s = con->private;
 	struct ceph_mds_client *mdsc = s->s_mdsc;
 
-	pr_warning("mds%d closed our session\n", s->s_mds);
+	pr_warn("mds%d closed our session\n", s->s_mds);
 	send_mds_reconnect(mdsc, s);
 }
 
diff --git a/fs/ceph/mdsmap.c b/fs/ceph/mdsmap.c
index 132b64e..261531e 100644
--- a/fs/ceph/mdsmap.c
+++ b/fs/ceph/mdsmap.c
@@ -62,7 +62,7 @@ struct ceph_mdsmap *ceph_mdsmap_decode(void **p, void *end)
 
 	ceph_decode_16_safe(p, end, version, bad);
 	if (version > 3) {
-		pr_warning("got mdsmap version %d > 3, failing", version);
+		pr_warn("got mdsmap version %d > 3, failing", version);
 		goto bad;
 	}
 
-- 
1.8.4.5

