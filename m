Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756961Ab3KIRvu (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Nov 2013 12:51:50 -0500
Received: from mail-pa0-f46.google.com ([209.85.220.46]:38658 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755960Ab3KIRvQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Nov 2013 12:51:16 -0500
From: Guenter Roeck <linux@roeck-us.net>
To: Jean Delvare <khali@linux-fr.org>, Fenghua Yu <fenghua.yu@intel.com>
Cc: lm-sensors@lm-sensors.org, linux-kernel@vger.kernel.org,
        linux-pm@vger.kernel.org, Guenter Roeck <linux@roeck-us.net>
Subject: [PATCH 2/3] hwmon: (coretemp) Add PCI device ID for CE41x0 CPUs
Date: Sat,  9 Nov 2013 09:51:08 -0800
Message-Id: <1384019469-18666-2-git-send-email-linux@roeck-us.net>
X-Mailer: git-send-email 1.7.9.7
In-Reply-To: <1384019469-18666-1-git-send-email-linux@roeck-us.net>
References: <1384019469-18666-1-git-send-email-linux@roeck-us.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Since we now have to use PCI IDs to detect CPU types anyway, use this mechanism
to detect CE41x0 CPUs. Advantage is that it only requires a single entry and
covers all variants of CE41x0, including those unknown to us.

Signed-off-by: Guenter Roeck <linux@roeck-us.net>
---
 drivers/hwmon/coretemp.c |    4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/drivers/hwmon/coretemp.c b/drivers/hwmon/coretemp.c
index 5c8ab25..cde4e47 100644
--- a/drivers/hwmon/coretemp.c
+++ b/drivers/hwmon/coretemp.c
@@ -197,6 +197,7 @@ struct tjmax_pci {
 };
 
 static const struct tjmax_pci tjmax_pci_table[] __cpuinitconst = {
+	{ 0x0708, 110000 },	/* CE41x0 (Sodaville ) */
 	{ 0x0c72, 102000 },	/* Atom S1240 (Centerton) */
 	{ 0x0c73, 95000 },	/* Atom S1220 (Centerton) */
 	{ 0x0c75, 95000 },	/* Atom S1260 (Centerton) */
@@ -210,9 +211,6 @@ struct tjmax {
 static const struct tjmax tjmax_table[] = {
 	{ "CPU  230", 100000 },		/* Model 0x1c, stepping 2	*/
 	{ "CPU  330", 125000 },		/* Model 0x1c, stepping 2	*/
-	{ "CPU CE4110", 110000 },	/* Model 0x1c, stepping 10 Sodaville */
-	{ "CPU CE4150", 110000 },	/* Model 0x1c, stepping 10	*/
-	{ "CPU CE4170", 110000 },	/* Model 0x1c, stepping 10	*/
 };
 
 struct tjmax_model {
-- 
1.7.9.7

