Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754128Ab3JCJrf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Oct 2013 05:47:35 -0400
Received: from mail-ea0-f172.google.com ([209.85.215.172]:39152 "EHLO
	mail-ea0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753855Ab3JCJrJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Oct 2013 05:47:09 -0400
From: Michal Simek <michal.simek@xilinx.com>
To: linux-kernel@vger.kernel.org, monstr@monstr.eu
Cc: Russell King <linux@arm.linux.org.uk>,
        Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        Tomi Valkeinen <tomi.valkeinen@ti.com>, linux-fbdev@vger.kernel.org
Subject: [PATCH 9/9] video: amba-clcd: Remove unnecessary amba_set_drvdata()
Date: Thu,  3 Oct 2013 11:46:31 +0200
Message-Id: <2f12a1d7caba382efe8d361b373da60c08e70622.1380793579.git.michal.simek@xilinx.com>
X-Mailer: git-send-email 1.8.2.3
In-Reply-To: <27e289763bbcb7d10f84081543cfc3a4dc770398.1380793579.git.michal.simek@xilinx.com>
References: <27e289763bbcb7d10f84081543cfc3a4dc770398.1380793579.git.michal.simek@xilinx.com>
In-Reply-To: <27e289763bbcb7d10f84081543cfc3a4dc770398.1380793579.git.michal.simek@xilinx.com>
References: <27e289763bbcb7d10f84081543cfc3a4dc770398.1380793579.git.michal.simek@xilinx.com>
Content-Type: multipart/signed;
    boundary="=_mimegpg-monstr-desktop-4165-1380793626-0001";
    micalg=pgp-sha1; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a MIME GnuPG-signed message.  If you see this text, it means that
your E-mail or Usenet software does not support MIME signed messages.
The Internet standard for MIME PGP messages, RFC 2015, was published in 1996.
To open this message correctly you will need to install E-mail or Usenet
software that supports modern Internet standards.

--=_mimegpg-monstr-desktop-4165-1380793626-0001

Driver core clears the driver data to NULL after device_release
or on probe failure, so just remove it from here.

Driver core change:
"device-core: Ensure drvdata = NULL when no driver is bound"
(sha1: 0998d0631001288a5974afc0b2a5f568bcdecb4d)

Signed-off-by: Michal Simek <michal.simek@xilinx.com>
---
 drivers/video/amba-clcd.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/video/amba-clcd.c b/drivers/video/amba-clcd.c
index 0a2cce7..0bab6ab 100644
--- a/drivers/video/amba-clcd.c
+++ b/drivers/video/amba-clcd.c
@@ -594,8 +594,6 @@ static int clcdfb_remove(struct amba_device *dev)
 {
 	struct clcd_fb *fb = amba_get_drvdata(dev);

-	amba_set_drvdata(dev, NULL);
-
 	clcdfb_disable(fb);
 	unregister_framebuffer(&fb->fb);
 	if (fb->fb.cmap.len)
--
1.8.2.3


--=_mimegpg-monstr-desktop-4165-1380793626-0001
Content-Type: application/pgp-signature
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEABECAAYFAlJNPRoACgkQykllyylKDCHcwwCdHLkeyMWDxFyiuUFRn6V6Njg+
Im4AnRxhoiYE30MftYnQafGuXa4PQ332
=XSu4
-----END PGP SIGNATURE-----

--=_mimegpg-monstr-desktop-4165-1380793626-0001--
