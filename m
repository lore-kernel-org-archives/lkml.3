Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752477AbaHSAOv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Aug 2014 20:14:51 -0400
Received: from mail-bl2lp0207.outbound.protection.outlook.com ([207.46.163.207]:19504
	"EHLO na01-bl2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752217AbaHSAOt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Aug 2014 20:14:49 -0400
Date: Tue, 19 Aug 2014 08:14:23 +0800
From: Peter Chen <peter.chen@freescale.com>
To: Stefan Agner <stefan@agner.ch>
CC: <s.hauer@pengutronix.de>, <kernel@pengutronix.de>,
        <shawn.guo@freescale.com>, <balbi@ti.com>,
        <gregkh@linuxfoundation.org>, <jingchang.lu@freescale.com>,
        <linux-arm-kernel@lists.infradead.org>, <linux-usb@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH RESEND v2 0/7] vf610: Add USB support
Message-ID: <20140819001422.GB2928@peterchendt>
References: <cover.1408391385.git.stefan@agner.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <cover.1408391385.git.stefan@agner.ch>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:192.88.168.50;CTRY:US;IPV:CAL;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(10019006)(6009001)(24454002)(189002)(199003)(51704005)(97756001)(97736001)(95666004)(85306004)(105606002)(77982001)(81542001)(44976005)(81342001)(19580395003)(74662001)(106466001)(6806004)(76176999)(76482001)(86362001)(83322001)(83072002)(54356999)(26826002)(87936001)(21056001)(92726001)(4396001)(110136001)(33656002)(68736004)(64706001)(20776003)(92566001)(83506001)(80022001)(46406003)(33716001)(99396002)(23726002)(84676001)(47776003)(104016003)(85852003)(57986006)(50466002)(74502001)(107046002)(31966008)(50986999)(46102001)(79102001)(102836001)(217873001)(55214005);DIR:OUT;SFP:1102;SCL:1;SRVR:DM2PR03MB351;H:tx30smr01.am.freescale.net;FPR:;MLV:ovrnspm;PTR:InfoDomainNonexistent;MX:1;A:1;LANG:en;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;UriScan:;
X-Forefront-PRVS: 0308EE423E
Authentication-Results: spf=fail (sender IP is 192.88.168.50)
 smtp.mailfrom=Peter.Chen@freescale.com; 
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 18, 2014 at 10:07:10PM +0200, Stefan Agner wrote:
> This patchset adds USB support for Vybrid VF610 SoC. It extends the
> clock framework to support the USB PHY cocks, extends the device
> tree files and adds support for the non-core registers in the
> usbmisc_imx driver.
> 
> This patchset needs the eSDHC registers length fix available in
> Shawn's for-next branch, since that overlapped by chance the USB
> areas.
> 
> The whole patchset proved to be working on a Colibri VF61 and
> Freescale Tower VF65GS10. The first USB controller runs in
> peripheral mode. I could successfully use RNDIS, however with some
> stability issues: Suddenly the other side was not reachable anymore
> and the interface needed to brought down and back up again. I'm
> still investigating this.
> 
> The second USB controller, running in USB host mode, showed errors
> when connecting devices behind a USB hub:
> 
> [  215.163507] usb usb1-port1: cannot reset (err = -32)
> [  215.170498] usb usb1-port1: cannot reset (err = -32)
> [  215.185120] usb usb1-port1: cannot reset (err = -32)
> [  215.191345] usb usb1-port1: cannot reset (err = -32)
> [  215.202487] usb usb1-port1: cannot reset (err = -32)
> [  215.207718] usb usb1-port1: Cannot enable. Maybe the USB cable is bad?
> [  215.219317] usb usb1-port1: unable to enumerate USB device
> 
> By extending the PHY driver with the MXS_PHY_NEED_IP_FIX flag, this
> issue is resolved.
> 
> Resend, also added Felipe Balbi this time, sorry about that. I think
> I only miss the Ack/Review from you here and then things should be
> fine.
> 
> Changes in v2:
> - Extended usbmisc_imx to support multiple instances
> - Update DT documentation and compatible strings where necessary
> - Add USB PHY flag MXS_PHY_NEED_IP_FIX
> - Added patches to enable USB on Tower
> 
> Stefan Agner (7):
>   ARM: dts: vf610: Add USB PHY and controller
>   ARM: imx: clk-vf610: Add USBPHY clocks
>   usb: phy: mxs: Add VF610 USB PHY support
>   ARM: dts: vf610: Add usbmisc for non-core registers
>   chipidea: usbmisc_imx: Add USB support for VF610 SoCs

This driver change is already at my tree, but it is too late
for 3.17-rc1 when you sent, so I sent it to greg for v3.18.

Peter

>   ARM: dts: vf610-colibri: Add USB support
>   ARM: dts: vf610-twr: Add USB support
> 
>  Documentation/devicetree/bindings/usb/mxs-phy.txt  |  1 +
>  .../devicetree/bindings/usb/usbmisc-imx.txt        |  1 +
>  arch/arm/boot/dts/vf610-colibri.dts                | 10 ++++
>  arch/arm/boot/dts/vf610-twr.dts                    | 10 ++++
>  arch/arm/boot/dts/vf610.dtsi                       | 60 ++++++++++++++++++++--
>  arch/arm/mach-imx/clk-vf610.c                      | 12 ++++-
>  drivers/usb/chipidea/ci_hdrc_imx.c                 |  8 +++
>  drivers/usb/chipidea/ci_hdrc_imx.h                 |  1 +
>  drivers/usb/chipidea/usbmisc_imx.c                 | 52 +++++++++++++++----
>  drivers/usb/phy/phy-mxs-usb.c                      |  6 +++
>  include/dt-bindings/clock/vf610-clock.h            |  5 +-
>  11 files changed, 149 insertions(+), 17 deletions(-)
> 
> -- 
> 2.0.4
> 

-- 
Best Regards,
Peter Chen
