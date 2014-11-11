Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751652AbaKKNZ0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Nov 2014 08:25:26 -0500
Received: from mail-wi0-f180.google.com ([209.85.212.180]:62185 "EHLO
	mail-wi0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751435AbaKKNZY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Nov 2014 08:25:24 -0500
Message-ID: <54620E58.4050207@gmail.com>
Date: Tue, 11 Nov 2014 14:25:44 +0100
From: Goffredo Baroncelli <kreijack@gmail.com>
Reply-To: kreijack@inwind.it
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Icedove/31.2.0
MIME-Version: 1.0
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
CC: LKML <linux-kernel@vger.kernel.org>, Jean Delvare <jdelvare@suse.de>,
        Guenter Roeck <linux@roeck-us.net>,
        Goffredo Baroncelli <kreijack@inwind.it>
Subject: [RESEND][PATCH 2/5] Remove attach_method because un-used
References: <1407567003-18332-1-git-send-email-kreijack@inwind.it>
In-Reply-To: <1407567003-18332-1-git-send-email-kreijack@inwind.it>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
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
2.1.0.rc1


