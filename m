Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753334Ab3JCJrY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Oct 2013 05:47:24 -0400
Received: from mail-ea0-f176.google.com ([209.85.215.176]:40030 "EHLO
	mail-ea0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752898Ab3JCJqz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Oct 2013 05:46:55 -0400
From: Michal Simek <michal.simek@xilinx.com>
To: linux-kernel@vger.kernel.org, monstr@monstr.eu
Cc: Russell King <linux@arm.linux.org.uk>, Chris Ball <cjb@laptop.org>,
        linux-mmc@vger.kernel.org
Subject: [PATCH 4/9] mmc: mmci: Remove unnecessary amba_set_drvdata()
Date: Thu,  3 Oct 2013 11:46:26 +0200
Message-Id: <c7c68ca23d51c799ce20be3e2f65019e4a537387.1380793579.git.michal.simek@xilinx.com>
X-Mailer: git-send-email 1.8.2.3
In-Reply-To: <27e289763bbcb7d10f84081543cfc3a4dc770398.1380793579.git.michal.simek@xilinx.com>
References: <27e289763bbcb7d10f84081543cfc3a4dc770398.1380793579.git.michal.simek@xilinx.com>
In-Reply-To: <27e289763bbcb7d10f84081543cfc3a4dc770398.1380793579.git.michal.simek@xilinx.com>
References: <27e289763bbcb7d10f84081543cfc3a4dc770398.1380793579.git.michal.simek@xilinx.com>
Content-Type: multipart/signed;
    boundary="=_mimegpg-monstr-desktop-4100-1380793611-0001";
    micalg=pgp-sha1; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a MIME GnuPG-signed message.  If you see this text, it means that
your E-mail or Usenet software does not support MIME signed messages.
The Internet standard for MIME PGP messages, RFC 2015, was published in 1996.
To open this message correctly you will need to install E-mail or Usenet
software that supports modern Internet standards.

--=_mimegpg-monstr-desktop-4100-1380793611-0001

Driver core clears the driver data to NULL after device_release
or on probe failure, so just remove it from here.

Driver core change:
"device-core: Ensure drvdata = NULL when no driver is bound"
(sha1: 0998d0631001288a5974afc0b2a5f568bcdecb4d)

Signed-off-by: Michal Simek <michal.simek@xilinx.com>
---
 drivers/mmc/host/mmci.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/mmc/host/mmci.c b/drivers/mmc/host/mmci.c
index c3785ed..07e17f1 100644
--- a/drivers/mmc/host/mmci.c
+++ b/drivers/mmc/host/mmci.c
@@ -1678,8 +1678,6 @@ static int mmci_remove(struct amba_device *dev)
 {
 	struct mmc_host *mmc = amba_get_drvdata(dev);

-	amba_set_drvdata(dev, NULL);
-
 	if (mmc) {
 		struct mmci_host *host = mmc_priv(mmc);

--
1.8.2.3


--=_mimegpg-monstr-desktop-4100-1380793611-0001
Content-Type: application/pgp-signature
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEABECAAYFAlJNPQsACgkQykllyylKDCFmVwCdEwk3Xf6xuDtUXSyUl+dGvE9L
GkIAn0cK2NLnNGUqzyb5R71eOZItNowQ
=EsND
-----END PGP SIGNATURE-----

--=_mimegpg-monstr-desktop-4100-1380793611-0001--
