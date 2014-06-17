Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932457AbaFQMGe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jun 2014 08:06:34 -0400
Received: from cpsmtpb-ews01.kpnxchange.com ([213.75.39.4]:51873 "EHLO
	cpsmtpb-ews01.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752049AbaFQMGd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jun 2014 08:06:33 -0400
Message-ID: <1403006790.1984.25.camel@x220>
Subject: [PATCH] eeepc-laptop: rename _set and _get arguments in macro
From: Paul Bolle <pebolle@tiscali.nl>
To: Corentin Chary <corentin.chary@gmail.com>,
        Matthew Garrett <matthew.garrett@nebula.com>
Cc: acpi4asus-user@lists.sourceforge.net, platform-driver-x86@vger.kernel.org,
        linux-kernel@vger.kernel.org
Date: Tue, 17 Jun 2014 14:06:30 +0200
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.4 (3.10.4-2.fc20) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 17 Jun 2014 12:06:30.0978 (UTC) FILETIME=[932E6220:01CF8A24]
X-RcptDomain: vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The _set and _get arguments to the EEEPC_CREATE_SENSOR_ATTR() macro
are confusingly named: _set should be _get and vice versa. Rename these
arguments.

Drop the trailing semicolon from that macro, while we're at it.

Signed-off-by: Paul Bolle <pebolle@tiscali.nl>
---
Compile tested (I do not have this hardware).

 drivers/platform/x86/eeepc-laptop.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/platform/x86/eeepc-laptop.c b/drivers/platform/x86/eeepc-laptop.c
index 9b0c57cd1d4a..bd533c22be57 100644
--- a/drivers/platform/x86/eeepc-laptop.c
+++ b/drivers/platform/x86/eeepc-laptop.c
@@ -1053,20 +1053,20 @@ static ssize_t show_sys_hwmon(int (*get)(void), char *buf)
 	return sprintf(buf, "%d\n", get());
 }
 
-#define EEEPC_CREATE_SENSOR_ATTR(_name, _mode, _set, _get)		\
+#define EEEPC_CREATE_SENSOR_ATTR(_name, _mode, _get, _set)		\
 	static ssize_t show_##_name(struct device *dev,			\
 				    struct device_attribute *attr,	\
 				    char *buf)				\
 	{								\
-		return show_sys_hwmon(_set, buf);			\
+		return show_sys_hwmon(_get, buf);			\
 	}								\
 	static ssize_t store_##_name(struct device *dev,		\
 				     struct device_attribute *attr,	\
 				     const char *buf, size_t count)	\
 	{								\
-		return store_sys_hwmon(_get, buf, count);		\
+		return store_sys_hwmon(_set, buf, count);		\
 	}								\
-	static DEVICE_ATTR(_name, _mode, show_##_name, store_##_name);
+	static DEVICE_ATTR(_name, _mode, show_##_name, store_##_name)
 
 EEEPC_CREATE_SENSOR_ATTR(fan1_input, S_IRUGO, eeepc_get_fan_rpm, NULL);
 EEEPC_CREATE_SENSOR_ATTR(pwm1, S_IRUGO | S_IWUSR,
-- 
1.9.3

