Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754788AbaHAOB4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Aug 2014 10:01:56 -0400
Received: from mail-wi0-f175.google.com ([209.85.212.175]:45323 "EHLO
	mail-wi0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754547AbaHAOBN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Aug 2014 10:01:13 -0400
From: Goffredo Baroncelli <kreijack@gmail.com>
X-Google-Original-From: Goffredo Baroncelli <kreijack@inwind.it>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: "\"" <jdelvare@suse.de>, "\"" <linux-kernel@vger.kernel.org>,
        "\"" <bryan@whatroute.net>, Goffredo Baroncelli <kreijack@inwind.it>
Subject: [PATCH 2/4] Remove attach_method because un-used
Date: Fri,  1 Aug 2014 14:00:48 +0000
Message-Id: <1406901650-20841-3-git-send-email-kreijack@inwind.it>
X-Mailer: git-send-email 2.0.1
In-Reply-To: <1406901650-20841-1-git-send-email-kreijack@inwind.it>
References: <1406901650-20841-1-git-send-email-kreijack@inwind.it>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove attach_method because i2c-powermac is
in charge to instantiate the driver directly.

Signed-off-by: Goffredo Baroncelli <kreijack@inwind.it>
---
 drivers/macintosh/therm_windtunnel.c | 35 -----------------------------------
 1 file changed, 35 deletions(-)

diff --git a/drivers/macintosh/therm_windtunnel.c b/drivers/macintosh/therm_windtunnel.c
index a64a06f..1e50455 100644
--- a/drivers/macintosh/therm_windtunnel.c
+++ b/drivers/macintosh/therm_windtunnel.c
@@ -300,40 +300,6 @@ static int control_loop(void *dummy)
 /*	i2c probing and setup						*/
 /************************************************************************/
 
-static int
-do_attach( struct i2c_adapter *adapter )
-{
-	/* scan 0x48-0x4f (DS1775) and 0x2c-2x2f (ADM1030) */
-	static const unsigned short scan_ds1775[] = {
-		0x48, 0x49, 0x4a, 0x4b, 0x4c, 0x4d, 0x4e, 0x4f,
-		I2C_CLIENT_END
-	};
-	static const unsigned short scan_adm1030[] = {
-		0x2c, 0x2d, 0x2e, 0x2f,
-		I2C_CLIENT_END
-	};
-
-	if( strncmp(adapter->name, "uni-n", 5) )
-		return 0;
-
-	if( !x.running ) {
-		struct i2c_board_info info;
-
-		memset(&info, 0, sizeof(struct i2c_board_info));
-		strlcpy(info.type, "therm_ds1775", I2C_NAME_SIZE);
-		i2c_new_probed_device(adapter, &info, scan_ds1775, NULL);
-
-		strlcpy(info.type, "therm_adm1030", I2C_NAME_SIZE);
-		i2c_new_probed_device(adapter, &info, scan_adm1030, NULL);
-
-		if( x.thermostat && x.fan ) {
-			x.running = 1;
-			x.poll_task = kthread_run(control_loop, NULL, "g4fand");
-		}
-	}
-	return 0;
-}
-
 static void
 try_start_control_loop(void)
 {
@@ -450,7 +416,6 @@ static struct i2c_driver g4fan_driver = {
 	.driver = {
 		.name	= "therm_windtunnel",
 	},
-	.attach_adapter = do_attach,
 	.probe		= do_probe,
 	.remove		= do_remove,
 	.id_table	= therm_windtunnel_id,
-- 
2.0.1

