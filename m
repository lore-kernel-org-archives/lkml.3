Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933246Ab3CLSkH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Mar 2013 14:40:07 -0400
Received: from casper.infradead.org ([85.118.1.10]:57927 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932465Ab3CLSkG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Mar 2013 14:40:06 -0400
Message-ID: <513F769D.6040306@infradead.org>
Date: Tue, 12 Mar 2013 11:40:29 -0700
From: Randy Dunlap <rdunlap@infradead.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130215 Thunderbird/17.0.3
MIME-Version: 1.0
To: Geert Uytterhoeven <geert@linux-m68k.org>
CC: Linux Kernel Development <linux-kernel@vger.kernel.org>,
        Janne Grunau <j@jannau.net>, linux-media <linux-media@vger.kernel.org>,
        Mauro Carvalho Chehab <mchehab@redhat.com>,
        Hans Verkuil <hans.verkuil@cisco.com>
Subject: [PATCH] media: fix hdpvr build warning
References: <alpine.DEB.2.00.1303112254140.16847@ayla.of.borg>
In-Reply-To: <alpine.DEB.2.00.1303112254140.16847@ayla.of.borg>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Randy Dunlap <rdunlap@infradead.org>

Fix build warning in hdpvr:

drivers/media/usb/hdpvr/hdpvr-video.c: warning: "CONFIG_I2C_MODULE" is not defined [-Wundef]

Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
Reported-by: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Janne Grunau <j@jannau.net>
---
 drivers/media/usb/hdpvr/hdpvr-video.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- lnx-39-rc2.orig/drivers/media/usb/hdpvr/hdpvr-video.c
+++ lnx-39-rc2/drivers/media/usb/hdpvr/hdpvr-video.c
@@ -1238,7 +1238,7 @@ static void hdpvr_device_release(struct
 	v4l2_device_unregister(&dev->v4l2_dev);
 
 	/* deregister I2C adapter */
-#if defined(CONFIG_I2C) || (CONFIG_I2C_MODULE)
+#if defined(CONFIG_I2C) || defined(CONFIG_I2C_MODULE)
 	mutex_lock(&dev->i2c_mutex);
 	i2c_del_adapter(&dev->i2c_adapter);
 	mutex_unlock(&dev->i2c_mutex);
