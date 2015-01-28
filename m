Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753383AbbA2BNr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jan 2015 20:13:47 -0500
Received: from mail-wi0-f170.google.com ([209.85.212.170]:33145 "EHLO
	mail-wi0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752160AbbA2BNo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jan 2015 20:13:44 -0500
From: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
To: Marek Belisko <marek.belisko@gmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>,
        Julia Lawall <julia.lawall@lip6.fr>, Joe Perches <joe@perches.com>,
        Greg Donald <gdonald@gmail.com>, Josh Triplett <josh@joshtriplett.org>,
        Tapasweni Pathak <tapaswenipathak@gmail.com>,
        Chen Weixiang <weixiangchen@gmail.com>, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] staging: ft1000: ft1000-usb: ft1000_debug: Removed variables that is never used
Date: Wed, 28 Jan 2015 23:43:56 +0100
Message-Id: <1422485036-10523-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Variable ar assigned a value that is never used.
I have also removed all the code that thereby serves no purpose.

This was found using a static code analysis program called cppcheck

Signed-off-by: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
---
 drivers/staging/ft1000/ft1000-usb/ft1000_debug.c |   14 ++++++--------
 1 file changed, 6 insertions(+), 8 deletions(-)

diff --git a/drivers/staging/ft1000/ft1000-usb/ft1000_debug.c b/drivers/staging/ft1000/ft1000-usb/ft1000_debug.c
index c8d2782..c43bfdf 100644
--- a/drivers/staging/ft1000/ft1000-usb/ft1000_debug.c
+++ b/drivers/staging/ft1000/ft1000-usb/ft1000_debug.c
@@ -297,14 +297,13 @@ void ft1000_destroy_dev(struct net_device *netdev)
  */
 static int ft1000_open(struct inode *inode, struct file *file)
 {
-	struct ft1000_info *info;
 	struct ft1000_usb *dev = (struct ft1000_usb *)inode->i_private;
 	int i, num;
 
 	num = (MINOR(inode->i_rdev) & 0xf);
 	pr_debug("minor number=%d\n", num);
 
-	info = file->private_data = netdev_priv(dev->net);
+	file->private_data = netdev_priv(dev->net);
 
 	pr_debug("f_owner = %p number of application = %d\n",
 		 &file->f_owner, dev->appcnt);
@@ -531,7 +530,6 @@ static long ft1000_ioctl(struct file *file, unsigned int command,
 		u16 *pmsg;
 		u16 total_len;
 		u16 app_index;
-		u16 status;
 
 		/* pr_debug("IOCTL_FT1000_SET_DPRAM called\n");*/
 
@@ -594,22 +592,22 @@ static long ft1000_ioctl(struct file *file, unsigned int command,
 				} else {
 					/* Put message into Slow Queue */
 					/* Only put a message into the DPRAM if msg doorbell is available */
-					status = ft1000_read_register(ft1000dev, &tempword, FT1000_REG_DOORBELL);
+					ft1000_read_register(ft1000dev, &tempword, FT1000_REG_DOORBELL);
 					/* pr_debug("READ REGISTER tempword=%x\n", tempword); */
 					if (tempword & FT1000_DB_DPRAM_TX) {
 						/* Suspend for 2ms and try again due to DSP doorbell busy */
 						mdelay(2);
-						status = ft1000_read_register(ft1000dev, &tempword, FT1000_REG_DOORBELL);
+						ft1000_read_register(ft1000dev, &tempword, FT1000_REG_DOORBELL);
 						if (tempword & FT1000_DB_DPRAM_TX) {
 							/* Suspend for 1ms and try again due to DSP doorbell busy */
 							mdelay(1);
-							status = ft1000_read_register(ft1000dev, &tempword, FT1000_REG_DOORBELL);
+							ft1000_read_register(ft1000dev, &tempword, FT1000_REG_DOORBELL);
 							if (tempword & FT1000_DB_DPRAM_TX) {
-								status = ft1000_read_register(ft1000dev, &tempword, FT1000_REG_DOORBELL);
+								ft1000_read_register(ft1000dev, &tempword, FT1000_REG_DOORBELL);
 								if (tempword & FT1000_DB_DPRAM_TX) {
 									/* Suspend for 3ms and try again due to DSP doorbell busy */
 									mdelay(3);
-									status = ft1000_read_register(ft1000dev, &tempword, FT1000_REG_DOORBELL);
+									ft1000_read_register(ft1000dev, &tempword, FT1000_REG_DOORBELL);
 									if (tempword & FT1000_DB_DPRAM_TX) {
 										pr_debug("Doorbell not available\n");
 										result = -ENOTTY;
-- 
1.7.10.4

