Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753081AbaBLP5B (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Feb 2014 10:57:01 -0500
Received: from mail-ea0-f174.google.com ([209.85.215.174]:40319 "EHLO
	mail-ea0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753056AbaBLP46 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Feb 2014 10:56:58 -0500
From: Michal Simek <michal.simek@xilinx.com>
To: netdev@vger.kernel.org
Cc: Srikanth Thokala <sthokal@xilinx.com>,
        Srikanth Thokala <srikanth.thokala@xilinx.com>,
        Michal Simek <monstr@monstr.eu>, Anirudha Sarangi <anirudh@xilinx.com>,
        John Linn <John.Linn@xilinx.com>, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 07/14] net: axienet: Support phy-less mode of operation
Date: Wed, 12 Feb 2014 16:55:41 +0100
Message-Id: <2dce248d6285beb10f3d4fcfba3c3a087e2c139f.1392220536.git.michal.simek@xilinx.com>
X-Mailer: git-send-email 1.8.2.3
In-Reply-To: <cover.1392220536.git.michal.simek@xilinx.com>
References: <cover.1392220536.git.michal.simek@xilinx.com>
In-Reply-To: <cover.1392220536.git.michal.simek@xilinx.com>
References: <cover.1392220536.git.michal.simek@xilinx.com>
Content-Type: multipart/signed;
    boundary="=_mimegpg-monstr-desktop-2277-1392220612-0001";
    micalg=pgp-sha1; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a MIME GnuPG-signed message.  If you see this text, it means that
your E-mail or Usenet software does not support MIME signed messages.
The Internet standard for MIME PGP messages, RFC 2015, was published in 1996.
To open this message correctly you will need to install E-mail or Usenet
software that supports modern Internet standards.

--=_mimegpg-monstr-desktop-2277-1392220612-0001

From: Srikanth Thokala <srikanth.thokala@xilinx.com>

This patch adds proper checks to handle the PHY-less case.

Signed-off-by: Srikanth Thokala <sthokal@xilinx.com>
Signed-off-by: Michal Simek <michal.simek@xilinx.com>
---

 drivers/net/ethernet/xilinx/xilinx_axienet_main.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/net/ethernet/xilinx/xilinx_axienet_main.c b/drivers/net/ethernet/xilinx/xilinx_axienet_main.c
index 9595403..9cc9e59 100644
--- a/drivers/net/ethernet/xilinx/xilinx_axienet_main.c
+++ b/drivers/net/ethernet/xilinx/xilinx_axienet_main.c
@@ -940,11 +940,10 @@ static int axienet_open(struct net_device *ndev)
 					     PHY_INTERFACE_MODE_RGMII_ID);
 		}

-		if (!lp->phy_dev) {
+		if (!lp->phy_dev)
 			dev_err(lp->dev, "of_phy_connect() failed\n");
-			return -ENODEV;
-		}
-		phy_start(lp->phy_dev);
+		else
+			phy_start(lp->phy_dev);
 	}

 	/* Enable tasklets for Axi DMA error handling */
@@ -1609,7 +1608,8 @@ static int axienet_of_probe(struct platform_device *op)
 	lp->coalesce_count_tx = XAXIDMA_DFT_TX_THRESHOLD;

 	lp->phy_node = of_parse_phandle(op->dev.of_node, "phy-handle", 0);
-	ret = axienet_mdio_setup(lp, op->dev.of_node);
+	if (lp->phy_node)
+		ret = axienet_mdio_setup(lp, op->dev.of_node);
 	if (ret)
 		dev_warn(&op->dev, "error registering MDIO bus\n");

--
1.8.2.3


--=_mimegpg-monstr-desktop-2277-1392220612-0001
Content-Type: application/pgp-signature
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEABECAAYFAlL7mcQACgkQykllyylKDCHv2ACfUjek6VEAZQ4YnnJMMyNpyNbI
xFkAmQEIjhoGcFvcYG6XcDYRLhSQZrm8
=KeIM
-----END PGP SIGNATURE-----

--=_mimegpg-monstr-desktop-2277-1392220612-0001--
