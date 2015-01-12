Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752646AbbALNlH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jan 2015 08:41:07 -0500
Received: from mail-we0-f172.google.com ([74.125.82.172]:39064 "EHLO
	mail-we0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750860AbbALNlF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jan 2015 08:41:05 -0500
From: =?UTF-8?q?Pali=20Roh=C3=A1r?= <pali.rohar@gmail.com>
To: Guenter Roeck <linux@roeck-us.net>, Arnd Bergmann <arnd@arndb.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Steven Honeyman <stevenhoneyman@gmail.com>,
        Jean Delvare <jdelvare@suse.de>,
        Gabriele Mazzotta <gabriele.mzt@gmail.com>,
        Jochen Eisinger <jochen@penguin-breeder.org>, Valdis.Kletnieks@vt.edu,
        linux-kernel@vger.kernel.org,
        =?UTF-8?q?Pali=20Roh=C3=A1r?= <pali.rohar@gmail.com>
Subject: [PATCH 3/9] i8k: Return -ENODATA for invalid temperature
Date: Mon, 12 Jan 2015 14:31:59 +0100
Message-Id: <1421069525-12875-4-git-send-email-pali.rohar@gmail.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1421069525-12875-1-git-send-email-pali.rohar@gmail.com>
References: <1421069525-12875-1-git-send-email-pali.rohar@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Guenter Roeck suggested to return -ENODATA instead -ERANGE or -EINVAL when BIOS
reports invalid temperature value.

Signed-off-by: Pali Rohár <pali.rohar@gmail.com>
Reviewed-by: Guenter Roeck <linux@roeck-us.net>
Tested-by: Guenter Roeck <linux@roeck-us.net>
---
 drivers/char/i8k.c |    4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/drivers/char/i8k.c b/drivers/char/i8k.c
index afcc9fe..1854fab 100644
--- a/drivers/char/i8k.c
+++ b/drivers/char/i8k.c
@@ -331,7 +331,7 @@ static int i8k_get_temp(int sensor)
 		prev[sensor] = temp;
 	}
 	if (temp > I8K_MAX_TEMP)
-		return -ERANGE;
+		return -ENODATA;
 #endif
 
 	return temp;
@@ -533,8 +533,6 @@ static ssize_t i8k_hwmon_show_temp(struct device *dev,
 	int temp;
 
 	temp = i8k_get_temp(index);
-	if (temp == -ERANGE)
-		return -EINVAL;
 	if (temp < 0)
 		return temp;
 	return sprintf(buf, "%d\n", temp * 1000);
-- 
1.7.9.5

