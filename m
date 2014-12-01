Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752650AbaLAG50 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Dec 2014 01:57:26 -0500
Received: from mail-pa0-f48.google.com ([209.85.220.48]:52971 "EHLO
	mail-pa0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752247AbaLAG5Z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Dec 2014 01:57:25 -0500
From: sunwxg <sun.wxg@gmail.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Andreas Dilger <andreas.dilger@intel.com>,
        Amir Shehata <amir.shehata@intel.com>, Peng Tao <bergwolf@gmail.com>,
        Doug Oucharek <doug.s.oucharek@intel.com>
Cc: Sun Wang <sun.wxg@gmail.com>, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] staging:lustre:lnet: Incorrect type in assignment 
Date: Mon,  1 Dec 2014 14:53:52 +0800
Message-Id: <1417416832-10352-2-git-send-email-sun.wxg@gmail.com>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <1417416832-10352-1-git-send-email-sun.wxg@gmail.com>
References: <1417416832-10352-1-git-send-email-sun.wxg@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Sun Wang <sun.wxg@gmail.com>

Incorrect type when assign value to varible iov_base.

Signed-off-by: Sun Wang <sun.wxg@gmail.com>

---
 .../drivers => drivers}/staging/lustre/lnet/lnet/lib-move.c             | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/staging/lustre/lnet/lnet/lib-move.c b/drivers/staging/lustre/lnet/lnet/lib-move.c
index 4b9567d..fa29c6d 100644
--- a/drivers/staging/lustre/lnet/lnet/lib-move.c
+++ b/drivers/staging/lustre/lnet/lnet/lib-move.c
@@ -256,7 +256,7 @@ lnet_extract_iov(int dst_niov, struct iovec *dst,
 		LASSERT((int)niov <= dst_niov);
 
 		frag_len = src->iov_len - offset;
-		dst->iov_base = ((char *)src->iov_base) + offset;
+		dst->iov_base = src->iov_base + offset;
 
 		if (len <= frag_len) {
 			dst->iov_len = len;
