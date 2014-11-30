Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752406AbaK3VCJ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Nov 2014 16:02:09 -0500
Received: from bh-25.webhostbox.net ([208.91.199.152]:58685 "EHLO
	bh-25.webhostbox.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752279AbaK3VCF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Nov 2014 16:02:05 -0500
From: Guenter Roeck <linux@roeck-us.net>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Arnd Bergmann <arnd@arndb.de>, lm-sensors@lm-sensors.org,
        linux-kernel@vger.kernel.org, Guenter Roeck <linux@roeck-us.net>,
        =?UTF-8?q?Pali=20Roh=C3=A1r?= <pali.rohar@gmail.com>
Subject: [PATCH 3/3] i8k: Add support for Dell XPS 13
Date: Sun, 30 Nov 2014 13:00:40 -0800
Message-Id: <1417381240-7641-3-git-send-email-linux@roeck-us.net>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1417381240-7641-1-git-send-email-linux@roeck-us.net>
References: <1417381240-7641-1-git-send-email-linux@roeck-us.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Authenticated_sender: guenter@roeck-us.net
X-OutGoing-Spam-Status: No, score=-1.0
X-CTCH-PVer: 0000001
X-CTCH-Spam: Unknown
X-CTCH-VOD: Unknown
X-CTCH-Flags: 0
X-CTCH-RefID: str=0001.0A020202.547B85CD.0151,ss=1,re=0.001,recu=0.000,reip=0.000,cl=1,cld=1,fgs=0
X-CTCH-Score: 0.001
X-CTCH-ScoreCust: 0.000
X-CTCH-Rules: C_4847,
X-CTCH-SenderID: linux@roeck-us.net
X-CTCH-SenderID-Flags: 0
X-CTCH-SenderID-TotalMessages: 13
X-CTCH-SenderID-TotalSpam: 0
X-CTCH-SenderID-TotalSuspected: 3
X-CTCH-SenderID-TotalConfirmed: 0
X-CTCH-SenderID-TotalBulk: 0
X-CTCH-SenderID-TotalVirus: 0
X-CTCH-SenderID-TotalRecipients: 0
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - bh-25.webhostbox.net
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - roeck-us.net
X-Get-Message-Sender-Via: bh-25.webhostbox.net: mailgid no entry from get_relayhosts_entry
X-Source: 
X-Source-Args: 
X-Source-Dir: 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

XPS 13 does not support turbo speed, so its initialization data
matches that of XPS M140. Make XPS initialization data generic,
and add support for XPS 13.

Cc: Pali Rohár <pali.rohar@gmail.com>
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
---
Applies on top of Pali's patch series. 

 drivers/char/i8k.c | 14 +++++++++++---
 1 file changed, 11 insertions(+), 3 deletions(-)

diff --git a/drivers/char/i8k.c b/drivers/char/i8k.c
index cdb2dc7..6d2caa9 100644
--- a/drivers/char/i8k.c
+++ b/drivers/char/i8k.c
@@ -705,7 +705,7 @@ enum i8k_configs {
 	DELL_LATITUDE_E6540,
 	DELL_PRECISION_490,
 	DELL_STUDIO,
-	DELL_XPS_M140,
+	DELL_XPS,
 };
 
 static const struct i8k_config_data i8k_config_data[] = {
@@ -725,7 +725,7 @@ static const struct i8k_config_data i8k_config_data[] = {
 		.fan_mult = 1,
 		.fan_max = I8K_FAN_HIGH,
 	},
-	[DELL_XPS_M140] = {
+	[DELL_XPS] = {
 		.fan_mult = 1,
 		.fan_max = I8K_FAN_HIGH,
 	},
@@ -829,12 +829,20 @@ static struct dmi_system_id i8k_dmi_table[] __initdata = {
 		.driver_data = (void *)&i8k_config_data[DELL_STUDIO],
 	},
 	{
+		.ident = "Dell XPS 13",
+		.matches = {
+			DMI_MATCH(DMI_SYS_VENDOR, "Dell Inc."),
+			DMI_MATCH(DMI_PRODUCT_NAME, "XPS13"),
+		},
+		.driver_data = (void *)&i8k_config_data[DELL_XPS],
+	},
+	{
 		.ident = "Dell XPS M140",
 		.matches = {
 			DMI_MATCH(DMI_SYS_VENDOR, "Dell Inc."),
 			DMI_MATCH(DMI_PRODUCT_NAME, "MXC051"),
 		},
-		.driver_data = (void *)&i8k_config_data[DELL_XPS_M140],
+		.driver_data = (void *)&i8k_config_data[DELL_XPS],
 	},
 	{ }
 };
-- 
1.9.1

