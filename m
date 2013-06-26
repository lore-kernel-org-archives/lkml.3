Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752047Ab3FZJwW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Jun 2013 05:52:22 -0400
Received: from mail-ea0-f175.google.com ([209.85.215.175]:48974 "EHLO
	mail-ea0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751377Ab3FZJwU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Jun 2013 05:52:20 -0400
From: Michal Simek <michal.simek@xilinx.com>
To: linux-kernel@vger.kernel.org
Cc: Michal Simek <monstr@monstr.eu>, Michal Simek <michal.simek@xilinx.com>,
        Pavel Machek <pavel@ucw.cz>, "Hans J. Koch" <hjk@hansjkoch.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Grant Likely <grant.likely@linaro.org>,
        Rob Herring <rob.herring@calxeda.com>,
        devicetree-discuss@lists.ozlabs.org
Subject: [PATCH v3 1/2] uio: Use of_match_ptr() macro in uio_pdrv_genirq.c
Date: Wed, 26 Jun 2013 11:52:11 +0200
Message-Id: <03c8973cc1e9efcd203e4d95d2dd9469afbcb39b.1372240320.git.michal.simek@xilinx.com>
X-Mailer: git-send-email 1.8.2.3
Content-Type: multipart/signed;
    boundary="=_mimegpg-monstr-desktop-21913-1372240333-0001";
    micalg=pgp-sha1; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a MIME GnuPG-signed message.  If you see this text, it means that
your E-mail or Usenet software does not support MIME signed messages.
The Internet standard for MIME PGP messages, RFC 2015, was published in 1996.
To open this message correctly you will need to install E-mail or Usenet
software that supports modern Internet standards.

--=_mimegpg-monstr-desktop-21913-1372240333-0001

This eliminates having an #ifdef returning NULL for the case
when OF is disabled.

Signed-off-by: Michal Simek <michal.simek@xilinx.com>

---
Changes in v3:
- Rebased on Pavel's UIO patch
  UIO: allow binding uio_pdrv_genirq.c to devices using command line option
  (sha1: 05c3e0bb5629b897b0459e4bfb1b93d729033b99)

Changes in v2:
- s/Use Use/Use/ from patch subject

 drivers/uio/uio_pdrv_genirq.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/drivers/uio/uio_pdrv_genirq.c b/drivers/uio/uio_pdrv_genirq.c
index bcd72f3..ad77450 100644
--- a/drivers/uio/uio_pdrv_genirq.c
+++ b/drivers/uio/uio_pdrv_genirq.c
@@ -274,8 +274,6 @@ MODULE_DEVICE_TABLE(of, uio_of_genirq_match);

 module_param_string(of_id, uio_of_genirq_match[0].compatible, 128, 0);
 MODULE_PARM_DESC(of_id, "Openfirmware id of the device to be handled by uio");
-#else
-# define uio_of_genirq_match NULL
 #endif

 static struct platform_driver uio_pdrv_genirq = {
@@ -285,7 +283,7 @@ static struct platform_driver uio_pdrv_genirq = {
 		.name = DRIVER_NAME,
 		.owner = THIS_MODULE,
 		.pm = &uio_pdrv_genirq_dev_pm_ops,
-		.of_match_table = uio_of_genirq_match,
+		.of_match_table = of_match_ptr(uio_of_genirq_match),
 	},
 };

--
1.8.2.3


--=_mimegpg-monstr-desktop-21913-1372240333-0001
Content-Type: application/pgp-signature
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEABECAAYFAlHKuc0ACgkQykllyylKDCE2LQCfedOrBbeWXuZ27YltKzhK7Rw8
2tUAnjPqvQcLVRLZOfA21S+6a+FoQdFN
=2Zg9
-----END PGP SIGNATURE-----

--=_mimegpg-monstr-desktop-21913-1372240333-0001--
