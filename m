Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030351Ab3E3K2d (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 May 2013 06:28:33 -0400
Received: from mail-wi0-f169.google.com ([209.85.212.169]:47454 "EHLO
	mail-wi0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S968162Ab3E3K2O (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 May 2013 06:28:14 -0400
From: Michal Simek <michal.simek@xilinx.com>
To: linux-kernel@vger.kernel.org
Cc: Michal Simek <monstr@monstr.eu>, Michal Simek <michal.simek@xilinx.com>,
        renner@efe-gmbh.de, Bill Pemberton <wfp5p@virginia.edu>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        netdev@vger.kernel.org
Subject: [PATCH v2 1/6] net: emaclite: Report failures in mdio setup
Date: Thu, 30 May 2013 12:28:03 +0200
Message-Id: <286fceaa6f4268594b89707d6e5d9ce5bd309c2d.1369909618.git.michal.simek@xilinx.com>
X-Mailer: git-send-email 1.8.2.3
In-Reply-To: <cover.1369909618.git.michal.simek@xilinx.com>
References: <cover.1369909618.git.michal.simek@xilinx.com>
In-Reply-To: <cover.1369909618.git.michal.simek@xilinx.com>
References: <cover.1369909618.git.michal.simek@xilinx.com>
Content-Type: multipart/signed;
    boundary="=_mimegpg-monstr-desktop-5436-1369909691-0001";
    micalg=pgp-sha1; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a MIME GnuPG-signed message.  If you see this text, it means that
your E-mail or Usenet software does not support MIME signed messages.
The Internet standard for MIME PGP messages, RFC 2015, was published in 1996.
To open this message correctly you will need to install E-mail or Usenet
software that supports modern Internet standards.

--=_mimegpg-monstr-desktop-5436-1369909691-0001

Be more verbose when any problem happens.

Signed-off-by: Michal Simek <michal.simek@xilinx.com>
---
Changes in v2: None

 drivers/net/ethernet/xilinx/xilinx_emaclite.c | 12 +++++++++---
 1 file changed, 9 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/xilinx/xilinx_emaclite.c b/drivers/net/ethernet/xilinx/xilinx_emaclite.c
index 919b983..a16dc35 100644
--- a/drivers/net/ethernet/xilinx/xilinx_emaclite.c
+++ b/drivers/net/ethernet/xilinx/xilinx_emaclite.c
@@ -852,8 +852,10 @@ static int xemaclite_mdio_setup(struct net_local *lp, struct device *dev)
 	/* Don't register the MDIO bus if the phy_node or its parent node
 	 * can't be found.
 	 */
-	if (!np)
+	if (!np) {
+		dev_err(dev, "Failed to register mdio bus.\n");
 		return -ENODEV;
+	}

 	/* Enable the MDIO bus by asserting the enable bit in MDIO Control
 	 * register.
@@ -862,8 +864,10 @@ static int xemaclite_mdio_setup(struct net_local *lp, struct device *dev)
 		 XEL_MDIOCTRL_MDIOEN_MASK);

 	bus = mdiobus_alloc();
-	if (!bus)
+	if (!bus) {
+		dev_err(dev, "Failed to allocal mdiobus\n");
 		return -ENOMEM;
+	}

 	of_address_to_resource(np, 0, &res);
 	snprintf(bus->id, MII_BUS_ID_SIZE, "%.8llx",
@@ -879,8 +883,10 @@ static int xemaclite_mdio_setup(struct net_local *lp, struct device *dev)
 	lp->mii_bus = bus;

 	rc = of_mdiobus_register(bus, np);
-	if (rc)
+	if (rc) {
+		dev_err(dev, "Failed to register mdio bus.\n");
 		goto err_register;
+	}

 	return 0;

--
1.8.2.3


--=_mimegpg-monstr-desktop-5436-1369909691-0001
Content-Type: application/pgp-signature
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEABECAAYFAlGnKbsACgkQykllyylKDCE6pQCfYavTqYoY8FBtImYNpBGhclth
aKcAni3mFVwF1ZVlO1kcJI/dktjVLSYZ
=YFLe
-----END PGP SIGNATURE-----

--=_mimegpg-monstr-desktop-5436-1369909691-0001--
