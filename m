Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752386AbbARNbZ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Jan 2015 08:31:25 -0500
Received: from mout.gmx.net ([212.227.17.22]:60152 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751398AbbARNbX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Jan 2015 08:31:23 -0500
From: Peter =?iso-8859-15?q?H=FCwe?= <PeterHuewe@gmx.de>
To: Bruno E O Meneguele <bmeneguele@gmail.com>
Subject: Re: [PATCH] Char: tpm: fixed white spaces and braces coding style issues
Date: Sun, 18 Jan 2015 14:33:23 +0100
User-Agent: KMail/1.13.7 (Linux/3.18.3-dirty; KDE/4.14.3; x86_64; ; )
Cc: linux-kernel@vger.kernel.org
References: <1421510610-12139-1-git-send-email-bmeneguele@gmail.com>
In-Reply-To: <1421510610-12139-1-git-send-email-bmeneguele@gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201501181433.24247.PeterHuewe@gmx.de>
X-Provags-ID: V03:K0:VaQf18MZNH7Qoy9Q5EBr3P9BaRswr31DK7o9q9SPPHfg+ljno/U
 AnGp0MpapncMMDZ3EAg9dAWu9GqnESS4BpZfDHs8HCnPh5lhTGfSKEhI+4eeR1ZsdDTozmn
 42dG1iOxt0pofAcudTZUEDouL3gyBCf+L1xLzXn/LF5YJXCqNqNS8WQeRnkBQG/km7dwz6n
 k8aJ28CExi6MmuaUZhD+Q==
X-UI-Out-Filterresults: notjunk:1;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Bruno,

thanks for your patch!
The patch is fine, 
but unfortunately not against the latest version of the tpm subsytem code.

You can find the latest version of the tpm subsystem at   
https://github.com/PeterHuewe/linux-tpmdd 
the for-james branch is usually the best choice here.

Nevertheless, I quickly ported it to the latest code (see below)
--> applied.



> Fixed some coding style issues.
Usually it is quite good if you include the reports by checkpatch.

Thanks,
Peter


So this is what got merged, the rest does not apply anymore due to recent code 
changes:



From: Bruno E O Meneguele <bmeneguele@gmail.com>
Date: Sat, 17 Jan 2015 17:03:30 +0100
Subject: [PATCH] char/tpm: fixed white spaces coding style issues

Fixed some coding style issues reported by checkpatch.

Signed-off-by: Bruno E O Meneguele <bmeneguele@gmail.com>
[phuewe: ported to latest code]
Signed-off-by: Peter Huewe <peterhuewe@gmx.de>
---
 drivers/char/tpm/tpm.h              | 6 +++---
 drivers/char/tpm/tpm_i2c_stm_st33.c | 2 +-
 2 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/char/tpm/tpm.h b/drivers/char/tpm/tpm.h
index cc421cf..7b0727c 100644
--- a/drivers/char/tpm/tpm.h
+++ b/drivers/char/tpm/tpm.h
@@ -10,13 +10,13 @@
  * Maintained by: <tpmdd-devel@lists.sourceforge.net>
  *
  * Device driver for TCG/TCPA TPM (trusted platform module).
- * Specifications at www.trustedcomputinggroup.org	 
+ * Specifications at www.trustedcomputinggroup.org
  *
  * This program is free software; you can redistribute it and/or
  * modify it under the terms of the GNU General Public License as
  * published by the Free Software Foundation, version 2 of the
  * License.
- * 
+ *
  */
 #include <linux/module.h>
 #include <linux/delay.h>
@@ -141,7 +141,7 @@ struct tpm_vendor_specific {
 	u16 manufacturer_id;
 };
 
-#define TPM_VPRIV(c)	(c)->vendor.priv
+#define TPM_VPRIV(c)     ((c)->vendor.priv)
 
 #define TPM_VID_INTEL    0x8086
 #define TPM_VID_WINBOND  0x1050
diff --git a/drivers/char/tpm/tpm_i2c_stm_st33.c 
b/drivers/char/tpm/tpm_i2c_stm_st33.c
index dbab8d0..612845b 100644
--- a/drivers/char/tpm/tpm_i2c_stm_st33.c
+++ b/drivers/char/tpm/tpm_i2c_stm_st33.c
@@ -777,7 +777,7 @@ tpm_stm_i2c_probe(struct i2c_client *client, const struct 
i2c_device_id *id)
 				IRQF_TRIGGER_HIGH,
 				"TPM SERIRQ management", chip);
 		if (ret < 0) {
-			dev_err(chip->pdev , "TPM SERIRQ signals %d not available\n",
+			dev_err(chip->pdev, "TPM SERIRQ signals %d not available\n",
 				client->irq);
 			goto _tpm_clean_answer;
 		}
-- 
2.0.5

