Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753558AbaCYI0J (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Mar 2014 04:26:09 -0400
Received: from mail-pa0-f53.google.com ([209.85.220.53]:46593 "EHLO
	mail-pa0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751218AbaCYI0D (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Mar 2014 04:26:03 -0400
From: Surendra Patil <surendra.tux@gmail.com>
To: marcel@holtmann.org, gustavo@padovan.org, johan.hedberg@gmail.com
Cc: linux-bluetooth@vger.kernel.org, linux-kernel@vger.kernel.org,
        surendra.tux@gmail.com
Subject: [PATCH] drivers:bluetooth:ath3k.c: Fixed sparse warning for cast to restricted __le32
Date: Tue, 25 Mar 2014 01:25:50 -0700
Message-Id: <1395735950-17968-1-git-send-email-surendra.tux@gmail.com>
X-Mailer: git-send-email 1.8.3.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch fixes below Sparse warnings -
drivers/bluetooth/ath3k.c:370:17: warning: cast to restricted __le32
drivers/bluetooth/ath3k.c:432:17: warning: cast to restricted __le32

Signed-off-by: Surendra Patil <surendra.tux@gmail.com>
---
 drivers/bluetooth/ath3k.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/bluetooth/ath3k.c b/drivers/bluetooth/ath3k.c
index be571fe..badacbc 100644
--- a/drivers/bluetooth/ath3k.c
+++ b/drivers/bluetooth/ath3k.c
@@ -367,7 +367,7 @@ static int ath3k_load_patch(struct usb_device *udev)
 	}
 
 	snprintf(filename, ATH3K_NAME_LEN, "ar3k/AthrBT_0x%08x.dfu",
-		le32_to_cpu(fw_version.rom_version));
+		fw_version.rom_version);
 
 	ret = request_firmware(&firmware, filename, &udev->dev);
 	if (ret < 0) {
@@ -429,7 +429,7 @@ static int ath3k_load_syscfg(struct usb_device *udev)
 	}
 
 	snprintf(filename, ATH3K_NAME_LEN, "ar3k/ramps_0x%08x_%d%s",
-		le32_to_cpu(fw_version.rom_version), clk_value, ".dfu");
+		 fw_version.rom_version, clk_value, ".dfu");
 
 	ret = request_firmware(&firmware, filename, &udev->dev);
 	if (ret < 0) {
-- 
1.8.3.2

