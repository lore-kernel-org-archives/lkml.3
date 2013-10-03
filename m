Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754091Ab3JCJrd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Oct 2013 05:47:33 -0400
Received: from mail-ea0-f181.google.com ([209.85.215.181]:35290 "EHLO
	mail-ea0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753810Ab3JCJrH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Oct 2013 05:47:07 -0400
From: Michal Simek <michal.simek@xilinx.com>
To: linux-kernel@vger.kernel.org, monstr@monstr.eu
Cc: Wim Van Sebroeck <wim@iguana.be>, linux-watchdog@vger.kernel.org
Subject: [PATCH 8/9] watchdog: sp805_wdt: Remove unnecessary amba_set_drvdata()
Date: Thu,  3 Oct 2013 11:46:30 +0200
Message-Id: <7a51da3b47e0dd14d9ad13853f649463dba9350f.1380793579.git.michal.simek@xilinx.com>
X-Mailer: git-send-email 1.8.2.3
In-Reply-To: <27e289763bbcb7d10f84081543cfc3a4dc770398.1380793579.git.michal.simek@xilinx.com>
References: <27e289763bbcb7d10f84081543cfc3a4dc770398.1380793579.git.michal.simek@xilinx.com>
In-Reply-To: <27e289763bbcb7d10f84081543cfc3a4dc770398.1380793579.git.michal.simek@xilinx.com>
References: <27e289763bbcb7d10f84081543cfc3a4dc770398.1380793579.git.michal.simek@xilinx.com>
Content-Type: multipart/signed;
    boundary="=_mimegpg-monstr-desktop-4152-1380793623-0001";
    micalg=pgp-sha1; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a MIME GnuPG-signed message.  If you see this text, it means that
your E-mail or Usenet software does not support MIME signed messages.
The Internet standard for MIME PGP messages, RFC 2015, was published in 1996.
To open this message correctly you will need to install E-mail or Usenet
software that supports modern Internet standards.

--=_mimegpg-monstr-desktop-4152-1380793623-0001

Driver core clears the driver data to NULL after device_release
or on probe failure, so just remove it from here.

Driver core change:
"device-core: Ensure drvdata = NULL when no driver is bound"
(sha1: 0998d0631001288a5974afc0b2a5f568bcdecb4d)

Signed-off-by: Michal Simek <michal.simek@xilinx.com>
---
 drivers/watchdog/sp805_wdt.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/watchdog/sp805_wdt.c b/drivers/watchdog/sp805_wdt.c
index 58df98a..3f786ce 100644
--- a/drivers/watchdog/sp805_wdt.c
+++ b/drivers/watchdog/sp805_wdt.c
@@ -268,7 +268,6 @@ static int sp805_wdt_remove(struct amba_device *adev)
 	struct sp805_wdt *wdt = amba_get_drvdata(adev);

 	watchdog_unregister_device(&wdt->wdd);
-	amba_set_drvdata(adev, NULL);
 	watchdog_set_drvdata(&wdt->wdd, NULL);

 	return 0;
--
1.8.2.3


--=_mimegpg-monstr-desktop-4152-1380793623-0001
Content-Type: application/pgp-signature
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEABECAAYFAlJNPRcACgkQykllyylKDCEKEQCfRDy7lFYAZSnLe6iStdsA0KiH
CWsAn3yRQ3KgJuflwgPMBsxIma3ky5IE
=geup
-----END PGP SIGNATURE-----

--=_mimegpg-monstr-desktop-4152-1380793623-0001--
