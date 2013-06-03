Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756733Ab3FCCIU (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Jun 2013 22:08:20 -0400
Received: from mail-bk0-f50.google.com ([209.85.214.50]:32860 "EHLO
	mail-bk0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755945Ab3FCCIO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Jun 2013 22:08:14 -0400
MIME-Version: 1.0
Date: Mon, 3 Jun 2013 10:08:13 +0800
Message-ID: <CAPgLHd9+Mgh9pz2Y2dAc_9pQ=1LZ8_+hLV9UL=8AeiozLBHjZQ@mail.gmail.com>
Subject: [PATCH -next] staging/lustre: fix return value check in libcfs_sock_ioctl()
From: Wei Yongjun <weiyj.lk@gmail.com>
To: gregkh@linuxfoundation.org, andreas.dilger@intel.com, tao.peng@emc.com
Cc: yongjun_wei@trendmicro.com.cn, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Wei Yongjun <yongjun_wei@trendmicro.com.cn>

In case of error, the function sock_alloc_file() returns ERR_PTR()
and never returns NULL. The NULL test in the return value check
should be replaced with IS_ERR().

Signed-off-by: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
---
no compile test
---
 drivers/staging/lustre/lustre/libcfs/linux/linux-tcpip.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/lustre/lustre/libcfs/linux/linux-tcpip.c b/drivers/staging/lustre/lustre/libcfs/linux/linux-tcpip.c
index 6f1f047..855c7e8 100644
--- a/drivers/staging/lustre/lustre/libcfs/linux/linux-tcpip.c
+++ b/drivers/staging/lustre/lustre/libcfs/linux/linux-tcpip.c
@@ -59,9 +59,9 @@ libcfs_sock_ioctl(int cmd, unsigned long arg)
 	}
 
 	sock_filp = sock_alloc_file(sock, 0, NULL);
-	if (!sock_filp) {
+	if (IS_ERR(sock_filp)) {
 		sock_release(sock);
-		rc = -ENOMEM;
+		rc = PTR_ERR(sock_filp);
 		goto out;
 	}
 

