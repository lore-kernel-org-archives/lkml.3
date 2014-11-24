Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754609AbaKXTkm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Nov 2014 14:40:42 -0500
Received: from mout.web.de ([212.227.17.11]:54756 "EHLO mout.web.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751842AbaKXTkk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Nov 2014 14:40:40 -0500
Message-ID: <547389A6.9090106@users.sourceforge.net>
Date: Mon, 24 Nov 2014 20:40:22 +0100
From: SF Markus Elfring <elfring@users.sourceforge.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: Anisse Astier <anisse@astier.eu>,
        Corentin Chary <corentin.chary@gmail.com>,
        Darren Hart <dvhart@infradead.org>, Ike Panhc <ike.pan@canonical.com>,
        Jonathan Woithe <jwoithe@just42.net>,
        Mattia Dongili <malattia@linux.it>,
        platform-driver-x86@vger.kernel.org,
        acpi4asus-user@lists.sourceforge.net
CC: LKML <linux-kernel@vger.kernel.org>, kernel-janitors@vger.kernel.org,
        Julia Lawall <julia.lawall@lip6.fr>
Subject: [PATCH 1/1] platform: x86: Deletion of checks before backlight_device_unregister()
References: <5307CAA2.8060406@users.sourceforge.net> <alpine.DEB.2.02.1402212321410.2043@localhost6.localdomain6> <530A086E.8010901@users.sourceforge.net> <alpine.DEB.2.02.1402231635510.1985@localhost6.localdomain6> <530A72AA.3000601@users.sourceforge.net> <alpine.DEB.2.02.1402240658210.2090@localhost6.localdomain6> <530B5FB6.6010207@users.sourceforge.net> <alpine.DEB.2.10.1402241710370.2074@hadrien> <530C5E18.1020800@users.sourceforge.net> <alpine.DEB.2.10.1402251014170.2080@hadrien> <530CD2C4.4050903@users.sourceforge.net> <alpine.DEB.2.10.1402251840450.7035@hadrien> <530CF8FF.8080600@users.sourceforge.net> <alpine.DEB.2.02.1402252117150.2047@localhost6.localdomain6> <530DD06F.4090703@users.sourceforge.net> <alpine.DEB.2.02.1402262129250.2221@localhost6.localdomain6> <5317A59D.4@users.sourceforge.net>
In-Reply-To: <5317A59D.4@users.sourceforge.net>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
X-Provags-ID: V03:K0:jjeNnIxxlPqcPj/IrgkSjzLz0jt8eRA0/GtwE0lyV4xQgDGNc9e
 lHINdvdi028J/BKgWdJTB1VYYmv8f22SmARa2w4XwNxWlqQUTBKhaUp6Y3HHoGVKRJLUSwf
 nzgEgN9DjsRVqK/Qc/OjP6Eoam3p09voMwlueu0TyIv0w6tOJ+wVEjD9bgLPwjN6kLJ+L8T
 39wbMs8WvJpOnIQxaePkw==
X-UI-Out-Filterresults: notjunk:1;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Markus Elfring <elfring@users.sourceforge.net>
Date: Mon, 24 Nov 2014 20:30:29 +0100

The backlight_device_unregister() function tests whether its argument is NULL
and then returns immediately. Thus the test around the call is not needed.

This issue was detected by using the Coccinelle software.

Signed-off-by: Markus Elfring <elfring@users.sourceforge.net>
---
 drivers/platform/x86/asus-laptop.c    | 3 +--
 drivers/platform/x86/asus-wmi.c       | 3 +--
 drivers/platform/x86/eeepc-laptop.c   | 3 +--
 drivers/platform/x86/fujitsu-laptop.c | 6 ++----
 drivers/platform/x86/ideapad-laptop.c | 3 +--
 drivers/platform/x86/intel_oaktrail.c | 3 +--
 drivers/platform/x86/msi-wmi.c        | 3 +--
 drivers/platform/x86/sony-laptop.c    | 3 +--
 drivers/platform/x86/toshiba_acpi.c   | 3 +--
 9 files changed, 10 insertions(+), 20 deletions(-)

diff --git a/drivers/platform/x86/asus-laptop.c b/drivers/platform/x86/asus-laptop.c
index 7f4dc6f..11fac1a 100644
--- a/drivers/platform/x86/asus-laptop.c
+++ b/drivers/platform/x86/asus-laptop.c
@@ -843,8 +843,7 @@ static int asus_backlight_init(struct asus_laptop *asus)
 
 static void asus_backlight_exit(struct asus_laptop *asus)
 {
-	if (asus->backlight_device)
-		backlight_device_unregister(asus->backlight_device);
+	backlight_device_unregister(asus->backlight_device);
 	asus->backlight_device = NULL;
 }
 
diff --git a/drivers/platform/x86/asus-wmi.c b/drivers/platform/x86/asus-wmi.c
index 21fc932..7543a56 100644
--- a/drivers/platform/x86/asus-wmi.c
+++ b/drivers/platform/x86/asus-wmi.c
@@ -1308,8 +1308,7 @@ static int asus_wmi_backlight_init(struct asus_wmi *asus)
 
 static void asus_wmi_backlight_exit(struct asus_wmi *asus)
 {
-	if (asus->backlight_device)
-		backlight_device_unregister(asus->backlight_device);
+	backlight_device_unregister(asus->backlight_device);
 
 	asus->backlight_device = NULL;
 }
diff --git a/drivers/platform/x86/eeepc-laptop.c b/drivers/platform/x86/eeepc-laptop.c
index bd533c2..9bc7eb7 100644
--- a/drivers/platform/x86/eeepc-laptop.c
+++ b/drivers/platform/x86/eeepc-laptop.c
@@ -1158,8 +1158,7 @@ static int eeepc_backlight_init(struct eeepc_laptop *eeepc)
 
 static void eeepc_backlight_exit(struct eeepc_laptop *eeepc)
 {
-	if (eeepc->backlight_device)
-		backlight_device_unregister(eeepc->backlight_device);
+	backlight_device_unregister(eeepc->backlight_device);
 	eeepc->backlight_device = NULL;
 }
 
diff --git a/drivers/platform/x86/fujitsu-laptop.c b/drivers/platform/x86/fujitsu-laptop.c
index 87aa28c..f1a670b 100644
--- a/drivers/platform/x86/fujitsu-laptop.c
+++ b/drivers/platform/x86/fujitsu-laptop.c
@@ -1147,8 +1147,7 @@ fail_hotkey1:
 fail_hotkey:
 	platform_driver_unregister(&fujitsupf_driver);
 fail_backlight:
-	if (fujitsu->bl_device)
-		backlight_device_unregister(fujitsu->bl_device);
+	backlight_device_unregister(fujitsu->bl_device);
 fail_sysfs_group:
 	sysfs_remove_group(&fujitsu->pf_device->dev.kobj,
 			   &fujitsupf_attribute_group);
@@ -1172,8 +1171,7 @@ static void __exit fujitsu_cleanup(void)
 
 	platform_driver_unregister(&fujitsupf_driver);
 
-	if (fujitsu->bl_device)
-		backlight_device_unregister(fujitsu->bl_device);
+	backlight_device_unregister(fujitsu->bl_device);
 
 	sysfs_remove_group(&fujitsu->pf_device->dev.kobj,
 			   &fujitsupf_attribute_group);
diff --git a/drivers/platform/x86/ideapad-laptop.c b/drivers/platform/x86/ideapad-laptop.c
index ed494f3..3163061 100644
--- a/drivers/platform/x86/ideapad-laptop.c
+++ b/drivers/platform/x86/ideapad-laptop.c
@@ -729,8 +729,7 @@ static int ideapad_backlight_init(struct ideapad_private *priv)
 
 static void ideapad_backlight_exit(struct ideapad_private *priv)
 {
-	if (priv->blightdev)
-		backlight_device_unregister(priv->blightdev);
+	backlight_device_unregister(priv->blightdev);
 	priv->blightdev = NULL;
 }
 
diff --git a/drivers/platform/x86/intel_oaktrail.c b/drivers/platform/x86/intel_oaktrail.c
index 4bc9604..0dd72cf 100644
--- a/drivers/platform/x86/intel_oaktrail.c
+++ b/drivers/platform/x86/intel_oaktrail.c
@@ -271,8 +271,7 @@ static int oaktrail_backlight_init(void)
 
 static void oaktrail_backlight_exit(void)
 {
-	if (oaktrail_bl_device)
-		backlight_device_unregister(oaktrail_bl_device);
+	backlight_device_unregister(oaktrail_bl_device);
 }
 
 static int oaktrail_probe(struct platform_device *pdev)
diff --git a/drivers/platform/x86/msi-wmi.c b/drivers/platform/x86/msi-wmi.c
index 70222f2..6d2bac0 100644
--- a/drivers/platform/x86/msi-wmi.c
+++ b/drivers/platform/x86/msi-wmi.c
@@ -354,8 +354,7 @@ static void __exit msi_wmi_exit(void)
 		sparse_keymap_free(msi_wmi_input_dev);
 		input_unregister_device(msi_wmi_input_dev);
 	}
