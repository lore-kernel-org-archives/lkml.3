Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752248AbaK3U1T (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Nov 2014 15:27:19 -0500
Received: from mail-wg0-f50.google.com ([74.125.82.50]:32936 "EHLO
	mail-wg0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751909AbaK3U1Q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Nov 2014 15:27:16 -0500
From: =?UTF-8?q?Pali=20Roh=C3=A1r?= <pali.rohar@gmail.com>
To: Guenter Roeck <linux@roeck-us.net>, Arnd Bergmann <arnd@arndb.de>,
        "Greg Kroah-Hartman" <gregkh@linuxfoundation.org>
Cc: Steven Honeyman <stevenhoneyman@gmail.com>, linux-kernel@vger.kernel.org,
        Gabriele Mazzotta <gabriele.mzt@gmail.com>,
        =?UTF-8?q?Pali=20Roh=C3=A1r?= <pali.rohar@gmail.com>
Subject: [PATCH 2/3] i8k: Register only temperature sensors which have labels
Date: Sun, 30 Nov 2014 21:26:17 +0100
Message-Id: <1417379178-5236-2-git-send-email-pali.rohar@gmail.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1417379178-5236-1-git-send-email-pali.rohar@gmail.com>
References: <1417379178-5236-1-git-send-email-pali.rohar@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Detect presense of sensor by calling type function instead trying to read
temperature value. Type function is working also for sensors which are temporary
turned off (e.g on GPU which is turned off). Dell DOS binary NBSVC.MDM is doing
similar checks, so we should do that too.

Signed-off-by: Pali Rohár <pali.rohar@gmail.com>
---
 drivers/char/i8k.c |   18 +++++++++---------
 1 file changed, 9 insertions(+), 9 deletions(-)

diff --git a/drivers/char/i8k.c b/drivers/char/i8k.c
index 4be72a4..7b56ede 100644
--- a/drivers/char/i8k.c
+++ b/drivers/char/i8k.c
@@ -660,19 +660,19 @@ static int __init i8k_init_hwmon(void)
 
 	i8k_hwmon_flags = 0;
 
-	/* CPU temperature attributes, if temperature reading is OK */
-	err = i8k_get_temp(0);
-	if (err >= 0 || err == -ERANGE)
+	/* CPU temperature attributes, if temperature type is OK */
+	err = i8k_get_temp_type(0);
+	if (err >= 0)
 		i8k_hwmon_flags |= I8K_HWMON_HAVE_TEMP1;
 	/* check for additional temperature sensors */
-	err = i8k_get_temp(1);
-	if (err >= 0 || err == -ERANGE)
+	err = i8k_get_temp_type(1);
+	if (err >= 0)
 		i8k_hwmon_flags |= I8K_HWMON_HAVE_TEMP2;
-	err = i8k_get_temp(2);
-	if (err >= 0 || err == -ERANGE)
+	err = i8k_get_temp_type(2);
+	if (err >= 0)
 		i8k_hwmon_flags |= I8K_HWMON_HAVE_TEMP3;
-	err = i8k_get_temp(3);
-	if (err >= 0 || err == -ERANGE)
+	err = i8k_get_temp_type(3);
+	if (err >= 0)
 		i8k_hwmon_flags |= I8K_HWMON_HAVE_TEMP4;
 
 	/* Left fan attributes, if left fan is present */
-- 
1.7.9.5

