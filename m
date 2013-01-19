Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756199Ab3ASBPE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jan 2013 20:15:04 -0500
Received: from userp1040.oracle.com ([156.151.31.81]:37242 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754318Ab3ASBO7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jan 2013 20:14:59 -0500
Subject: [PATCH 6/6] ubifs: Wait for page writeback to provide stable pages
To: axboe@kernel.dk, lucho@ionkov.net, jack@suse.cz, darrick.wong@oracle.com,
        ericvh@gmail.com, viro@zeniv.linux.org.uk, rminnich@sandia.gov,
        tytso@mit.edu
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: martin.petersen@oracle.com, Artem Bityutskiy <dedekind1@gmail.com>,
        neilb@suse.de, Adrian Hunter <adrian.hunter@intel.com>,
        david@fromorbit.com, gnehzuil.liu@gmail.com,
        linux-kernel@vger.kernel.org, hch@infradead.org,
        linux-fsdevel@vger.kernel.org, adilger.kernel@dilger.ca,
        bharrosh@panasas.com, jlayton@samba.org, linux-mtd@lists.infradead.org,
        akpm@linux-foundation.org, linux-ext4@vger.kernel.org,
        hirofumi@mail.parknet.co.jp
Date: Fri, 18 Jan 2013 17:13:16 -0800
Message-ID: <20130119011316.20902.56721.stgit@blackbox.djwong.org>
In-Reply-To: <20130119011231.20902.55954.stgit@blackbox.djwong.org>
References: <20130119011231.20902.55954.stgit@blackbox.djwong.org>
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
CC: Adrian Hunter <adrian.hunter@intel.com>
CC: linux-mtd@lists.infradead.org
From: Jan Kara <jack@suse.cz>
Signed-off-by: Jan Kara <jack@suse.cz>
Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
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
 

