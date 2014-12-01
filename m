Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752562AbaLAGTM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Dec 2014 01:19:12 -0500
Received: from mail-pa0-f46.google.com ([209.85.220.46]:38877 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752228AbaLAGTL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Dec 2014 01:19:11 -0500
From: sunwxg <sun.wxg@gmail.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Andreas Dilger <andreas.dilger@intel.com>,
        Amir Shehata <amir.shehata@intel.com>, Peng Tao <bergwolf@gmail.com>,
        Doug Oucharek <doug.s.oucharek@intel.com>
Cc: Sun Wang <sun.wxg@gmail.com>, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] staging:lustre:lnet: Incorrect type in assignment 
Date: Mon,  1 Dec 2014 14:18:04 +0800
Message-Id: <1417414684-9726-2-git-send-email-sun.wxg@gmail.com>
X-Mailer: git-send-email 2.1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Sun Wang <sun.wxg@gmail.com>

Incorrect type when assign value to varible iov_base.

Signed-off-by: Sun Wang <sun.wxg@gmail.com>

---
.../drivers => drivers}/staging/lustre/lnet/lnet/lib-move.c            | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/staging/lustre/lnet/lnet/lib-move.c b/drivers/staging/lustre/lnet/lnet/lib-move.c
index 4b9567d..7b22c6e 100644
--- a/drivers/staging/lustre/lnet/lnet/lib-move.c
+++ b/drivers/staging/lustre/lnet/lnet/lib-move.c
@@ -256,7 +256,8 @@ lnet_extract_iov(int dst_niov, struct iovec *dst,
 		LASSERT((int)niov <= dst_niov);
 
 		frag_len = src->iov_len - offset;
-		dst->iov_base = ((char *)src->iov_base) + offset;
+		dst->iov_base = (void __user *)
+				(((char *)src->iov_base) + offset);
 
 		if (len <= frag_len) {
 			dst->iov_len = len;
