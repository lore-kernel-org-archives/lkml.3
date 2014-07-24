Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934287AbaGXHIH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jul 2014 03:08:07 -0400
Received: from ozlabs.org ([103.22.144.67]:44820 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934061AbaGXHIE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jul 2014 03:08:04 -0400
Date: Thu, 24 Jul 2014 17:07:55 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Greg KH <greg@kroah.com>, Olof Johansson <olof@lixom.net>,
        Arnd Bergmann <arnd@arndb.de>, <linux-arm-kernel@lists.infradead.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Pratyush Anand <pratyush.anand@st.com>,
        Viresh Kumar <viresh.kumar@linaro.org>,
        Thierry Reding <treding@nvidia.com>
Subject: linux-next: build failure after merge of the usb tree
Message-ID: <20140724170755.035cea1c@canb.auug.org.au>
X-Mailer: Claws Mail 3.10.1 (GTK+ 2.24.24; i486-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 boundary="Sig_/1FQDszzikH4KhNZ2AuRXyh1"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/1FQDszzikH4KhNZ2AuRXyh1
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi Greg,

After merging the usb tree, today's linux-next build (x86_64 allmodconfig)
failed like this:

drivers/phy/phy-spear1310-miphy.c: In function 'spear1310_miphy_probe':
drivers/phy/phy-spear1310-miphy.c:232:14: warning: passing argument 2 of 'd=
evm_phy_create' from incompatible pointer type
  priv->phy =3D devm_phy_create(dev, &spear1310_miphy_ops, NULL);
              ^
In file included from drivers/phy/phy-spear1310-miphy.c:21:0:
include/linux/phy/phy.h:164:13: note: expected 'struct device_node *' but a=
rgument is of type 'struct phy_ops *'
 struct phy *devm_phy_create(struct device *dev, struct device_node *node,
             ^
drivers/phy/phy-spear1310-miphy.c:232:14: error: too few arguments to funct=
ion 'devm_phy_create'
  priv->phy =3D devm_phy_create(dev, &spear1310_miphy_ops, NULL);
              ^
In file included from drivers/phy/phy-spear1310-miphy.c:21:0:
include/linux/phy/phy.h:164:13: note: declared here
 struct phy *devm_phy_create(struct device *dev, struct device_node *node,
             ^
drivers/phy/phy-spear1340-miphy.c: In function 'spear1340_miphy_probe':
drivers/phy/phy-spear1340-miphy.c:264:14: warning: passing argument 2 of 'd=
evm_phy_create' from incompatible pointer type
  priv->phy =3D devm_phy_create(dev, &spear1340_miphy_ops, NULL);
              ^
In file included from drivers/phy/phy-spear1340-miphy.c:21:0:
include/linux/phy/phy.h:164:13: note: expected 'struct device_node *' but a=
rgument is of type 'struct phy_ops *'
 struct phy *devm_phy_create(struct device *dev, struct device_node *node,
             ^
drivers/phy/phy-spear1340-miphy.c:264:14: error: too few arguments to funct=
ion 'devm_phy_create'
  priv->phy =3D devm_phy_create(dev, &spear1340_miphy_ops, NULL);
              ^
In file included from drivers/phy/phy-spear1340-miphy.c:21:0:
include/linux/phy/phy.h:164:13: note: declared here
 struct phy *devm_phy_create(struct device *dev, struct device_node *node,
             ^

Caused by commit f0ed817638b5 ("phy: core: Let node ptr of PHY point to
PHY and not of PHY provider") interacting with commit 64562e99477f
("phy: Add drivers for PCIe and SATA phy on SPEAr13xx") from the
arm-soc tree.

I fixed that up and then got:

drivers/pinctrl/pinctrl-tegra-xusb.c: In function 'tegra_xusb_padctl_probe':
drivers/pinctrl/pinctrl-tegra-xusb.c:913:8: warning: passing argument 2 of =
'devm_phy_create' from incompatible pointer type
  phy =3D devm_phy_create(&pdev->dev, &pcie_phy_ops, NULL);
        ^
In file included from drivers/pinctrl/pinctrl-tegra-xusb.c:18:0:
include/linux/phy/phy.h:164:13: note: expected 'struct device_node *' but a=
rgument is of type 'const struct phy_ops *'
 struct phy *devm_phy_create(struct device *dev, struct device_node *node,
             ^
drivers/pinctrl/pinctrl-tegra-xusb.c:913:8: error: too few arguments to fun=
ction 'devm_phy_create'
  phy =3D devm_phy_create(&pdev->dev, &pcie_phy_ops, NULL);
        ^
In file included from drivers/pinctrl/pinctrl-tegra-xusb.c:18:0:
include/linux/phy/phy.h:164:13: note: declared here
 struct phy *devm_phy_create(struct device *dev, struct device_node *node,
             ^
drivers/pinctrl/pinctrl-tegra-xusb.c:922:8: warning: passing argument 2 of =
'devm_phy_create' from incompatible pointer type
  phy =3D devm_phy_create(&pdev->dev, &sata_phy_ops, NULL);
        ^
In file included from drivers/pinctrl/pinctrl-tegra-xusb.c:18:0:
include/linux/phy/phy.h:164:13: note: expected 'struct device_node *' but a=
rgument is of type 'const struct phy_ops *'
 struct phy *devm_phy_create(struct device *dev, struct device_node *node,
             ^
drivers/pinctrl/pinctrl-tegra-xusb.c:922:8: error: too few arguments to fun=
ction 'devm_phy_create'
  phy =3D devm_phy_create(&pdev->dev, &sata_phy_ops, NULL);
        ^
In file included from drivers/pinctrl/pinctrl-tegra-xusb.c:18:0:
include/linux/phy/phy.h:164:13: note: declared here
 struct phy *devm_phy_create(struct device *dev, struct device_node *node,
             ^

=46rom an interaction with commit dc0a39386687 ("pinctrl: Add NVIDIA
Tegra XUSB pad controller support") from the arm-soc tree.

Final merge fix patch:

From: Stephen Rothwell <sfr@canb.auug.org.au>
Date: Thu, 24 Jul 2014 16:55:16 +1000
Subject: [PATCH] phy: fix up for devm_phy_create api change

Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>
---
 drivers/phy/phy-spear1310-miphy.c    | 2 +-
 drivers/phy/phy-spear1340-miphy.c    | 2 +-
 drivers/pinctrl/pinctrl-tegra-xusb.c | 4 ++--
 3 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/phy/phy-spear1310-miphy.c b/drivers/phy/phy-spear1310-=
miphy.c
index c58c869d57e0..6dcbfcddb372 100644
--- a/drivers/phy/phy-spear1310-miphy.c
+++ b/drivers/phy/phy-spear1310-miphy.c
@@ -229,7 +229,7 @@ static int spear1310_miphy_probe(struct platform_device=
 *pdev)
 		return -EINVAL;
 	}
=20
-	priv->phy =3D devm_phy_create(dev, &spear1310_miphy_ops, NULL);
+	priv->phy =3D devm_phy_create(dev, NULL, &spear1310_miphy_ops, NULL);
 	if (IS_ERR(priv->phy)) {
 		dev_err(dev, "failed to create SATA PCIe PHY\n");
 		return PTR_ERR(priv->phy);
diff --git a/drivers/phy/phy-spear1340-miphy.c b/drivers/phy/phy-spear1340-=
miphy.c
index 8de98adf21c3..7135ba2603b6 100644
--- a/drivers/phy/phy-spear1340-miphy.c
+++ b/drivers/phy/phy-spear1340-miphy.c
@@ -261,7 +261,7 @@ static int spear1340_miphy_probe(struct platform_device=
 *pdev)
 		return PTR_ERR(priv->misc);
 	}
=20
-	priv->phy =3D devm_phy_create(dev, &spear1340_miphy_ops, NULL);
+	priv->phy =3D devm_phy_create(dev, NULL, &spear1340_miphy_ops, NULL);
 	if (IS_ERR(priv->phy)) {
 		dev_err(dev, "failed to create SATA PCIe PHY\n");
 		return PTR_ERR(priv->phy);
diff --git a/drivers/pinctrl/pinctrl-tegra-xusb.c b/drivers/pinctrl/pinctrl=
-tegra-xusb.c
index 4a7daf577b49..a06620474845 100644
--- a/drivers/pinctrl/pinctrl-tegra-xusb.c
+++ b/drivers/pinctrl/pinctrl-tegra-xusb.c
@@ -910,7 +910,7 @@ static int tegra_xusb_padctl_probe(struct platform_devi=
ce *pdev)
 		goto reset;
 	}
=20
-	phy =3D devm_phy_create(&pdev->dev, &pcie_phy_ops, NULL);
+	phy =3D devm_phy_create(&pdev->dev, NULL, &pcie_phy_ops, NULL);
 	if (IS_ERR(phy)) {
 		err =3D PTR_ERR(phy);
 		goto unregister;
@@ -919,7 +919,7 @@ static int tegra_xusb_padctl_probe(struct platform_devi=
ce *pdev)
 	padctl->phys[TEGRA_XUSB_PADCTL_PCIE] =3D phy;
 	phy_set_drvdata(phy, padctl);
=20
-	phy =3D devm_phy_create(&pdev->dev, &sata_phy_ops, NULL);
+	phy =3D devm_phy_create(&pdev->dev, NULL, &sata_phy_ops, NULL);
 	if (IS_ERR(phy)) {
 		err =3D PTR_ERR(phy);
 		goto unregister;
--=20
2.0.1

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Sig_/1FQDszzikH4KhNZ2AuRXyh1
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBCAAGBQJT0LDRAAoJEMDTa8Ir7ZwVokcP/jZwOUszsu7nVztV5LP1WrWd
KaSL3ybrHV7/LxyLKx+Nm3XbRp15EK2nV2rNwfStwg/Yh/+J9UV+whWhqkRbhwq1
DbqLfepklCN9lK/uhYFr8ln+RDaCFoUtywqmryV0K9OK6+H6+TenLsQIrLCV4kR7
XZqch1W/ZBrWaNDpUnx/nms1QpjTTljVqo8/1sA7QC7/aKPBN6SFZ4Yy8d7SBVky
F1e+gr4c3CWIhU/4GRx95lWPIk2WWEUWwjZqkiKBm2vSDwFICFdtpFyHgiirQhl+
e8prVTJnM9V6TxQz5Z4qopCYPpRUZ7iloSyhlG+w1hXKiVydbQqDTT2+Ok+KdHok
e2rX5tV3t2L2bdh0Lp3v/IvuhP6eTeeRgnQCyaGRngnRODUWziQSUrOZqT4NTcNY
GBmdJnrA8+WgNVdMx3vlgDeD7e2U/kkeSGpSC97YubjTFze86L/jjSm5rAzmB1Q4
/WFWDb8E/zU6b0FJ++Wr4mYRXxF9RbZGlnfx0Uy7LWjvO3B788i79OEC3WKukP/K
BYi0ZJfltMMbWELDbIU956T3xgTcUM7iMKHTWmCZ9Bv76pWu/sEWwO/uq/biF7YF
/W3DGA2QhSnI0TmZ6x9CkDV4MZHHRKqs+cvRJ3YScdryZcBBvx1J+aDY4rl3IykG
GTdoHvp/6301RjdlYvcV
=0lwz
-----END PGP SIGNATURE-----

--Sig_/1FQDszzikH4KhNZ2AuRXyh1--
