Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752181Ab3KJSi0 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Nov 2013 13:38:26 -0500
Received: from mail-ee0-f48.google.com ([74.125.83.48]:37477 "EHLO
	mail-ee0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752019Ab3KJSh6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Nov 2013 13:37:58 -0500
From: Michal Nazarewicz <mpn@google.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Kelley Nielsen <kelleynnn@gmail.com>
Cc: Marek Belisko <marek.belisko@gmail.com>, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] staging: ft1000: fix use of potentially unitiliaside variable
Date: Sun, 10 Nov 2013 19:37:54 +0100
Message-Id: <1384108674-23434-1-git-send-email-mpn@google.com>
X-Mailer: git-send-email 1.8.4.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Michal Nazarewicz <mina86@mina86.com>

If boot_case is false, status in never assigned a value.
---
 drivers/staging/ft1000/ft1000-usb/ft1000_download.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/staging/ft1000/ft1000-usb/ft1000_download.c b/drivers/staging/ft1000/ft1000-usb/ft1000_download.c
index 68ded17..12f333f 100644
--- a/drivers/staging/ft1000/ft1000-usb/ft1000_download.c
+++ b/drivers/staging/ft1000/ft1000-usb/ft1000_download.c
@@ -578,7 +578,7 @@ static int request_code_segment(struct ft1000_usb *ft1000dev, u16 **s_file,
 		 u8 **c_file, const u8 *endpoint, bool boot_case)
 {
 	long word_length;
-	int status;
+	int status = 0;
 
 	/*DEBUG("FT1000:REQUEST_CODE_SEGMENT\n");i*/
 	word_length = get_request_value(ft1000dev);
@@ -1074,4 +1074,3 @@ int scram_dnldr(struct ft1000_usb *ft1000dev, void *pFileStart,
 
 	return status;
 }
-
-- 
1.8.3.2

