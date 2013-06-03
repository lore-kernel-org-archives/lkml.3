Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757662Ab3FCMcH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Jun 2013 08:32:07 -0400
Received: from mail-we0-f180.google.com ([74.125.82.180]:57175 "EHLO
	mail-we0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757626Ab3FCMcD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Jun 2013 08:32:03 -0400
From: Michal Simek <michal.simek@xilinx.com>
To: linux-kernel@vger.kernel.org
Cc: Michal Simek <monstr@monstr.eu>, Michal Simek <michal.simek@xilinx.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Arnd Bergmann <arnd@arndb.de>, Grant Likely <grant.likely@linaro.org>
Subject: [PATCH v2 4/6] GPIO: xilinx: Use BIT macro
Date: Mon,  3 Jun 2013 14:31:19 +0200
Message-Id: <59b555e17f7cb055af93e555892bc43543c08ce3.1370262666.git.michal.simek@xilinx.com>
X-Mailer: git-send-email 1.8.2.3
In-Reply-To: <d96317c2681b5feb9e058efe0bd60ff101a0e0fa.1370262666.git.michal.simek@xilinx.com>
References: <d96317c2681b5feb9e058efe0bd60ff101a0e0fa.1370262666.git.michal.simek@xilinx.com>
In-Reply-To: <d96317c2681b5feb9e058efe0bd60ff101a0e0fa.1370262666.git.michal.simek@xilinx.com>
References: <d96317c2681b5feb9e058efe0bd60ff101a0e0fa.1370262666.git.michal.simek@xilinx.com>
Content-Type: multipart/signed;
    boundary="=_mimegpg-monstr-desktop-25596-1370262719-0001";
    micalg=pgp-sha1; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a MIME GnuPG-signed message.  If you see this text, it means that
your E-mail or Usenet software does not support MIME signed messages.
The Internet standard for MIME PGP messages, RFC 2015, was published in 1996.
To open this message correctly you will need to install E-mail or Usenet
software that supports modern Internet standards.

--=_mimegpg-monstr-desktop-25596-1370262719-0001

Use BIT macro from linux/bitops.h.

Signed-off-by: Michal Simek <michal.simek@xilinx.com>
---
Changes in v2:
- New patch in this series suggested by Linus Valleij

 drivers/gpio/gpio-xilinx.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/gpio/gpio-xilinx.c b/drivers/gpio/gpio-xilinx.c
index 791ddae..792a05a 100644
--- a/drivers/gpio/gpio-xilinx.c
+++ b/drivers/gpio/gpio-xilinx.c
@@ -94,9 +94,9 @@ static void xgpio_set(struct gpio_chip *gc, unsigned int gpio, int val)

 	/* Write to GPIO signal and set its direction to output */
 	if (val)
-		chip->gpio_state |= 1 << gpio;
+		chip->gpio_state |= BIT(gpio);
 	else
-		chip->gpio_state &= ~(1 << gpio);
+		chip->gpio_state &= ~BIT(gpio);

 	xgpio_writereg(regs + chip->offset + XGPIO_DATA_OFFSET,
 							 chip->gpio_state);
@@ -124,7 +124,7 @@ static int xgpio_dir_in(struct gpio_chip *gc, unsigned int gpio)
 	spin_lock_irqsave(&chip->gpio_lock, flags);

 	/* Set the GPIO bit in shadow register and set direction as input */
-	chip->gpio_dir |= (1 << gpio);
+	chip->gpio_dir |= BIT(gpio);
 	xgpio_writereg(regs + chip->offset + XGPIO_TRI_OFFSET, chip->gpio_dir);

 	spin_unlock_irqrestore(&chip->gpio_lock, flags);
@@ -154,14 +154,14 @@ static int xgpio_dir_out(struct gpio_chip *gc, unsigned int gpio, int val)

 	/* Write state of GPIO signal */
 	if (val)
-		chip->gpio_state |= 1 << gpio;
+		chip->gpio_state |= BIT(gpio);
 	else
-		chip->gpio_state &= ~(1 << gpio);
+		chip->gpio_state &= ~BIT(gpio);
 	xgpio_writereg(regs + chip->offset + XGPIO_DATA_OFFSET,
 		       chip->gpio_state);

 	/* Clear the GPIO bit in shadow register and set direction as output */
-	chip->gpio_dir &= (~(1 << gpio));
+	chip->gpio_dir &= ~BIT(gpio);
 	xgpio_writereg(regs + chip->offset + XGPIO_TRI_OFFSET, chip->gpio_dir);

 	spin_unlock_irqrestore(&chip->gpio_lock, flags);
--
1.8.2.3


--=_mimegpg-monstr-desktop-25596-1370262719-0001
Content-Type: application/pgp-signature
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEABECAAYFAlGsjL8ACgkQykllyylKDCHQxwCfblmdVwkwknGF7A4+HTvyTVbk
SWMAoIv+P1XmMYI7v55w/wTJctZ8kB+d
=MtVA
-----END PGP SIGNATURE-----

--=_mimegpg-monstr-desktop-25596-1370262719-0001--
