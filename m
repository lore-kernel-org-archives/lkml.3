Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932136Ab3GBFpY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Jul 2013 01:45:24 -0400
Received: from mail-pd0-f173.google.com ([209.85.192.173]:60571 "EHLO
	mail-pd0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752278Ab3GBFpV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Jul 2013 01:45:21 -0400
Date: Tue, 2 Jul 2013 13:45:17 +0800
From: majianpeng <majianpeng@gmail.com>
To: sage <sage@inktank.com>
Cc: ceph-devel <ceph-devel@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Reply-To: majianpeng <majianpeng@gmail.com>
Subject: [PATCH 3/3] ceph: For ceph_sync_read, update the atime of file.
X-Priority: 3
X-GUID: 6A09C052-7F0F-4737-BADF-C3B6F1EBA162
X-Has-Attach: no
X-Mailer: Foxmail 7.0.1.90[en]
Mime-Version: 1.0
Message-ID: <201307021345131042678@gmail.com>
Content-Type: text/plain;
	charset="gb2312"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id r625jdR7005636

For buffer read, the func generic_file_aio_read will update atime of
file.But the ceph_sync_read don't do it.So add this.

Signed-off-by: Jianpeng Ma <majianpeng@gmail.com>
---
 fs/ceph/file.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/fs/ceph/file.c b/fs/ceph/file.c
index 656e169..87df15a 100644
--- a/fs/ceph/file.c
+++ b/fs/ceph/file.c
@@ -442,6 +442,9 @@ done:
 		ceph_put_page_vector(pages, num_pages, true);
 	else
 		ceph_release_page_vector(pages, num_pages);
+
+	file_accessed(file);
+
 	dout("sync_read result %d\n", ret);
 	return ret;
 }
-- 
1.8.1.2
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
