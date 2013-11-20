Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755453Ab3KTU52 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Nov 2013 15:57:28 -0500
Received: from mail-qe0-f45.google.com ([209.85.128.45]:50173 "EHLO
	mail-qe0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755207Ab3KTU5Z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Nov 2013 15:57:25 -0500
From: "Geyslan G. Bem" <geyslan@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: kernel-br@googlegroups.com, "Geyslan G. Bem" <geyslan@gmail.com>,
        Mauro Carvalho Chehab <m.chehab@samsung.com>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Peter Senna Tschudin <peter.senna@gmail.com>,
        Ezequiel Garcia <elezegarcia@gmail.com>,
        Johannes Erdfelt <johannes@erdfelt.com>,
        linux-media@vger.kernel.org (open list:MEDIA INPUT INFRA...)
Subject: [PATCH] usb: cx231xx: Fix explicit freed pointer dereference
Date: Wed, 20 Nov 2013 17:51:23 -0300
Message-Id: <1384980697-4696-1-git-send-email-geyslan@gmail.com>
X-Mailer: git-send-email 1.8.4.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Put kfree after the 'clear_bit()' call.

Signed-off-by: Geyslan G. Bem <geyslan@gmail.com>
---
 drivers/media/usb/cx231xx/cx231xx-cards.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/usb/cx231xx/cx231xx-cards.c b/drivers/media/usb/cx231xx/cx231xx-cards.c
index e9d017b..528cce9 100644
--- a/drivers/media/usb/cx231xx/cx231xx-cards.c
+++ b/drivers/media/usb/cx231xx/cx231xx-cards.c
@@ -1412,8 +1412,8 @@ err_v4l2:
 	usb_set_intfdata(interface, NULL);
 err_if:
 	usb_put_dev(udev);
-	kfree(dev);
 	clear_bit(dev->devno, &cx231xx_devused);
+	kfree(dev);
 	return retval;
 }
 
-- 
1.8.4.2

