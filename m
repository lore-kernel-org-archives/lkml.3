Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754524Ab3LSPFX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Dec 2013 10:05:23 -0500
Received: from mail-ee0-f43.google.com ([74.125.83.43]:60414 "EHLO
	mail-ee0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754482Ab3LSPFT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Dec 2013 10:05:19 -0500
From: Michal Simek <michal.simek@xilinx.com>
To: linux-kernel@vger.kernel.org, monstr@monstr.eu, wsa@the-dreams.de,
        joe@perches.com
Cc: Kedareswara rao Appana <appana.durga.rao@xilinx.com>,
        Jingoo Han <jg1.han@samsung.com>, Jean Delvare <khali@linux-fr.org>,
        Peter Korsgaard <jacmet@sunsite.dk>, linux-i2c@vger.kernel.org
Subject: [PATCH v5 1/3] i2c: xilinx: Fix i2c checkpatch warnings
Date: Thu, 19 Dec 2013 16:05:04 +0100
Message-Id: <c220f51fd2ee7a5d65afa805a62582bd23e4d599.1387465488.git.michal.simek@xilinx.com>
X-Mailer: git-send-email 1.8.2.3
Content-Type: multipart/signed;
    boundary="=_mimegpg-monstr-desktop-14292-1387465506-0001";
    micalg=pgp-sha1; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a MIME GnuPG-signed message.  If you see this text, it means that
your E-mail or Usenet software does not support MIME signed messages.
The Internet standard for MIME PGP messages, RFC 2015, was published in 1996.
To open this message correctly you will need to install E-mail or Usenet
software that supports modern Internet standards.

--=_mimegpg-monstr-desktop-14292-1387465506-0001

From: Kedareswara rao Appana <appana.durga.rao@xilinx.com>

Code changes to fix checkpatch warnings listed below.
- WARNING: please, no space before tabs
- WARNING: quoted string split across lines

Signed-off-by: Kedareswara rao Appana <appanad@xilinx.com>
Signed-off-by: Michal Simek <michal.simek@xilinx.com>
---

Changes in v5: None
Changes in v4:
- Get back full dev_dbg message

Changes in v3: None
Changes in v2:
- It is checkpatch warnings not sparse
- Extend patch description with checkpatch warnings

Tested by:
./scripts/checkpatch.pl -f drivers/i2c/busses/i2c-xiic.c

---
 drivers/i2c/busses/i2c-xiic.c | 20 +++++++++++---------
 1 file changed, 11 insertions(+), 9 deletions(-)

diff --git a/drivers/i2c/busses/i2c-xiic.c b/drivers/i2c/busses/i2c-xiic.c
index fc2716a..5e5fae7 100644
--- a/drivers/i2c/busses/i2c-xiic.c
+++ b/drivers/i2c/busses/i2c-xiic.c
@@ -69,7 +69,7 @@ struct xiic_i2c {
 	struct i2c_adapter	adap;
 	struct i2c_msg		*tx_msg;
 	spinlock_t		lock;
-	unsigned int 		tx_pos;
+	unsigned int		tx_pos;
 	unsigned int		nmsgs;
 	enum xilinx_i2c_state	state;
 	struct i2c_msg		*rx_msg;
@@ -272,8 +272,8 @@ static void xiic_read_rx(struct xiic_i2c *i2c)

 	bytes_in_fifo = xiic_getreg8(i2c, XIIC_RFO_REG_OFFSET) + 1;

-	dev_dbg(i2c->adap.dev.parent, "%s entry, bytes in fifo: %d, msg: %d"
-		", SR: 0x%x, CR: 0x%x\n",
+	dev_dbg(i2c->adap.dev.parent,
+		"%s entry, bytes in fifo: %d, msg: %d, SR: 0x%x, CR: 0x%x\n",
 		__func__, bytes_in_fifo, xiic_rx_space(i2c),
 		xiic_getreg8(i2c, XIIC_SR_REG_OFFSET),
 		xiic_getreg8(i2c, XIIC_CR_REG_OFFSET));
@@ -340,9 +340,10 @@ static void xiic_process(struct xiic_i2c *i2c)
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
@@ -542,9 +543,10 @@ static void xiic_start_send(struct xiic_i2c *i2c)

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


--=_mimegpg-monstr-desktop-14292-1387465506-0001
Content-Type: application/pgp-signature
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEABECAAYFAlKzCyIACgkQykllyylKDCE7XACffb1EJed/tm7wuN8gIKSJMMsW
h0QAoIYrsM1qdB+5mt/ICppY5iP8zg5T
=SmHk
-----END PGP SIGNATURE-----

--=_mimegpg-monstr-desktop-14292-1387465506-0001--
