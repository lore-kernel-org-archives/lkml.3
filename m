Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753209AbaEWKNF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 May 2014 06:13:05 -0400
Received: from mail-wg0-f42.google.com ([74.125.82.42]:51338 "EHLO
	mail-wg0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752155AbaEWKNC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 May 2014 06:13:02 -0400
From: Djordje Zekovic <dj@zeko.me>
To: gregkh@linuxfoundation.org
Cc: linux-kernel@vger.kernel.org, richard.weinberger@gmail.com,
        Djordje Zekovic <dj@zeko.me>
Subject: [PATCH] staging: usbip: use kcalloc instead of kzalloc for array allocations
Date: Fri, 23 May 2014 12:08:58 +0000
Message-Id: <1400846938-31333-1-git-send-email-dj@zeko.me>
X-Mailer: git-send-email 1.8.5.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The advantage of kcalloc is, that will prevent integer overflows which could
result from the multiplication of number of elements and size and it is also
a bit nicer to read.

Signed-off-by: Djordje Zekovic <dj@zeko.me>
---
 Fixed: Richard Weinberger <richard.weinberger@gmail.com> pointed to 
 	building issue in his review.
 drivers/staging/usbip/stub_tx.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/staging/usbip/stub_tx.c b/drivers/staging/usbip/stub_tx.c
index 1622563..f09abb2 100644
--- a/drivers/staging/usbip/stub_tx.c
+++ b/drivers/staging/usbip/stub_tx.c
@@ -179,7 +179,7 @@ static int stub_send_ret_submit(struct stub_device *sdev)
 		else
 			iovnum = 2;
 
-		iov = kzalloc(iovnum * sizeof(struct kvec), GFP_KERNEL);
+		iov = kcalloc(iovnum, sizeof(struct kvec), GFP_KERNEL);
 
 		if (!iov) {
 			usbip_event_add(&sdev->ud, SDEV_EVENT_ERROR_MALLOC);
-- 
1.8.5.2

