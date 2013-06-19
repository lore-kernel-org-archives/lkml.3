Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756567Ab3FSHMM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Jun 2013 03:12:12 -0400
Received: from mail-pa0-f54.google.com ([209.85.220.54]:50518 "EHLO
	mail-pa0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756393Ab3FSHMK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Jun 2013 03:12:10 -0400
Date: Wed, 19 Jun 2013 15:12:06 +0800
From: majianpeng <majianpeng@gmail.com>
To: sage <sage@inktank.com>
Cc: ceph-devel <ceph-devel@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Reply-To: majianpeng <majianpeng@gmail.com>
Subject: [PATCH] ceph: avoid meaningless calling ceph_caps_revoking if sync_mode == WB_SYNC_ALL.
X-Priority: 3
X-GUID: 7B38E144-81EF-413B-B8C7-D2BD0DC4372A
X-Has-Attach: no
X-Mailer: Foxmail 7.0.1.90[en]
Mime-Version: 1.0
Message-ID: <201306191512024406391@gmail.com>
Content-Type: text/plain;
	charset="gb2312"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id r5J7CKWh006513

Signed-off-by: Jianpeng Ma <majianpeng@gmail.com>
---
 fs/ceph/addr.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/ceph/addr.c b/fs/ceph/addr.c
index 3e68ac1..25fa8b8 100644
--- a/fs/ceph/addr.c
+++ b/fs/ceph/addr.c
@@ -677,8 +677,8 @@ static int ceph_writepages_start(struct address_space *mapping,
 	 * integrity write (e.g., O_SYNC write or fsync()), or if our
 	 * cap is being revoked.
 	 */
-	do_sync = wbc->sync_mode == WB_SYNC_ALL;
-	if (ceph_caps_revoking(ci, CEPH_CAP_FILE_BUFFER))
+	if ((wbc->sync_mode == WB_SYNC_ALL) ||
+		ceph_caps_revoking(ci, CEPH_CAP_FILE_BUFFER))
 		do_sync = 1;
 	dout("writepages_start %p dosync=%d (mode=%s)\n",
 	     inode, do_sync,
-- 
1.8.3.rc1.44.gb387c77
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
