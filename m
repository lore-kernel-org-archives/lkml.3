Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753050AbaBJMAA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Feb 2014 07:00:00 -0500
Received: from mail-ea0-f170.google.com ([209.85.215.170]:58775 "EHLO
	mail-ea0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753020AbaBJL74 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Feb 2014 06:59:56 -0500
From: Michal Simek <michal.simek@xilinx.com>
To: linux-kernel@vger.kernel.org, monstr@monstr.eu
Cc: Arnd Bergmann <arnd@arndb.de>, Lars-Peter Clausen <lars@metafoo.de>,
        Mark Brown <broonie@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: [PATCH v2] regmap: Check readable regs in _regmap_read
Date: Mon, 10 Feb 2014 12:59:46 +0100
Message-Id: <57a9999d46c2e0703c95ee68a88f3c539bd10f9f.1392033580.git.michal.simek@xilinx.com>
X-Mailer: git-send-email 1.8.2.3
Content-Type: multipart/signed;
    boundary="=_mimegpg-monstr-desktop-30018-1392033586-0001";
    micalg=pgp-sha1; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a MIME GnuPG-signed message.  If you see this text, it means that
your E-mail or Usenet software does not support MIME signed messages.
The Internet standard for MIME PGP messages, RFC 2015, was published in 1996.
To open this message correctly you will need to install E-mail or Usenet
software that supports modern Internet standards.

--=_mimegpg-monstr-desktop-30018-1392033586-0001

Check if regs are readable.

Signed-off-by: Michal Simek <michal.simek@xilinx.com>
---

Changes in v2:
- Move checking below cache read

 drivers/base/regmap/regmap.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/base/regmap/regmap.c b/drivers/base/regmap/regmap.c
index 6a19515..b897c1a 100644
--- a/drivers/base/regmap/regmap.c
+++ b/drivers/base/regmap/regmap.c
@@ -1736,6 +1736,9 @@ static int _regmap_read(struct regmap *map, unsigned int reg,
 	if (map->cache_only)
 		return -EBUSY;

+	if (!regmap_readable(map, reg))
+		return -EIO;
+
 	ret = map->reg_read(context, reg, val);
 	if (ret == 0) {
 #ifdef LOG_DEVICE
--
1.8.2.3


--=_mimegpg-monstr-desktop-30018-1392033586-0001
Content-Type: application/pgp-signature
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEABECAAYFAlL4vzIACgkQykllyylKDCGG1wCfWJIP7CCj2ALkb+955rC1gR0O
FKkAn2DZOtfKw8M2nIORZBKa5tQS5dgc
=3oco
-----END PGP SIGNATURE-----

--=_mimegpg-monstr-desktop-30018-1392033586-0001--
