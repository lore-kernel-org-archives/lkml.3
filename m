Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751370AbaGVAUf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jul 2014 20:20:35 -0400
Received: from mail-bn1lp0144.outbound.protection.outlook.com ([207.46.163.144]:14573
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750790AbaGVAUe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jul 2014 20:20:34 -0400
Date: Tue, 22 Jul 2014 08:13:24 +0800
From: Peter Chen <peter.chen@freescale.com>
To: Stefan Agner <stefan@agner.ch>
CC: <s.hauer@pengutronix.de>, <shawn.guo@freescale.com>,
        <b35083@freescale.com>, <linux-arm-kernel@lists.infradead.org>,
        <linux-usb@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 0/6] vf610: Add USB support
Message-ID: <20140722001322.GA6636@shlinux1.ap.freescale.net>
References: <cover.1405702442.git.stefan@agner.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <cover.1405702442.git.stefan@agner.ch>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:192.88.158.2;CTRY:US;IPV:CAL;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(6009001)(24454002)(51704005)(189002)(199002)(104016003)(15202345003)(86362001)(47776003)(92726001)(97736001)(107046002)(74662001)(4396001)(83072002)(69596002)(68736004)(74502001)(92566001)(105606002)(64706001)(102836001)(80022001)(81342001)(33656002)(81156004)(20776003)(46406003)(77982001)(87936001)(79102001)(110136001)(106466001)(84676001)(6806004)(19580405001)(54356999)(19580395003)(83322001)(31966008)(46102001)(85852003)(50466002)(97756001)(95666004)(76482001)(81542001)(21056001)(15975445006)(44976005)(99396002)(76176999)(83506001)(85306003)(50986999)(26826002)(23726002)(55214005);DIR:OUT;SFP:;SCL:1;SRVR:DM2PR03MB351;H:az84smr01.freescale.net;FPR:;MLV:ovrnspm;PTR:InfoDomainNonexistent;MX:1;LANG:en;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:
X-Forefront-PRVS: 02801ACE41
Authentication-Results: spf=fail (sender IP is 192.88.158.2)
 smtp.mailfrom=Peter.Chen@freescale.com; 
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 18, 2014 at 07:01:36PM +0200, Stefan Agner wrote:
> This patchset adds USB support for Vybrid VF610 SoC. It extends the
> clock framework to support the USB PHY cocks, extends the device
> tree files and adds support for the non-core registers in the
> usbmisc_imx driver.
> 
> This patchset needs the eSDHC length fix available in Shawn's
> for-next branch.
> 

Why it is related to USB patchset?

> The whole patchset proved to be working on a Colibri VF61. The
> first USB controller runs in peripheral mode. I could successfully
> use RNDIS, however with some stability issues: Suddenly the other
> side was not reachable anymore and the interface needed to brought
> down and back up again. I'm still investigating this.

Do you use ubuntu as host distribution? I find ubuntu will lost the
first connection for usb-ethernet-gadget(usb0) as network interface,
but once you re-config usb0 again (ifconfig usb0 ip up), it should work
and will not lose connection any more.

> 
> The second USB controller, running in USB host mode, showed no
> issues so far.
> 
> Stefan Agner (6):
>   ARM: dts: vf610: add USB PHY and controller
>   ARM: imx: clk-vf610: add USBPHY clocks
>   ARM: dts: vf610: Add usbmisc for non-core registers
>   chipidea: usbmisc_imx: Add USB support for VF610 SoCs
>   usb: phy: mxs: Add VF610 USB PHY support
>   ARM: dts: vf610-colibri: add USB support
> 
>  arch/arm/boot/dts/vf610-colibri.dts     | 10 +++++
>  arch/arm/boot/dts/vf610.dtsi            | 55 ++++++++++++++++++++++--
>  arch/arm/mach-imx/clk-vf610.c           | 12 +++++-
>  drivers/usb/chipidea/usbmisc_imx.c      | 76 +++++++++++++++++++++++----------
>  drivers/usb/phy/phy-mxs-usb.c           |  5 +++
>  include/dt-bindings/clock/vf610-clock.h |  5 ++-
>  6 files changed, 135 insertions(+), 28 deletions(-)
> 
> -- 
> 2.0.1
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-usb" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

-- 

Best Regards,
Peter Chen
