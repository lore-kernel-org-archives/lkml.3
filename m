Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752466AbaIAAYY (ORCPT <rfc822;w@1wt.eu>);
	Sun, 31 Aug 2014 20:24:24 -0400
Received: from mail-yk0-f173.google.com ([209.85.160.173]:49480 "EHLO
	mail-yk0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752177AbaIAAYX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 31 Aug 2014 20:24:23 -0400
From: Greg Donald <gdonald@gmail.com>
To: Greg Kroah-Hartman <greg@kroah.com>, linux-kernel@vger.kernel.org
Cc: Marek Belisko <marek.belisko@gmail.com>, Greg Donald <gdonald@gmail.com>
Subject: [PATCH] drivers: staging: ft1000: Fix return is not a function, parentheses are not required errors
Date: Sun, 31 Aug 2014 19:22:59 -0500
Message-Id: <1409530979-19049-1-git-send-email-gdonald@gmail.com>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix checkpatch.pl return is not a function, parentheses are not required errors

Signed-off-by: Greg Donald <gdonald@gmail.com>
---
 drivers/staging/ft1000/ft1000-pcmcia/ft1000_hw.c | 9 +++++----
 drivers/staging/ft1000/ft1000-usb/ft1000_debug.c | 2 +-
 2 files changed, 6 insertions(+), 5 deletions(-)

diff --git a/drivers/staging/ft1000/ft1000-pcmcia/ft1000_hw.c b/drivers/staging/ft1000/ft1000-pcmcia/ft1000_hw.c
index 21f09fe..a92bce8 100644
--- a/drivers/staging/ft1000/ft1000-pcmcia/ft1000_hw.c
+++ b/drivers/staging/ft1000/ft1000-pcmcia/ft1000_hw.c
@@ -125,7 +125,7 @@ u16 ft1000_read_dpram(struct net_device *dev, int offset)
 	data = ft1000_read_reg(dev, FT1000_REG_DPRAM_DATA);
 	spin_unlock_irqrestore(&info->dpram_lock, flags);
 
-	return (data);
+	return data;
 }
 
 /*---------------------------------------------------------------------------
@@ -183,7 +183,7 @@ u16 ft1000_read_dpram_mag_16(struct net_device *dev, int offset, int Index)
 	}
 	spin_unlock_irqrestore(&info->dpram_lock, flags);
 
-	return (data);
+	return data;
 }
 
 /*---------------------------------------------------------------------------
@@ -240,7 +240,7 @@ u32 ft1000_read_dpram_mag_32(struct net_device *dev, int offset)
 	data = inl(dev->base_addr + FT1000_REG_MAG_DPDATAL);
 	spin_unlock_irqrestore(&info->dpram_lock, flags);
 
-	return (data);
+	return data;
 }
 
 /*---------------------------------------------------------------------------
@@ -1922,7 +1922,8 @@ static int ft1000_copy_down_pkt(struct net_device *dev, u16 * packet, u16 len)
 static struct net_device_stats *ft1000_stats(struct net_device *dev)
 {
 	struct ft1000_info *info = netdev_priv(dev);
-	return (&info->stats);
+
+	return &info->stats;
 }
 
 static int ft1000_open(struct net_device *dev)
diff --git a/drivers/staging/ft1000/ft1000-usb/ft1000_debug.c b/drivers/staging/ft1000/ft1000-usb/ft1000_debug.c
index 9f4c785..0f347ab 100644
--- a/drivers/staging/ft1000/ft1000-usb/ft1000_debug.c
+++ b/drivers/staging/ft1000/ft1000-usb/ft1000_debug.c
@@ -390,7 +390,7 @@ static unsigned int ft1000_poll_dev(struct file *file, poll_table *wait)
     poll_wait(file, &dev->app_info[i].wait_dpram_msg, wait);
     /* DEBUG("FT1000:ft1000_poll_dev:Polling for data from DSP\n"); */
 
-    return (0);
+	return 0;
 }
 
 /*
-- 
1.9.1

