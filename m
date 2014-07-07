Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751652AbaGGPbB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jul 2014 11:31:01 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:28051 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750957AbaGGPa6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jul 2014 11:30:58 -0400
X-AuditID: cbfee61a-f79e46d00000134f-db-53babd2f0bad
From: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
To: Pratyush Anand <pratyush.anand@st.com>
Cc: "Arnd Bergmann (arnd@arndb.de)" <arnd@arndb.de>,
        "'Bjorn Helgaas' (bhelgaas@google.com)" <bhelgaas@google.com>,
        Mohit KUMAR <mohit.kumar@st.com>,
        spear-devel <spear-devel@list.st.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        Mark Nicholson <mark@nicholnet.com>
Subject: Re: [PATCH V8 0/9] PCI: Add SPEAr13xx PCie support
Date: Mon, 07 Jul 2014 17:30:40 +0200
Message-id: <8677743.Bty96DiF3F@amdc1032>
User-Agent: KMail/4.8.4 (Linux/3.2.0-54-generic-pae; KDE/4.8.5; i686; ; )
In-reply-to: <20140522113119.GA2646@pratyush-vbox>
References: <cover.1397555158.git.mohit.kumar@st.com>
 <2CC2A0A4A178534D93D5159BF3BCB6619B94997E2B@EAPEX1MAIL1.st.com>
 <20140522113119.GA2646@pratyush-vbox>
MIME-version: 1.0
Content-transfer-encoding: 7Bit
Content-type: text/plain; charset=us-ascii
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrKLMWRmVeSWpSXmKPExsVy+t9jAV2DvbuCDeauYLL4O+kYu8WSpgyL
	+UfOsVpc3jWHzeLsvONsFjsfb2az2Dj1F6NF+yVlizkzNrM6cHr8/jWJ0WPBplKPkxdOsnjM
	brXzePpjL7PH501yAWxRXDYpqTmZZalF+nYJXBnLf9QUPDSp2H/nN1sD4xu1LkZODgkBE4m+
	Kc+YIGwxiQv31rN1MXJxCAksYpT4/2EqK4TTwiTx5XgfWBWbgJXExPZVjCC2iICWxLMdi8A6
	mAXmM0ssWLeIvYuRg0NYwFpi4wt9kBoWAVWJA/8ugtXzCmhKfF80gQ3EFhXwlNixfSUbSDmn
	gJFEx954kLCQwHxGidd9MRDlghI/Jt9jAbGZBeQl9u0HuQfE1pJYv/M40wRGgVlIymYhKZuF
	pGwBI/MqRtHUguSC4qT0XEO94sTc4tK8dL3k/NxNjODAfya1g3Flg8UhRgEORiUe3gOrdgYL
	sSaWFVfmHmKU4GBWEuFdsXxXsBBvSmJlVWpRfnxRaU5q8SFGaQ4WJXHeA63WgUIC6Yklqdmp
	qQWpRTBZJg5OqQbGhbaKrB7mr+KMLaa42P2OzFuh1TynXaMrh4V35hxxn31Tlh/cVbOCI7hs
	k1iqWZCfkcPHr5cUzX+/cT+9ev7PkEOZHw+nrqxecqs/yeLolJSzKk2/ZbP/60pNT/Ka5jSv
	d0WO3gQ/Z4vHm8rKZk6Qn93bWbhDv5VjbUNaTO+Pj/xnRBcLv3dRYinOSDTUYi4qTgQA3UkF
	+HgCAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi Arnd,

Any update on status of this patchset?  Is it OK for it to go through
arm-soc tree or should it be splitted into separate parts which would
go through pci/phy/arm-soc trees?

[ The patchset applies fine to next-20140707 after fixing trivial
  reject in drivers/pci/host/Makefile in patch #8.  To make it build
  the following line from patch #8 needs to be dropped:

  +       spin_lock_init(&pp->conf_lock);
]

Best regards,
--
Bartlomiej Zolnierkiewicz
Samsung R&D Institute Poland
Samsung Electronics

