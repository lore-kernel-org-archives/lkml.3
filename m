Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753314Ab3JWTP4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Oct 2013 15:15:56 -0400
Received: from smtprelay0148.hostedemail.com ([216.40.44.148]:51415 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753230Ab3JWTPx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Oct 2013 15:15:53 -0400
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::::::::::::::::::::,RULES_HIT:327:355:379:541:960:966:973:988:989:1260:1345:1359:1437:1605:1730:1747:1777:1792:1981:2194:2196:2199:2200:2393:2559:2562:3138:3139:3140:3141:3142:3503:3504:3505:3865:3866:3867:3868:3872:4250:4321:4385:4423:4605:5007:6261:7903:9592:10004:10026:10848:11026:11657:11914:12043:12114:12296:12438:12517:12519:12555:13972,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,
X-HE-Tag: lake46_6cf76d24c2e02
X-Filterd-Recvd-Size: 39476
From: Joe Perches <joe@perches.com>
To: linux-kernel@vger.kernel.org
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Wan ZongShun <mcuos.com@gmail.com>,
        Andrey Moiseev <o2g.org.ru@gmail.com>,
        Henrik Rydberg <rydberg@euromail.se>, Josh Wu <josh.wu@atmel.com>,
        Ferruh Yigit <fery@cypress.com>, Pau Oliva Fora <pof@eslack.org>,
        Ben Dooks <ben-linux@fluff.org>, Kukjin Kim <kgene.kim@samsung.com>,
        linux-input@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org
Subject: [PATCH 4/8] input: Remove OOM message after input_allocate_device
Date: Wed, 23 Oct 2013 12:14:50 -0700
Message-Id: <cc5e6a317bc9ef33cfdfae3ed9d3a47b5319a47b.1382555436.git.joe@perches.com>
X-Mailer: git-send-email 1.8.1.2.459.gbcd45b4.dirty
In-Reply-To: <cover.1382555436.git.joe@perches.com>
References: <cover.1382555436.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Emitting an OOM message isn't necessary after input_allocate_device
as there's a generic OOM and a dump_stack already done.

Signed-off-by: Joe Perches <joe@perches.com>
---
 drivers/input/joystick/as5011.c             | 2 --
 drivers/input/joystick/db9.c                | 1 -
 drivers/input/joystick/gamecon.c            | 4 +---
 drivers/input/joystick/turbografx.c         | 1 -
 drivers/input/joystick/walkera0701.c        | 1 -
 drivers/input/keyboard/amikbd.c             | 4 +---
 drivers/input/keyboard/davinci_keyscan.c    | 1 -
 drivers/input/keyboard/gpio_keys.c          | 1 -
 drivers/input/keyboard/lpc32xx-keys.c       | 1 -
 drivers/input/keyboard/max7359_keypad.c     | 1 -
 drivers/input/keyboard/mcs_touchkey.c       | 1 -
 drivers/input/keyboard/mpr121_touchkey.c    | 1 -
 drivers/input/keyboard/nomadik-ske-keypad.c | 1 -
 drivers/input/keyboard/opencores-kbd.c      | 1 -
 drivers/input/keyboard/pmic8xxx-keypad.c    | 1 -
 drivers/input/keyboard/pxa27x_keypad.c      | 1 -
 drivers/input/keyboard/pxa930_rotary.c      | 1 -
 drivers/input/keyboard/qt1070.c             | 1 -
 drivers/input/keyboard/qt2160.c             | 1 -
 drivers/input/keyboard/sh_keysc.c           | 1 -
 drivers/input/keyboard/tc3589x-keypad.c     | 1 -
 drivers/input/keyboard/tnetv107x-keypad.c   | 1 -
 drivers/input/keyboard/w90p910_keypad.c     | 1 -
 drivers/input/misc/88pm80x_onkey.c          | 1 -
 drivers/input/misc/88pm860x_onkey.c         | 1 -
 drivers/input/misc/arizona-haptics.c        | 4 +---
 drivers/input/misc/atlas_btns.c             | 4 +---
 drivers/input/misc/da9052_onkey.c           | 1 -
 drivers/input/misc/da9055_onkey.c           | 4 +---
 drivers/input/misc/ideapad_slidebar.c       | 1 -
 drivers/input/misc/ims-pcu.c                | 7 +------
 drivers/input/misc/kxtj9.c                  | 4 +---
 drivers/input/misc/max8997_haptic.c         | 1 -
 drivers/input/misc/mc13783-pwrbutton.c      | 4 +---
 drivers/input/misc/mpu3050.c                | 1 -
 drivers/input/misc/pcf8574_keypad.c         | 1 -
 drivers/input/misc/pm8xxx-vibrator.c        | 1 -
 drivers/input/misc/pmic8xxx-pwrkey.c        | 1 -
 drivers/input/misc/pwm-beeper.c             | 1 -
 drivers/input/misc/twl4030-pwrbutton.c      | 4 +---
 drivers/input/misc/twl6040-vibra.c          | 1 -
 drivers/input/mouse/appletouch.c            | 4 +---
 drivers/input/mouse/bcm5974.c               | 4 +---
 drivers/input/mouse/cyapa.c                 | 4 +---
 drivers/input/mouse/inport.c                | 1 -
 drivers/input/mouse/logibm.c                | 1 -
 drivers/input/mouse/pc110pad.c              | 1 -
 drivers/input/mouse/pxa930_trkball.c        | 1 -
 drivers/input/tablet/aiptek.c               | 5 +----
 drivers/input/tablet/gtco.c                 | 1 -
 drivers/input/touchscreen/88pm860x-ts.c     | 1 -
 drivers/input/touchscreen/atmel_mxt_ts.c    | 1 -
 drivers/input/touchscreen/atmel_tsadcc.c    | 1 -
 drivers/input/touchscreen/bu21013_ts.c      | 1 -
 drivers/input/touchscreen/cyttsp4_core.c    | 2 --
 drivers/input/touchscreen/da9034-ts.c       | 1 -
 drivers/input/touchscreen/edt-ft5x06.c      | 1 -
 drivers/input/touchscreen/eeti_ts.c         | 5 +----
 drivers/input/touchscreen/htcpen.c          | 1 -
 drivers/input/touchscreen/intel-mid-touch.c | 1 -
 drivers/input/touchscreen/lpc32xx_ts.c      | 1 -
 drivers/input/touchscreen/mcs5000_ts.c      | 1 -
 drivers/input/touchscreen/migor_ts.c        | 1 -
 drivers/input/touchscreen/mk712.c           | 1 -
 drivers/input/touchscreen/pixcir_i2c_ts.c   | 1 -
 drivers/input/touchscreen/s3c2410_ts.c      | 1 -
 drivers/input/touchscreen/ti_am335x_tsc.c   | 1 -
 drivers/input/touchscreen/tnetv107x-ts.c    | 1 -
 68 files changed, 14 insertions(+), 103 deletions(-)

diff --git a/drivers/input/joystick/as5011.c b/drivers/input/joystick/as5011.c
index 005d852..3b9c709 100644
--- a/drivers/input/joystick/as5011.c
+++ b/drivers/input/joystick/as5011.c
@@ -254,8 +254,6 @@ static int as5011_probe(struct i2c_client *client,
 	as5011 = kmalloc(sizeof(struct as5011_device), GFP_KERNEL);
 	input_dev = input_allocate_device();
 	if (!as5011 || !input_dev) {
-		dev_err(&client->dev,
-			"Can't allocate memory for device structure\n");
 		error = -ENOMEM;
 		goto err_free_mem;
 	}
diff --git a/drivers/input/joystick/db9.c b/drivers/input/joystick/db9.c
index 8e7de5c..b0f18f2 100644
--- a/drivers/input/joystick/db9.c
+++ b/drivers/input/joystick/db9.c
@@ -609,7 +609,6 @@ static struct db9 __init *db9_probe(int parport, int mode)
 
 		db9->dev[i] = input_dev = input_allocate_device();
 		if (!input_dev) {
-			printk(KERN_ERR "db9.c: Not enough memory for input device\n");
 			err = -ENOMEM;
 			goto err_unreg_devs;
 		}
diff --git a/drivers/input/joystick/gamecon.c b/drivers/input/joystick/gamecon.c
index e68e497..ded4f23 100644
--- a/drivers/input/joystick/gamecon.c
+++ b/drivers/input/joystick/gamecon.c
@@ -824,10 +824,8 @@ static int __init gc_setup_pad(struct gc *gc, int idx, int pad_type)
 	}
 
 	pad->dev = input_dev = input_allocate_device();
-	if (!input_dev) {
-		pr_err("Not enough memory for input device\n");
+	if (!input_dev)
 		return -ENOMEM;
-	}
 
 	pad->type = pad_type;
 
diff --git a/drivers/input/joystick/turbografx.c b/drivers/input/joystick/turbografx.c
index 27b6a3c..932d1b3 100644
--- a/drivers/input/joystick/turbografx.c
+++ b/drivers/input/joystick/turbografx.c
@@ -204,7 +204,6 @@ static struct tgfx __init *tgfx_probe(int parport, int *n_buttons, int n_devs)
 
 		tgfx->dev[i] = input_dev = input_allocate_device();
 		if (!input_dev) {
-			printk(KERN_ERR "turbografx.c: Not enough memory for input device\n");
 			err = -ENOMEM;
 			goto err_unreg_devs;
 		}
diff --git a/drivers/input/joystick/walkera0701.c b/drivers/input/joystick/walkera0701.c
index b76ac58..5000959 100644
--- a/drivers/input/joystick/walkera0701.c
+++ b/drivers/input/joystick/walkera0701.c
@@ -237,7 +237,6 @@ static int walkera0701_connect(struct walkera_dev *w, int parport)
 
 	w->input_dev = input_allocate_device();
 	if (!w->input_dev) {
-		pr_err("failed to allocate input device\n");
 		error = -ENOMEM;
 		goto err_unregister_device;
 	}
diff --git a/drivers/input/keyboard/amikbd.c b/drivers/input/keyboard/amikbd.c
index 096d606..e3c0455 100644
--- a/drivers/input/keyboard/amikbd.c
+++ b/drivers/input/keyboard/amikbd.c
@@ -189,10 +189,8 @@ static int __init amikbd_probe(struct platform_device *pdev)
 	int i, j, err;
 
 	dev = input_allocate_device();
-	if (!dev) {
-		dev_err(&pdev->dev, "Not enough memory for input device\n");
+	if (!dev)
 		return -ENOMEM;
-	}
 
 	dev->name = pdev->name;
 	dev->phys = "amikbd/input0";
diff --git a/drivers/input/keyboard/davinci_keyscan.c b/drivers/input/keyboard/davinci_keyscan.c
index d15977a..9455d7a 100644
--- a/drivers/input/keyboard/davinci_keyscan.c
+++ b/drivers/input/keyboard/davinci_keyscan.c
@@ -200,7 +200,6 @@ static int __init davinci_ks_probe(struct platform_device *pdev)
 
 	key_dev = input_allocate_device();
 	if (!key_dev) {
-		dev_dbg(dev, "could not allocate input device\n");
 		error = -ENOMEM;
 		goto fail1;
 	}
diff --git a/drivers/input/keyboard/gpio_keys.c b/drivers/input/keyboard/gpio_keys.c
index 440ce32..9302aaf 100644
--- a/drivers/input/keyboard/gpio_keys.c
+++ b/drivers/input/keyboard/gpio_keys.c
@@ -704,7 +704,6 @@ static int gpio_keys_probe(struct platform_device *pdev)
 			GFP_KERNEL);
 	input = input_allocate_device();
 	if (!ddata || !input) {
-		dev_err(dev, "failed to allocate state\n");
 		error = -ENOMEM;
 		goto fail1;
 	}
