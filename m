Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751710Ab3KRMNz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Nov 2013 07:13:55 -0500
Received: from mail-ea0-f181.google.com ([209.85.215.181]:45277 "EHLO
	mail-ea0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751372Ab3KRMN2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Nov 2013 07:13:28 -0500
From: Michal Simek <michal.simek@xilinx.com>
To: linux-kernel@vger.kernel.org, monstr@monstr.eu, wsa@the-dreams.de,
        joe@perches.com
Cc: Jean Delvare <khali@linux-fr.org>, Peter Korsgaard <jacmet@sunsite.dk>,
        Kedareswara rao Appana <appanad@xilinx.com>, linux-i2c@vger.kernel.org
Subject: [PATCH v4 2/3] i2c: xilinx: Do not enable irq before irq handler
Date: Mon, 18 Nov 2013 13:13:08 +0100
Message-Id: <bd1e63067664dc83400fa9749da21a2bbd09639c.1384776761.git.michal.simek@xilinx.com>
X-Mailer: git-send-email 1.8.2.3
In-Reply-To: <04a1a7e01e2f3ff132658b7246ef32e74c73aa29.1384776761.git.michal.simek@xilinx.com>
References: <04a1a7e01e2f3ff132658b7246ef32e74c73aa29.1384776761.git.michal.simek@xilinx.com>
In-Reply-To: <04a1a7e01e2f3ff132658b7246ef32e74c73aa29.1384776761.git.michal.simek@xilinx.com>
References: <04a1a7e01e2f3ff132658b7246ef32e74c73aa29.1384776761.git.michal.simek@xilinx.com>
Content-Type: multipart/signed;
    boundary="=_mimegpg-monstr-desktop-25641-1384776801-0001";
    micalg=pgp-sha1; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a MIME GnuPG-signed message.  If you see this text, it means that
your E-mail or Usenet software does not support MIME signed messages.
The Internet standard for MIME PGP messages, RFC 2015, was published in 1996.
To open this message correctly you will need to install E-mail or Usenet
software that supports modern Internet standards.

--=_mimegpg-monstr-desktop-25641-1384776801-0001

IRQ handler has to be register first before IRQ
is enabled in xiic_reinit().

Signed-off-by: Michal Simek <michal.simek@xilinx.com>

---
Changes in v4: None
Changes in v3:
- New patch in this patchset based on my discussion with Wolfram
  https://lkml.org/lkml/2013/10/4/148

Changes in v2: None

 drivers/i2c/busses/i2c-xiic.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/i2c/busses/i2c-xiic.c b/drivers/i2c/busses/i2c-xiic.c
index 4d5c79e..1ded456b 100644
--- a/drivers/i2c/busses/i2c-xiic.c
+++ b/drivers/i2c/busses/i2c-xiic.c
@@ -730,8 +730,6 @@ static int xiic_i2c_probe(struct platform_device *pdev)
 	i2c->adap.dev.parent = &pdev->dev;
 	i2c->adap.dev.of_node = pdev->dev.of_node;

-	xiic_reinit(i2c);
-
 	spin_lock_init(&i2c->lock);
 	init_waitqueue_head(&i2c->wait);
 	ret = request_irq(irq, xiic_isr, 0, pdev->name, i2c);
@@ -740,6 +738,8 @@ static int xiic_i2c_probe(struct platform_device *pdev)
 		goto request_irq_failed;
 	}

+	xiic_reinit(i2c);
+
 	/* add i2c adapter to i2c tree */
 	ret = i2c_add_adapter(&i2c->adap);
 	if (ret) {
--
1.8.2.3


--=_mimegpg-monstr-desktop-25641-1384776801-0001
Content-Type: application/pgp-signature
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEABECAAYFAlKKBGEACgkQykllyylKDCG7mACfXy+h8z1oa2+L8E2qRpCW7Xmd
O44AoJLRiQ2J8ke1wapIM0yOmEh+KErE
=gyW0
-----END PGP SIGNATURE-----

--=_mimegpg-monstr-desktop-25641-1384776801-0001--
