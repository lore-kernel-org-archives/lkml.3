Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756150Ab3ASBO6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jan 2013 20:14:58 -0500
Received: from userp1040.oracle.com ([156.151.31.81]:37191 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755647Ab3ASBOz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jan 2013 20:14:55 -0500
Subject: [PATCH 3/6] 9pfs: Fix filesystem to wait for stable page writeback
To: axboe@kernel.dk, lucho@ionkov.net, jack@suse.cz, darrick.wong@oracle.com,
        ericvh@gmail.com, viro@zeniv.linux.org.uk, rminnich@sandia.gov,
        tytso@mit.edu
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: martin.petersen@oracle.com, neilb@suse.de, david@fromorbit.com,
        gnehzuil.liu@gmail.com, linux-kernel@vger.kernel.org,
        hch@infradead.org, linux-fsdevel@vger.kernel.org,
        adilger.kernel@dilger.ca, bharrosh@panasas.com, jlayton@samba.org,
        akpm@linux-foundation.org, linux-ext4@vger.kernel.org,
        hirofumi@mail.parknet.co.jp
Date: Fri, 18 Jan 2013 17:12:53 -0800
Message-ID: <20130119011253.20902.38148.stgit@blackbox.djwong.org>
In-Reply-To: <20130119011231.20902.55954.stgit@blackbox.djwong.org>
References: <20130119011231.20902.55954.stgit@blackbox.djwong.org>
User-Agent: StGit/0.15
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix up the ->page_mkwrite handler to provide stable page writes if necessary.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/9p/vfs_file.c |    1 +
 1 file changed, 1 insertion(+)


diff --git a/fs/9p/vfs_file.c b/fs/9p/vfs_file.c
index c2483e9..357260b 100644
--- a/fs/9p/vfs_file.c
+++ b/fs/9p/vfs_file.c
@@ -620,6 +620,7 @@ v9fs_vm_page_mkwrite(struct vm_area_struct *vma, struct vm_fault *vmf)
 	lock_page(page);
 	if (page->mapping != inode->i_mapping)
 		goto out_unlock;
+	wait_for_stable_page(page);
 
 	return VM_FAULT_LOCKED;
 out_unlock:

