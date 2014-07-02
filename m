Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755880AbaGBPaS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jul 2014 11:30:18 -0400
Received: from mail-ie0-f177.google.com ([209.85.223.177]:47198 "EHLO
	mail-ie0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755584AbaGBP3p (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jul 2014 11:29:45 -0400
From: Lee Jones <lee.jones@linaro.org>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Cc: sameo@linux.intel.com, linus.walleij@linaro.org,
        Lee Jones <lee.jones@linaro.org>
Subject: [PATCH 11/12] mfd: ab3100-core: Correct code sytle problems
Date: Wed,  2 Jul 2014 16:28:43 +0100
Message-Id: <1404314924-23564-12-git-send-email-lee.jones@linaro.org>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1404314924-23564-1-git-send-email-lee.jones@linaro.org>
References: <1404314924-23564-1-git-send-email-lee.jones@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Corrects the following checkpatch gripes:

    WARNING: quoted string split across lines
    #95: FILE: drivers/mfd/ab3100-core.c:95:
    +			"write error (write register) "
    +			"%d bytes transferred (expected 2)\n",

    WARNING: quoted string split across lines
    #139: FILE: drivers/mfd/ab3100-core.c:139:
    +			"write error (write test register) "
    +			"%d bytes transferred (expected 2)\n",

    WARNING: quoted string split across lines
    #175: FILE: drivers/mfd/ab3100-core.c:175:
    +			"write error (send register address) "
    +			"%d bytes transferred (expected 1)\n",

    WARNING: quoted string split across lines
    #193: FILE: drivers/mfd/ab3100-core.c:193:
    +			"write error (read register) "
    +			"%d bytes transferred (expected 1)\n",

    WARNING: quoted string split across lines
    #241: FILE: drivers/mfd/ab3100-core.c:241:
    +			"write error (send first register address) "
    +			"%d bytes transferred (expected 1)\n",

    WARNING: quoted string split across lines
    #256: FILE: drivers/mfd/ab3100-core.c:256:
    +			"write error (read register page) "
    +			"%d bytes transferred (expected %d)\n",

    WARNING: quoted string split across lines
    #299: FILE: drivers/mfd/ab3100-core.c:299:
    +			"write error (maskset send address) "
    +			"%d bytes transferred (expected 1)\n",

    WARNING: quoted string split across lines
    #314: FILE: drivers/mfd/ab3100-core.c:314:
    +			"write error (maskset read register) "
    +			"%d bytes transferred (expected 1)\n",

    WARNING: quoted string split across lines
    #334: FILE: drivers/mfd/ab3100-core.c:334:
    +			"write error (write register) "
    +			"%d bytes transferred (expected 2)\n",

    WARNING: please, no spaces at the start of a line
    #374: FILE: drivers/mfd/ab3100-core.c:374:
    +  return blocking_notifier_chain_unregister(&ab3100->event_subscribers,$

    WARNING: Prefer seq_puts to seq_printf
    #458: FILE: drivers/mfd/ab3100-core.c:458:
    +	seq_printf(s, "AB3100 registers:\n");

    WARNING: quoted string split across lines
    #564: FILE: drivers/mfd/ab3100-core.c:564:
    +			 "debug write reg[0x%02x] with 0x%02x, "
    +			 "after readback: 0x%02x\n",

    WARNING: quoted string split across lines
    #723: FILE: drivers/mfd/ab3100-core.c:723:
    +			 "AB3100 P1E variant detected, "
    +			 "forcing chip to 32KHz\n");

    WARNING: quoted string split across lines
    #882: FILE: drivers/mfd/ab3100-core.c:882:
    +			"could not communicate with the AB3100 analog "
    +			"baseband chip\n");

    WARNING: quoted string split across lines
    #906: FILE: drivers/mfd/ab3100-core.c:906:
    +		dev_err(&client->dev, "accepting it anyway. Please update "
    +			"the driver.\n");

    total: 0 errors, 15 warnings, 999 lines checked

Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 drivers/mfd/ab3100-core.c | 54 +++++++++++++++++++++++------------------------
 1 file changed, 26 insertions(+), 28 deletions(-)

diff --git a/drivers/mfd/ab3100-core.c b/drivers/mfd/ab3100-core.c
index b348ae5..4659ac1 100644
--- a/drivers/mfd/ab3100-core.c
+++ b/drivers/mfd/ab3100-core.c
@@ -91,8 +91,8 @@ static int ab3100_set_register_interruptible(struct ab3100 *ab3100,
 			err);
 	} else if (err != 2) {
 		dev_err(ab3100->dev,
-			"write error (write register) "
-			"%d bytes transferred (expected 2)\n",
+			"write error (write register)\n"
+			"  %d bytes transferred (expected 2)\n",
 			err);
 		err = -EIO;
 	} else {
@@ -135,8 +135,8 @@ static int ab3100_set_test_register_interruptible(struct ab3100 *ab3100,
 			err);
 	} else if (err != 2) {
 		dev_err(ab3100->dev,
-			"write error (write test register) "
-			"%d bytes transferred (expected 2)\n",
+			"write error (write test register)\n"
+			"  %d bytes transferred (expected 2)\n",
 			err);
 		err = -EIO;
 	} else {
@@ -171,8 +171,8 @@ static int ab3100_get_register_interruptible(struct ab3100 *ab3100,
 		goto get_reg_out_unlock;
 	} else if (err != 1) {
 		dev_err(ab3100->dev,
-			"write error (send register address) "
-			"%d bytes transferred (expected 1)\n",
+			"write error (send register address)\n"
+			"  %d bytes transferred (expected 1)\n",
 			err);
 		err = -EIO;
 		goto get_reg_out_unlock;
@@ -189,8 +189,8 @@ static int ab3100_get_register_interruptible(struct ab3100 *ab3100,
 		goto get_reg_out_unlock;
 	} else if (err != 1) {
 		dev_err(ab3100->dev,
-			"write error (read register) "
-			"%d bytes transferred (expected 1)\n",
+			"write error (read register)\n"
+			"  %d bytes transferred (expected 1)\n",
 			err);
 		err = -EIO;
 		goto get_reg_out_unlock;
@@ -237,8 +237,8 @@ static int ab3100_get_register_page_interruptible(struct ab3100 *ab3100,
 		goto get_reg_page_out_unlock;
 	} else if (err != 1) {
 		dev_err(ab3100->dev,
-			"write error (send first register address) "
-			"%d bytes transferred (expected 1)\n",
+			"write error (send first register address)\n"
+			"  %d bytes transferred (expected 1)\n",
 			err);
 		err = -EIO;
 		goto get_reg_page_out_unlock;
@@ -252,8 +252,8 @@ static int ab3100_get_register_page_interruptible(struct ab3100 *ab3100,
 		goto get_reg_page_out_unlock;
 	} else if (err != numregs) {
 		dev_err(ab3100->dev,
-			"write error (read register page) "
-			"%d bytes transferred (expected %d)\n",
+			"write error (read register page)\n"
+			"  %d bytes transferred (expected %d)\n",
 			err, numregs);
 		err = -EIO;
 		goto get_reg_page_out_unlock;
@@ -295,8 +295,8 @@ static int ab3100_mask_and_set_register_interruptible(struct ab3100 *ab3100,
 		goto get_maskset_unlock;
 	} else if (err != 1) {
 		dev_err(ab3100->dev,
-			"write error (maskset send address) "
-			"%d bytes transferred (expected 1)\n",
+			"write error (maskset send address)\n"
+			"  %d bytes transferred (expected 1)\n",
 			err);
 		err = -EIO;
 		goto get_maskset_unlock;
@@ -310,8 +310,8 @@ static int ab3100_mask_and_set_register_interruptible(struct ab3100 *ab3100,
 		goto get_maskset_unlock;
 	} else if (err != 1) {
 		dev_err(ab3100->dev,
-			"write error (maskset read register) "
-			"%d bytes transferred (expected 1)\n",
+			"write error (maskset read register)\n"
+			"  %d bytes transferred (expected 1)\n",
 			err);
 		err = -EIO;
 		goto get_maskset_unlock;
@@ -330,8 +330,8 @@ static int ab3100_mask_and_set_register_interruptible(struct ab3100 *ab3100,
 		goto get_maskset_unlock;
 	} else if (err != 2) {
 		dev_err(ab3100->dev,
-			"write error (write register) "
-			"%d bytes transferred (expected 2)\n",
+			"write error (write register)\n"
+			"  %d bytes transferred (expected 2)\n",
 			err);
 		err = -EIO;
 		goto get_maskset_unlock;
@@ -371,7 +371,7 @@ EXPORT_SYMBOL(ab3100_event_register);
 int ab3100_event_unregister(struct ab3100 *ab3100,
 			    struct notifier_block *nb)
 {
-  return blocking_notifier_chain_unregister(&ab3100->event_subscribers,
+	return blocking_notifier_chain_unregister(&ab3100->event_subscribers,
 					    nb);
 }
 EXPORT_SYMBOL(ab3100_event_unregister);
@@ -455,7 +455,7 @@ static int ab3100_registers_print(struct seq_file *s, void *p)
 	u8 value;
 	u8 reg;
 
-	seq_printf(s, "AB3100 registers:\n");
+	seq_puts(s, "AB3100 registers:\n");
 
 	for (reg = 0; reg < 0xff; reg++) {
 		ab3100_get_register_interruptible(ab3100, reg, &value);
@@ -560,8 +560,8 @@ static ssize_t ab3100_get_set_reg(struct file *file,
 		ab3100_get_register_interruptible(ab3100, user_reg, &regvalue);
 
 		dev_info(ab3100->dev,
-			 "debug write reg[0x%02x] with 0x%02x, "
-			 "after readback: 0x%02x\n",
+			 "debug write reg[0x%02x]\n"
+			 "  with 0x%02x, after readback: 0x%02x\n",
 			 user_reg, user_value, regvalue);
 	}
 	return buf_size;
@@ -719,8 +719,7 @@ static int ab3100_setup(struct ab3100 *ab3100)
 	 */
 	if (ab3100->chip_id == 0xc4) {
 		dev_warn(ab3100->dev,
-			 "AB3100 P1E variant detected, "
-			 "forcing chip to 32KHz\n");
+			 "AB3100 P1E variant detected forcing chip to 32KHz\n");
 		err = ab3100_set_test_register_interruptible(ab3100,
 			0x02, 0x08);
 	}
@@ -878,8 +877,7 @@ static int ab3100_probe(struct i2c_client *client,
 						&ab3100->chip_id);
 	if (err) {
 		dev_err(&client->dev,
-			"could not communicate with the AB3100 analog "
-			"baseband chip\n");
+			"failed to communicate with AB3100 chip\n");
 		goto exit_no_detect;
 	}
 
@@ -902,8 +900,8 @@ static int ab3100_probe(struct i2c_client *client,
 	if (ids[i].id == 0x0) {
 		dev_err(&client->dev, "unknown analog baseband chip id: 0x%x\n",
 			ab3100->chip_id);
-		dev_err(&client->dev, "accepting it anyway. Please update "
-			"the driver.\n");
+		dev_err(&client->dev,
+			"accepting it anyway. Please update the driver.\n");
 		goto exit_no_detect;
 	}
 
-- 
1.8.3.2

