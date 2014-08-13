Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752762AbaHMMBs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Aug 2014 08:01:48 -0400
Received: from mail-wi0-f181.google.com ([209.85.212.181]:56162 "EHLO
	mail-wi0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751341AbaHMMBq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Aug 2014 08:01:46 -0400
From: Michal Simek <michal.simek@xilinx.com>
To: linux-kernel@vger.kernel.org, monstr@monstr.eu
Cc: linux-arm-kernel@lists.infradead.org,
        Josh Cartwright <josh.cartwright@ni.com>,
        Steffen Trumtrar <s.trumtrar@pengutronix.de>,
        Rob Herring <robherring2@gmail.com>,
        Peter Crosthwaite <peter.crosthwaite@xilinx.com>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Daniel Lezcano <daniel.lezcano@linaro.org>, linux-pm@vger.kernel.org
Subject: [PATCH] ARM: zynq: cpuidle: Remove .owner field for driver
Date: Wed, 13 Aug 2014 14:01:43 +0200
Message-Id: <01b4472cb5b1a5d03c98ec78cdd223970a52bd54.1407931299.git.michal.simek@xilinx.com>
X-Mailer: git-send-email 1.8.2.3
Content-Type: multipart/signed;
    boundary="=_mimegpg-monstr-desktop-21313-1407931303-0001";
    micalg=pgp-sha1; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a MIME GnuPG-signed message.  If you see this text, it means that
your E-mail or Usenet software does not support MIME signed messages.
The Internet standard for MIME PGP messages, RFC 2015, was published in 1996.
To open this message correctly you will need to install E-mail or Usenet
software that supports modern Internet standards.

--=_mimegpg-monstr-desktop-21313-1407931303-0001

There is no need to init .owner field.

Based on the patch from Peter Griffin <peter.griffin@linaro.org>
"mmc: remove .owner field for drivers using module_platform_driver"

This patch removes the superflous .owner field for drivers which
use the module_platform_driver API, as this is overriden in
platform_driver_register anyway."

Signed-off-by: Michal Simek <michal.simek@xilinx.com>
---

 drivers/cpuidle/cpuidle-zynq.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/cpuidle/cpuidle-zynq.c b/drivers/cpuidle/cpuidle-zynq.c
index aded75928028..6e03734e3508 100644
--- a/drivers/cpuidle/cpuidle-zynq.c
+++ b/drivers/cpuidle/cpuidle-zynq.c
@@ -80,7 +80,6 @@ static int zynq_cpuidle_probe(struct platform_device *pdev)
 static struct platform_driver zynq_cpuidle_driver = {
 	.driver = {
 		.name = "cpuidle-zynq",
-		.owner = THIS_MODULE,
 	},
 	.probe = zynq_cpuidle_probe,
 };
--
1.8.2.3


--=_mimegpg-monstr-desktop-21313-1407931303-0001
Content-Type: application/pgp-signature
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEABECAAYFAlPrU6cACgkQykllyylKDCG9QACcDsP/l7Pab9W2rN8NG6Kb5nVA
3DMAn3+OFJVRO2x49JITig178MevNUMw
=6Bq7
-----END PGP SIGNATURE-----

--=_mimegpg-monstr-desktop-21313-1407931303-0001--
