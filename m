Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754020Ab3JCJr3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Oct 2013 05:47:29 -0400
Received: from mail-ee0-f41.google.com ([74.125.83.41]:53849 "EHLO
	mail-ee0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753714Ab3JCJrB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Oct 2013 05:47:01 -0400
From: Michal Simek <michal.simek@xilinx.com>
To: linux-kernel@vger.kernel.org, monstr@monstr.eu
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-serial@vger.kernel.org, Russell King <linux@arm.linux.org.uk>,
        Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 6/9] serial: Remove unnecessary amba_set_drvdata()
Date: Thu,  3 Oct 2013 11:46:28 +0200
Message-Id: <5af83e9d6daf21f1caf26e49eaec3fcafd22a882.1380793579.git.michal.simek@xilinx.com>
X-Mailer: git-send-email 1.8.2.3
In-Reply-To: <27e289763bbcb7d10f84081543cfc3a4dc770398.1380793579.git.michal.simek@xilinx.com>
References: <27e289763bbcb7d10f84081543cfc3a4dc770398.1380793579.git.michal.simek@xilinx.com>
In-Reply-To: <27e289763bbcb7d10f84081543cfc3a4dc770398.1380793579.git.michal.simek@xilinx.com>
References: <27e289763bbcb7d10f84081543cfc3a4dc770398.1380793579.git.michal.simek@xilinx.com>
Content-Type: multipart/signed;
    boundary="=_mimegpg-monstr-desktop-4126-1380793617-0001";
    micalg=pgp-sha1; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a MIME GnuPG-signed message.  If you see this text, it means that
your E-mail or Usenet software does not support MIME signed messages.
The Internet standard for MIME PGP messages, RFC 2015, was published in 1996.
To open this message correctly you will need to install E-mail or Usenet
software that supports modern Internet standards.

--=_mimegpg-monstr-desktop-4126-1380793617-0001

Driver core clears the driver data to NULL after device_release
or on probe failure, so just remove it from here.

Driver core change:
"device-core: Ensure drvdata = NULL when no driver is bound"
(sha1: 0998d0631001288a5974afc0b2a5f568bcdecb4d)

Signed-off-by: Michal Simek <michal.simek@xilinx.com>
---
 drivers/tty/serial/amba-pl010.c | 3 ---
 drivers/tty/serial/amba-pl011.c | 3 ---
 2 files changed, 6 deletions(-)

diff --git a/drivers/tty/serial/amba-pl010.c b/drivers/tty/serial/amba-pl010.c
index 8b90f0b..33bd860 100644
--- a/drivers/tty/serial/amba-pl010.c
+++ b/drivers/tty/serial/amba-pl010.c
@@ -728,7 +728,6 @@ static int pl010_probe(struct amba_device *dev, const struct amba_id *id)
 	amba_set_drvdata(dev, uap);
 	ret = uart_add_one_port(&amba_reg, &uap->port);
 	if (ret) {
-		amba_set_drvdata(dev, NULL);
 		amba_ports[i] = NULL;
 		clk_put(uap->clk);
  unmap:
@@ -745,8 +744,6 @@ static int pl010_remove(struct amba_device *dev)
 	struct uart_amba_port *uap = amba_get_drvdata(dev);
 	int i;

-	amba_set_drvdata(dev, NULL);
-
 	uart_remove_one_port(&amba_reg, &uap->port);

 	for (i = 0; i < ARRAY_SIZE(amba_ports); i++)
diff --git a/drivers/tty/serial/amba-pl011.c b/drivers/tty/serial/amba-pl011.c
index aaa2286..7203864 100644
--- a/drivers/tty/serial/amba-pl011.c
+++ b/drivers/tty/serial/amba-pl011.c
@@ -2147,7 +2147,6 @@ static int pl011_probe(struct amba_device *dev, const struct amba_id *id)
 	amba_set_drvdata(dev, uap);
 	ret = uart_add_one_port(&amba_reg, &uap->port);
 	if (ret) {
-		amba_set_drvdata(dev, NULL);
 		amba_ports[i] = NULL;
 		pl011_dma_remove(uap);
 	}
@@ -2160,8 +2159,6 @@ static int pl011_remove(struct amba_device *dev)
 	struct uart_amba_port *uap = amba_get_drvdata(dev);
 	int i;

-	amba_set_drvdata(dev, NULL);
-
 	uart_remove_one_port(&amba_reg, &uap->port);

 	for (i = 0; i < ARRAY_SIZE(amba_ports); i++)
--
1.8.2.3


--=_mimegpg-monstr-desktop-4126-1380793617-0001
Content-Type: application/pgp-signature
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEABECAAYFAlJNPREACgkQykllyylKDCGrywCfVjn0d8ARGy58alxUDVWyHlNn
g48An1mcoZX+m/JVafQEInR/nAfoCF5Q
=C76P
-----END PGP SIGNATURE-----

--=_mimegpg-monstr-desktop-4126-1380793617-0001--
