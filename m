Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755926Ab3FLKSI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Jun 2013 06:18:08 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:11716 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751454Ab3FLKSF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Jun 2013 06:18:05 -0400
X-AuditID: cbfee691-b7fef6d000002d62-40-51b84ada81cf
From: Jingoo Han <jg1.han@samsung.com>
To: "'Kukjin Kim'" <kgene.kim@samsung.com>,
        "'Bjorn Helgaas'" <bhelgaas@google.com>
Cc: linux-samsung-soc@vger.kernel.org, linux-pci@vger.kernel.org,
        devicetree-discuss@lists.ozlabs.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        "'Grant Likely'" <grant.likely@secretlab.ca>,
        "'Andrew Murray'" <andrew.murray@arm.com>,
        "'Thomas Petazzoni'" <thomas.petazzoni@free-electrons.com>,
        "'Thierry Reding'" <thierry.reding@avionic-design.de>,
        "'Jason Gunthorpe'" <jgunthorpe@obsidianresearch.com>,
        Arnd Bergmann <arnd@arndb.de>,
        "'Surendranath Gurivireddy Balla'" <suren.reddy@samsung.com>,
        "'Siva Reddy Kallam'" <siva.kallam@samsung.com>,
        "'Thomas Abraham'" <thomas.abraham@linaro.org>,
        "'Jingoo Han'" <jg1.han@samsung.com>
Subject: [PATCH V4 0/3] PCIe support for Samsung Exynos5440 SoC
Date: Wed, 12 Jun 2013 19:18:02 +0900
Message-id: <003001ce6756$1ef00d60$5cd02820$@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Outlook 14.0
Thread-index: Ac5nVhJODk8vZaVFSae5/hzbnW/jUg==
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprNKsWRmVeSWpSXmKPExsVy+t8zY91bXjsCDR4v17Zo/r+d1eLvpGPs
	FkuaMiwOzH7IavHqzEY2i8sLL7FafL9hatG74CqbxabH11gtLu+aw2Zxdt5xNosZ5/cxWaxo
	2sposfjicmaL3SuXsFgcm7GE0eLpgyYmB0GPNfPWMHr8/jWJ0aNvylU2jyebLjJ6LNhU6nHn
	2h42j81L6j3Oz1jI6PF9Ry9QwZZVjB4/X+p4fN4kF8ATxWWTkpqTWZZapG+XwJXx/9R01oKt
	fBXznl9ib2B8xtXFyMEhIWAi8XmfaxcjJ5ApJnHh3nq2LkYuDiGBZYwSN5+fYYJImEj8ODSN
	CSIxnVHiy9+r7BDOL0aJJbP/MoNUsQmoSXz5cpgdxBYR8Je4drWVBaSIWWAKq0Trnj6wImEB
	e4m187rBilgEVCUuvDsCFucVsJRYtmUPO4QtKPFj8j0WEJtZQEti/c7jTBC2vMTmNW+ZIU5S
	kNhx9jUjxDI9iY+rDkPVi0jse/GOEWSxhMAZDolXB2axQiwTkPg2+RALxM+yEpsOQM2RlDi4
	4gbLBEaxWUhWz0KyehaS1bOQrFjAyLKKUTS1ILmgOCm9yFSvODG3uDQvXS85P3cTIyRhTNzB
	eP+A9SHGZKD1E5mlRJPzgQknryTe0NjMyMLUxNTYyNzSjDRhJXFe9RbrQCGB9MSS1OzU1ILU
	ovii0pzU4kOMTBycUg2M6wIOJy0o/8U1uyu3//OSAtOgiXNEph7I/eY9RTS8mysldbV1xf8K
	4wNaL3ecNHX+ZOffnTQtrdK2Om7Xj58KZb5z6sKV9l81/uHn4fAmI9TijWvCSbHTyzx6jxmE
	TlZLVwl1+aNs0Z+5TOyT4FT21y7F8jNFk0/NTU2L2PBE+UbnhcDQEg8lluKMREMt5qLiRACe
	ZogTLgMAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrJKsWRmVeSWpSXmKPExsVy+t9jQd1bXjsCDf4dULFo/r+d1eLvpGPs
	FkuaMiwOzH7IavHqzEY2i8sLL7FafL9hatG74CqbxabH11gtLu+aw2Zxdt5xNosZ5/cxWaxo
	2sposfjicmaL3SuXsFgcm7GE0eLpgyYmB0GPNfPWMHr8/jWJ0aNvylU2jyebLjJ6LNhU6nHn
	2h42j81L6j3Oz1jI6PF9Ry9QwZZVjB4/X+p4fN4kF8AT1cBok5GamJJapJCal5yfkpmXbqvk
	HRzvHG9qZmCoa2hpYa6kkJeYm2qr5OIToOuWmQP0l5JCWWJOKVAoILG4WEnfDtOE0BA3XQuY
	xghd35AguB4jAzSQsI4x4/+p6awFW/kq5j2/xN7A+Iyri5GTQ0LAROLHoWlMELaYxIV769m6
	GLk4hASmM0p8+XuVHcL5xSixZPZfZpAqNgE1iS9fDrOD2CIC/hLXrraygBQxC0xhlWjd0wdW
	JCxgL7F2XjdYEYuAqsSFd0fA4rwClhLLtuxhh7AFJX5MvscCYjMLaEms33mcCcKWl9i85i0z
	xEkKEjvOvmaEWKYn8XHVYah6EYl9L94xTmAUmIVk1Cwko2YhGTULScsCRpZVjKKpBckFxUnp
	uYZ6xYm5xaV56XrJ+bmbGMEJ6ZnUDsaVDRaHGAU4GJV4eA+YbQ8UYk0sK67MPcQowcGsJMJb
	pb0jUIg3JbGyKrUoP76oNCe1+BBjMtCnE5mlRJPzgckyryTe0NjEzMjSyMzCyMTcnDRhJXHe
	A63WgUIC6YklqdmpqQWpRTBbmDg4pRoYi0rb5Z7P+c/mdeQx2yfObXcj+G7IFB3Uq911YHaz
	jvu7G28X3RUOL+BdN6Vy48oPl0QPcHI92K1xfaXJUk2uzyv+8pzfumvzuYXn2SP55XkObd3r
	YPIryJRNbfGtX0LPcv3X8R2d18qtueBwybwrJluSvq6WPXfrDm9FHj9PVt7f0+GOK9nEDyqx
	FGckGmoxFxUnAgD0eUzvjAMAAA==
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

