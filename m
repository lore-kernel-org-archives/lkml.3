Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752332AbaK3U1W (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Nov 2014 15:27:22 -0500
Received: from mail-wi0-f182.google.com ([209.85.212.182]:49638 "EHLO
	mail-wi0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752253AbaK3U1U (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Nov 2014 15:27:20 -0500
From: =?UTF-8?q?Pali=20Roh=C3=A1r?= <pali.rohar@gmail.com>
To: Guenter Roeck <linux@roeck-us.net>, Arnd Bergmann <arnd@arndb.de>,
        "Greg Kroah-Hartman" <gregkh@linuxfoundation.org>
Cc: Steven Honeyman <stevenhoneyman@gmail.com>, linux-kernel@vger.kernel.org,
        Gabriele Mazzotta <gabriele.mzt@gmail.com>,
        =?UTF-8?q?Pali=20Roh=C3=A1r?= <pali.rohar@gmail.com>
Subject: [PATCH 3/3] i8k: Return -ENODATA for invalid temperature
Date: Sun, 30 Nov 2014 21:26:18 +0100
Message-Id: <1417379178-5236-3-git-send-email-pali.rohar@gmail.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1417379178-5236-1-git-send-email-pali.rohar@gmail.com>
References: <1417379178-5236-1-git-send-email-pali.rohar@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Guenter Roeck suggested to return -ENODATA instead -ERANGE or -EINVAL when BIOS
reports invalid temperature value.

Signed-off-by: Pali Rohár <pali.rohar@gmail.com>
---
 drivers/char/i8k.c |    4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/drivers/char/i8k.c b/drivers/char/i8k.c
index 7b56ede..8c7c642 100644
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

