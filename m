Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756049AbaG3Upu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jul 2014 16:45:50 -0400
Received: from outrelay08.libero.it ([212.52.84.112]:56871 "EHLO
	outrelay08.libero.it" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751230AbaG3Upr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jul 2014 16:45:47 -0400
X-libjamoibt: 1823
Message-ID: <53D95AB8.5050501@inwind.it>
Date: Wed, 30 Jul 2014 22:51:04 +0200
From: Goffredo Baroncelli <kreijack@inwind.it>
Reply-To: kreijack@inwind.it
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.7.0
MIME-Version: 1.0
To: Jean Delvare <jdelvare@suse.de>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>
CC: LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH 2/3] therm_windtunnel doesn't work properly on PowerMac G4
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



Remove attach_method because un-used: now i2c-powermac is in charge to
instantiate the driver.

Signed-off-by: Goffredo Baroncelli <kreijack@inwind.it>

---
 drivers/macintosh/therm_windtunnel.c |   35 ----------------------------------
 1 file changed, 35 deletions(-)

diff --git a/drivers/macintosh/therm_windtunnel.c b/drivers/macintosh/therm_windtunnel.c
index 9583413..fbe4516 100644
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
@@ -442,7 +408,6 @@ static struct i2c_driver g4fan_driver = {
 	.driver = {
 		.name	= "therm_windtunnel",
 	},
-	.attach_adapter = do_attach,
 	.probe		= do_probe,
 	.remove		= do_remove,
 	.id_table	= therm_windtunnel_id,
