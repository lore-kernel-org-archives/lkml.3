Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753276AbaHDCMY (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Aug 2014 22:12:24 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:12886 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752342AbaHDCMW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Aug 2014 22:12:22 -0400
X-AuditID: cbfee61a-f79e46d00000134f-0c-53deec04958e
From: Chao Yu <chao2.yu@samsung.com>
To: Jaegeuk Kim <jaegeuk@kernel.org>, Changman Lee <cm224.lee@samsung.com>
Cc: linux-f2fs-devel@lists.sourceforge.net, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [f2fs-dev][PATCH 2/2] f2fs: add f2fs_balance_fs for expand_inode_data
Date: Mon, 04 Aug 2014 10:11:17 +0800
Message-id: <001f01cfaf89$85b07c70$91117550$@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Outlook 14.0
Thread-index: Ac+vh7t4MH2EKloDQSudQ2fKKnhlVg==
Content-language: zh-cn
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrOLMWRmVeSWpSXmKPExsVy+t9jQV2WN/eCDVbdtLC4tq+RyeLJ+lnM
	FpcWuVvs2XuSxeLyrjlsDqwem1Z1snnsXvCZyaNvyypGj8+b5AJYorhsUlJzMstSi/TtErgy
	7i05zFpwi6Xi0LsG5gbG58xdjJwcEgImEttb+5kgbDGJC/fWs3UxcnEICUxnlNjecZAVwvnB
	KPH06VSwKjYBFYnlHf/BbBEBL4lJ+0+wgNjMApkS95pmgE0VFvCT2P/yEVicRUBVYlXnNzCb
	V8BSorf1AxuELSjxY/I9qF4tifU7jzNB2PISm9e8hbpOQWLH2deMXYwcQLv0JN4vV4coEZfY
	eOQWywRGgVlIJs1CMmkWkkmzkLQsYGRZxSiaWpBcUJyUnmuoV5yYW1yal66XnJ+7iREc3M+k
	djCubLA4xCjAwajEw6uw926wEGtiWXFl7iFGCQ5mJRHexJf3goV4UxIrq1KL8uOLSnNSiw8x
	SnOwKInzHmi1DhQSSE8sSc1OTS1ILYLJMnFwSjUwrnu+edbd+iD+11sClk/bVvDla9mO8INX
	dh1vebqi9ZvlyeVPhfN/hp3byBz09diNF+El5qVTFLO0+22teU+UZP7ZEzpVzuzhwu19b75b
	bGJxs3KO2PYvcOWSR79fvb/5f9LzyQvVgl7t3fVJ9V7Flxy1G0/mBH/03JYwv8dg/1SmDI3L
	xR5Xi64qsRRnJBpqMRcVJwIAxRedpmoCAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds f2fs_balance_fs in expand_inode_data to avoid allocation failure
with segment.

Signed-off-by: Chao Yu <chao2.yu@samsung.com>
---
 fs/f2fs/file.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/fs/f2fs/file.c b/fs/f2fs/file.c
index 9550135..5d3b779 100644
--- a/fs/f2fs/file.c
+++ b/fs/f2fs/file.c
@@ -671,6 +671,8 @@ static int expand_inode_data(struct inode *inode, loff_t offset,
 	loff_t off_start, off_end;
 	int ret = 0;
 
+	f2fs_balance_fs(sbi);
+
 	ret = inode_newsize_ok(inode, (len + offset));
 	if (ret)
 		return ret;
-- 
2.0.0.421.g786a89d


