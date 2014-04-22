Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758467AbaDVUje (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Apr 2014 16:39:34 -0400
Received: from mail-ee0-f47.google.com ([74.125.83.47]:56307 "EHLO
	mail-ee0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758446AbaDVUja (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Apr 2014 16:39:30 -0400
Message-ID: <5356D37E.4040306@gmail.com>
Date: Tue, 22 Apr 2014 22:39:26 +0200
From: poma <pomidorabelisima@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: Linux Kernel list <linux-kernel@vger.kernel.org>
CC: AceLan Kao <acelan.kao@canonical.com>,
        Matthew Garrett <matthew.garrett@nebula.com>,
        Corentin Chary <corentin.chary@gmail.com>
Subject: asus-nb-wmi: set wapf=4 for ASUSTeK COMPUTER INC. X75VBP
Content-Type: multipart/mixed;
 boundary="------------010703080304000609090204"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------010703080304000609090204
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit


Ahoy!

Need to set wapf to 4 for ASUSTeK COMPUTER INC. X75VBP, so that
the device is enabled.

The corresponding /sys/class/dmi/id/* values via dmesg:
DMI: ASUSTeK COMPUTER INC. X75VBP/X75VBP, BIOS X75VBP.304 06/04/2013

Tested with WAPF values 0, 1 and 4.
The values 1 and 4 have the same effect regarding wireless network
adapter enablement.
A value of 0 has no effect.
The corresponding command line:
Kernel command line: BOOT_IMAGE=/isolinux/vmlinuz0
root=live:LABEL=Fedora-Live-Xfce-x86_64-rawhide- ro rd.live.image
selinux=0 biosdevname=0 asus-nb-wmi.wapf=4

rfkill list - vulgaris:
1: asus-wlan: Wireless LAN
	Soft blocked: no
	Hard blocked: no
2: asus-bluetooth: Bluetooth
	Soft blocked: no
	Hard blocked: no
3: phy0: Wireless LAN
	Soft blocked: no
	Hard blocked: yes
4: hci0: Bluetooth
	Soft blocked: no
	Hard blocked: no

rfkill list - asus-nb-wmi.wapf=1,
              asus-nb-wmi.wapf=4:
0: hci0: Bluetooth
	Soft blocked: no
	Hard blocked: no
1: phy0: Wireless LAN
	Soft blocked: no
	Hard blocked: no
2: asus-wlan: Wireless LAN
	Soft blocked: no
	Hard blocked: no
3: asus-bluetooth: Bluetooth
	Soft blocked: no
	Hard blocked: no

Regardless of the values ​​of the WAPF parameter,
<Fn><F2> key combination does not give any results,
i.e. does not toggles The Internal Wireless LAN ON or OFF.
Also the WLAN LED is always ON, no matter what.


poma



--------------010703080304000609090204
Content-Type: text/x-patch;
 name="asus-nb-wmi.wapf4-ASUSTeK-X75VBP.diff"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="asus-nb-wmi.wapf4-ASUSTeK-X75VBP.diff"

diff --git a/drivers/platform/x86/asus-nb-wmi.c b/drivers/platform/x86/asus-nb-wmi.c
index 563f59e..674793d 100644
--- a/drivers/platform/x86/asus-nb-wmi.c
+++ b/drivers/platform/x86/asus-nb-wmi.c
@@ -182,6 +182,15 @@ static struct dmi_system_id asus_quirks[] = {
 	},
 	{
 		.callback = dmi_matched,
+		.ident = "ASUSTeK COMPUTER INC. X75VBP",
+		.matches = {
+			DMI_MATCH(DMI_SYS_VENDOR, "ASUSTeK COMPUTER INC."),
+			DMI_MATCH(DMI_PRODUCT_NAME, "X75VBP"),
+		},
+		.driver_data = &quirk_asus_x401u,
+	},
+	{
+		.callback = dmi_matched,
 		.ident = "ASUSTeK COMPUTER INC. 1015E",
 		.matches = {
 			DMI_MATCH(DMI_SYS_VENDOR, "ASUSTeK COMPUTER INC."),





--------------010703080304000609090204--
