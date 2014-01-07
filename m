Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756083AbaAGI4i (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Jan 2014 03:56:38 -0500
Received: from mail-bk0-f43.google.com ([209.85.214.43]:61712 "EHLO
	mail-bk0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751262AbaAGI4h (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Jan 2014 03:56:37 -0500
MIME-Version: 1.0
Date: Tue, 7 Jan 2014 16:56:35 +0800
Message-ID: <CAPgLHd9DJxmadJQb_0-J_2DZ1aVpOZ65J4iVCid-tJ=OLmKBNA@mail.gmail.com>
Subject: [PATCH -next] misc: genwqe: fix return value check in genwqe_device_create()
From: Wei Yongjun <weiyj.lk@gmail.com>
To: haver@linux.vnet.ibm.com, gregkh@linuxfoundation.org
Cc: yongjun_wei@trendmicro.com.cn, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Wei Yongjun <yongjun_wei@trendmicro.com.cn>

In case of error, the function device_create_with_groups()
returns ERR_PTR() and never returns NULL. The NULL test in
the return value check should be replaced with IS_ERR().

Signed-off-by: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
---
 drivers/misc/genwqe/card_dev.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/misc/genwqe/card_dev.c b/drivers/misc/genwqe/card_dev.c
index 9b231bb..46fa2ca 100644
--- a/drivers/misc/genwqe/card_dev.c
+++ b/drivers/misc/genwqe/card_dev.c
@@ -1378,8 +1378,8 @@ int genwqe_device_create(struct genwqe_dev *cd)
 					    genwqe_attribute_groups,
 					    GENWQE_DEVNAME "%u_card",
 					    cd->card_idx);
-	if (cd->dev == NULL) {
-		rc = -ENODEV;
+	if (IS_ERR(cd->dev)) {
+		rc = PTR_ERR(cd->dev);
 		goto err_cdev;
 	}
 

