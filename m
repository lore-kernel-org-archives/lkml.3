Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758280AbaDBJtH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Apr 2014 05:49:07 -0400
Received: from mail-pa0-f44.google.com ([209.85.220.44]:51830 "EHLO
	mail-pa0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758042AbaDBJtF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Apr 2014 05:49:05 -0400
From: Daeseok Youn <daeseok.youn@gmail.com>
To: m.chehab@samsung.com
Cc: jarod@wilsonet.com, gregkh@linuxfoundation.org, dan.carpenter@oracle.com,
        paulmck@linux.vnet.ibm.com, mtrompou@gmail.com, bernat.ada@gmail.com,
        linux-media@vger.kernel.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] staging: lirc: remove redundant NULL check in unregister_from_lirc()
Date: Wed, 02 Apr 2014 02:49:03 -0700 (PDT)
Message-ID: <4738406.3PgrFdIbI3@daeseok-laptop.cloud.net>
User-Agent: KMail/4.8.5 (Linux/3.2.0-58-generic; KDE/4.8.5; x86_64; ; )
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


"ir" is already checked before calling unregister_from_lirc().

Signed-off-by: Daeseok Youn <daeseok.youn@gmail.com>
---
 drivers/staging/media/lirc/lirc_igorplugusb.c |    6 ------
 1 files changed, 0 insertions(+), 6 deletions(-)

diff --git a/drivers/staging/media/lirc/lirc_igorplugusb.c b/drivers/staging/media/lirc/lirc_igorplugusb.c
index f508a13..e93e1c2 100644
--- a/drivers/staging/media/lirc/lirc_igorplugusb.c
+++ b/drivers/staging/media/lirc/lirc_igorplugusb.c
@@ -222,12 +222,6 @@ static int unregister_from_lirc(struct igorplug *ir)
 	struct lirc_driver *d;
 	int devnum;
 
-	if (!ir) {
-		dev_err(&ir->usbdev->dev,
-			"%s: called with NULL device struct!\n", __func__);
-		return -EINVAL;
-	}
-
 	devnum = ir->devnum;
 	d = ir->d;
 
-- 
1.7.4.4


