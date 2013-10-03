Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754063Ab3JCJrb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Oct 2013 05:47:31 -0400
Received: from mail-ea0-f176.google.com ([209.85.215.176]:59112 "EHLO
	mail-ea0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753742Ab3JCJrE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Oct 2013 05:47:04 -0400
From: Michal Simek <michal.simek@xilinx.com>
To: linux-kernel@vger.kernel.org, monstr@monstr.eu
Cc: Mark Brown <broonie@kernel.org>, linux-spi@vger.kernel.org
Subject: [PATCH 7/9] spi: pl022: Remove unnecessary amba_set_drvdata()
Date: Thu,  3 Oct 2013 11:46:29 +0200
Message-Id: <cd3d21358986b23653f1ca35d2761fef7f747dd8.1380793579.git.michal.simek@xilinx.com>
X-Mailer: git-send-email 1.8.2.3
In-Reply-To: <27e289763bbcb7d10f84081543cfc3a4dc770398.1380793579.git.michal.simek@xilinx.com>
References: <27e289763bbcb7d10f84081543cfc3a4dc770398.1380793579.git.michal.simek@xilinx.com>
In-Reply-To: <27e289763bbcb7d10f84081543cfc3a4dc770398.1380793579.git.michal.simek@xilinx.com>
References: <27e289763bbcb7d10f84081543cfc3a4dc770398.1380793579.git.michal.simek@xilinx.com>
Content-Type: multipart/signed;
    boundary="=_mimegpg-monstr-desktop-4139-1380793620-0001";
    micalg=pgp-sha1; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a MIME GnuPG-signed message.  If you see this text, it means that
your E-mail or Usenet software does not support MIME signed messages.
The Internet standard for MIME PGP messages, RFC 2015, was published in 1996.
To open this message correctly you will need to install E-mail or Usenet
software that supports modern Internet standards.

--=_mimegpg-monstr-desktop-4139-1380793620-0001

Driver core clears the driver data to NULL after device_release
or on probe failure, so just remove it from here.

Driver core change:
"device-core: Ensure drvdata = NULL when no driver is bound"
(sha1: 0998d0631001288a5974afc0b2a5f568bcdecb4d)

Signed-off-by: Michal Simek <michal.simek@xilinx.com>
---
 drivers/spi/spi-pl022.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/spi/spi-pl022.c b/drivers/spi/spi-pl022.c
index 9c511a9..f661a7e 100644
--- a/drivers/spi/spi-pl022.c
+++ b/drivers/spi/spi-pl022.c
@@ -2288,7 +2288,6 @@ pl022_remove(struct amba_device *adev)
 	amba_release_regions(adev);
 	tasklet_disable(&pl022->pump_transfers);
 	spi_unregister_master(pl022->master);
-	amba_set_drvdata(adev, NULL);
 	return 0;
 }

--
1.8.2.3


--=_mimegpg-monstr-desktop-4139-1380793620-0001
Content-Type: application/pgp-signature
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEABECAAYFAlJNPRQACgkQykllyylKDCFiTACffxyK3C0GN1DjvWlhAs077HVR
v/QAn0UdF7vcPWtV0dkHOlStObb3miEW
=0nyO
-----END PGP SIGNATURE-----

--=_mimegpg-monstr-desktop-4139-1380793620-0001--
