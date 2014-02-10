Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752539AbaBJKqL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Feb 2014 05:46:11 -0500
Received: from mail-ea0-f173.google.com ([209.85.215.173]:41476 "EHLO
	mail-ea0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752223AbaBJKqH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Feb 2014 05:46:07 -0500
From: Michal Simek <michal.simek@xilinx.com>
To: linux-kernel@vger.kernel.org, monstr@monstr.eu
Cc: Arnd Bergmann <arnd@arndb.de>, Mark Brown <broonie@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: [PATCH] regmap: Check readable regs in _regmap_read
Date: Mon, 10 Feb 2014 11:46:02 +0100
Message-Id: <73e82a7cf77a1a68c5303def3071418b7d0ea382.1392029156.git.michal.simek@xilinx.com>
X-Mailer: git-send-email 1.8.2.3
Content-Type: multipart/signed;
    boundary="=_mimegpg-monstr-desktop-23750-1392029162-0001";
    micalg=pgp-sha1; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a MIME GnuPG-signed message.  If you see this text, it means that
your E-mail or Usenet software does not support MIME signed messages.
The Internet standard for MIME PGP messages, RFC 2015, was published in 1996.
To open this message correctly you will need to install E-mail or Usenet
software that supports modern Internet standards.

--=_mimegpg-monstr-desktop-23750-1392029162-0001

Check if regs are readable.

Signed-off-by: Michal Simek <michal.simek@xilinx.com>
---

 drivers/base/regmap/regmap.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/base/regmap/regmap.c b/drivers/base/regmap/regmap.c
index 6a19515..7569dfc 100644
--- a/drivers/base/regmap/regmap.c
+++ b/drivers/base/regmap/regmap.c
@@ -1725,6 +1725,9 @@ static int _regmap_read(struct regmap *map, unsigned int reg,
 	int ret;
 	void *context = _regmap_map_get_context(map);

+	if (!regmap_readable(map, reg))
+		return -EIO;
+
 	WARN_ON(!map->reg_read);

 	if (!map->cache_bypass) {
--
1.8.2.3


--=_mimegpg-monstr-desktop-23750-1392029162-0001
Content-Type: application/pgp-signature
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEABECAAYFAlL4reoACgkQykllyylKDCGk3QCfcvwoLww8bIaMhEuF43hgUGvc
EN4Ani5PdgLByphonXTQ7N8rECXA4lBo
=9wF4
-----END PGP SIGNATURE-----

--=_mimegpg-monstr-desktop-23750-1392029162-0001--
