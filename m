Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752552AbaKRGHJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Nov 2014 01:07:09 -0500
Received: from mail-bn1on0112.outbound.protection.outlook.com ([157.56.110.112]:2784
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750808AbaKRGHG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Nov 2014 01:07:06 -0500
Date: Tue, 18 Nov 2014 13:00:03 +0800
From: Peter Chen <peter.chen@freescale.com>
To: Antoine Tenart <antoine.tenart@free-electrons.com>
CC: <sebastian.hesselbarth@gmail.com>, <balbi@ti.com>,
        <p.zabel@pengutronix.de>, <alexandre.belloni@free-electrons.com>,
        <thomas.petazzoni@free-electrons.com>, <zmxu@marvell.com>,
        <jszhang@marvell.com>, <michal.simek@xilinx.com>,
        <linux-arm-kernel@lists.infradead.org>, <linux-usb@vger.kernel.org>,
        <devicetree@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v8 00/13] ARM: berlin: USB support
Message-ID: <20141118050002.GC15650@shlinux2>
References: <1416231347-27193-1-git-send-email-antoine.tenart@free-electrons.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <1416231347-27193-1-git-send-email-antoine.tenart@free-electrons.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-EOPAttributedMessage: 0
Authentication-Results: spf=fail (sender IP is 192.88.168.50)
 smtp.mailfrom=Peter.Chen@freescale.com; 
X-Forefront-Antispam-Report: CIP:192.88.168.50;CTRY:US;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(10019020)(6009001)(24454002)(51704005)(199003)(189002)(54356999)(64706001)(47776003)(20776003)(97756001)(4396001)(50986999)(50466002)(76176999)(31966008)(105606002)(77156002)(106466001)(107046002)(62966003)(95666004)(33716001)(99396003)(86362001)(23726002)(104016003)(46406003)(120916001)(97736003)(83506001)(6806004)(68736004)(15975445006)(110136001)(19580395003)(33656002)(44976005)(87936001)(46102003)(21056001)(102836001)(85426001)(92566001)(92726001)(84676001)(7059030);DIR:OUT;SFP:1102;SCL:1;SRVR:DM2PR0301MB0638;H:tx30smr01.am.freescale.net;FPR:;MLV:sfv;PTR:InfoDomainNonexistent;A:1;MX:1;LANG:en;
X-Microsoft-Antispam: UriScan:;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;SRVR:DM2PR0301MB0638;
X-Exchange-Antispam-Report-CFA-Test: BCL:0;PCL:0;RULEID:(7)(6);SRVR:DM2PR0301MB0638;
X-Forefront-PRVS: 039975700A
X-Exchange-Antispam-Report-CFA-Test: BCL:0;PCL:0;RULEID:;SRVR:DM2PR0301MB0638;
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 17, 2014 at 02:35:34PM +0100, Antoine Tenart wrote:
> This series adds the support for ChipIdea USB2 (ci13xxx) controllers,
> the USB PHYs of the Marvell Berlin SoCs and also adds a reset
> controller for these SoCs.
> 
> The reset controller is used by the PHY driver and shares the
> existing chip controller node with the clocks and one pin controller.
> 
> The Marvell Berlin USB controllers are host only on the BG2Q and are
> compatible with USB ChipIdea. We here add a glue to use the available
> common functions for this kind of controllers, and add a generic USB2
> ChipIdea driver. A PHY driver is also added to control the USB PHY.
> 
> This series applies on top of Peter Chen's ci-for-usb-next branch[1]
> containing the generic PHY support in the USB framework[2].
> 
> Patches 1-4 should already have been taken by Sebastian.
> 

Applied patches 7-9, thanks.

