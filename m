Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754007Ab3GCGME (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Jul 2013 02:12:04 -0400
Received: from mail-pd0-f169.google.com ([209.85.192.169]:58163 "EHLO
	mail-pd0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751767Ab3GCGMC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Jul 2013 02:12:02 -0400
Date: Wed, 3 Jul 2013 14:11:48 +0800
From: majianpeng <majianpeng@gmail.com>
To: sage <sage@inktank.com>
Cc: ceph-devel <ceph-devel@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Reply-To: majianpeng <majianpeng@gmail.com>
Subject: [PATCH 2/2] ceph: for sync_read, call file_accessed to update atime.
X-Priority: 3
X-GUID: 11AD6990-D96E-41B9-977E-8130DD297C8B
X-Has-Attach: no
X-Mailer: Foxmail 7.0.1.90[en]
Mime-Version: 1.0
Message-ID: <201307031334535261195@gmail.com>
Content-Type: text/plain;
	charset="gb2312"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id r636CCqK012464

For ceph_sync_read,it don't call file_accessed to update atime.But the
buffer_read do it .So add it.

Signed-off-by: Jianpeng Ma <majianpeng@gmail.com>
---
 fs/ceph/file.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/fs/ceph/file.c b/fs/ceph/file.c
index fa74e6f..b0e6f0b 100644
--- a/fs/ceph/file.c
+++ b/fs/ceph/file.c
@@ -442,6 +442,7 @@ done:
 		ceph_put_page_vector(pages, num_pages, true);
 	else
 		ceph_release_page_vector(pages, num_pages);
+	file_accessed(file);
 	dout("sync_read result %d\n", ret);
 	return ret;
 }
-- 
1.8.1.2
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
