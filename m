Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754308Ab3L0ECY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Dec 2013 23:02:24 -0500
Received: from mailout2.samsung.com ([203.254.224.25]:62327 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754124Ab3L0EBp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Dec 2013 23:01:45 -0500
X-AuditID: cbfee68d-b7fcd6d00000315b-11-52bcfb9df158
From: Jaegeuk Kim <jaegeuk.kim@samsung.com>
Cc: Jaegeuk Kim <jaegeuk.kim@samsung.com>, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net
Subject: [PATCH 3/6] f2fs: call f2fs_put_page at the error case
Date: Fri, 27 Dec 2013 13:00:17 +0900
Message-id: <1388116820-15038-3-git-send-email-jaegeuk.kim@samsung.com>
X-Mailer: git-send-email 1.8.4.474.g128a96c
In-reply-to: <1388116820-15038-1-git-send-email-jaegeuk.kim@samsung.com>
References: <1388116820-15038-1-git-send-email-jaegeuk.kim@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrFLMWRmVeSWpSXmKPExsVy+t8zY915v/cEGUzoY7K4vusvk8WlRe4W
	e/aeZLG4vGsOmwOLx+4Fn5k8+rasYvT4vEkugDmKyyYlNSezLLVI3y6BK2P7mwnMBVO5Kx6d
	NG1gvMbZxcjJISFgInFmwQw2CFtM4sK99UA2F4eQwDJGieXNZxhhiq71nWOGSExnlFj8spkd
	JCEk0Mwk0TaTt4uRg4NNQFti834DkLCIALPEgqnnGUHqmQUmMEr8X/SeBSQhLGAvcb7pEBtI
	PYuAqkTjj3qQMK+Au8S6c51QR2hLbHs+EWwvp4CHRPvP+1Cr3CW+rj/IBDJTQuA3m8SadRuY
	QBIsAgIS3yYfYgGZKSEgK7HpADPEHEmJgytusExgFF7AyLCKUTS1ILmgOCm9yFCvODG3uDQv
	XS85P3cTIyRce3cw3j5gfYgxGWjcRGYp0eR8YLjnlcQbGpsZWZiamBobmVuakSasJM6b9DAp
	SEggPbEkNTs1tSC1KL6oNCe1+BAjEwenVANjY//ZCcdzHjpKvRLZURSgsjrltplE0ik7050b
	n8/8nH9uV1XK0fZduVIqhrsWK/hbzH85U2/V+7Nr9gcIF9/Vev6//ukF3amqP1c/CGx0sW5l
	mGfUsyzpLSfLX46+iyu3GZmvd7vxsdCbp3bZq4vxWTO2Ttyj8fxw2O4Eg6kO3LMnBy41Pqr4
	TomlOCPRUIu5qDgRAB42eT5tAgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrOIsWRmVeSWpSXmKPExsVy+t9jQd25v/cEGXRetLa4vusvk8WlRe4W
	e/aeZLG4vGsOmwOLx+4Fn5k8+rasYvT4vEkugDmqgdEmIzUxJbVIITUvOT8lMy/dVsk7ON45
	3tTMwFDX0NLCXEkhLzE31VbJxSdA1y0zB2ibkkJZYk4pUCggsbhYSd8O04TQEDddC5jGCF3f
	kCC4HiMDNJCwjjFj+5sJzAVTuSsenTRtYLzG2cXIySEhYCJxre8cM4QtJnHh3nq2LkYuDiGB
	6YwSi182s4MkhASamSTaZvJ2MXJwsAloS2zebwASFhFgllgw9TwjSD2zwARGif+L3rOAJIQF
	7CXONx1iA6lnEVCVaPxRDxLmFXCXWHeukw1il7bEtucTGUFsTgEPifaf96FWuUt8XX+QaQIj
	7wJGhlWMoqkFyQXFSem5RnrFibnFpXnpesn5uZsYwdHwTHoH46oGi0OMAhyMSjy8Dhv2BAmx
	JpYVV+YeYpTgYFYS4f18BSjEm5JYWZValB9fVJqTWnyIMRnoqInMUqLJ+cBIzSuJNzQ2MTOy
	NDKzMDIxNydNWEmc92CrdaCQQHpiSWp2ampBahHMFiYOTqkGxhU7kpiKWBKk7tgq8bIedn4Q
	GdYkEfJ7xj3TtzuTf0r6HOd+rGrxp2nTi4Xt5fH8TSnf36QwLnv/UahP7f2fz0EP+NZLTfle
	NSHCKbv04fxb+rsPNKzeMa1176UTk4xk3Uunau+KrfwcIiLTvdj9pvcdptPrGeN/LN6YG2Hw
	Lvz5pttZk4If8imxFGckGmoxFxUnAgCFwMniygIAAA==
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
To: unlisted-recipients:; (no To-header on input)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In f2fs_write_begin(), if f2fs_conver_inline_data() returns an error like
-ENOSPC, f2fs should call f2fs_put_page().
Otherwise, it is remained as a locked page, resulting in the following bug.

[<ffffffff8114657e>] sleep_on_page+0xe/0x20
[<ffffffff81146567>] __lock_page+0x67/0x70
[<ffffffff81157d08>] truncate_inode_pages_range+0x368/0x5d0
[<ffffffff81157ff5>] truncate_inode_pages+0x15/0x20
[<ffffffff8115804b>] truncate_pagecache+0x4b/0x70
[<ffffffff81158082>] truncate_setsize+0x12/0x20
[<ffffffffa02a1842>] f2fs_setattr+0x72/0x270 [f2fs]
[<ffffffff811cdae3>] notify_change+0x213/0x400
[<ffffffff811ab376>] do_truncate+0x66/0xa0
[<ffffffff811ab541>] vfs_truncate+0x191/0x1b0
[<ffffffff811ab5bc>] do_sys_truncate+0x5c/0xa0
[<ffffffff811ab78e>] SyS_truncate+0xe/0x10
[<ffffffff81756052>] system_call_fastpath+0x16/0x1b
[<ffffffffffffffff>] 0xffffffffffffffff

Signed-off-by: Jaegeuk Kim <jaegeuk.kim@samsung.com>
---
 fs/f2fs/data.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/fs/f2fs/data.c b/fs/f2fs/data.c
index bf39eed..253e663 100644
--- a/fs/f2fs/data.c
+++ b/fs/f2fs/data.c
@@ -916,8 +916,10 @@ repeat:
 			goto inline_data;
 	} else if (f2fs_has_inline_data(inode)) {
 		err = f2fs_convert_inline_data(inode, page, flags);
-		if (err)
+		if (err) {
+			f2fs_put_page(page, 1);
 			return err;
+		}
 	}
 
 	f2fs_lock_op(sbi);
-- 
1.8.4.474.g128a96c