> Changes since v7:
> 	- rebased on top of the latest CI for-next branch of Peter[1]
> 	- removed CI_HDRC_REQUIRE_TRANSCEIVER
> 	- added a missing tested-by
> 	- some cosmetic fixes and a commit message reword
> 
> Changes since v6:
>         - removed ci_hdrc_usb2_dt_probe
>         - fixed a bug in the ChipIdea core for PHY handling
>         - called unconditionally dma_set_mask_and_coherent()
> 
> Changes since v5:
>         - added a missing header in ci_hdrc_usb2
> 
> Changes since v4:
>         - fixed the error handling of ci_hdrc_usb2_probe()
> 
> Changes since v3:
>         - removed the DMA mask property
>         - moved the clock handling in the common probe function
>         - fixed the documentation for the USB2 ChipIdea USB PHY binding
>         - made sure the reset bit is 0-31 in the reset driver
> 
> Changes since v2:
>         - moved the PHY driver to the generic PHY framework
>         - changed the compatible to 'chipidea,usb2'
>         - added a property to set the DMA mask in the USB2 CI driver
>         - separated dt specific calls in the CI probing function
>         - rebased on top of the generic PHY support for CI[2]
> 
> Changes since v1:
>         - made the Berlin CI USB driver a generic one
>         - added support to custom offset for the reset register
>         - added fixed regulators to support supply the VBUS
>         - modified the PHY driver to support the one one the BG2CD as
>           well
>         - documented the reset properties
>         - added bindings for the BG2CD
>         - cosmetic fixes
> 
> [1] https://github.com/hzpeterchen/linux-usb.git ci-for-usb-next
> [2] git://git.free-electrons.com:users/antoine-tenart/linux.git usb-phy
> 
> Antoine Tenart (11):
>   reset: add the Berlin reset controller driver
>   Documentation: bindings: add reset bindings docs for Marvell Berlin
>     SoCs
>   ARM: Berlin: select the reset controller
>   ARM: dts: berlin: add a required reset property in the chip controller
>     node
>   phy: add the Berlin USB PHY driver
>   Documentation: bindings: add doc for the Berlin USB PHY
>   usb: chipidea: fix phy handling
>   usb: chipidea: add a usb2 driver for ci13xxx
>   Documentation: bindings: add doc for the USB2 ChipIdea USB driver
>   ARM: dts: berlin: add BG2Q nodes for USB support
>   ARM: dts: Berlin: enable USB on the BG2Q DMP
> 
> Sebastian Hesselbarth (2):
>   ARM: dts: berlin: add BG2CD nodes for USB support
>   ARM: dts: berlin: enable USB on the Google Chromecast
> 
>  .../devicetree/bindings/arm/marvell,berlin.txt     |  10 +
>  .../devicetree/bindings/phy/berlin-usb-phy.txt     |  16 ++
>  .../devicetree/bindings/usb/ci-hdrc-usb2.txt       |  24 +++
>  arch/arm/boot/dts/berlin2.dtsi                     |   1 +
>  arch/arm/boot/dts/berlin2cd-google-chromecast.dts  |   4 +
>  arch/arm/boot/dts/berlin2cd.dtsi                   |  37 ++++
>  arch/arm/boot/dts/berlin2q-marvell-dmp.dts         |  53 +++++
>  arch/arm/boot/dts/berlin2q.dtsi                    |  56 ++++++
>  arch/arm/mach-berlin/Kconfig                       |   2 +
>  drivers/phy/Kconfig                                |   7 +
>  drivers/phy/Makefile                               |   1 +
>  drivers/phy/phy-berlin-usb.c                       | 224 +++++++++++++++++++++
>  drivers/reset/Makefile                             |   1 +
>  drivers/reset/reset-berlin.c                       | 131 ++++++++++++
>  drivers/usb/chipidea/Makefile                      |   1 +
>  drivers/usb/chipidea/ci_hdrc_usb2.c                | 116 +++++++++++
>  drivers/usb/chipidea/core.c                        |   4 +-
>  17 files changed, 686 insertions(+), 2 deletions(-)
>  create mode 100644 Documentation/devicetree/bindings/phy/berlin-usb-phy.txt
>  create mode 100644 Documentation/devicetree/bindings/usb/ci-hdrc-usb2.txt
>  create mode 100644 drivers/phy/phy-berlin-usb.c
>  create mode 100644 drivers/reset/reset-berlin.c
>  create mode 100644 drivers/usb/chipidea/ci_hdrc_usb2.c
> 
> -- 
> 2.1.0
> 

-- 

Best Regards,
Peter Chen