On Thursday, May 22, 2014 05:01:19 PM Pratyush Anand wrote:
> Hi Arnd/Bjorn,
> 
> On Mon, May 19, 2014 at 07:55:12PM +0800, Mohit KUMAR wrote:
> > Hello Arnd,
> > 
> > > -----Original Message-----
> > > From: Mohit KUMAR DCG
> > > Sent: Tuesday, April 15, 2014 5:20 PM
> > > To: spear-devel; linux-kernel@vger.kernel.org; devicetree@vger.kernel.org;
> > > linux-pci@vger.kernel.org; linux-arm-kernel@lists.infradead.org
> > > Cc: Mohit KUMAR DCG
> > > Subject: [PATCH V8 0/9] PCI: Add SPEAr13xx PCie support
> > > 
> > > Patch# 1 and 2: Improvement and fixes for SPEAr13xx support.
> > > Patch# 3,4 and 6: Add DT bindings for spear1310/40-miphy, misc and pcie
> > > node Patch# 5: Add spear1310/40-miphy driver and support for spear1310/40
> > > miphy wrapper.
> > > Patch# 7-9: Add SPEAr13xx PCIe driver and dt support.
> > > 
> > > These pathes are tested with linux-3.15 tag of arm-soc tree.
> > > Tested with SPEAr1310 evaluation board with:
> > > 	- INTEL PRO 100/100 EP card
> > > 	- USB xhci gen2 card
> > >  	- Above cards connected through LeCROY PTC switch
> > > 
> > > Modifications for SATA are tested with SPEAr1340-evb board
> > > 
> > 
> > I think 3.16 windows is about to close, are you planning to merge this series?
> > Pls let me know if something pending on our part.
> 
> If you could let us know the status of this patch series inclusion.
> 
> Regards
> Pratyush
> 
> > 
> > Regards
> > Mohit
> > 
> > > Changes since v7:
> > > - Rebase over for-linus-3.15 tag of arm-soc tree so that complete patch series
> > > can be applied cleanly.
> > > - Incorporated few comments on comment style and superfluous comments
> > > Changes since v6:
> > > - Split miphy driver for SPEAr1310 and SPEAr1340
> > > - Some cleanup and incorporated other minor comments Changes since v5:
> > > - Split DT bindings for misc, miphy-40lp and pcie node into sepearte patches
> > > - Merge config options PCIE_SPEAR13XX and PCI_MSI into defconfig patch
> > > - Incorporated other minor comments
> > > Changes since v4:
> > > - Uses per device function pointers passed from .data field to
> > >   the of_device_id instead of of_device_is_compatible.
> > > - Incorporated other minor comments from v4
> > > 
> > > Changes since v3:
> > > - Phy driver renamed to phy-miphy40lp
> > > - ahci phy hook patch used as suggested by Arnd
> > > - Incorporated other minor comments from v3
> > > 
> > > Changes since v2:
> > > - Incorporated comments to move SPEAr13xx PCIe and SATA phy specific
> > > routines to
> > >   the phy framework
> > > - Modify ahci driver to include phy hooks
> > > - phy-core driver modifications for subsys_initcall()
> > > 
> > > Changes since v1:
> > > - Few patches of the series are already accepted and applied to mainline e.g.
> > >  pcie designware driver improvements,fixes for IO translation bug, PCIe dw
> > > driver maintainer. So dropped these from v2.
> > > - Incorporated comment to move the common/reset PCIe code to the
> > > seperate driver
> > > - PCIe and SATA share common PHY configuration registers, so move SATA
> > > platform code to the system config driver Fourth patch is improves pcie
> > > designware driver and fixes the IO translation bug. IO translation bug fix
> > > leads to the working of PCIe EP devices connected to RC through switch.
> > > 
> > > Mohit Kumar (1):
> > >   SPEAr13xx: defconfig: Update
> > > 
> > > Pratyush Anand (8):
> > >   clk: SPEAr13XX: Fix pcie clock name
> > >   SPEAr13XX: Fix static mapping table
> > >   phy: SPEAr1310/40-miphy: Add binding information
> > >   SPEAr: misc: Add binding information
> > >   phy: SPEAr1310/40-miphy: Add phy driver for PCIe and SATA
> > >   SPEAr13XX: Add binding information for PCIe controller
> > >   SPEAr13XX: dts: Add PCIe node information
> > >   pcie: SPEAr13xx: Add designware wrapper support
> > > 
> > >  .../devicetree/bindings/arm/spear-misc.txt         |    9 +
> > >  .../devicetree/bindings/pci/spear13xx-pcie.txt     |   14 +
> > >  .../devicetree/bindings/phy/st-spear1310-miphy.txt |   12 +
> > >  .../devicetree/bindings/phy/st-spear1340-miphy.txt |   11 +
> > >  MAINTAINERS                                        |    6 +
> > >  arch/arm/boot/dts/spear1310-evb.dts                |    4 +
> > >  arch/arm/boot/dts/spear1310.dtsi                   |   93 +++++-
> > >  arch/arm/boot/dts/spear1340-evb.dts                |    4 +
> > >  arch/arm/boot/dts/spear1340.dtsi                   |   30 ++-
> > >  arch/arm/boot/dts/spear13xx.dtsi                   |    9 +-
> > >  arch/arm/configs/spear13xx_defconfig               |   16 +
> > >  arch/arm/mach-spear/Kconfig                        |    4 +
> > >  arch/arm/mach-spear/include/mach/spear.h           |    4 +-
> > >  arch/arm/mach-spear/spear1340.c                    |  127 +------
> > >  arch/arm/mach-spear/spear13xx.c                    |    2 +-
> > >  drivers/clk/spear/spear1310_clock.c                |    6 +-
> > >  drivers/clk/spear/spear1340_clock.c                |    2 +-
> > >  drivers/pci/host/Kconfig                           |    8 +
> > >  drivers/pci/host/Makefile                          |    1 +
> > >  drivers/pci/host/pcie-spear13xx.c                  |  407 ++++++++++++++++++++
> > >  drivers/phy/Kconfig                                |   12 +
> > >  drivers/phy/Makefile                               |    2 +
> > >  drivers/phy/phy-spear1310-miphy.c                  |  274 +++++++++++++
> > >  drivers/phy/phy-spear1340-miphy.c                  |  300 ++++++++++++++
> > >  24 files changed, 1218 insertions(+), 139 deletions(-)  create mode 100644
> > > Documentation/devicetree/bindings/arm/spear-misc.txt
> > >  create mode 100644 Documentation/devicetree/bindings/pci/spear13xx-
> > > pcie.txt
> > >  create mode 100644 Documentation/devicetree/bindings/phy/st-
> > > spear1310-miphy.txt
> > >  create mode 100644 Documentation/devicetree/bindings/phy/st-
> > > spear1340-miphy.txt
> > >  create mode 100644 drivers/pci/host/pcie-spear13xx.c  create mode 100644
> > > drivers/phy/phy-spear1310-miphy.c  create mode 100644 drivers/phy/phy-
> > > spear1340-miphy.c

