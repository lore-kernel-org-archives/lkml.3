Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755457Ab3AOFpG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jan 2013 00:45:06 -0500
Received: from aserp1040.oracle.com ([141.146.126.69]:45539 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751162Ab3AOFpB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jan 2013 00:45:01 -0500
Subject: [PATCH 6/6] ubifs: Wait for page writeback to provide stable pages
To: axboe@kernel.dk, lucho@ionkov.net, jack@suse.cz, darrick.wong@oracle.com,
        ericvh@gmail.com, tytso@mit.edu, viro@zeniv.linux.org.uk,
        rminnich@sandia.gov
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: martin.petersen@oracle.com, Artem Bityutskiy <dedekind1@gmail.com>,
        neilb@suse.de, Adrian Hunter <adrian.hunter@intel.com>,
        david@fromorbit.com, gnehzuil.liu@gmail.com,
        linux-kernel@vger.kernel.org, hch@infradead.org,
        linux-fsdevel@vger.kernel.org, adilger.kernel@dilger.ca,
        bharrosh@panasas.com, jlayton@samba.org, linux-mtd@lists.infradead.org,
        linux-ext4@vger.kernel.org, hirofumi@mail.parknet.co.jp
Date: Mon, 14 Jan 2013 21:43:20 -0800
Message-ID: <20130115054320.1563.54829.stgit@blackbox.djwong.org>
In-Reply-To: <20130115054235.1563.12967.stgit@blackbox.djwong.org>
References: <20130115054235.1563.12967.stgit@blackbox.djwong.org>
User-Agent: StGit/0.15
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When stable pages are required, we have to wait if the page is just
going to disk and we want to modify it. Add proper callback to
ubifs_vm_page_mkwrite().

CC: Artem Bityutskiy <dedekind1@gmail.com>
From: Jan Kara <jack@suse.cz>
CC: Adrian Hunter <adrian.hunter@intel.com>
CC: linux-mtd@lists.infradead.org
Signed-off-by: Jan Kara <jack@suse.cz>
---
 fs/ubifs/file.c |    1 +
 1 file changed, 1 insertion(+)


diff --git a/fs/ubifs/file.c b/fs/ubifs/file.c
index 5bc7781..4f6493c 100644
--- a/fs/ubifs/file.c
+++ b/fs/ubifs/file.c
@@ -1522,6 +1522,7 @@ static int ubifs_vm_page_mkwrite(struct vm_area_struct *vma,
 			ubifs_release_dirty_inode_budget(c, ui);
 	}
 
+	wait_for_stable_page(page);
 	unlock_page(page);
 	return 0;
 

