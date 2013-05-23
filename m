Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759290Ab3EWOCS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 May 2013 10:02:18 -0400
Received: from mail-wi0-f173.google.com ([209.85.212.173]:53440 "EHLO
	mail-wi0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758158Ab3EWOCP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 May 2013 10:02:15 -0400
From: Michal Simek <michal.simek@xilinx.com>
To: linux-kernel@vger.kernel.org
Cc: Michal Simek <monstr@monstr.eu>, Michal Simek <michal.simek@xilinx.com>,
        "Hans J. Koch" <hjk@hansjkoch.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Grant Likely <grant.likely@linaro.org>,
        Rob Herring <rob.herring@calxeda.com>,
        devicetree-discuss@lists.ozlabs.org
Subject: [RFC PATCH 1/2] uio: Use Use of_match_ptr() macro in uio_pdrv_genirq.c
Date: Thu, 23 May 2013 16:01:58 +0200
Message-Id: <086bdaf83fe546bd3c7fe163e565a0887770770f.1369317710.git.michal.simek@xilinx.com>
X-Mailer: git-send-email 1.8.2.3
Content-Type: multipart/signed;
    boundary="=_mimegpg-monstr-desktop-8037-1369317719-0001";
    micalg=pgp-sha1; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a MIME GnuPG-signed message.  If you see this text, it means that
your E-mail or Usenet software does not support MIME signed messages.
The Internet standard for MIME PGP messages, RFC 2015, was published in 1996.
To open this message correctly you will need to install E-mail or Usenet
software that supports modern Internet standards.

--=_mimegpg-monstr-desktop-8037-1369317719-0001

This eliminates having an #ifdef returning NULL for the case
when OF is disabled.

Signed-off-by: Michal Simek <michal.simek@xilinx.com>
---
 drivers/uio/uio_pdrv_genirq.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/drivers/uio/uio_pdrv_genirq.c b/drivers/uio/uio_pdrv_genirq.c
index c122bca..d7ba355 100644
--- a/drivers/uio/uio_pdrv_genirq.c
+++ b/drivers/uio/uio_pdrv_genirq.c
@@ -267,8 +267,6 @@ static const struct of_device_id uio_of_genirq_match[] = {
 	{ /* empty for now */ },
 };
 MODULE_DEVICE_TABLE(of, uio_of_genirq_match);
-#else
-# define uio_of_genirq_match NULL
 #endif

 static struct platform_driver uio_pdrv_genirq = {
@@ -278,7 +276,7 @@ static struct platform_driver uio_pdrv_genirq = {
 		.name = DRIVER_NAME,
 		.owner = THIS_MODULE,
 		.pm = &uio_pdrv_genirq_dev_pm_ops,
-		.of_match_table = uio_of_genirq_match,
+		.of_match_table = of_match_ptr(uio_of_genirq_match),
 	},
 };

--
1.8.2.3


--=_mimegpg-monstr-desktop-8037-1369317719-0001
Content-Type: application/pgp-signature
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEABECAAYFAlGeIVcACgkQykllyylKDCENXQCdFpB65jqAu+9bvU7H+7iqcTfM
XPwAni+CY+jM/eTf+OL2DsMym2w7FThD
=GBCS
-----END PGP SIGNATURE-----

--=_mimegpg-monstr-desktop-8037-1369317719-0001--
