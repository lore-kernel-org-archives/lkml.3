Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752622AbaHMLxs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Aug 2014 07:53:48 -0400
Received: from mail-wi0-f172.google.com ([209.85.212.172]:42484 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751024AbaHMLxq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Aug 2014 07:53:46 -0400
From: Michal Simek <michal.simek@xilinx.com>
To: linux-kernel@vger.kernel.org, monstr@monstr.eu
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-serial@vger.kernel.org, Jiri Slaby <jslaby@suse.cz>,
        linux-arm-kernel@lists.infradead.org
Subject: [PATCH 1/2] tty: serial: xuartps: Remove .owner field for driver
Date: Wed, 13 Aug 2014 13:53:42 +0200
Message-Id: <54c1e2bd13d6a6e679e1481818d6e068d352ba18.1407930818.git.michal.simek@xilinx.com>
X-Mailer: git-send-email 1.8.2.3
Content-Type: multipart/signed;
    boundary="=_mimegpg-monstr-desktop-19147-1407930823-0001";
    micalg=pgp-sha1; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a MIME GnuPG-signed message.  If you see this text, it means that
your E-mail or Usenet software does not support MIME signed messages.
The Internet standard for MIME PGP messages, RFC 2015, was published in 1996.
To open this message correctly you will need to install E-mail or Usenet
software that supports modern Internet standards.

--=_mimegpg-monstr-desktop-19147-1407930823-0001

There is no need to init .owner field.

Based on the patch from Peter Griffin <peter.griffin@linaro.org>
"mmc: remove .owner field for drivers using module_platform_driver"

This patch removes the superflous .owner field for drivers which
use the module_platform_driver API, as this is overriden in
platform_driver_register anyway."

Signed-off-by: Michal Simek <michal.simek@xilinx.com>
---

 drivers/tty/serial/xilinx_uartps.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/tty/serial/xilinx_uartps.c b/drivers/tty/serial/xilinx_uartps.c
index 01951d27cc03..c3c252db8b61 100644
--- a/drivers/tty/serial/xilinx_uartps.c
+++ b/drivers/tty/serial/xilinx_uartps.c
@@ -1428,7 +1428,6 @@ static struct platform_driver cdns_uart_platform_driver = {
 	.probe   = cdns_uart_probe,
 	.remove  = cdns_uart_remove,
 	.driver  = {
-		.owner = THIS_MODULE,
 		.name = CDNS_UART_NAME,
 		.of_match_table = cdns_uart_of_match,
 		.pm = &cdns_uart_dev_pm_ops,
--
1.8.2.3


--=_mimegpg-monstr-desktop-19147-1407930823-0001
Content-Type: application/pgp-signature
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEUEABECAAYFAlPrUccACgkQykllyylKDCE5TwCXb9bf/tG8mXoU11sXjP1W1TQB
IACeL6szm/tELjrGkfi7bdguiPDv3QA=
=YjmF
-----END PGP SIGNATURE-----

--=_mimegpg-monstr-desktop-19147-1407930823-0001--
