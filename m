Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755199Ab3I3JJk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Sep 2013 05:09:40 -0400
Received: from mail-ea0-f182.google.com ([209.85.215.182]:40586 "EHLO
	mail-ea0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754196Ab3I3JJI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Sep 2013 05:09:08 -0400
From: Michal Simek <michal.simek@xilinx.com>
To: linux-kernel@vger.kernel.org, monstr@monstr.eu
Cc: Kedareswara rao Appana <appana.durga.rao@xilinx.com>,
        Wolfram Sang <wsa@the-dreams.de>,
        Kedareswara rao Appana <appanad@xilinx.com>,
        Jean Delvare <khali@linux-fr.org>, Peter Korsgaard <jacmet@sunsite.dk>,
        linux-i2c@vger.kernel.org
Subject: [PATCH 2/3] i2c: xilinx: Set tx direction in write operation
Date: Mon, 30 Sep 2013 11:08:51 +0200
Message-Id: <5d234cfc8d23cfc7e8d750f103344cf4e8e398d4.1380532113.git.michal.simek@xilinx.com>
X-Mailer: git-send-email 1.8.2.3
In-Reply-To: <c122ad49b27406ee495ef0d6cac191968d64f09f.1380532113.git.michal.simek@xilinx.com>
References: <c122ad49b27406ee495ef0d6cac191968d64f09f.1380532113.git.michal.simek@xilinx.com>
In-Reply-To: <c122ad49b27406ee495ef0d6cac191968d64f09f.1380532113.git.michal.simek@xilinx.com>
References: <c122ad49b27406ee495ef0d6cac191968d64f09f.1380532113.git.michal.simek@xilinx.com>
Content-Type: multipart/signed;
    boundary="=_mimegpg-monstr-desktop-3913-1380532145-0001";
    micalg=pgp-sha1; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a MIME GnuPG-signed message.  If you see this text, it means that
your E-mail or Usenet software does not support MIME signed messages.
The Internet standard for MIME PGP messages, RFC 2015, was published in 1996.
To open this message correctly you will need to install E-mail or Usenet
software that supports modern Internet standards.

--=_mimegpg-monstr-desktop-3913-1380532145-0001

From: Kedareswara rao Appana <appana.durga.rao@xilinx.com>

In write operation, after filling address byte to tx fifo,
set the direction of transfer to tx using control register.

Signed-off-by: Kedareswara rao Appana <appanad@xilinx.com>
Signed-off-by: Michal Simek <michal.simek@xilinx.com>
---
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


--=_mimegpg-monstr-desktop-3913-1380532145-0001
Content-Type: application/pgp-signature
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEABECAAYFAlJJP7EACgkQykllyylKDCEoKwCfcjw9Jl03yRApgAfZlmsPShI6
qMMAnR0xGKhgpuJq8IkUXeRujgstbuIv
=cklk
-----END PGP SIGNATURE-----

--=_mimegpg-monstr-desktop-3913-1380532145-0001--
