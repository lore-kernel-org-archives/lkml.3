Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934168AbaGXG20 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jul 2014 02:28:26 -0400
Received: from ozlabs.org ([103.22.144.67]:36949 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933521AbaGXG2Z (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jul 2014 02:28:25 -0400
Date: Thu, 24 Jul 2014 16:28:11 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Greg KH <greg@kroah.com>, Olof Johansson <olof@lixom.net>,
        Arnd Bergmann <arnd@arndb.de>, <linux-arm-kernel@lists.infradead.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Pratyush Anand <pratyush.anand@st.com>,
        Viresh Kumar <viresh.kumar@linaro.org>,
        Srinivas Kandagatla <srinivas.kandagatla@linaro.org>,
        Kishon Vijay Abraham I <kishon@ti.com>
Subject: linux-next: manual merge of the usb tree with the arm-soc tree
Message-ID: <20140724162811.5e12107a@canb.auug.org.au>
X-Mailer: Claws Mail 3.10.1 (GTK+ 2.24.24; i486-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 boundary="Sig_/eLREgiIUz=fnk550RGhgrED"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/eLREgiIUz=fnk550RGhgrED
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi Greg,

Today's linux-next merge of the usb tree got a conflict in
drivers/phy/Kconfig between commit 64562e99477f ("phy: Add drivers for
PCIe and SATA phy on SPEAr13xx") from the arm-soc tree and commit
1de990d8a169 ("phy: qcom: Add driver for QCOM APQ8064 SATA PHY") from
the usb tree.

I fixed it up (see below) and can carry the fix as necessary (no action
is required).

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc drivers/phy/Kconfig
index 86c22e26a243,cc97c897945a..000000000000
--- a/drivers/phy/Kconfig
+++ b/drivers/phy/Kconfig
@@@ -124,53 -149,30 +149,40 @@@ config PHY_SUN4I_US
  config PHY_SAMSUNG_USB2
  	tristate "Samsung USB 2.0 PHY driver"
  	depends on HAS_IOMEM
+ 	depends on USB_EHCI_EXYNOS || USB_OHCI_EXYNOS || USB_DWC2
  	select GENERIC_PHY
  	select MFD_SYSCON
+ 	default ARCH_EXYNOS
  	help
  	  Enable this to support the Samsung USB 2.0 PHY driver for Samsung
- 	  SoCs. This driver provides the interface for USB 2.0 PHY. Support for
- 	  particular SoCs has to be enabled in addition to this driver. Number
- 	  and type of supported phys depends on the SoC.
+ 	  SoCs. This driver provides the interface for USB 2.0 PHY. Support
+ 	  for particular PHYs will be enabled based on the SoC type in addition
+ 	  to this driver.
 =20
 +config PHY_S5PV210_USB2
 +	bool "Support for S5PV210"
 +	depends on PHY_SAMSUNG_USB2
 +	depends on ARCH_S5PV210
 +	help
 +	  Enable USB PHY support for S5PV210. This option requires that Samsung
 +	  USB 2.0 PHY driver is enabled and means that support for this
 +	  particular SoC is compiled in the driver. In case of S5PV210 two phys
 +	  are available - device and host.
 +
  config PHY_EXYNOS4210_USB2
- 	bool "Support for Exynos 4210"
+ 	bool
  	depends on PHY_SAMSUNG_USB2
- 	depends on CPU_EXYNOS4210
- 	help
- 	  Enable USB PHY support for Exynos 4210. This option requires that
- 	  Samsung USB 2.0 PHY driver is enabled and means that support for this
- 	  particular SoC is compiled in the driver. In case of Exynos 4210 four
- 	  phys are available - device, host, HSIC0 and HSIC1.
+ 	default CPU_EXYNOS4210
 =20
  config PHY_EXYNOS4X12_USB2
- 	bool "Support for Exynos 4x12"
+ 	bool
  	depends on PHY_SAMSUNG_USB2
- 	depends on (SOC_EXYNOS4212 || SOC_EXYNOS4412)
- 	help
- 	  Enable USB PHY support for Exynos 4x12. This option requires that
- 	  Samsung USB 2.0 PHY driver is enabled and means that support for this
- 	  particular SoC is compiled in the driver. In case of Exynos 4x12 four
- 	  phys are available - device, host, HSIC0 and HSIC1.
+ 	default SOC_EXYNOS3250 || SOC_EXYNOS4212 || SOC_EXYNOS4412
 =20
  config PHY_EXYNOS5250_USB2
- 	bool "Support for Exynos 5250"
+ 	bool
  	depends on PHY_SAMSUNG_USB2
- 	depends on SOC_EXYNOS5250
- 	help
- 	  Enable USB PHY support for Exynos 5250. This option requires that
- 	  Samsung USB 2.0 PHY driver is enabled and means that support for this
- 	  particular SoC is compiled in the driver. In case of Exynos 5250 four
- 	  phys are available - device, host, HSIC0 and HSIC.
+ 	default SOC_EXYNOS5250 || SOC_EXYNOS5420
 =20
  config PHY_EXYNOS5_USBDRD
  	tristate "Exynos5 SoC series USB DRD PHY driver"
@@@ -190,16 -194,18 +204,30 @@@ config PHY_XGEN
  	help
  	  This option enables support for APM X-Gene SoC multi-purpose PHY.
 =20
 +config PHY_ST_SPEAR1310_MIPHY
 +	tristate "ST SPEAR1310-MIPHY driver"
 +	select GENERIC_PHY
 +	help
 +	  Support for ST SPEAr1310 MIPHY which can be used for PCIe and SATA.
 +
 +config PHY_ST_SPEAR1340_MIPHY
 +	tristate "ST SPEAR1340-MIPHY driver"
 +	select GENERIC_PHY
 +	help
 +	  Support for ST SPEAr1340 MIPHY which can be used for PCIe and SATA.
 +
+ config PHY_QCOM_APQ8064_SATA
+ 	tristate "Qualcomm APQ8064 SATA SerDes/PHY driver"
+ 	depends on ARCH_QCOM
+ 	depends on HAS_IOMEM
+ 	depends on OF
+ 	select GENERIC_PHY
+=20
+ config PHY_QCOM_IPQ806X_SATA
+ 	tristate "Qualcomm IPQ806x SATA SerDes/PHY driver"
+ 	depends on ARCH_QCOM
+ 	depends on HAS_IOMEM
+ 	depends on OF
+ 	select GENERIC_PHY
+=20
  endmenu

--Sig_/eLREgiIUz=fnk550RGhgrED
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBCAAGBQJT0KeGAAoJEMDTa8Ir7ZwVAq0P/0RQQYQ6UjwHa2h0FWVwy/BL
gT0j2Ocpp2ykFd9CMco9JVFJgXxh+hE7K1QsrBktE4acfhMvLhicl7oylPyv9lXn
2BoknCwBo7Z6bhoQ03i/8nSB2lK/LPVPHaWKdtKe1yXXlDb+aG8GZ/XTVSjaeNpm
O3rm1Rp9Sr0YklSbwPyJ7fbvGbmyOaYYMJICoZQzS3YxOrd6V9fDXW4DgZPxP08A
A5aVArK3TLNFdCqMnmG4WaDHcO70m/sR71DxqEKOhSi5mKZSDCX5GO3lgey3dq83
+5PSysJ/ArnLN9Pg4Nuoz1lM6A/La0YeOzfUv7c00C6jIXdHTYDlW38q3u2q5HGl
O4CdVdU/ivO8Z5KaXPKapTrbs7SthujVjmcnXSLJZeACrx8QCuygAMAr1xUi2VdJ
KOTepwU81G4XwLfdg0fQ1nEA33i+pDAGj/sDf/9IBMZXwuoGkUqEfafUYYlxtNf0
YirLyS4FaPNtx8nTYSly0bzfvazEE1U6Pc0HWgDAPak9XSgn0jbLkr6qFRsobOl+
4UhszLDCc7lhVpQzRWwBteg5gDdl6rW0LWjclEV7kyk44svn4FIYc8tEZ/Oa02tC
EQpVGF2eglkS+L0YyodRtUAMaDOnHAfhRhvmDfj2Di1buI6VKFfEqdMRP07h6HZ6
pDsULRnOH+qPhIVSSnya
=yi5d
-----END PGP SIGNATURE-----

--Sig_/eLREgiIUz=fnk550RGhgrED--
