Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752137AbaEGGBh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 May 2014 02:01:37 -0400
Received: from mail-pa0-f46.google.com ([209.85.220.46]:51826 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750709AbaEGGBf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 May 2014 02:01:35 -0400
Date: Wed, 7 May 2014 15:01:04 +0900
From: Daeseok Youn <daeseok.youn@gmail.com>
To: gregkh@linuxfoundation.org
Cc: lisa@xenapiadmin.com, gokul.linux@gmail.com, daeseok.youn@gmail.com,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: [PATCH] staging: bcm: use kzalloc instead of kmalloc/memset
Message-ID: <20140507060104.GA25230@devel.8.8.4.4>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-12-10)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Daeseok Youn <daeseok.youn@gmail.com>
---
 drivers/staging/bcm/InterfaceDld.c |    6 ++----
 1 files changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/staging/bcm/InterfaceDld.c b/drivers/staging/bcm/InterfaceDld.c
index 005e460..e1925bd 100644
--- a/drivers/staging/bcm/InterfaceDld.c
+++ b/drivers/staging/bcm/InterfaceDld.c
@@ -53,8 +53,8 @@ int InterfaceFileReadbackFromChip(PVOID arg, struct file *flp,
 	struct bcm_interface_adapter *psIntfAdapter = arg;
 	int bytes;
 
-	buff = kmalloc(MAX_TRANSFER_CTRL_BYTE_USB, GFP_DMA);
-	buff_readback = kmalloc(MAX_TRANSFER_CTRL_BYTE_USB , GFP_DMA);
+	buff = kzalloc(MAX_TRANSFER_CTRL_BYTE_USB, GFP_DMA);
+	buff_readback = kzalloc(MAX_TRANSFER_CTRL_BYTE_USB , GFP_DMA);
 	if (!buff || !buff_readback) {
 		kfree(buff);
 		kfree(buff_readback);
@@ -64,8 +64,6 @@ int InterfaceFileReadbackFromChip(PVOID arg, struct file *flp,
 
 	is_config_file = (on_chip_loc == CONFIG_BEGIN_ADDR) ? 1 : 0;
 
-	memset(buff_readback, 0, MAX_TRANSFER_CTRL_BYTE_USB);
-	memset(buff, 0, MAX_TRANSFER_CTRL_BYTE_USB);
 	while (1) {
 		oldfs = get_fs();
 		set_fs(get_ds());
-- 
1.7.1