-	if (backlight)
-		backlight_device_unregister(backlight);
+	backlight_device_unregister(backlight);
 }
 
 module_init(msi_wmi_init);
diff --git a/drivers/platform/x86/sony-laptop.c b/drivers/platform/x86/sony-laptop.c
index 26ad9ff..a48cdc7 100644
--- a/drivers/platform/x86/sony-laptop.c
+++ b/drivers/platform/x86/sony-laptop.c
@@ -3141,8 +3141,7 @@ static void sony_nc_backlight_setup(void)
 
 static void sony_nc_backlight_cleanup(void)
 {
-	if (sony_bl_props.dev)
-		backlight_device_unregister(sony_bl_props.dev);
+	backlight_device_unregister(sony_bl_props.dev);
 }
 
 static int sony_nc_add(struct acpi_device *device)
diff --git a/drivers/platform/x86/toshiba_acpi.c b/drivers/platform/x86/toshiba_acpi.c
index d0dce73..703a68a 100644
--- a/drivers/platform/x86/toshiba_acpi.c
+++ b/drivers/platform/x86/toshiba_acpi.c
@@ -1647,8 +1647,7 @@ static int toshiba_acpi_remove(struct acpi_device *acpi_dev)
 		rfkill_destroy(dev->bt_rfk);
 	}
 
-	if (dev->backlight_dev)
-		backlight_device_unregister(dev->backlight_dev);
+	backlight_device_unregister(dev->backlight_dev);
 
 	if (dev->illumination_supported)
 		led_classdev_unregister(&dev->led_dev);
-- 
2.1.3

