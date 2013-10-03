Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753667Ab3JCJq6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Oct 2013 05:46:58 -0400
Received: from mail-ee0-f49.google.com ([74.125.83.49]:36240 "EHLO
	mail-ee0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752789Ab3JCJqt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Oct 2013 05:46:49 -0400
From: Michal Simek <michal.simek@xilinx.com>
To: linux-kernel@vger.kernel.org, monstr@monstr.eu
Cc: Russell King <linux@arm.linux.org.uk>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        linux-input@vger.kernel.org
Subject: [PATCH 2/9] input: ambakmi: Remove unnecessary amba_set_drvdata()
Date: Thu,  3 Oct 2013 11:46:24 +0200
Message-Id: <90c09ded0d4b6b9fbc0dbca7f57deb94384eaf8d.1380793579.git.michal.simek@xilinx.com>
X-Mailer: git-send-email 1.8.2.3
In-Reply-To: <27e289763bbcb7d10f84081543cfc3a4dc770398.1380793579.git.michal.simek@xilinx.com>
References: <27e289763bbcb7d10f84081543cfc3a4dc770398.1380793579.git.michal.simek@xilinx.com>
In-Reply-To: <27e289763bbcb7d10f84081543cfc3a4dc770398.1380793579.git.michal.simek@xilinx.com>
References: <27e289763bbcb7d10f84081543cfc3a4dc770398.1380793579.git.michal.simek@xilinx.com>
Content-Type: multipart/signed;
    boundary="=_mimegpg-monstr-desktop-4075-1380793604-0001";
    micalg=pgp-sha1; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a MIME GnuPG-signed message.  If you see this text, it means that
your E-mail or Usenet software does not support MIME signed messages.
The Internet standard for MIME PGP messages, RFC 2015, was published in 1996.
To open this message correctly you will need to install E-mail or Usenet
software that supports modern Internet standards.

--=_mimegpg-monstr-desktop-4075-1380793604-0001

Driver core clears the driver data to NULL after device_release
or on probe failure, so just remove it from here.

Driver core change:
"device-core: Ensure drvdata = NULL when no driver is bound"
(sha1: 0998d0631001288a5974afc0b2a5f568bcdecb4d)

Signed-off-by: Michal Simek <michal.simek@xilinx.com>
---
 drivers/input/serio/ambakmi.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/input/serio/ambakmi.c b/drivers/input/serio/ambakmi.c
index 4e2fd44..b7c206d 100644
--- a/drivers/input/serio/ambakmi.c
+++ b/drivers/input/serio/ambakmi.c
@@ -167,8 +167,6 @@ static int amba_kmi_remove(struct amba_device *dev)
 {
 	struct amba_kmi_port *kmi = amba_get_drvdata(dev);

-	amba_set_drvdata(dev, NULL);
-
 	serio_unregister_port(kmi->io);
 	clk_put(kmi->clk);
 	iounmap(kmi->base);
--
1.8.2.3


--=_mimegpg-monstr-desktop-4075-1380793604-0001
Content-Type: application/pgp-signature
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEABECAAYFAlJNPQQACgkQykllyylKDCH2VACghqYQRBSukqWtCd7fMSycl36i
7IMAnRVOLi+Gv2phgIKzER2FjYw6J+aj
=Apdc
-----END PGP SIGNATURE-----

--=_mimegpg-monstr-desktop-4075-1380793604-0001--
