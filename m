Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S968380Ab3DSQ1v (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Apr 2013 12:27:51 -0400
Received: from mail-da0-f54.google.com ([209.85.210.54]:32872 "EHLO
	mail-da0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757924Ab3DSQ1s (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Apr 2013 12:27:48 -0400
From: Namjae Jeon <linkinjeon@gmail.com>
To: jaegeuk.kim@samsung.com
Cc: linux-f2fs-devel@lists.sourceforge.net, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, Namjae Jeon <linkinjeon@gmail.com>,
        Namjae Jeon <namjae.jeon@samsung.com>,
        Amit Sahrawat <a.sahrawat@samsung.com>
Subject: [PATCH 2/2] f2fs: add REQ_META about metadata requests for submit bio
Date: Sat, 20 Apr 2013 01:27:40 +0900
Message-Id: <1366388860-18735-1-git-send-email-linkinjeon@gmail.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Namjae Jeon <namjae.jeon@samsung.com>

Adding REQ_META for all the metadata requests can help in improving the
FS performance, if the underlying device supports TAGGING.
So, when considering the submit_bio path for all the f2fs requests. We can
add REQ_META for all the META requests.
As a precursor to this change we considered the commit
4265900e0be653f5b78baf2816857ef57cf1332f 'mmc: MMC-4.5 Data Tag Support'

Signed-off-by: Namjae Jeon <namjae.jeon@samsung.com>
Signed-off-by: Amit Sahrawat <a.sahrawat@samsung.com>
---
 fs/f2fs/segment.c |    3 +++
 1 file changed, 3 insertions(+)

diff --git a/fs/f2fs/segment.c b/fs/f2fs/segment.c
index 1193a26..a2e5de7 100644
--- a/fs/f2fs/segment.c
+++ b/fs/f2fs/segment.c
@@ -689,6 +689,9 @@ static void do_submit_bio(struct f2fs_sb_info *sbi,
 	if (type >= META_FLUSH)
 		rw = WRITE_FLUSH_FUA;
 
+	if (type == META)
+		rw |= REQ_META;
+
 	if (sbi->bio[btype]) {
 		struct bio_private *p = sbi->bio[btype]->bi_private;
 		trace_f2fs_do_submit_bio(sbi->sb, btype, sync,
-- 
1.7.9.5

