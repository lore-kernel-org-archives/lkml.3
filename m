Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934460AbaE3WUj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 May 2014 18:20:39 -0400
Received: from mail.ispras.ru ([83.149.199.45]:41898 "EHLO mail.ispras.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754614AbaE3WUi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 May 2014 18:20:38 -0400
From: Alexey Khoroshilov <khoroshilov@ispras.ru>
To: Huang Shijie <shijie8@gmail.com>, Hans Verkuil <hverkuil@xs4all.nl>,
        Carvalho Chehab <m.chehab@samsung.com>
Cc: Alexey Khoroshilov <khoroshilov@ispras.ru>, linux-media@vger.kernel.org,
        linux-kernel@vger.kernel.org, ldv-project@linuxtesting.org
Subject: [PATCH] [media] tlg2300: fix leak at failure path in poseidon_probe()
Date: Sat, 31 May 2014 02:20:11 +0400
Message-Id: <1401488411-22458-1-git-send-email-khoroshilov@ispras.ru>
X-Mailer: git-send-email 1.8.3.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Error handling code in poseidon_probe() misses usb_put_intf()
and usb_put_dev().

Found by Linux Driver Verification project (linuxtesting.org).

Signed-off-by: Alexey Khoroshilov <khoroshilov@ispras.ru>
---
 drivers/media/usb/tlg2300/pd-main.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/media/usb/tlg2300/pd-main.c b/drivers/media/usb/tlg2300/pd-main.c
index 3316caa4733b..b31f4791b8ff 100644
--- a/drivers/media/usb/tlg2300/pd-main.c
+++ b/drivers/media/usb/tlg2300/pd-main.c
@@ -476,6 +476,8 @@ err_audio:
 err_video:
 	v4l2_device_unregister(&pd->v4l2_dev);
 err_v4l2:
+	usb_put_intf(pd->interface);
+	usb_put_dev(pd->udev);
 	kfree(pd);
 	return ret;
 }
-- 
1.8.3.2

