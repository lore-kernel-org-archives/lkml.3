Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758134AbaDBIT1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Apr 2014 04:19:27 -0400
Received: from mail-pa0-f41.google.com ([209.85.220.41]:43392 "EHLO
	mail-pa0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758038AbaDBISn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Apr 2014 04:18:43 -0400
From: Daeseok Youn <daeseok.youn@gmail.com>
To: m.chehab@samsung.com
Cc: gregkh@linuxfoundation.org, jarod@wilsonet.com, dan.carpenter@oracle.com,
        paulmck@linux.vnet.ibm.com, mtrompou@gmail.com, bernat.ada@gmail.com,
        linux-media@vger.kernel.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] staging: lirc: fix NULL pointer dereference
Date: Wed, 02 Apr 2014 17:18:39 +0900
Message-ID: <1671118.MbmRfxWPeo@daeseok-laptop.cloud.net>
User-Agent: KMail/4.8.5 (Linux/3.2.0-58-generic; KDE/4.8.5; x86_64; ; )
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


coccicheck says:
 drivers/staging/media/lirc/lirc_igorplugusb.c:226:15-21:
ERROR: ir is NULL but dereferenced.

Signed-off-by: Daeseok Youn <daeseok.youn@gmail.com>
---
 drivers/staging/media/lirc/lirc_igorplugusb.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/media/lirc/lirc_igorplugusb.c b/drivers/staging/media/lirc/lirc_igorplugusb.c
index f508a13..0ef393b 100644
--- a/drivers/staging/media/lirc/lirc_igorplugusb.c
+++ b/drivers/staging/media/lirc/lirc_igorplugusb.c
@@ -223,8 +223,8 @@ static int unregister_from_lirc(struct igorplug *ir)
 	int devnum;
 
 	if (!ir) {
-		dev_err(&ir->usbdev->dev,
-			"%s: called with NULL device struct!\n", __func__);
+		printk(DRIVER_NAME "%s: called with NULL device struct!\n",
+		       __func__);
 		return -EINVAL;
 	}
 
-- 
1.7.4.4