diff --git a/drivers/input/keyboard/lpc32xx-keys.c b/drivers/input/keyboard/lpc32xx-keys.c
index 4218143..cb1792e 100644
--- a/drivers/input/keyboard/lpc32xx-keys.c
+++ b/drivers/input/keyboard/lpc32xx-keys.c
@@ -211,7 +211,6 @@ static int lpc32xx_kscan_probe(struct platform_device *pdev)
 
 	kscandat->input = input = input_allocate_device();
 	if (!input) {
-		dev_err(&pdev->dev, "failed to allocate input device\n");
 		error = -ENOMEM;
 		goto err_free_keymap;
 	}
diff --git a/drivers/input/keyboard/max7359_keypad.c b/drivers/input/keyboard/max7359_keypad.c
index bc2cdaf..8421f8c 100644
--- a/drivers/input/keyboard/max7359_keypad.c
+++ b/drivers/input/keyboard/max7359_keypad.c
@@ -205,7 +205,6 @@ static int max7359_probe(struct i2c_client *client,
 	keypad = kzalloc(sizeof(struct max7359_keypad), GFP_KERNEL);
 	input_dev = input_allocate_device();
 	if (!keypad || !input_dev) {
-		dev_err(&client->dev, "failed to allocate memory\n");
 		error = -ENOMEM;
 		goto failed_free_mem;
 	}
diff --git a/drivers/input/keyboard/mcs_touchkey.c b/drivers/input/keyboard/mcs_touchkey.c
index 7c236f9..6743644 100644
--- a/drivers/input/keyboard/mcs_touchkey.c
+++ b/drivers/input/keyboard/mcs_touchkey.c
@@ -119,7 +119,6 @@ static int mcs_touchkey_probe(struct i2c_client *client,
 			GFP_KERNEL);
 	input_dev = input_allocate_device();
 	if (!data || !input_dev) {
-		dev_err(&client->dev, "Failed to allocate memory\n");
 		error = -ENOMEM;
 		goto err_free_mem;
 	}
diff --git a/drivers/input/keyboard/mpr121_touchkey.c b/drivers/input/keyboard/mpr121_touchkey.c
index f7f3e9a..570275d 100644
--- a/drivers/input/keyboard/mpr121_touchkey.c
+++ b/drivers/input/keyboard/mpr121_touchkey.c
@@ -217,7 +217,6 @@ static int mpr_touchkey_probe(struct i2c_client *client,
 	mpr121 = kzalloc(sizeof(struct mpr121_touchkey), GFP_KERNEL);
 	input_dev = input_allocate_device();
 	if (!mpr121 || !input_dev) {
-		dev_err(&client->dev, "Failed to allocate memory\n");
 		error = -ENOMEM;
 		goto err_free_mem;
 	}
diff --git a/drivers/input/keyboard/nomadik-ske-keypad.c b/drivers/input/keyboard/nomadik-ske-keypad.c
index c7d505c..01c971f 100644
--- a/drivers/input/keyboard/nomadik-ske-keypad.c
+++ b/drivers/input/keyboard/nomadik-ske-keypad.c
@@ -249,7 +249,6 @@ static int __init ske_keypad_probe(struct platform_device *pdev)
 	keypad = kzalloc(sizeof(struct ske_keypad), GFP_KERNEL);
 	input = input_allocate_device();
 	if (!keypad || !input) {
-		dev_err(&pdev->dev, "failed to allocate keypad memory\n");
 		error = -ENOMEM;
 		goto err_free_mem;
 	}
diff --git a/drivers/input/keyboard/opencores-kbd.c b/drivers/input/keyboard/opencores-kbd.c
index 7b9b441..72a6855 100644
--- a/drivers/input/keyboard/opencores-kbd.c
+++ b/drivers/input/keyboard/opencores-kbd.c
@@ -59,7 +59,6 @@ static int opencores_kbd_probe(struct platform_device *pdev)
 	opencores_kbd = kzalloc(sizeof(*opencores_kbd), GFP_KERNEL);
 	input = input_allocate_device();
 	if (!opencores_kbd || !input) {
-		dev_err(&pdev->dev, "failed to allocate device structures\n");
 		error = -ENOMEM;
 		goto err_free_mem;
 	}
diff --git a/drivers/input/keyboard/pmic8xxx-keypad.c b/drivers/input/keyboard/pmic8xxx-keypad.c
index 2c9f19a..8bdea7e 100644
--- a/drivers/input/keyboard/pmic8xxx-keypad.c
+++ b/drivers/input/keyboard/pmic8xxx-keypad.c
@@ -597,7 +597,6 @@ static int pmic8xxx_kp_probe(struct platform_device *pdev)
 
 	kp->input = input_allocate_device();
 	if (!kp->input) {
-		dev_err(&pdev->dev, "unable to allocate input device\n");
 		rc = -ENOMEM;
 		goto err_alloc_device;
 	}
diff --git a/drivers/input/keyboard/pxa27x_keypad.c b/drivers/input/keyboard/pxa27x_keypad.c
index a2e758d..52001f1 100644
--- a/drivers/input/keyboard/pxa27x_keypad.c
+++ b/drivers/input/keyboard/pxa27x_keypad.c
@@ -741,7 +741,6 @@ static int pxa27x_keypad_probe(struct platform_device *pdev)
 	keypad = kzalloc(sizeof(struct pxa27x_keypad), GFP_KERNEL);
 	input_dev = input_allocate_device();
 	if (!keypad || !input_dev) {
-		dev_err(&pdev->dev, "failed to allocate memory\n");
 		error = -ENOMEM;
 		goto failed_free;
 	}
diff --git a/drivers/input/keyboard/pxa930_rotary.c b/drivers/input/keyboard/pxa930_rotary.c
index 248cdcf..fbe0f2e 100644
--- a/drivers/input/keyboard/pxa930_rotary.c
+++ b/drivers/input/keyboard/pxa930_rotary.c
@@ -125,7 +125,6 @@ static int pxa930_rotary_probe(struct platform_device *pdev)
 	/* allocate and register the input device */
 	input_dev = input_allocate_device();
 	if (!input_dev) {
-		dev_err(&pdev->dev, "failed to allocate input device\n");
 		err = -ENOMEM;
 		goto failed_free_io;
 	}
diff --git a/drivers/input/keyboard/qt1070.c b/drivers/input/keyboard/qt1070.c
index 6c561ec..8081f89 100644
--- a/drivers/input/keyboard/qt1070.c
+++ b/drivers/input/keyboard/qt1070.c
@@ -167,7 +167,6 @@ static int qt1070_probe(struct i2c_client *client,
 	data = kzalloc(sizeof(struct qt1070_data), GFP_KERNEL);
 	input = input_allocate_device();
 	if (!data || !input) {
-		dev_err(&client->dev, "insufficient memory\n");
 		err = -ENOMEM;
 		goto err_free_mem;
 	}
diff --git a/drivers/input/keyboard/qt2160.c b/drivers/input/keyboard/qt2160.c
index 1c0ddad..4e078fe 100644
--- a/drivers/input/keyboard/qt2160.c
+++ b/drivers/input/keyboard/qt2160.c
@@ -399,7 +399,6 @@ static int qt2160_probe(struct i2c_client *client,
 	qt2160 = kzalloc(sizeof(struct qt2160_data), GFP_KERNEL);
 	input = input_allocate_device();
 	if (!qt2160 || !input) {
-		dev_err(&client->dev, "insufficient memory\n");
 		error = -ENOMEM;
 		goto err_free_mem;
 	}
diff --git a/drivers/input/keyboard/sh_keysc.c b/drivers/input/keyboard/sh_keysc.c
index fe0e498..b739f11 100644
--- a/drivers/input/keyboard/sh_keysc.c
+++ b/drivers/input/keyboard/sh_keysc.c
@@ -210,7 +210,6 @@ static int sh_keysc_probe(struct platform_device *pdev)
 
 	priv->input = input_allocate_device();
 	if (!priv->input) {
-		dev_err(&pdev->dev, "failed to allocate input device\n");
 		error = -ENOMEM;
 		goto err2;
 	}
diff --git a/drivers/input/keyboard/tc3589x-keypad.c b/drivers/input/keyboard/tc3589x-keypad.c
index 208de7c..5f4af0f 100644
--- a/drivers/input/keyboard/tc3589x-keypad.c
+++ b/drivers/input/keyboard/tc3589x-keypad.c
@@ -318,7 +318,6 @@ static int tc3589x_keypad_probe(struct platform_device *pdev)
 	keypad = kzalloc(sizeof(struct tc_keypad), GFP_KERNEL);
 	input = input_allocate_device();
 	if (!keypad || !input) {
-		dev_err(&pdev->dev, "failed to allocate keypad memory\n");
 		error = -ENOMEM;
 		goto err_free_mem;
 	}
diff --git a/drivers/input/keyboard/tnetv107x-keypad.c b/drivers/input/keyboard/tnetv107x-keypad.c
index 5f7b427..82dfca2 100644
--- a/drivers/input/keyboard/tnetv107x-keypad.c
+++ b/drivers/input/keyboard/tnetv107x-keypad.c
@@ -243,7 +243,6 @@ static int keypad_probe(struct platform_device *pdev)
 
 	kp->input_dev = input_allocate_device();
 	if (!kp->input_dev) {
-		dev_err(dev, "cannot allocate input device\n");
 		error = -ENOMEM;
 		goto error_input;
 	}
diff --git a/drivers/input/keyboard/w90p910_keypad.c b/drivers/input/keyboard/w90p910_keypad.c
index 7b03916..4feca23 100644
--- a/drivers/input/keyboard/w90p910_keypad.c
+++ b/drivers/input/keyboard/w90p910_keypad.c
@@ -145,7 +145,6 @@ static int w90p910_keypad_probe(struct platform_device *pdev)
 	keypad = kzalloc(sizeof(struct w90p910_keypad), GFP_KERNEL);
 	input_dev = input_allocate_device();
 	if (!keypad || !input_dev) {
-		dev_err(&pdev->dev, "failed to allocate driver data\n");
 		error = -ENOMEM;
 		goto failed_free;
 	}
diff --git a/drivers/input/misc/88pm80x_onkey.c b/drivers/input/misc/88pm80x_onkey.c
index ee43e5b..f8d9b73 100644
--- a/drivers/input/misc/88pm80x_onkey.c
+++ b/drivers/input/misc/88pm80x_onkey.c
@@ -91,7 +91,6 @@ static int pm80x_onkey_probe(struct platform_device *pdev)
 
 	info->idev = input_allocate_device();
 	if (!info->idev) {
-		dev_err(&pdev->dev, "Failed to allocate input dev\n");
 		err = -ENOMEM;
 		goto out;
 	}
diff --git a/drivers/input/misc/88pm860x_onkey.c b/drivers/input/misc/88pm860x_onkey.c
index abd8453..c05f0a1 100644
--- a/drivers/input/misc/88pm860x_onkey.c
+++ b/drivers/input/misc/88pm860x_onkey.c
@@ -78,7 +78,6 @@ static int pm860x_onkey_probe(struct platform_device *pdev)
 
 	info->idev = input_allocate_device();
 	if (!info->idev) {
-		dev_err(chip->dev, "Failed to allocate input dev\n");
 		ret = -ENOMEM;
 		goto out;
 	}
diff --git a/drivers/input/misc/arizona-haptics.c b/drivers/input/misc/arizona-haptics.c
index 7a04f54..a687bf9 100644
--- a/drivers/input/misc/arizona-haptics.c
+++ b/drivers/input/misc/arizona-haptics.c
@@ -190,10 +190,8 @@ static int arizona_haptics_probe(struct platform_device *pdev)
 	INIT_WORK(&haptics->work, arizona_haptics_work);
 
 	haptics->input_dev = input_allocate_device();
-	if (haptics->input_dev == NULL) {
-		dev_err(arizona->dev, "Failed to allocate input device\n");
+	if (haptics->input_dev == NULL)
 		return -ENOMEM;
-	}
 
 	input_set_drvdata(haptics->input_dev, haptics);
 
diff --git a/drivers/input/misc/atlas_btns.c b/drivers/input/misc/atlas_btns.c
index 5d44023..c765465 100644
--- a/drivers/input/misc/atlas_btns.c
+++ b/drivers/input/misc/atlas_btns.c
@@ -79,10 +79,8 @@ static int atlas_acpi_button_add(struct acpi_device *device)
 	int err;
 
 	input_dev = input_allocate_device();
-	if (!input_dev) {
-		pr_err("unable to allocate input device\n");
+	if (!input_dev)
 		return -ENOMEM;
-	}
 
 	input_dev->name = "Atlas ACPI button driver";
 	input_dev->phys = "ASIM0000/atlas/input0";
diff --git a/drivers/input/misc/da9052_onkey.c b/drivers/input/misc/da9052_onkey.c
index 020569a..53591e8 100644
--- a/drivers/input/misc/da9052_onkey.c
+++ b/drivers/input/misc/da9052_onkey.c
@@ -85,7 +85,6 @@ static int da9052_onkey_probe(struct platform_device *pdev)
 	onkey = kzalloc(sizeof(*onkey), GFP_KERNEL);
 	input_dev = input_allocate_device();
 	if (!onkey || !input_dev) {
-		dev_err(&pdev->dev, "Failed to allocate memory\n");
 		error = -ENOMEM;
 		goto err_free_mem;
 	}
diff --git a/drivers/input/misc/da9055_onkey.c b/drivers/input/misc/da9055_onkey.c
index a0af8b2..76bc187 100644
--- a/drivers/input/misc/da9055_onkey.c
+++ b/drivers/input/misc/da9055_onkey.c
@@ -94,10 +94,8 @@ static int da9055_onkey_probe(struct platform_device *pdev)
 	}
 
 	input_dev = input_allocate_device();
-	if (!input_dev) {
-		dev_err(&pdev->dev, "Failed to allocate memory\n");
+	if (!input_dev)
 		return -ENOMEM;
-	}
 
 	onkey->input = input_dev;
 	onkey->da9055 = da9055;
diff --git a/drivers/input/misc/ideapad_slidebar.c b/drivers/input/misc/ideapad_slidebar.c
index edfd623..2cd57b43 100644
--- a/drivers/input/misc/ideapad_slidebar.c
+++ b/drivers/input/misc/ideapad_slidebar.c
@@ -223,7 +223,6 @@ static int __init ideapad_probe(struct platform_device* pdev)
 
 	slidebar_input_dev = input_allocate_device();
 	if (!slidebar_input_dev) {
-		dev_err(&pdev->dev, "Failed to allocate input device\n");
 		err = -ENOMEM;
 		goto err_release_ports;
 	}
diff --git a/drivers/input/misc/ims-pcu.c b/drivers/input/misc/ims-pcu.c
index e204f26..444dd85 100644
--- a/drivers/input/misc/ims-pcu.c
+++ b/drivers/input/misc/ims-pcu.c
@@ -206,11 +206,8 @@ static int ims_pcu_setup_buttons(struct ims_pcu *pcu,
 	int error;
 
 	input = input_allocate_device();
-	if (!input) {
-		dev_err(pcu->dev,
-			"Not enough memory for input input device\n");
+	if (!input)
 		return -ENOMEM;
-	}
 
 	snprintf(buttons->name, sizeof(buttons->name),
 		 "IMS PCU#%d Button Interface", pcu->device_no);
@@ -290,8 +287,6 @@ static int ims_pcu_setup_gamepad(struct ims_pcu *pcu)
 	gamepad = kzalloc(sizeof(struct ims_pcu_gamepad), GFP_KERNEL);
 	input = input_allocate_device();
 	if (!gamepad || !input) {
-		dev_err(pcu->dev,
-			"Not enough memory for gamepad device\n");
 		error = -ENOMEM;
 		goto err_free_mem;
 	}
diff --git a/drivers/input/misc/kxtj9.c b/drivers/input/misc/kxtj9.c
index a993b67..7734eed 100644
--- a/drivers/input/misc/kxtj9.c
+++ b/drivers/input/misc/kxtj9.c
@@ -314,10 +314,8 @@ static int kxtj9_setup_input_device(struct kxtj9_data *tj9)
 	int err;
 
 	input_dev = input_allocate_device();
-	if (!input_dev) {
-		dev_err(&tj9->client->dev, "input device allocate failed\n");
+	if (!input_dev)
 		return -ENOMEM;
-	}
 
 	tj9->input_dev = input_dev;
 
diff --git a/drivers/input/misc/max8997_haptic.c b/drivers/input/misc/max8997_haptic.c
index e973133..b2f9615 100644
--- a/drivers/input/misc/max8997_haptic.c
+++ b/drivers/input/misc/max8997_haptic.c
@@ -260,7 +260,6 @@ static int max8997_haptic_probe(struct platform_device *pdev)
 	chip = kzalloc(sizeof(struct max8997_haptic), GFP_KERNEL);
 	input_dev = input_allocate_device();
 	if (!chip || !input_dev) {
-		dev_err(&pdev->dev, "unable to allocate memory\n");
 		error = -ENOMEM;
 		goto err_free_mem;
 	}
diff --git a/drivers/input/misc/mc13783-pwrbutton.c b/drivers/input/misc/mc13783-pwrbutton.c
index d0277a7..87538be 100644
--- a/drivers/input/misc/mc13783-pwrbutton.c
+++ b/drivers/input/misc/mc13783-pwrbutton.c
@@ -105,10 +105,8 @@ static int mc13783_pwrbutton_probe(struct platform_device *pdev)
 	}
 
 	pwr = input_allocate_device();
-	if (!pwr) {
-		dev_dbg(&pdev->dev, "Can't allocate power button\n");
+	if (!pwr)
 		return -ENOMEM;
-	}
 
 	priv = kzalloc(sizeof(*priv), GFP_KERNEL);
 	if (!priv) {
diff --git a/drivers/input/misc/mpu3050.c b/drivers/input/misc/mpu3050.c
index dce0d95..d21521d 100644
--- a/drivers/input/misc/mpu3050.c
+++ b/drivers/input/misc/mpu3050.c
@@ -317,7 +317,6 @@ static int mpu3050_probe(struct i2c_client *client,
 	sensor = kzalloc(sizeof(struct mpu3050_sensor), GFP_KERNEL);
 	idev = input_allocate_device();
 	if (!sensor || !idev) {
-		dev_err(&client->dev, "failed to allocate driver data\n");
 		error = -ENOMEM;
 		goto err_free_mem;
 	}
diff --git a/drivers/input/misc/pcf8574_keypad.c b/drivers/input/misc/pcf8574_keypad.c
index e373929..729de73 100644
--- a/drivers/input/misc/pcf8574_keypad.c
+++ b/drivers/input/misc/pcf8574_keypad.c
@@ -99,7 +99,6 @@ static int pcf8574_kp_probe(struct i2c_client *client, const struct i2c_device_i
 
 	idev = input_allocate_device();
 	if (!idev) {
-		dev_err(&client->dev, "Can't allocate input device\n");
 		ret = -ENOMEM;
 		goto fail_allocate;
 	}
diff --git a/drivers/input/misc/pm8xxx-vibrator.c b/drivers/input/misc/pm8xxx-vibrator.c
index ec086f6..9e5f13a 100644
--- a/drivers/input/misc/pm8xxx-vibrator.c
+++ b/drivers/input/misc/pm8xxx-vibrator.c
@@ -189,7 +189,6 @@ static int pm8xxx_vib_probe(struct platform_device *pdev)
 	vib = kzalloc(sizeof(*vib), GFP_KERNEL);
 	input_dev = input_allocate_device();
 	if (!vib || !input_dev) {
-		dev_err(&pdev->dev, "couldn't allocate memory\n");
 		error = -ENOMEM;
 		goto err_free_mem;
 	}
diff --git a/drivers/input/misc/pmic8xxx-pwrkey.c b/drivers/input/misc/pmic8xxx-pwrkey.c
index b49b738..a411b28 100644
--- a/drivers/input/misc/pmic8xxx-pwrkey.c
+++ b/drivers/input/misc/pmic8xxx-pwrkey.c
@@ -109,7 +109,6 @@ static int pmic8xxx_pwrkey_probe(struct platform_device *pdev)
 
 	pwr = input_allocate_device();
 	if (!pwr) {
-		dev_dbg(&pdev->dev, "Can't allocate power button\n");
 		err = -ENOMEM;
 		goto free_pwrkey;
 	}
diff --git a/drivers/input/misc/pwm-beeper.c b/drivers/input/misc/pwm-beeper.c
index 2ff4d1c..41c5535 100644
--- a/drivers/input/misc/pwm-beeper.c
+++ b/drivers/input/misc/pwm-beeper.c
@@ -89,7 +89,6 @@ static int pwm_beeper_probe(struct platform_device *pdev)
 
 	beeper->input = input_allocate_device();
 	if (!beeper->input) {
-		dev_err(&pdev->dev, "Failed to allocate input device\n");
 		error = -ENOMEM;
 		goto err_pwm_free;
 	}
diff --git a/drivers/input/misc/twl4030-pwrbutton.c b/drivers/input/misc/twl4030-pwrbutton.c
index b9a05fd..4405548 100644
--- a/drivers/input/misc/twl4030-pwrbutton.c
+++ b/drivers/input/misc/twl4030-pwrbutton.c
@@ -59,10 +59,8 @@ static int __init twl4030_pwrbutton_probe(struct platform_device *pdev)
 	int err;
 
 	pwr = input_allocate_device();
-	if (!pwr) {
-		dev_dbg(&pdev->dev, "Can't allocate power button\n");
+	if (!pwr)
 		return -ENOMEM;
-	}
 
 	pwr->evbit[0] = BIT_MASK(EV_KEY);
 	pwr->keybit[BIT_WORD(KEY_POWER)] = BIT_MASK(KEY_POWER);
diff --git a/drivers/input/misc/twl6040-vibra.c b/drivers/input/misc/twl6040-vibra.c
index 7864b0c..1272a65 100644
--- a/drivers/input/misc/twl6040-vibra.c
+++ b/drivers/input/misc/twl6040-vibra.c
@@ -354,7 +354,6 @@ static int twl6040_vibra_probe(struct platform_device *pdev)
 
 	info->input_dev = input_allocate_device();
 	if (info->input_dev == NULL) {
-		dev_err(info->dev, "couldn't allocate input device\n");
 		ret = -ENOMEM;
 		goto err_regulator;
 	}
diff --git a/drivers/input/mouse/appletouch.c b/drivers/input/mouse/appletouch.c
index e42f1fa..20dcbf9 100644
--- a/drivers/input/mouse/appletouch.c
+++ b/drivers/input/mouse/appletouch.c
@@ -798,10 +798,8 @@ static int atp_probe(struct usb_interface *iface,
 	/* allocate memory for our device state and initialize it */
 	dev = kzalloc(sizeof(struct atp), GFP_KERNEL);
 	input_dev = input_allocate_device();
-	if (!dev || !input_dev) {
-		dev_err(&iface->dev, "Out of memory\n");
+	if (!dev || !input_dev)
 		goto err_free_devs;
-	}
 
 	dev->udev = udev;
 	dev->intf = iface;
diff --git a/drivers/input/mouse/bcm5974.c b/drivers/input/mouse/bcm5974.c
index a73f961..2ca2861 100644
--- a/drivers/input/mouse/bcm5974.c
+++ b/drivers/input/mouse/bcm5974.c
@@ -862,10 +862,8 @@ static int bcm5974_probe(struct usb_interface *iface,
 	/* allocate memory for our device state and initialize it */
 	dev = kzalloc(sizeof(struct bcm5974), GFP_KERNEL);
 	input_dev = input_allocate_device();
-	if (!dev || !input_dev) {
-		dev_err(&iface->dev, "out of memory\n");
+	if (!dev || !input_dev)
 		goto err_free_devs;
-	}
 
 	dev->udev = udev;
 	dev->intf = iface;
diff --git a/drivers/input/mouse/cyapa.c b/drivers/input/mouse/cyapa.c
index b409c3d7..736e156 100644
--- a/drivers/input/mouse/cyapa.c
+++ b/drivers/input/mouse/cyapa.c
@@ -763,10 +763,8 @@ static int cyapa_create_input_dev(struct cyapa *cyapa)
 		return -EINVAL;
 
 	input = cyapa->input = input_allocate_device();
-	if (!input) {
-		dev_err(dev, "allocate memory for input device failed\n");
+	if (!input)
 		return -ENOMEM;
-	}
 
 	input->name = CYAPA_NAME;
 	input->phys = cyapa->phys;
diff --git a/drivers/input/mouse/inport.c b/drivers/input/mouse/inport.c
index 3827a22..7b66f11 100644
--- a/drivers/input/mouse/inport.c
+++ b/drivers/input/mouse/inport.c
@@ -148,7 +148,6 @@ static int __init inport_init(void)
 
 	inport_dev = input_allocate_device();
 	if (!inport_dev) {
-		printk(KERN_ERR "inport.c: Not enough memory for input device\n");
 		err = -ENOMEM;
 		goto err_release_region;
 	}
diff --git a/drivers/input/mouse/logibm.c b/drivers/input/mouse/logibm.c
index e241311..2af1235 100644
--- a/drivers/input/mouse/logibm.c
+++ b/drivers/input/mouse/logibm.c
@@ -141,7 +141,6 @@ static int __init logibm_init(void)
 
 	logibm_dev = input_allocate_device();
 	if (!logibm_dev) {
-		printk(KERN_ERR "logibm.c: Not enough memory for input device\n");
 		err = -ENOMEM;
 		goto err_release_region;
 	}
diff --git a/drivers/input/mouse/pc110pad.c b/drivers/input/mouse/pc110pad.c
index 7b02b65..d08965b 100644
--- a/drivers/input/mouse/pc110pad.c
+++ b/drivers/input/mouse/pc110pad.c
@@ -129,7 +129,6 @@ static int __init pc110pad_init(void)
 
 	pc110pad_dev = input_allocate_device();
 	if (!pc110pad_dev) {
-		printk(KERN_ERR "pc110pad: Not enough memory.\n");
 		err = -ENOMEM;
 		goto err_free_irq;
 	}
diff --git a/drivers/input/mouse/pxa930_trkball.c b/drivers/input/mouse/pxa930_trkball.c
index 0ecb9e7..0ab27cc 100644
--- a/drivers/input/mouse/pxa930_trkball.c
+++ b/drivers/input/mouse/pxa930_trkball.c
@@ -194,7 +194,6 @@ static int pxa930_trkball_probe(struct platform_device *pdev)
 
 	input = input_allocate_device();
 	if (!input) {
-		dev_err(&pdev->dev, "failed to allocate input device\n");
 		error = -ENOMEM;
 		goto failed_free_irq;
 	}
diff --git a/drivers/input/tablet/aiptek.c b/drivers/input/tablet/aiptek.c
index ee83c39..fa309d9 100644
--- a/drivers/input/tablet/aiptek.c
+++ b/drivers/input/tablet/aiptek.c
@@ -1710,11 +1710,8 @@ aiptek_probe(struct usb_interface *intf, const struct usb_device_id *id)
 
 	aiptek = kzalloc(sizeof(struct aiptek), GFP_KERNEL);
 	inputdev = input_allocate_device();
-	if (!aiptek || !inputdev) {
-		dev_warn(&intf->dev,
-			 "cannot allocate memory or input device\n");
+	if (!aiptek || !inputdev)
 		goto fail1;
-        }
 
 	aiptek->data = usb_alloc_coherent(usbdev, AIPTEK_PACKET_LENGTH,
 					  GFP_ATOMIC, &aiptek->data_dma);
diff --git a/drivers/input/tablet/gtco.c b/drivers/input/tablet/gtco.c
index 29e01ab..fddff41 100644
--- a/drivers/input/tablet/gtco.c
+++ b/drivers/input/tablet/gtco.c
@@ -840,7 +840,6 @@ static int gtco_probe(struct usb_interface *usbinterface,
 	gtco = kzalloc(sizeof(struct gtco), GFP_KERNEL);
 	input_dev = input_allocate_device();
 	if (!gtco || !input_dev) {
-		dev_err(&usbinterface->dev, "No more memory\n");
 		error = -ENOMEM;
 		goto err_free_devs;
 	}
diff --git a/drivers/input/touchscreen/88pm860x-ts.c b/drivers/input/touchscreen/88pm860x-ts.c
index f7de14a..53373b2 100644
--- a/drivers/input/touchscreen/88pm860x-ts.c
+++ b/drivers/input/touchscreen/88pm860x-ts.c
@@ -241,7 +241,6 @@ static int pm860x_touch_probe(struct platform_device *pdev)
 
 	touch->idev = input_allocate_device();
 	if (touch->idev == NULL) {
-		dev_err(&pdev->dev, "Failed to allocate input device!\n");
 		ret = -ENOMEM;
 		goto out;
 	}
diff --git a/drivers/input/touchscreen/atmel_mxt_ts.c b/drivers/input/touchscreen/atmel_mxt_ts.c
index 59aa240..aa1fbc0 100644
--- a/drivers/input/touchscreen/atmel_mxt_ts.c
+++ b/drivers/input/touchscreen/atmel_mxt_ts.c
@@ -1142,7 +1142,6 @@ static int mxt_probe(struct i2c_client *client,
 	data = kzalloc(sizeof(struct mxt_data), GFP_KERNEL);
 	input_dev = input_allocate_device();
 	if (!data || !input_dev) {
-		dev_err(&client->dev, "Failed to allocate memory\n");
 		error = -ENOMEM;
 		goto err_free_mem;
 	}
diff --git a/drivers/input/touchscreen/atmel_tsadcc.c b/drivers/input/touchscreen/atmel_tsadcc.c
index bddabc5..8da3902 100644
--- a/drivers/input/touchscreen/atmel_tsadcc.c
+++ b/drivers/input/touchscreen/atmel_tsadcc.c
@@ -206,7 +206,6 @@ static int atmel_tsadcc_probe(struct platform_device *pdev)
 
 	input_dev = input_allocate_device();
 	if (!input_dev) {
-		dev_err(&pdev->dev, "failed to allocate input device.\n");
 		err = -EBUSY;
 		goto err_free_mem;
 	}
diff --git a/drivers/input/touchscreen/bu21013_ts.c b/drivers/input/touchscreen/bu21013_ts.c
index b9b5dda..29a09e5 100644
--- a/drivers/input/touchscreen/bu21013_ts.c
+++ b/drivers/input/touchscreen/bu21013_ts.c
@@ -524,7 +524,6 @@ static int bu21013_probe(struct i2c_client *client,
 	bu21013_data = kzalloc(sizeof(struct bu21013_ts_data), GFP_KERNEL);
 	in_dev = input_allocate_device();
 	if (!bu21013_data || !in_dev) {
-		dev_err(&client->dev, "device memory alloc failed\n");
 		error = -ENOMEM;
 		goto err_free_mem;
 	}
diff --git a/drivers/input/touchscreen/cyttsp4_core.c b/drivers/input/touchscreen/cyttsp4_core.c
index a035a39..9b86453 100644
--- a/drivers/input/touchscreen/cyttsp4_core.c
+++ b/drivers/input/touchscreen/cyttsp4_core.c
@@ -1958,8 +1958,6 @@ static int cyttsp4_mt_probe(struct cyttsp4 *cd)
 		__func__);
 	md->input = input_allocate_device();
 	if (md->input == NULL) {
-		dev_err(dev, "%s: Error, failed to allocate input device\n",
-			__func__);
 		rc = -ENOSYS;
 		goto error_alloc_failed;
 	}
diff --git a/drivers/input/touchscreen/da9034-ts.c b/drivers/input/touchscreen/da9034-ts.c
index 34ad841..0ec0761 100644
--- a/drivers/input/touchscreen/da9034-ts.c
+++ b/drivers/input/touchscreen/da9034-ts.c
@@ -325,7 +325,6 @@ static int da9034_touch_probe(struct platform_device *pdev)
 
 	input_dev = input_allocate_device();
 	if (!input_dev) {
-		dev_err(&pdev->dev, "failed to allocate input device\n");
 		ret = -ENOMEM;
 		goto err_free_touch;
 	}
diff --git a/drivers/input/touchscreen/edt-ft5x06.c b/drivers/input/touchscreen/edt-ft5x06.c
index 83fa1b1..675184a 100644
--- a/drivers/input/touchscreen/edt-ft5x06.c
+++ b/drivers/input/touchscreen/edt-ft5x06.c
@@ -736,7 +736,6 @@ static int edt_ft5x06_ts_probe(struct i2c_client *client,
 	tsdata = kzalloc(sizeof(*tsdata), GFP_KERNEL);
 	input = input_allocate_device();
 	if (!tsdata || !input) {
-		dev_err(&client->dev, "failed to allocate driver data.\n");
 		error = -ENOMEM;
 		goto err_free_mem;
 	}
diff --git a/drivers/input/touchscreen/eeti_ts.c b/drivers/input/touchscreen/eeti_ts.c
index 1ce3d29..d2e509e 100644
--- a/drivers/input/touchscreen/eeti_ts.c
+++ b/drivers/input/touchscreen/eeti_ts.c
@@ -178,11 +178,8 @@ static int eeti_ts_probe(struct i2c_client *client,
 
 	mutex_init(&priv->mutex);
 	input = input_allocate_device();
-
-	if (!input) {
-		dev_err(&client->dev, "Failed to allocate input device.\n");
+	if (!input)
 		goto err1;
-	}
 
 	input->evbit[0] = BIT_MASK(EV_KEY) | BIT_MASK(EV_ABS);
 	input->keybit[BIT_WORD(BTN_TOUCH)] = BIT_MASK(BTN_TOUCH);
diff --git a/drivers/input/touchscreen/htcpen.c b/drivers/input/touchscreen/htcpen.c
index 92e2243..ddd2d14 100644
--- a/drivers/input/touchscreen/htcpen.c
+++ b/drivers/input/touchscreen/htcpen.c
@@ -127,7 +127,6 @@ static int htcpen_isa_probe(struct device *dev, unsigned int id)
 
 	htcpen_dev = input_allocate_device();
 	if (!htcpen_dev) {
-		printk(KERN_ERR "htcpen: can't allocate device\n");
 		err = -ENOMEM;
 		goto input_alloc_failed;
 	}
diff --git a/drivers/input/touchscreen/intel-mid-touch.c b/drivers/input/touchscreen/intel-mid-touch.c
index e30d837..95bf513 100644
--- a/drivers/input/touchscreen/intel-mid-touch.c
+++ b/drivers/input/touchscreen/intel-mid-touch.c
@@ -584,7 +584,6 @@ static int mrstouch_probe(struct platform_device *pdev)
 	tsdev = kzalloc(sizeof(struct mrstouch_dev), GFP_KERNEL);
 	input = input_allocate_device();
 	if (!tsdev || !input) {
-		dev_err(&pdev->dev, "unable to allocate memory\n");
 		err = -ENOMEM;
 		goto err_free_mem;
 	}
diff --git a/drivers/input/touchscreen/lpc32xx_ts.c b/drivers/input/touchscreen/lpc32xx_ts.c
index 9101ee5..5b24d4c 100644
--- a/drivers/input/touchscreen/lpc32xx_ts.c
+++ b/drivers/input/touchscreen/lpc32xx_ts.c
@@ -227,7 +227,6 @@ static int lpc32xx_ts_probe(struct platform_device *pdev)
 	tsc = kzalloc(sizeof(*tsc), GFP_KERNEL);
 	input = input_allocate_device();
 	if (!tsc || !input) {
-		dev_err(&pdev->dev, "failed allocating memory\n");
 		error = -ENOMEM;
 		goto err_free_mem;
 	}
diff --git a/drivers/input/touchscreen/mcs5000_ts.c b/drivers/input/touchscreen/mcs5000_ts.c
index f9f4e0c..85101e7 100644
--- a/drivers/input/touchscreen/mcs5000_ts.c
+++ b/drivers/input/touchscreen/mcs5000_ts.c
@@ -200,7 +200,6 @@ static int mcs5000_ts_probe(struct i2c_client *client,
 	data = kzalloc(sizeof(struct mcs5000_ts_data), GFP_KERNEL);
 	input_dev = input_allocate_device();
 	if (!data || !input_dev) {
-		dev_err(&client->dev, "Failed to allocate memory\n");
 		ret = -ENOMEM;
 		goto err_free_mem;
 	}
diff --git a/drivers/input/touchscreen/migor_ts.c b/drivers/input/touchscreen/migor_ts.c
index c038db9..23a2fd5 100644
--- a/drivers/input/touchscreen/migor_ts.c
+++ b/drivers/input/touchscreen/migor_ts.c
@@ -139,7 +139,6 @@ static int migor_ts_probe(struct i2c_client *client,
 	priv = kzalloc(sizeof(*priv), GFP_KERNEL);
 	input = input_allocate_device();
 	if (!priv || !input) {
-		dev_err(&client->dev, "failed to allocate memory\n");
 		error = -ENOMEM;
 		goto err_free_mem;
 	}
diff --git a/drivers/input/touchscreen/mk712.c b/drivers/input/touchscreen/mk712.c
index 36e57de..0ba4e47 100644
--- a/drivers/input/touchscreen/mk712.c
+++ b/drivers/input/touchscreen/mk712.c
@@ -170,7 +170,6 @@ static int __init mk712_init(void)
 
 	mk712_dev = input_allocate_device();
 	if (!mk712_dev) {
-		printk(KERN_ERR "mk712: not enough memory\n");
 		err = -ENOMEM;
 		goto fail1;
 	}
diff --git a/drivers/input/touchscreen/pixcir_i2c_ts.c b/drivers/input/touchscreen/pixcir_i2c_ts.c
index 6cc6b36..70580b6 100644
--- a/drivers/input/touchscreen/pixcir_i2c_ts.c
+++ b/drivers/input/touchscreen/pixcir_i2c_ts.c
@@ -141,7 +141,6 @@ static int pixcir_i2c_ts_probe(struct i2c_client *client,
 	tsdata = kzalloc(sizeof(*tsdata), GFP_KERNEL);
 	input = input_allocate_device();
 	if (!tsdata || !input) {
-		dev_err(&client->dev, "Failed to allocate driver data!\n");
 		error = -ENOMEM;
 		goto err_free_mem;
 	}
diff --git a/drivers/input/touchscreen/s3c2410_ts.c b/drivers/input/touchscreen/s3c2410_ts.c
index b061af2..40461f8 100644
--- a/drivers/input/touchscreen/s3c2410_ts.c
+++ b/drivers/input/touchscreen/s3c2410_ts.c
@@ -308,7 +308,6 @@ static int s3c2410ts_probe(struct platform_device *pdev)
 
 	input_dev = input_allocate_device();
 	if (!input_dev) {
-		dev_err(dev, "Unable to allocate the input device !!\n");
 		ret = -ENOMEM;
 		goto err_iomap;
 	}
diff --git a/drivers/input/touchscreen/ti_am335x_tsc.c b/drivers/input/touchscreen/ti_am335x_tsc.c
index 24e625c..698b70c 100644
--- a/drivers/input/touchscreen/ti_am335x_tsc.c
+++ b/drivers/input/touchscreen/ti_am335x_tsc.c
@@ -378,7 +378,6 @@ static int titsc_probe(struct platform_device *pdev)
 	ts_dev = kzalloc(sizeof(struct titsc), GFP_KERNEL);
 	input_dev = input_allocate_device();
 	if (!ts_dev || !input_dev) {
-		dev_err(&pdev->dev, "failed to allocate memory.\n");
 		err = -ENOMEM;
 		goto err_free_mem;
 	}
diff --git a/drivers/input/touchscreen/tnetv107x-ts.c b/drivers/input/touchscreen/tnetv107x-ts.c
index c47827a..e3bff77 100644
--- a/drivers/input/touchscreen/tnetv107x-ts.c
+++ b/drivers/input/touchscreen/tnetv107x-ts.c
@@ -306,7 +306,6 @@ static int tsc_probe(struct platform_device *pdev)
 
 	ts->input_dev = input_allocate_device();
 	if (!ts->input_dev) {
-		dev_err(dev, "cannot allocate input device\n");
 		error = -ENOMEM;
 		goto error_input;
 	}
-- 
1.8.1.2.459.gbcd45b4.dirty

