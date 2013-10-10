Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754484Ab3JJKjr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Oct 2013 06:39:47 -0400
Received: from mail-ea0-f169.google.com ([209.85.215.169]:53068 "EHLO
	mail-ea0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752641Ab3JJKjo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Oct 2013 06:39:44 -0400
From: Michal Simek <michal.simek@xilinx.com>
To: linux-kernel@vger.kernel.org, monstr@monstr.eu, wsa@the-dreams.de
Cc: Kedareswara rao Appana <appana.durga.rao@xilinx.com>,
        Jean Delvare <khali@linux-fr.org>, Peter Korsgaard <jacmet@sunsite.dk>,
        Kedareswara rao Appana <appanad@xilinx.com>, linux-i2c@vger.kernel.org
Subject: [PATCH v3 1/3] i2c: xilinx: Fix i2c checkpatch warnings
Date: Thu, 10 Oct 2013 12:39:36 +0200
Message-Id: <f3fd6f38d2553e59b077edff1969f4d07f8aa811.1381401561.git.michal.simek@xilinx.com>
X-Mailer: git-send-email 1.8.2.3
Content-Type: multipart/signed;
    boundary="=_mimegpg-monstr-desktop-11210-1381401578-0001";
    micalg=pgp-sha1; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a MIME GnuPG-signed message.  If you see this text, it means that
your E-mail or Usenet software does not support MIME signed messages.
The Internet standard for MIME PGP messages, RFC 2015, was published in 1996.
To open this message correctly you will need to install E-mail or Usenet
software that supports modern Internet standards.

--=_mimegpg-monstr-desktop-11210-1381401578-0001

From: Kedareswara rao Appana <appana.durga.rao@xilinx.com>

Code changes to fix checkpatch warnings listed below.
- WARNING: please, no space before tabs
- WARNING: quoted string split across lines

Signed-off-by: Kedareswara rao Appana <appanad@xilinx.com>
Signed-off-by: Michal Simek <michal.simek@xilinx.com>
---
Changes in v3: None
Changes in v2:
- It is checkpatch warnings not sparse
- Extend patch description with checkpatch warnings

Tested by:
./scripts/checkpatch.pl -f drivers/i2c/busses/i2c-xiic.c

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


--=_mimegpg-monstr-desktop-11210-1381401578-0001
Content-Type: application/pgp-signature
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEABECAAYFAlJWg+oACgkQykllyylKDCGU2ACeL+kHDBVXwY7jrY7XtCN9R++K
RgoAoJpkTotx4ixRZmXwr7OjAcQGE9Lc
=y+cm
-----END PGP SIGNATURE-----

--=_mimegpg-monstr-desktop-11210-1381401578-0001--
