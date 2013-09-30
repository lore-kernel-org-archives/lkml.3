Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755282Ab3I3Lu6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Sep 2013 07:50:58 -0400
Received: from mail-ea0-f182.google.com ([209.85.215.182]:59825 "EHLO
	mail-ea0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755197Ab3I3Luz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Sep 2013 07:50:55 -0400
From: Michal Simek <michal.simek@xilinx.com>
To: linux-kernel@vger.kernel.org
Cc: Michal Simek <monstr@monstr.eu>, Michal Simek <michal.simek@xilinx.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-serial@vger.kernel.org, arnd@arndb.de,
        Peter Korsgaard <jacmet@sunsite.dk>,
        Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <rob.herring@calxeda.com>, Jiri Slaby <jslaby@suse.cz>
Subject: [RFC PATCH] tty: serial: uartlite: Extend time for sending chars through mdm IP
Date: Mon, 30 Sep 2013 13:50:35 +0200
Message-Id: <fec1c418d7d8933a9729ea1926c76e404f8c3020.1380541829.git.michal.simek@xilinx.com>
X-Mailer: git-send-email 1.8.2.3
Content-Type: multipart/signed;
    boundary="=_mimegpg-monstr-desktop-26444-1380541835-0001";
    micalg=pgp-sha1; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a MIME GnuPG-signed message.  If you see this text, it means that
your E-mail or Usenet software does not support MIME signed messages.
The Internet standard for MIME PGP messages, RFC 2015, was published in 1996.
To open this message correctly you will need to install E-mail or Usenet
software that supports modern Internet standards.

--=_mimegpg-monstr-desktop-26444-1380541835-0001

From: Michal Simek <monstr@monstr.eu>

Serial over jtag via mdm is compatible with uartlite driver
just need to extend time for reading chars because connection
is slow.

Signed-off-by: Michal Simek <michal.simek@xilinx.com>
---
 drivers/tty/serial/uartlite.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/tty/serial/uartlite.c b/drivers/tty/serial/uartlite.c
index 5f90ef2..f55c342 100644
--- a/drivers/tty/serial/uartlite.c
+++ b/drivers/tty/serial/uartlite.c
@@ -422,7 +422,7 @@ static void ulite_console_wait_tx(struct uart_port *port)
 	u8 val;

 	/* Spin waiting for TX fifo to have space available */
-	for (i = 0; i < 100000; i++) {
+	for (i = 0; i < 10000000; i++) {
 		val = uart_in32(ULITE_STATUS, port);
 		if ((val & ULITE_STATUS_TXFULL) == 0)
 			break;
--
1.8.2.3


--=_mimegpg-monstr-desktop-26444-1380541835-0001
Content-Type: application/pgp-signature
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEABECAAYFAlJJZYwACgkQykllyylKDCFcEwCfYS7b9CoQT2W9Fa6X4UpMsXHV
z/IAniUmOPNjOYt3rv16bpQe3Tl5srvd
=j/qv
-----END PGP SIGNATURE-----

--=_mimegpg-monstr-desktop-26444-1380541835-0001--
