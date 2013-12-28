Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754955Ab3L1C2Y (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Dec 2013 21:28:24 -0500
Received: from mail-pd0-f178.google.com ([209.85.192.178]:36365 "EHLO
	mail-pd0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754853Ab3L1C2X (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Dec 2013 21:28:23 -0500
From: Wenliang Fan <fanwlexca@gmail.com>
To: slava@dubeyko.com, konishi.ryusuke@lab.ntt.co.jp
Cc: linux-nilfs@vger.kernel.org, linux-kernel@vger.kernel.org,
        Wenliang Fan <fanwlexca@gmail.com>
Subject: [PATCH] fs/nilfs2: Integer overflow in nilfs_ioctl_wrap_copy()
Date: Sat, 28 Dec 2013 10:28:16 +0800
Message-Id: <1388197696-4648-1-git-send-email-fanwlexca@gmail.com>
X-Mailer: git-send-email 1.8.5.rc1.28.g7061504
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The local variable 'pos' comes from userspace. If a large number was
passed, there would be an integer overflow in the following line:
        pos += n;

Signed-off-by: Wenliang Fan <fanwlexca@gmail.com>
---
 fs/nilfs2/ioctl.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/fs/nilfs2/ioctl.c b/fs/nilfs2/ioctl.c
index b44bdb2..a260a98 100644
--- a/fs/nilfs2/ioctl.c
+++ b/fs/nilfs2/ioctl.c
@@ -65,6 +65,8 @@ static int nilfs_ioctl_wrap_copy(struct the_nilfs *nilfs,
 	ret = 0;
 	total = 0;
 	pos = argv->v_index;
+	if (pos > ULONG_MAX - argv->v_nmembs)
+		return -EINVAL;
 	for (i = 0; i < argv->v_nmembs; i += n) {
 		n = (argv->v_nmembs - i < maxmembs) ?
 			argv->v_nmembs - i : maxmembs;
-- 
1.8.5.rc1.28.g7061504

