Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758775Ab3EOABh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 May 2013 20:01:37 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:15489 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758613Ab3EOABV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 May 2013 20:01:21 -0400
X-AuditID: cbfee68d-b7f096d0000043fc-54-5192d048494b
From: Jaegeuk Kim <jaegeuk.kim@samsung.com>
Cc: Jaegeuk Kim <jaegeuk.kim@samsung.com>, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net
Subject: [PATCH 2/2] f2fs: fix the inconsistent state of data pages
Date: Wed, 15 May 2013 08:59:52 +0900
Message-id: <1368575992-7142-2-git-send-email-jaegeuk.kim@samsung.com>
X-Mailer: git-send-email 1.8.1.3.566.gaa39828
In-reply-to: <1368575992-7142-1-git-send-email-jaegeuk.kim@samsung.com>
References: <1368575992-7142-1-git-send-email-jaegeuk.kim@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrDLMWRmVeSWpSXmKPExsVy+t8zQ12PC5MCDWb+VrK4vusvk8WlRe4W
	e/aeZLG4vGsOmwOLx+4Fn5k8+rasYvT4vEkugDmKyyYlNSezLLVI3y6BK+PR8v2sBe/5Kl5c
	2MLWwLiGp4uRk0NCwETi2+YnLBC2mMSFe+vZQGwhgWWMEosmssDUtMzsYO5i5AKKL2KUmNc9
	jxXCaWOSaNqyGqiDg4NNQFti834DkAYRAWaJBVPPM4LUMAtMYJT4v+g92CRhAWeJD5PvM4HY
	LAKqEvt/fwKzeQXcJLr+9bBBbNOVWP3/OTuIzSngLjFr20qoi9wklvxaCDZUQuA7m8TWX+fZ
	IAYJSHybfIgF5AgJAVmJTQeYIeZIShxccYNlAqPwAkaGVYyiqQXJBcVJ6UWGesWJucWleel6
	yfm5mxghIdu7g/H2AetDjMlA4yYyS4km5wNDPq8k3tDYzMjC1MTU2Mjc0ow0YSVxXrUW60Ah
	gfTEktTs1NSC1KL4otKc1OJDjEwcnFINjPMvzLzT/t97JteiioyLCsG/PVM2LXRe/3Q6s7DF
	KwXG27K1iixHZhd56AebWiwwKj9j52El0LB90+vU29N0zGdd+yoXsenlrWNd7/0Zqqvvf/vx
	fNOsEKtERlvttVMq3a97HPR/l5UzoVBn/4U/Qe9bBNpXtm9ycpNeuvPfliYOY1ajHerWakos
	xRmJhlrMRcWJAGRpRfxvAgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrFIsWRmVeSWpSXmKPExsVy+t9jAV2PC5MCDRavkre4vusvk8WlRe4W
	e/aeZLG4vGsOmwOLx+4Fn5k8+rasYvT4vEkugDmqgdEmIzUxJbVIITUvOT8lMy/dVsk7ON45
	3tTMwFDX0NLCXEkhLzE31VbJxSdA1y0zB2ibkkJZYk4pUCggsbhYSd8O04TQEDddC5jGCF3f
	kCC4HiMDNJCwjjHj0fL9rAXv+SpeXNjC1sC4hqeLkZNDQsBEomVmBzOELSZx4d56ti5GLg4h
	gUWMEvO657FCOG1MEk1bVgNlODjYBLQlNu83AGkQEWCWWDD1PCNIDbPABEaJ/4ves4AkhAWc
	JT5Mvs8EYrMIqErs//0JzOYVcJPo+tfDBrFNV2L1/+fsIDangLvErG0rweJCQDVLfi1knMDI
	u4CRYRWjaGpBckFxUnqukV5xYm5xaV66XnJ+7iZGcEw8k97BuKrB4hCjAAejEg9vYeCkQCHW
	xLLiytxDjBIczEoivM+jgEK8KYmVValF+fFFpTmpxYcYk4GumsgsJZqcD4zXvJJ4Q2MTMyNL
	IzMLIxNzc9KElcR5D7ZaBwoJpCeWpGanphakFsFsYeLglGpgnHe3JmTtdKnXB/93HItc+uX5
	/Exu76DoYpG0sw+TXZbFbrjiP9fu+EIHqfuHshrNqth2m+WFdPB0//M3lbtSwy06a5pisMGy
	7wvv/3R9e/vFKoEPfHuWX73XbR1539fkDvMOeaaz593++Exb3/Lyu1UBc9Lb9J3/py3tDH0U
	Uyp5UbGsakNUghJLcUaioRZzUXEiAGtKpMTNAgAA
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
To: unlisted-recipients:; (no To-header on input)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In get_lock_data_page, if there is a data race between get_dnode_of_data for
node and grab_cache_page for data, f2fs is able to face with the following
BUG_ON(dn.data_blkaddr == NEW_ADDR).

kernel BUG at /home/zeus/f2fs_test/src/fs/f2fs/data.c:251!
 [<ffffffffa044966c>] get_lock_data_page+0x1ec/0x210 [f2fs]
Call Trace:
 [<ffffffffa043b089>] f2fs_readdir+0x89/0x210 [f2fs]
 [<ffffffff811a0920>] ? fillonedir+0x100/0x100
 [<ffffffff811a0920>] ? fillonedir+0x100/0x100
 [<ffffffff811a07f8>] vfs_readdir+0xb8/0xe0
 [<ffffffff811a0b4f>] sys_getdents+0x8f/0x110
 [<ffffffff816d7999>] system_call_fastpath+0x16/0x1b

This bug is able to be occurred when the block address of the data block is
changed after f2fs_put_dnode().
In order to avoid that, this patch fixes the lock order of node and data
blocks in which the node block lock is covered by the data block lock.

Signed-off-by: Jaegeuk Kim <jaegeuk.kim@samsung.com>
---
 fs/f2fs/data.c | 17 +++++++++++------
 1 file changed, 11 insertions(+), 6 deletions(-)

diff --git a/fs/f2fs/data.c b/fs/f2fs/data.c
index 91ff93b..05fb5c6 100644
--- a/fs/f2fs/data.c
+++ b/fs/f2fs/data.c
@@ -233,18 +233,23 @@ struct page *get_lock_data_page(struct inode *inode, pgoff_t index)
 	struct page *page;
 	int err;
 
+repeat:
+	page = grab_cache_page(mapping, index);
+	if (!page)
+		return ERR_PTR(-ENOMEM);
+
 	set_new_dnode(&dn, inode, NULL, NULL, 0);
 	err = get_dnode_of_data(&dn, index, LOOKUP_NODE);
-	if (err)
+	if (err) {
+		f2fs_put_page(page, 1);
 		return ERR_PTR(err);
+	}
 	f2fs_put_dnode(&dn);
 
-	if (dn.data_blkaddr == NULL_ADDR)
+	if (dn.data_blkaddr == NULL_ADDR) {
+		f2fs_put_page(page, 1);
 		return ERR_PTR(-ENOENT);
-repeat:
-	page = grab_cache_page(mapping, index);
-	if (!page)
-		return ERR_PTR(-ENOMEM);
+	}
 
 	if (PageUptodate(page))
 		return page;
-- 
1.8.1.3.566.gaa39828

