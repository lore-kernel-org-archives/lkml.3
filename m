Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752046AbaCZGgq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Mar 2014 02:36:46 -0400
Received: from mail-pd0-f173.google.com ([209.85.192.173]:38655 "EHLO
	mail-pd0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750991AbaCZGgn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Mar 2014 02:36:43 -0400
From: Surendra Patil <surendra.tux@gmail.com>
To: marcel@holtmann.org, gustavo@padovan.org, johan.hedberg@gmail.com,
        joe@perches.com
Cc: linux-bluetooth@vger.kernel.org, linux-kernel@vger.kernel.org,
        surendra.tux@gmail.com
Subject: [PATCH] drivers:bluetooth:ath3k.c Fixed sparse warning for cast to restricted __le32
Date: Tue, 25 Mar 2014 23:36:28 -0700
Message-Id: <1395815788-24666-1-git-send-email-surendra.tux@gmail.com>
X-Mailer: git-send-email 1.8.3.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

 To fix the sparse warning "cast to restricted __le32" marked
 "rom_version"  to __le32 instead of unsigned int in "struct ath3k_version"
 and added cpu_to_le32() for the expression assigning int value to "rom_version".
 Successfully built the module without warnings and errors on x86 machine with sparse.

Signed-off-by: Surendra Patil <surendra.tux@gmail.com>
---
 drivers/bluetooth/ath3k.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/bluetooth/ath3k.c b/drivers/bluetooth/ath3k.c
index be571fe..5564207 100644
--- a/drivers/bluetooth/ath3k.c
+++ b/drivers/bluetooth/ath3k.c
@@ -50,7 +50,7 @@
 #define ATH3K_NAME_LEN				0xFF
 
 struct ath3k_version {
-	unsigned int	rom_version;
+	__le32		rom_version;
 	unsigned int	build_version;
 	unsigned int	ram_version;
 	unsigned char	ref_clock;
@@ -375,7 +375,7 @@ static int ath3k_load_patch(struct usb_device *udev)
 		return ret;
 	}
 
-	pt_version.rom_version = *(int *)(firmware->data + firmware->size - 8);
+	pt_version.rom_version = cpu_to_le32(*(int *)(firmware->data + firmware->size - 8));
 	pt_version.build_version = *(int *)
 		(firmware->data + firmware->size - 4);
 
-- 
1.8.3.2

