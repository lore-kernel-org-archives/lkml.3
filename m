Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751663AbaJPHYD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Oct 2014 03:24:03 -0400
Received: from mail1.bemta14.messagelabs.com ([193.109.254.108]:27422 "EHLO
	mail1.bemta14.messagelabs.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751632AbaJPHYB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Oct 2014 03:24:01 -0400
X-Env-Sender: Andreas.Werner@men.de
X-Msg-Ref: server-3.tower-194.messagelabs.com!1413444237!19546310!1
X-Originating-IP: [80.255.6.145]
X-StarScan-Received: 
X-StarScan-Version: 6.12.3; banners=-,-,-
X-VirusChecked: Checked
X-PGP-Universal: processed;
	by keys.men.de on Thu, 16 Oct 2014 09:23:57 +0200
Date: Thu, 16 Oct 2014 10:15:27 +0200
From: Andreas Werner <andreas.werner@men.de>
To: <gregkh@linuxfoundation.org>
CC: <linux-kernel@vger.kernel.org>, <wsa@the-dreams.de>,
        <linux-i2c@vger.kernel.org>, <johannes.thumshirn@men.de>,
        <andreas.werner@men.de>
Subject: [PATCH 2/2] Documentation/ABI/testing/men_eeprod: Added sysfs
 description for men_eeprod
Message-ID: <dd7d012a2067068570c000fa85eb1760097baa92.1413416105.git.andreas.werner@men.de>
References: <cover.1413416105.git.andreas.werner@men.de>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <cover.1413416105.git.andreas.werner@men.de>
User-Agent: Mutt/1.5.23 (2014-03-12)
X-Originating-IP: [192.1.1.171]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds the description for the men_eeprod.
men_eeprod is a driver for the MEN Board Information EEPROM which
exports the data using sysfs entries.

Signed-off-by: Andreas Werner <andreas.werner@men.de>
---
 .../ABI/testing/sysfs-bus-i2c-devices-men_eeprod   | 69 ++++++++++++++++++++++
 1 file changed, 69 insertions(+)
 create mode 100644 Documentation/ABI/testing/sysfs-bus-i2c-devices-men_eeprod

diff --git a/Documentation/ABI/testing/sysfs-bus-i2c-devices-men_eeprod b/Documentation/ABI/testing/sysfs-bus-i2c-devices-men_eeprod
new file mode 100644
index 0000000..a488d0e
--- /dev/null
+++ b/Documentation/ABI/testing/sysfs-bus-i2c-devices-men_eeprod
@@ -0,0 +1,69 @@
+What:		/sys/bus/i2c/devices/i2c-<busnr>/<busnr>-<devaddr>/eeprod_id
+Date:		October 2014
+Contact:	Andreas Werner <andreas.werner@men.de>
+Description:
+		Show the identifier of the EEPROM structure.
+		There are different layouts of the EEPROM with more or less
+		information. The ID identifies each of the layouts.
+
+		Currently supported structure is EEPROD2 (0x0E)
+
+What:		/sys/bus/i2c/devices/i2c-<busnr>/<busnr>-<devaddr>/revision
+Date:		October 2014
+Contact:	Andreas Werner <andreas.werner@men.de>
+Description:
+		Show the revision of the board.
+		Format of the revision field is XX.XX.XX
+
+What:		/sys/bus/i2c/devices/i2c-<busnr>/<busnr>-<devaddr>/serialnr
+Date:		October 2014
+Contact:	Andreas Werner <andreas.werner@men.de>
+Description:
+		Show the serialnumber of the board. The serial number is
+		a decimal number.
+
+What:		/sys/bus/i2c/devices/i2c-<busnr>/<busnr>-<devaddr>/hw_name
+Date:		October 2014
+Contact:	Andreas Werner <andreas.werner@men.de>
+Description:
+		Show the name of the board including the model.
+		There are boards which have different features such as
+		different size of RAM, the model identifies the different
+		types.
+
+		Format of the hw_name is: <name><model>.
+		Example: F075P00 where F75P is the hw_name and 00 the model.
+
+What:		/sys/bus/i2c/devices/i2c-<busnr>/<busnr>-<devaddr>/prod_date
+Date:		October 2014
+Contact:	Andreas Werner <andreas.werner@men.de>
+Description:
+		Show the board production date.
+
+		Format of the date: YYYY-MM-DD
+
+What:		/sys/bus/i2c/devices/i2c-<busnr>/<busnr>-<devaddr>/rep_date
+Date:		October 2014
+Contact:	Andreas Werner <andreas.werner@men.de>
+Description:
+		Show the last repair date.
+		If the board returns back to the repair department, this field
+		will be programmed with the current date.
+		If the board has never returned, the field will be empty and
+		the read access to this sysfs entry returns -EINVAL.
+
+		Format of the date: YYYY-MM-DD
+
+What:		/sys/bus/i2c/devices/i2c-<busnr>/<busnr>-<devaddr>/user_section
+Date:		October 2014
+Contact:	Andreas Werner <andreas.werner@men.de>
+Description:
+		Read or write access to the user section of the EEPROM
+		This sysfs entry is a binary file where customer can write
+		there own data to.
+		The size of this file depends on the EEPROM layout which is
+		identified by the eeprod_id.
+
+		eeprod_id	user_section size
+		---------------------------------
+		0x0E		232 byte
-- 
2.1.0

