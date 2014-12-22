Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755896AbaLVWSm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Dec 2014 17:18:42 -0500
Received: from sauhun.de ([89.238.76.85]:53790 "EHLO pokefinder.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755880AbaLVWSj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Dec 2014 17:18:39 -0500
From: Wolfram Sang <wsa@the-dreams.de>
To: linux-kernel@vger.kernel.org
Cc: Wolfram Sang <wsa@the-dreams.de>,
        Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-media@vger.kernel.org, devel@driverdev.osuosl.org
Subject: [PATCH 2/2] staging: media: bcm2048: Remove obsolete cleanup for clientdata
Date: Mon, 22 Dec 2014 23:18:29 +0100
Message-Id: <1419286710-9991-2-git-send-email-wsa@the-dreams.de>
X-Mailer: git-send-email 2.1.3
In-Reply-To: <1419286710-9991-1-git-send-email-wsa@the-dreams.de>
References: <1419286710-9991-1-git-send-email-wsa@the-dreams.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

A few new i2c-drivers came into the kernel which clear the clientdata-pointer
on exit or error. This is obsolete meanwhile, the core will do it.

Signed-off-by: Wolfram Sang <wsa@the-dreams.de>
---
 drivers/staging/media/bcm2048/radio-bcm2048.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/staging/media/bcm2048/radio-bcm2048.c b/drivers/staging/media/bcm2048/radio-bcm2048.c
index 60a57b2a8fb2..4d5e2f400ff6 100644
--- a/drivers/staging/media/bcm2048/radio-bcm2048.c
+++ b/drivers/staging/media/bcm2048/radio-bcm2048.c
@@ -2699,8 +2699,6 @@ static int __exit bcm2048_i2c_driver_remove(struct i2c_client *client)
 		kfree(bdev);
 	}
 
-	i2c_set_clientdata(client, NULL);
-
 	return 0;
 }
 
-- 
2.1.3

