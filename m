Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752828AbaHMMCL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Aug 2014 08:02:11 -0400
Received: from mail-wi0-f176.google.com ([209.85.212.176]:51404 "EHLO
	mail-wi0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751382AbaHMMCJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Aug 2014 08:02:09 -0400
From: Michal Simek <michal.simek@xilinx.com>
To: linux-kernel@vger.kernel.org, monstr@monstr.eu
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Arnd Bergmann <arnd@arndb.de>, Jingoo Han <jg1.han@samsung.com>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        linux-arm-kernel@lists.infradead.org
Subject: [PATCH] char: xilinx_hwicap: Remove .owner field for driver
Date: Wed, 13 Aug 2014 14:02:05 +0200
Message-Id: <b2fb97b7fe72ba11ce1bef74ad2038d4e932b5a9.1407931319.git.michal.simek@xilinx.com>
X-Mailer: git-send-email 1.8.2.3
Content-Type: multipart/signed;
    boundary="=_mimegpg-monstr-desktop-21524-1407931326-0001";
    micalg=pgp-sha1; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a MIME GnuPG-signed message.  If you see this text, it means that
your E-mail or Usenet software does not support MIME signed messages.
The Internet standard for MIME PGP messages, RFC 2015, was published in 1996.
To open this message correctly you will need to install E-mail or Usenet
software that supports modern Internet standards.

--=_mimegpg-monstr-desktop-21524-1407931326-0001

There is no need to init .owner field.

Based on the patch from Peter Griffin <peter.griffin@linaro.org>
"mmc: remove .owner field for drivers using module_platform_driver"

This patch removes the superflous .owner field for drivers which
use the module_platform_driver API, as this is overriden in
platform_driver_register anyway."

Signed-off-by: Michal Simek <michal.simek@xilinx.com>
---

 drivers/char/xilinx_hwicap/xilinx_hwicap.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/char/xilinx_hwicap/xilinx_hwicap.c b/drivers/char/xilinx_hwicap/xilinx_hwicap.c
index 9b1a5ac4881d..c07dfe5c4da3 100644
--- a/drivers/char/xilinx_hwicap/xilinx_hwicap.c
+++ b/drivers/char/xilinx_hwicap/xilinx_hwicap.c
@@ -843,7 +843,6 @@ static struct platform_driver hwicap_platform_driver = {
 	.probe = hwicap_drv_probe,
 	.remove = hwicap_drv_remove,
 	.driver = {
-		.owner = THIS_MODULE,
 		.name = DRIVER_NAME,
 		.of_match_table = hwicap_of_match,
 	},
--
1.8.2.3


--=_mimegpg-monstr-desktop-21524-1407931326-0001
Content-Type: application/pgp-signature
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEABECAAYFAlPrU74ACgkQykllyylKDCHTngCdGTqK7xVZokD2ObQnQtY9tKYn
ZXYAnAq656fIzWNkILuFzHS3ss/6SEa8
=6OgM
-----END PGP SIGNATURE-----

--=_mimegpg-monstr-desktop-21524-1407931326-0001--
