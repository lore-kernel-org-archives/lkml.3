Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752770AbaFIFzb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jun 2014 01:55:31 -0400
Received: from mail-bl2lp0204.outbound.protection.outlook.com ([207.46.163.204]:10574
	"EHLO na01-bl2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751012AbaFIFzY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jun 2014 01:55:24 -0400
Date: Mon, 9 Jun 2014 12:30:20 +0800
From: Peter Chen <peter.chen@freescale.com>
To: Antoine =?iso-8859-1?Q?T=E9nart?= 
	<antoine.tenart@free-electrons.com>
CC: <sebastian.hesselbarth@gmail.com>, <balbi@ti.com>,
        <p.zabel@pengutronix.de>, <alexandre.belloni@free-electrons.com>,
        <thomas.petazzoni@free-electrons.com>, <zmxu@marvell.com>,
        <jszhang@marvell.com>, <linux-arm-kernel@lists.infradead.org>,
        <linux-usb@vger.kernel.org>, <devicetree@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 0/9] ARM: Berlin: USB support
Message-ID: <20140609043019.GA32255@shlinux1.ap.freescale.net>
References: <1401983326-19205-1-git-send-email-antoine.tenart@free-electrons.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1401983326-19205-1-git-send-email-antoine.tenart@free-electrons.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:192.88.168.50;CTRY:US;IPV:CAL;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(6009001)(199002)(189002)(51704005)(24454002)(46102001)(104016001)(21056001)(80022001)(74502001)(31966008)(4396001)(6806004)(19580395003)(92726001)(83322001)(44976005)(47776003)(92566001)(83072002)(87936001)(79102001)(84676001)(20776003)(23756003)(83506001)(81342001)(50466002)(68736004)(76482001)(77096999)(81542001)(97736001)(86362001)(26826002)(74662001)(102836001)(77982001)(85852003)(64706001)(33656002)(99396002)(54356999)(76176999)(50986999);DIR:OUT;SFP:;SCL:1;SRVR:BY2PR03MB410;H:tx30smr01.am.freescale.net;FPR:;MLV:ovrnspm;PTR:InfoDomainNonexistent;A:1;MX:1;LANG:en;
X-Microsoft-Antispam: BL:0;ACTION:Default;RISK:Low;SCL:0;SPMLVL:NotSpam;PCL:0;RULEID:
X-Forefront-PRVS: 02379661A3
Authentication-Results: spf=fail (sender IP is 192.88.168.50)
 smtp.mailfrom=Peter.Chen@freescale.com; 
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 05, 2014 at 05:48:37PM +0200, Antoine Ténart wrote:
> This series adds the support for the Marvell Berlin USB controllers,
> the USB PHYs and also adds a reset controller.
> 
> The reset controller is used by the USB PHY driver and shares the
> existing chip controller node with the clocks and one pin controller.
> 
> The Marvell Berlin USB controllers are host only on the BG2Q and are
> compatible with USB ChipIdea. We here add a glue to use the available
> common functions for this kind of controllers. A USB PHY driver is also
> added to control the PHY.
> 
> Antoine Ténart (9):
>   reset: add the Berlin reset controller driver
>   ARM: Berlin: select the reset controller
>   ARM: dts: berlin: add a required reset property in the chip controller
>     node
>   usb: phy: add the Berlin USB PHY driver
>   Documentation: bindings: add doc for the Berlin USB PHY
>   usb: chipidea: add Berlin USB support
>   Documentation: bindings: add doc for the Berlin ChipIdea USB driver
>   ARM: dts: berlin: add BG2Q nodes for USB support
>   ARM: dts: Berlin: enable USB on the BG2Q DMP
> 
>  .../devicetree/bindings/usb/berlin-usbphy.txt      |  18 ++
>  .../devicetree/bindings/usb/ci-hdrc-berlin.txt     |  18 ++
>  arch/arm/boot/dts/berlin2.dtsi                     |   1 +
>  arch/arm/boot/dts/berlin2cd.dtsi                   |   1 +
>  arch/arm/boot/dts/berlin2q-marvell-dmp.dts         |  20 ++
>  arch/arm/boot/dts/berlin2q.dtsi                    |  52 +++++
>  arch/arm/mach-berlin/Kconfig                       |   2 +
>  drivers/reset/Makefile                             |   1 +
>  drivers/reset/reset-berlin.c                       | 113 +++++++++++
>  drivers/usb/chipidea/Makefile                      |   1 +
>  drivers/usb/chipidea/ci_hdrc_berlin.c              | 108 ++++++++++
>  drivers/usb/phy/Kconfig                            |   9 +
>  drivers/usb/phy/Makefile                           |   1 +
>  drivers/usb/phy/phy-berlin-usb.c                   | 223 +++++++++++++++++++++
>  14 files changed, 568 insertions(+)
>  create mode 100644 Documentation/devicetree/bindings/usb/berlin-usbphy.txt
>  create mode 100644 Documentation/devicetree/bindings/usb/ci-hdrc-berlin.txt
>  create mode 100644 drivers/reset/reset-berlin.c
>  create mode 100644 drivers/usb/chipidea/ci_hdrc_berlin.c
>  create mode 100644 drivers/usb/phy/phy-berlin-usb.c
> 
> -- 
> 1.9.1
> 

I am fine with 6/9, 7/9, will queue them if no other objections.

-- 

Best Regards,
Peter Chen
