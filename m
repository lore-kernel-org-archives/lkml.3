Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755464Ab3I3OPb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Sep 2013 10:15:31 -0400
Received: from mail-ee0-f50.google.com ([74.125.83.50]:65316 "EHLO
	mail-ee0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754557Ab3I3OP2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Sep 2013 10:15:28 -0400
From: Michal Simek <michal.simek@xilinx.com>
To: linux-kernel@vger.kernel.org, monstr@monstr.eu, wsa@the-dreams.de
Cc: Kedareswara rao Appana <appana.durga.rao@xilinx.com>,
        Kedareswara rao Appana <appanad@xilinx.com>,
        Jean Delvare <khali@linux-fr.org>, Peter Korsgaard <jacmet@sunsite.dk>,
        linux-i2c@vger.kernel.org
Subject: [PATCH v2 2/3] i2c: xilinx: Set tx direction in write operation
Date: Mon, 30 Sep 2013 16:15:14 +0200
Message-Id: <57a4f5352ce6f03bde7aafe8b880f91b52994379.1380550490.git.michal.simek@xilinx.com>
X-Mailer: git-send-email 1.8.2.3
In-Reply-To: <f3fd6f38d2553e59b077edff1969f4d07f8aa811.1380550490.git.michal.simek@xilinx.com>
References: <f3fd6f38d2553e59b077edff1969f4d07f8aa811.1380550490.git.michal.simek@xilinx.com>
In-Reply-To: <f3fd6f38d2553e59b077edff1969f4d07f8aa811.1380550490.git.michal.simek@xilinx.com>
References: <f3fd6f38d2553e59b077edff1969f4d07f8aa811.1380550490.git.michal.simek@xilinx.com>
Content-Type: multipart/signed;
    boundary="=_mimegpg-monstr-desktop-15296-1380550525-0001";
    micalg=pgp-sha1; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a MIME GnuPG-signed message.  If you see this text, it means that
your E-mail or Usenet software does not support MIME signed messages.
The Internet standard for MIME PGP messages, RFC 2015, was published in 1996.
To open this message correctly you will need to install E-mail or Usenet
software that supports modern Internet standards.

--=_mimegpg-monstr-desktop-15296-1380550525-0001

From: Kedareswara rao Appana <appana.durga.rao@xilinx.com>

The patch fixes the problem with i2c eeprom memories
where controller is not properly setup to transmit mode.

This problem is fixed in write operation, after filling
address byte to tx fifo, set the direction of transfer
to tx using control register.

Signed-off-by: Kedareswara rao Appana <appanad@xilinx.com>
Signed-off-by: Michal Simek <michal.simek@xilinx.com>
---
Changes in v2:
- Extend patch description as Wolfram asked for.

 drivers/i2c/busses/i2c-xiic.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/i2c/busses/i2c-xiic.c b/drivers/i2c/busses/i2c-xiic.c
index 5eb0a8b..44e6ae7 100644
--- a/drivers/i2c/busses/i2c-xiic.c
+++ b/drivers/i2c/busses/i2c-xiic.c
@@ -536,6 +536,7 @@ static void xiic_start_recv(struct xiic_i2c *i2c)
 static void xiic_start_send(struct xiic_i2c *i2c)
 {
 	struct i2c_msg *msg = i2c->tx_msg;
+	u32 cr;

 	xiic_irq_clr(i2c, XIIC_INTR_TX_ERROR_MASK);

@@ -556,6 +557,10 @@ static void xiic_start_send(struct xiic_i2c *i2c)
 		xiic_setreg16(i2c, XIIC_DTR_REG_OFFSET, data);
 	}

+	cr = xiic_getreg32(i2c, XIIC_CR_REG_OFFSET);
+	cr |= XIIC_CR_DIR_IS_TX_MASK;
+	xiic_setreg32(i2c, XIIC_CR_REG_OFFSET, cr);
+
 	xiic_fill_tx_fifo(i2c);

 	/* Clear any pending Tx empty, Tx Error and then enable them. */
--
1.8.2.3


--=_mimegpg-monstr-desktop-15296-1380550525-0001
Content-Type: application/pgp-signature
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEABECAAYFAlJJh30ACgkQykllyylKDCHKKQCeOLeJ+FHVL0AE25SEtM9VSx2E
JAMAn3X48FylPGeTJToRwveVq6+xtsM/
=BPSB
-----END PGP SIGNATURE-----

--=_mimegpg-monstr-desktop-15296-1380550525-0001--
