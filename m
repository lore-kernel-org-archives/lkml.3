Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755095Ab3I3JJJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Sep 2013 05:09:09 -0400
Received: from mail-ea0-f182.google.com ([209.85.215.182]:41079 "EHLO
	mail-ea0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753787Ab3I3JJG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Sep 2013 05:09:06 -0400
From: Michal Simek <michal.simek@xilinx.com>
To: linux-kernel@vger.kernel.org, monstr@monstr.eu
Cc: Kedareswara rao Appana <appana.durga.rao@xilinx.com>,
        Wolfram Sang <wsa@the-dreams.de>,
        Kedareswara rao Appana <appanad@xilinx.com>,
        Jean Delvare <khali@linux-fr.org>, Peter Korsgaard <jacmet@sunsite.dk>,
        linux-i2c@vger.kernel.org
Subject: [PATCH 1/3] i2c: xilinx: Fix i2c sparse warnings
Date: Mon, 30 Sep 2013 11:08:50 +0200
Message-Id: <c122ad49b27406ee495ef0d6cac191968d64f09f.1380532113.git.michal.simek@xilinx.com>
X-Mailer: git-send-email 1.8.2.3
Content-Type: multipart/signed;
    boundary="=_mimegpg-monstr-desktop-3882-1380532132-0001";
    micalg=pgp-sha1; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a MIME GnuPG-signed message.  If you see this text, it means that
your E-mail or Usenet software does not support MIME signed messages.
The Internet standard for MIME PGP messages, RFC 2015, was published in 1996.
To open this message correctly you will need to install E-mail or Usenet
software that supports modern Internet standards.

--=_mimegpg-monstr-desktop-3882-1380532132-0001

From: Kedareswara rao Appana <appana.durga.rao@xilinx.com>

code changes to fix sparse warnings

Signed-off-by: Kedareswara rao Appana <appanad@xilinx.com>
Signed-off-by: Michal Simek <michal.simek@xilinx.com>
---
 drivers/i2c/busses/i2c-xiic.c | 23 +++++++++++------------
 1 file changed, 11 insertions(+), 12 deletions(-)

diff --git a/drivers/i2c/busses/i2c-xiic.c b/drivers/i2c/busses/i2c-xiic.c
index 4c8b368..5eb0a8b 100644
--- a/drivers/i2c/busses/i2c-xiic.c
+++ b/drivers/i2c/busses/i2c-xiic.c
@@ -68,7 +68,7 @@ struct xiic_i2c {
 	struct i2c_adapter	adap;
 	struct i2c_msg		*tx_msg;
 	spinlock_t		lock;
-	unsigned int 		tx_pos;
+	unsigned int		tx_pos;
 	unsigned int		nmsgs;
 	enum xilinx_i2c_state	state;
 	struct i2c_msg		*rx_msg;
@@ -271,11 +271,8 @@ static void xiic_read_rx(struct xiic_i2c *i2c)

 	bytes_in_fifo = xiic_getreg8(i2c, XIIC_RFO_REG_OFFSET) + 1;

-	dev_dbg(i2c->adap.dev.parent, "%s entry, bytes in fifo: %d, msg: %d"
-		", SR: 0x%x, CR: 0x%x\n",
-		__func__, bytes_in_fifo, xiic_rx_space(i2c),
-		xiic_getreg8(i2c, XIIC_SR_REG_OFFSET),
-		xiic_getreg8(i2c, XIIC_CR_REG_OFFSET));
+	dev_dbg(i2c->adap.dev.parent, "%s entry, bytes in fifo: %d, msg: %d",
+		__func__, bytes_in_fifo, xiic_rx_space(i2c));

 	if (bytes_in_fifo > xiic_rx_space(i2c))
 		bytes_in_fifo = xiic_rx_space(i2c);
@@ -339,9 +336,10 @@ static void xiic_process(struct xiic_i2c *i2c)
 	ier = xiic_getreg32(i2c, XIIC_IIER_OFFSET);
 	pend = isr & ier;

-	dev_dbg(i2c->adap.dev.parent, "%s entry, IER: 0x%x, ISR: 0x%x, "
-		"pend: 0x%x, SR: 0x%x, msg: %p, nmsgs: %d\n",
-		__func__, ier, isr, pend, xiic_getreg8(i2c, XIIC_SR_REG_OFFSET),
+	dev_dbg(i2c->adap.dev.parent, "%s: IER: 0x%x, ISR: 0x%x, pend: 0x%x\n",
+		__func__, ier, isr, pend);
+	dev_dbg(i2c->adap.dev.parent, "%s: SR: 0x%x, msg: %p, nmsgs: %d\n",
+		__func__, xiic_getreg8(i2c, XIIC_SR_REG_OFFSET),
 		i2c->tx_msg, i2c->nmsgs);

 	/* Do not processes a devices interrupts if the device has no
@@ -541,9 +539,10 @@ static void xiic_start_send(struct xiic_i2c *i2c)

 	xiic_irq_clr(i2c, XIIC_INTR_TX_ERROR_MASK);

-	dev_dbg(i2c->adap.dev.parent, "%s entry, msg: %p, len: %d, "
-		"ISR: 0x%x, CR: 0x%x\n",
-		__func__, msg, msg->len, xiic_getreg32(i2c, XIIC_IISR_OFFSET),
+	dev_dbg(i2c->adap.dev.parent, "%s entry, msg: %p, len: %d",
+		__func__, msg, msg->len);
+	dev_dbg(i2c->adap.dev.parent, "%s entry, ISR: 0x%x, CR: 0x%x\n",
+		__func__, xiic_getreg32(i2c, XIIC_IISR_OFFSET),
 		xiic_getreg8(i2c, XIIC_CR_REG_OFFSET));

 	if (!(msg->flags & I2C_M_NOSTART)) {
--
1.8.2.3


--=_mimegpg-monstr-desktop-3882-1380532132-0001
Content-Type: application/pgp-signature
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEABECAAYFAlJJP6UACgkQykllyylKDCGZ+QCeP84sG4qVHRgThO6QXGUsgHdY
IZ4AoIComSltUmzfaWyt4E1QsTlBHxt2
=Pb49
-----END PGP SIGNATURE-----

--=_mimegpg-monstr-desktop-3882-1380532132-0001--
