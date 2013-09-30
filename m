Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753462Ab3I3H2m (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Sep 2013 03:28:42 -0400
Received: from mail-ea0-f171.google.com ([209.85.215.171]:34864 "EHLO
	mail-ea0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751372Ab3I3H2j (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Sep 2013 03:28:39 -0400
From: Michal Simek <michal.simek@xilinx.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Arnd Bergmann <arnd@arndb.de>, Michal Simek <monstr@monstr.eu>,
        Bill Pemberton <wfp5p@virginia.edu>, linux-kernel@vger.kernel.org
Subject: [PATCH] char: hwicap: Remove unnecessary dev_set_drvdata()
Date: Mon, 30 Sep 2013 09:28:36 +0200
Message-Id: <cc76bdcebecf567439c39f2bc907a79ba4768aa6.1380526104.git.michal.simek@xilinx.com>
X-Mailer: git-send-email 1.8.2.3
Content-Type: multipart/signed;
    boundary="=_mimegpg-monstr-desktop-19493-1380526116-0001";
    micalg=pgp-sha1; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a MIME GnuPG-signed message.  If you see this text, it means that
your E-mail or Usenet software does not support MIME signed messages.
The Internet standard for MIME PGP messages, RFC 2015, was published in 1996.
To open this message correctly you will need to install E-mail or Usenet
software that supports modern Internet standards.

--=_mimegpg-monstr-desktop-19493-1380526116-0001

Driver core clears the driver data to NULL after device_release
or on probe failure, so just remove it from here.

Signed-off-by: Michal Simek <michal.simek@xilinx.com>
---
 drivers/char/xilinx_hwicap/xilinx_hwicap.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/char/xilinx_hwicap/xilinx_hwicap.c b/drivers/char/xilinx_hwicap/xilinx_hwicap.c
index 5224da5..aaf3234 100644
--- a/drivers/char/xilinx_hwicap/xilinx_hwicap.c
+++ b/drivers/char/xilinx_hwicap/xilinx_hwicap.c
@@ -731,7 +731,6 @@ static int hwicap_remove(struct device *dev)
 	iounmap(drvdata->base_address);
 	release_mem_region(drvdata->mem_start, drvdata->mem_size);
 	kfree(drvdata);
-	dev_set_drvdata(dev, NULL);

 	mutex_lock(&icap_sem);
 	probed_devices[MINOR(dev->devt)-XHWICAP_MINOR] = 0;
--
1.8.2.3


--=_mimegpg-monstr-desktop-19493-1380526116-0001
Content-Type: application/pgp-signature
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEABECAAYFAlJJKCQACgkQykllyylKDCH6BACeMsJmKcuaq7/ze+jcf5qBRzS9
y/oAnidRq3Dc4zLpiskLKCjqxVffrz17
=wSIM
-----END PGP SIGNATURE-----

--=_mimegpg-monstr-desktop-19493-1380526116-0001--