This series of patches introduces PCIe support for Samsung Exynos5440,
and is based on the latest 'linux-next' tree (20130607).
These patches was tested with Intel e1000e LAN card on Exynos5440.

This PATCH v4 follows:
 * PATCH v3, sent on June, 6th 2013
 * PATCH v2, sent on March, 23rd 2013
 * PATCH v1, sent on March, 4th 2013
 
Changes between v3 and v4:
  * Added support for multi domains as reviewed by Jason Gunthorpe,
    and Arnd Bergmann.
  * Fixed both MEM space and I/O space in DT.
  * Removed redundant physical addresses from struct pcie_port,
    added devm_ioremap_resource() to make add_pcie_port() simpler.
  * Added clock names and clock enable/disable.
	
Changes between v2 and v3:
  * Rebased on the top of 3.10-rc4
  * Updated names of PCIe PHY registers
 
Changes between v1 and v2:
  * Moved Exynos PCIe driver from arch/arm to drivers/pci/host.
  * Added DT properties of PCI DT standard.

Thank you.

Best regards,
Jingoo Han


Jingoo Han (3):
  pci: Add PCIe driver for Samsung Exynos
  ARM: EXYNOS: Enable PCIe support for Exynos5440
  ARM: dts: Add pcie controller node for Samsung EXYNOS5440 SoC

 arch/arm/boot/dts/exynos5440-ssdk5440.dts |    8 ++++++
 arch/arm/boot/dts/exynos5440.dtsi         |   38 +++++++++++++++++++++++++++++
 arch/arm/Kconfig             |    1 +
 arch/arm/mach-exynos/Kconfig |    2 ++
 .../devicetree/bindings/pci/exynos-pcie.txt        |   71 ++
 drivers/pci/host/Kconfig                           |    5 +
 drivers/pci/host/Makefile                          |    1 +
 drivers/pci/host/pci-exynos.c                      | 1074 ++++++++++++++++++++
 8 files changed, 1200 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/pci/exynos-pcie.txt
 create mode 100644 drivers/pci/host/pci-exynos.c

-- 
1.7.10.4


