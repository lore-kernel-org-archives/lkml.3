Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932900Ab3GLLZu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Jul 2013 07:25:50 -0400
Received: from mail-pd0-f175.google.com ([209.85.192.175]:46277 "EHLO
	mail-pd0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932578Ab3GLLZs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Jul 2013 07:25:48 -0400
Date: Fri, 12 Jul 2013 19:25:34 +0800
From: majianpeng <majianpeng@gmail.com>
To: sage <sage@inktank.com>
Cc: ceph-devel <ceph-devel@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Reply-To: majianpeng <majianpeng@gmail.com>
Subject: [PATCH] libceph: Unregister request if __map_request failed.
X-Priority: 3
X-GUID: 914B6DD9-8552-40E0-952B-2B3787E5B710
X-Has-Attach: no
X-Mailer: Foxmail 7.0.1.90[en]
Mime-Version: 1.0
Message-ID: <201307121925324881460@gmail.com>
Content-Type: text/plain;
	charset="gb2312"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id r6CBQ8fO029922

In func ceph_osdc_start_request, if __mape_request failed, it should
call __unregister_request avoid cause bugs, etc memleak, umount fs
failed.

Signed-off-by: Jianpeng Ma <majianpeng@gmail.com>
---
 net/ceph/osd_client.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/net/ceph/osd_client.c b/net/ceph/osd_client.c
index dd47889..6356539 100644
--- a/net/ceph/osd_client.c
+++ b/net/ceph/osd_client.c
@@ -2130,6 +2130,7 @@ int ceph_osdc_start_request(struct ceph_osd_client *osdc,
 				" will retry %lld\n", req->r_tid);
 			rc = 0;
 		}
+		__unregister_request(osdc, req);
 		goto out_unlock;
 	}
 	if (req->r_osd == NULL) {
-- 
1.8.1.2
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
