Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933001AbbANHhe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jan 2015 02:37:34 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:58782 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755269AbbANHhb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jan 2015 02:37:31 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Dan Carpenter <dan.carpenter@oracle.com>,
        Ilya Dryomov <idryomov@redhat.com>
Subject: [PATCH 3.14 52/77] ceph: do_sync is never initialized
Date: Tue, 13 Jan 2015 23:23:32 -0800
Message-Id: <20150114072227.113051412@linuxfoundation.org>
X-Mailer: git-send-email 2.2.2
In-Reply-To: <20150114072224.182299947@linuxfoundation.org>
References: <20150114072224.182299947@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dan Carpenter <dan.carpenter@oracle.com>

commit 021b77bee210843bed1ea91b5cad58235ff9c8e5 upstream.

Probably this code was syncing a lot more often then intended because
the do_sync variable wasn't set to zero.

Fixes: c62988ec0910 ('ceph: avoid meaningless calling ceph_caps_revoking if sync_mode == WB_SYNC_ALL.')
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
Signed-off-by: Ilya Dryomov <idryomov@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/ceph/addr.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/fs/ceph/addr.c
+++ b/fs/ceph/addr.c
@@ -676,7 +676,7 @@ static int ceph_writepages_start(struct
 	int rc = 0;
 	unsigned wsize = 1 << inode->i_blkbits;
 	struct ceph_osd_request *req = NULL;
-	int do_sync;
+	int do_sync = 0;
 	u64 truncate_size, snap_size;
 	u32 truncate_seq;
 


