Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754701Ab3GDNne (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Jul 2013 09:43:34 -0400
Received: from mail-bk0-f53.google.com ([209.85.214.53]:63126 "EHLO
	mail-bk0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751468Ab3GDNnd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Jul 2013 09:43:33 -0400
MIME-Version: 1.0
Date: Thu, 4 Jul 2013 21:43:32 +0800
Message-ID: <CAPgLHd-GqFRjqWyM-hef+iUz+ioHY2DrV=SFZn4PN3GjeMSdwQ@mail.gmail.com>
Subject: [PATCH] ncpfs: fix error return code in ncp_parse_options()
From: Wei Yongjun <weiyj.lk@gmail.com>
To: petr@vandrovec.name, viro@zeniv.linux.org.uk, ebiederm@xmission.com,
        serge.hallyn@canonical.com, akpm@linux-foundation.org,
        marco.stornelli@gmail.com
Cc: yongjun_wei@trendmicro.com.cn, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Wei Yongjun <yongjun_wei@trendmicro.com.cn>

Fix to return -EINVAL from the option parse error handling
case instead of 0, as done elsewhere in this function.

Signed-off-by: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
---
 fs/ncpfs/inode.c | 12 +++++++++---
 1 file changed, 9 insertions(+), 3 deletions(-)

diff --git a/fs/ncpfs/inode.c b/fs/ncpfs/inode.c
index 26910c8..cb0e9db 100644
--- a/fs/ncpfs/inode.c
+++ b/fs/ncpfs/inode.c
@@ -403,18 +403,24 @@ static int ncp_parse_options(struct ncp_mount_data_kernel *data, char *options)
 		switch (optval) {
 			case 'u':
 				data->uid = make_kuid(current_user_ns(), optint);
-				if (!uid_valid(data->uid))
+				if (!uid_valid(data->uid)) {
+					ret = -EINVAL;
 					goto err;
+				}
 				break;
 			case 'g':
 				data->gid = make_kgid(current_user_ns(), optint);
-				if (!gid_valid(data->gid))
+				if (!gid_valid(data->gid)) {
+					ret = -EINVAL;
 					goto err;
+				}
 				break;
 			case 'o':
 				data->mounted_uid = make_kuid(current_user_ns(), optint);
-				if (!uid_valid(data->mounted_uid))
+				if (!uid_valid(data->mounted_uid)) {
+					ret = -EINVAL;
 					goto err;
+				}
 				break;
 			case 'm':
 				data->file_mode = optint;

