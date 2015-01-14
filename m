Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752406AbbANS7x (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jan 2015 13:59:53 -0500
Received: from mail-ob0-f176.google.com ([209.85.214.176]:45582 "EHLO
	mail-ob0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751696AbbANS7v (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jan 2015 13:59:51 -0500
From: Azael Avalos <coproscefalo@gmail.com>
To: Darren Hart <dvhart@infradead.org>, platform-driver-x86@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc: Azael Avalos <coproscefalo@gmail.com>
Subject: [PATCH] toshiba_acpi: Change sci_open function return value
Date: Wed, 14 Jan 2015 11:59:32 -0700
Message-Id: <1421261972-3130-1-git-send-email-coproscefalo@gmail.com>
X-Mailer: git-send-email 2.2.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Some Toshiba laptops have "poorly implemented" SCI calls on their
BIOSes and are not checking for sci_{open, close} calls, therefore,
the sci_open function is failing and making some of the supported
features unavailable (kbd backlight, touchpad and illumination).

This patch changes the default return code of the sci_open function
to return one instead of zero, making all those faulty laptops load
all the supported features.

Signed-off-by: Azael Avalos <coproscefalo@gmail.com>
---
 drivers/platform/x86/toshiba_acpi.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/platform/x86/toshiba_acpi.c b/drivers/platform/x86/toshiba_acpi.c
index fc34a71..71ac7c12 100644
--- a/drivers/platform/x86/toshiba_acpi.c
+++ b/drivers/platform/x86/toshiba_acpi.c
@@ -391,9 +391,10 @@ static int sci_open(struct toshiba_acpi_dev *dev)
 		return 1;
 	} else if (out[0] == TOS_NOT_PRESENT) {
 		pr_info("Toshiba SCI is not present\n");
+		return 0;
 	}
 
-	return 0;
+	return 1;
 }
 
 static void sci_close(struct toshiba_acpi_dev *dev)
-- 
2.2.1

