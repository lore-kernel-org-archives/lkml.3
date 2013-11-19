Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752076Ab3KSKvX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Nov 2013 05:51:23 -0500
Received: from mail-wi0-f171.google.com ([209.85.212.171]:39409 "EHLO
	mail-wi0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751592Ab3KSKvV convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Nov 2013 05:51:21 -0500
From: Pali =?utf-8?q?Roh=C3=A1r?= <pali.rohar@gmail.com>
To: Felipe Balbi <balbi@ti.com>,
        "Greg Kroah-Hartman" <gregkh@linuxfoundation.org>
Subject: BUG: usb: obex in g_nokia.ko causing kernel panic
Date: Tue, 19 Nov 2013 11:51:12 +0100
User-Agent: KMail/1.13.7 (Linux/3.11.0-14-generic; KDE/4.11.2; x86_64; ; )
Cc: linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        Pavel Machek <pavel@ucw.cz>, Aaro Koskinen <aaro.koskinen@iki.fi>,
        freemangordon@abv.bg, Sebastian Reichel <sre@ring0.de>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-Id: <201311191151.17153@pali>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

For a long time (since 3.5 or 3.8? - I do not remember) obex
subdriver in g_nokia usb gadget module causing kernel panic after
module is loaded on Nokia N900. I do not know where is problem
and due to immediatelly kernel crash when loading driver I was
not able to see any dmesg output. Now I was able to store
something into mtd log and here is crash backtrace:

Log Entry 437 (at position 52)
<4>[   18.606414] [<c037eac0>] (__schedule+0x5c/0x50c) from [<c037d3bc>] (schedule_timeout+0x1f4/0x25c)
<4>[   18.623809] [<c037d3bc>] (schedule_timeout+0x1f4/0x25c) from [<c037f12c>] (wait_for_common+0xc8/0x1ac)
<4>[   18.649291] [<c037f12c>] (wait_for_common+0xc8/0x1ac) from [<c028c1c0>] (omap_i2c_xfer+0x338/0x488)
<4>[   18.674499] [<c028c1c0>] (omap_i2c_xfer+0x338/0x488) from [<c0288144>] (__i2c_transfer+0x40/0x74)
<4>[   18.692047] [<c0288144>] (__i2c_transfer+0x40/0x74) from [<c0288a2c>] (i2c_transfer+0x6c/0x90)
<4>[   18.709320] [<c0288a2c>] (i2c_transfer+0x6c/0x90) from [<c02351c8>] (regmap_i2c_read+0x48/0x68)
<4>[   18.726715] [<c02351c8>] (regmap_i2c_read+0x48/0x68) from [<c023161c>] (_regmap_raw_read+0x128/0x220)
<4>[   18.752685] [<c023161c>] (_regmap_raw_read+0x128/0x220) from [<c02317b4>] (regmap_raw_read+0xa0/0x130)
<4>[   18.779052] [<c02317b4>] (regmap_raw_read+0xa0/0x130) from [<c023193c>] (regmap_bulk_read+0xf8/0x16c)
<4>[   18.805694] [<c023193c>] (regmap_bulk_read+0xf8/0x16c) from [<c0238ea8>] (twl_i2c_read+0xa4/0xe0)
<4>[   18.823730] [<c0238ea8>] (twl_i2c_read+0xa4/0xe0) from [<c0274d34>] (__twl4030_phy_power.isra.12+0x1c/0x58)
<4>[   18.850921] [<c0274d34>] (__twl4030_phy_power.isra.12+0x1c/0x58) from [<c0274df0>] 
(twl4030_phy_power.part.14+0x80/0xc8)
<4>[   18.879699] [<c0274df0>] (twl4030_phy_power.part.14+0x80/0xc8) from [<c0274f9c>] 
(twl4030_set_suspend+0x54/0x1e8)
<4>[   18.908325] [<c0274f9c>] (twl4030_set_suspend+0x54/0x1e8) from [<c027c8c4>] 
(omap2430_runtime_resume+0x5c/0x64)
<4>[   18.937042] [<c027c8c4>] (omap2430_runtime_resume+0x5c/0x64) from [<c0225dd0>] 
(pm_generic_runtime_resume+0x2c/0x38)
<4>[   18.966461] [<c0225dd0>] (pm_generic_runtime_resume+0x2c/0x38) from [<c0229fe0>] (__rpm_callback+0x54/0x80)
<4>[   18.995117] [<c0229fe0>] (__rpm_callback+0x54/0x80) from [<c022a04c>] (rpm_callback+0x40/0x74)
<4>[   19.013610] [<c022a04c>] (rpm_callback+0x40/0x74) from [<c022b3c8>] (rpm_resume+0x448/0x63c)
<4>[   19.031921] [<c022b3c8>] (rpm_resume+0x448/0x63c) from [<c022b2e4>] (rpm_resume+0x364/0x63c)
<4>[   19.050140] [<c022b2e4>] (rpm_resume+0x364/0x63c) from [<c022b874>] (__pm_runtime_resume+0x48/0x74)
<4>[   19.077728] [<c022b874>] (__pm_runtime_resume+0x48/0x74) from [<c027b4fc>] (musb_gadget_pullup+0x1c/0xb4)
<4>[   19.105895] [<c027b4fc>] (musb_gadget_pullup+0x1c/0xb4) from [<bf025c14>] (usb_function_deactivate+0x54/0xa4 
[libcomposite])
<4>[   19.135955] [<bf025c14>] (usb_function_deactivate+0x54/0xa4 [libcomposite]) from [<bf05b3b8>] 
(obex_bind+0x124/0x1d8 [usb_f_obex])
<4>[   19.166870] [<bf05b3b8>] (obex_bind+0x124/0x1d8 [usb_f_obex]) from [<bf025794>] (usb_add_function+0x58/0xf4 
[libcomposite])
<4>[   19.197143] [<bf025794>] (usb_add_function+0x58/0xf4 [libcomposite]) from [<bf037420>] 
(nokia_bind_config+0x204/0x250 [g_nokia])
<4>[   19.227905] [<bf037420>] (nokia_bind_config+0x204/0x250 [g_nokia]) from [<bf0263fc>] (usb_add_config+0x28/0xc0 
[libcomposite])
<4>[   19.258483] [<bf0263fc>] (usb_add_config+0x28/0xc0 [libcomposite]) from [<bf03709c>] (nokia_bind+0x9c/0x21c 
[g_nokia])
<4>[   19.288421] [<bf03709c>] (nokia_bind+0x9c/0x21c [g_nokia]) from [<bf0275bc>] (composite_bind+0x74/0x180 
[libcomposite])
<4>[   19.318420] [<bf0275bc>] (composite_bind+0x74/0x180 [libcomposite]) from [<c027d658>] 
(udc_bind_to_driver+0x2c/0xc4)
<4>[   19.348114] [<c027d658>] (udc_bind_to_driver+0x2c/0xc4) from [<c027d764>] (usb_gadget_probe_driver+0x74/0x94)
<4>[   19.377166] [<c027d764>] (usb_gadget_probe_driver+0x74/0x94) from [<c00086f8>] (do_one_initcall+0x94/0x138)
<4>[   19.406005] [<c00086f8>] (do_one_initcall+0x94/0x138) from [<c007a460>] (load_module+0x113c/0x13c4)
<4>[   19.434051] [<c007a460>] (load_module+0x113c/0x13c4) from [<c007a7b4>] (SyS_init_module+0xcc/0xec)
<4>[   19.462127] [<c007a7b4>] (SyS_init_module+0xcc/0xec) from [<c000dd40>] (ret_fast_syscall+0x0/0x30)
<0>[   19.490753] Code: 0a00002e e1a00004 eb001438 e598300c (e5d3202c) 
<4>[   19.506805] ---[ end trace 060b62ec0d68a78b ]---
<0>[   19.523132] Kernel panic - not syncing: Fatal exception in interrupt

(above dump is from 3.12-rc5 kernel)

When I disable obex code in drivers/usb/gadget/nokia.c then gadget driver working fine without any crash, error or warning.

Here is patch which disabling obex code which I using (for 3.12):

diff --git a/drivers/usb/gadget/nokia.c b/drivers/usb/gadget/nokia.c
index ba47977..869cbfa 100644
--- a/drivers/usb/gadget/nokia.c
+++ b/drivers/usb/gadget/nokia.c
@@ -110,10 +110,10 @@ static struct usb_function *f_acm_cfg1;
 static struct usb_function *f_acm_cfg2;
 static struct usb_function *f_ecm_cfg1;
 static struct usb_function *f_ecm_cfg2;
-static struct usb_function *f_obex1_cfg1;
+/*static struct usb_function *f_obex1_cfg1;
 static struct usb_function *f_obex2_cfg1;
 static struct usb_function *f_obex1_cfg2;
-static struct usb_function *f_obex2_cfg2;
+static struct usb_function *f_obex2_cfg2;*/
 static struct usb_function *f_phonet_cfg1;
 static struct usb_function *f_phonet_cfg2;
 
@@ -136,20 +136,20 @@ static struct usb_configuration nokia_config_100ma_driver = {
 
 static struct usb_function_instance *fi_acm;
 static struct usb_function_instance *fi_ecm;
-static struct usb_function_instance *fi_obex1;
-static struct usb_function_instance *fi_obex2;
+/*static struct usb_function_instance *fi_obex1;
+static struct usb_function_instance *fi_obex2;*/
 static struct usb_function_instance *fi_phonet;
 
 static int __init nokia_bind_config(struct usb_configuration *c)
 {
 	struct usb_function *f_acm;
 	struct usb_function *f_phonet = NULL;
-	struct usb_function *f_obex1 = NULL;
+/*	struct usb_function *f_obex1 = NULL; */
 	struct usb_function *f_ecm;
-	struct usb_function *f_obex2 = NULL;
+/*	struct usb_function *f_obex2 = NULL; */
 	int status = 0;
-	int obex1_stat = 0;
-	int obex2_stat = 0;
+/*	int obex1_stat = 0;
+	int obex2_stat = 0;*/
 	int phonet_stat = 0;
 
 	if (!IS_ERR(fi_phonet)) {
@@ -158,7 +158,7 @@ static int __init nokia_bind_config(struct usb_configuration *c)
 			pr_debug("could not get phonet function\n");
 	}
 
-	if (!IS_ERR(fi_obex1)) {
+/*	if (!IS_ERR(fi_obex1)) {
 		f_obex1 = usb_get_function(fi_obex1);
 		if (IS_ERR(f_obex1))
 			pr_debug("could not get obex function 0\n");
@@ -168,7 +168,7 @@ static int __init nokia_bind_config(struct usb_configuration *c)
 		f_obex2 = usb_get_function(fi_obex2);
 		if (IS_ERR(f_obex2))
 			pr_debug("could not get obex function 1\n");
-	}
+	}*/
 
 	f_acm = usb_get_function(fi_acm);
 	if (IS_ERR(f_acm)) {
@@ -188,7 +188,7 @@ static int __init nokia_bind_config(struct usb_configuration *c)
 			pr_debug("could not add phonet function\n");
 	}
 
-	if (!IS_ERR_OR_NULL(f_obex1)) {
+/*	if (!IS_ERR_OR_NULL(f_obex1)) {
 		obex1_stat = usb_add_function(c, f_obex1);
 		if (obex1_stat)
 			pr_debug("could not add obex function 0\n");
@@ -198,7 +198,7 @@ static int __init nokia_bind_config(struct usb_configuration *c)
 		obex2_stat = usb_add_function(c, f_obex2);
 		if (obex2_stat)
 			pr_debug("could not add obex function 1\n");
-	}
+	}*/
 
 	status = usb_add_function(c, f_acm);
 	if (status)
@@ -213,14 +213,14 @@ static int __init nokia_bind_config(struct usb_configuration *c)
 		f_acm_cfg1 = f_acm;
 		f_ecm_cfg1 = f_ecm;
 		f_phonet_cfg1 = f_phonet;
-		f_obex1_cfg1 = f_obex1;
-		f_obex2_cfg1 = f_obex2;
+/*		f_obex1_cfg1 = f_obex1;
+		f_obex2_cfg1 = f_obex2;*/
 	} else {
 		f_acm_cfg2 = f_acm;
 		f_ecm_cfg2 = f_ecm;
 		f_phonet_cfg2 = f_phonet;
-		f_obex1_cfg2 = f_obex1;
-		f_obex2_cfg2 = f_obex2;
+/*		f_obex1_cfg2 = f_obex1;
+		f_obex2_cfg2 = f_obex2;*/
 	}
 
 	status = fsg_bind_config(c->cdev, c, &fsg_common);
@@ -232,20 +232,20 @@ static int __init nokia_bind_config(struct usb_configuration *c)
 err_ecm:
 	usb_remove_function(c, f_acm);
 err_conf:
-	if (!obex2_stat)
+/*	if (!obex2_stat)
 		usb_remove_function(c, f_obex2);
 	if (!obex1_stat)
-		usb_remove_function(c, f_obex1);
+		usb_remove_function(c, f_obex1);*/
 	if (!phonet_stat)
 		usb_remove_function(c, f_phonet);
 	usb_put_function(f_ecm);
 err_get_ecm:
 	usb_put_function(f_acm);
 err_get_acm:
-	if (!IS_ERR_OR_NULL(f_obex2))
+/*	if (!IS_ERR_OR_NULL(f_obex2))
 		usb_put_function(f_obex2);
 	if (!IS_ERR_OR_NULL(f_obex1))
-		usb_put_function(f_obex1);
+		usb_put_function(f_obex1);*/
 	if (!IS_ERR_OR_NULL(f_phonet))
 		usb_put_function(f_phonet);
 	return status;
@@ -285,13 +285,13 @@ static int __init nokia_bind(struct usb_composite_dev *cdev)
 	if (IS_ERR(fi_phonet))
 		pr_debug("could not find phonet function\n");
 
-	fi_obex1 = usb_get_function_instance("obex");
+/*	fi_obex1 = usb_get_function_instance("obex");
 	if (IS_ERR(fi_obex1))
 		pr_debug("could not find obex function 1\n");
 
 	fi_obex2 = usb_get_function_instance("obex");
 	if (IS_ERR(fi_obex2))
-		pr_debug("could not find obex function 2\n");
+		pr_debug("could not find obex function 2\n");*/
 
 	fi_acm = usb_get_function_instance("acm");
 	if (IS_ERR(fi_acm)) {
@@ -323,10 +323,10 @@ static int __init nokia_bind(struct usb_composite_dev *cdev)
 
 err_put_cfg1:
 	usb_put_function(f_acm_cfg1);
-	if (!IS_ERR_OR_NULL(f_obex1_cfg1))
+/*	if (!IS_ERR_OR_NULL(f_obex1_cfg1))
 		usb_put_function(f_obex1_cfg1);
 	if (!IS_ERR_OR_NULL(f_obex2_cfg1))
-		usb_put_function(f_obex2_cfg1);
+		usb_put_function(f_obex2_cfg1);*/
 	if (!IS_ERR_OR_NULL(f_phonet_cfg1))
 		usb_put_function(f_phonet_cfg1);
 	usb_put_function(f_ecm_cfg1);
@@ -335,10 +335,10 @@ err_ecm_inst:
 err_acm_inst:
 	usb_put_function_instance(fi_acm);
 err_obex2_inst:
-	if (!IS_ERR(fi_obex2))
+/*	if (!IS_ERR(fi_obex2))
 		usb_put_function_instance(fi_obex2);
 	if (!IS_ERR(fi_obex1))
-		usb_put_function_instance(fi_obex1);
+		usb_put_function_instance(fi_obex1);*/
 	if (!IS_ERR(fi_phonet))
 		usb_put_function_instance(fi_phonet);
 err_usb:
@@ -349,14 +349,14 @@ err_fsg:
 
 static int __exit nokia_unbind(struct usb_composite_dev *cdev)
 {
-	if (!IS_ERR_OR_NULL(f_obex1_cfg2))
+/*	if (!IS_ERR_OR_NULL(f_obex1_cfg2))
 		usb_put_function(f_obex1_cfg2);
 	if (!IS_ERR_OR_NULL(f_obex2_cfg2))
 		usb_put_function(f_obex2_cfg2);
 	if (!IS_ERR_OR_NULL(f_obex1_cfg1))
 		usb_put_function(f_obex1_cfg1);
 	if (!IS_ERR_OR_NULL(f_obex2_cfg1))
-		usb_put_function(f_obex2_cfg1);
+		usb_put_function(f_obex2_cfg1);*/
 	if (!IS_ERR_OR_NULL(f_phonet_cfg1))
 		usb_put_function(f_phonet_cfg1);
 	if (!IS_ERR_OR_NULL(f_phonet_cfg2))
@@ -367,10 +367,10 @@ static int __exit nokia_unbind(struct usb_composite_dev *cdev)
 	usb_put_function(f_ecm_cfg2);
 
 	usb_put_function_instance(fi_ecm);
-	if (!IS_ERR(fi_obex2))
+/*	if (!IS_ERR(fi_obex2))
 		usb_put_function_instance(fi_obex2);
 	if (!IS_ERR(fi_obex1))
-		usb_put_function_instance(fi_obex1);
+		usb_put_function_instance(fi_obex1);*/
 	if (!IS_ERR(fi_phonet))
 		usb_put_function_instance(fi_phonet);
 	usb_put_function_instance(fi_acm);

Please can you look where can be problem and why gadget causing
immediatelly kernel panic?

Note that g_nokia.ko usb gadget is for nokia n900 device. And
because it crashing (without above patch) I suggesting to remove
or comment obex code, because really driver is unusable on that
device...

-- 
Pali Rohár
pali.rohar@gmail.com
