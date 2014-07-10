Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751513AbaGJHB2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jul 2014 03:01:28 -0400
Received: from mail-bn1lp0139.outbound.protection.outlook.com ([207.46.163.139]:55237
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750733AbaGJHB0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jul 2014 03:01:26 -0400
Date: Thu, 10 Jul 2014 15:01:04 +0800
From: Shawn Guo <shawn.guo@freescale.com>
To: George Joseph <george.joseph@fairview5.com>
CC: Sascha Hauer <kernel@pengutronix.de>, Rob Herring <robh+dt@kernel.org>,
        Pawel Moll <pawel.moll@arm.com>, Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Russell King <linux@arm.linux.org.uk>,
        <linux-arm-kernel@lists.infradead.org>, <devicetree@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH V2] ARM: dts: Restructure imx6qdl-wandboard.dtsi for new
 rev C1 board.
Message-ID: <20140710070103.GA2542@dragon>
References: <1404845297-13751-1-git-send-email-george.joseph@fairview5.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <1404845297-13751-1-git-send-email-george.joseph@fairview5.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:192.88.158.2;CTRY:US;IPV:CAL;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(6009001)(199002)(189002)(51704005)(24454002)(107046002)(33716001)(4396001)(47776003)(95666004)(99396002)(85852003)(102836001)(46406003)(33656002)(6806004)(64706001)(81156004)(77982001)(76482001)(76176999)(81342001)(80022001)(81542001)(50466002)(105606002)(86362001)(54356999)(44976005)(85306003)(83322001)(68736004)(20776003)(50986999)(19580405001)(23726002)(97736001)(31966008)(74662001)(92566001)(83072002)(57986006)(21056001)(87936001)(19580395003)(46102001)(97756001)(74502001)(106466001)(84676001)(92726001)(83506001)(69596002)(110136001)(26826002)(79102001)(104016003)(32563001);DIR:OUT;SFP:;SCL:1;SRVR:DM2PR03MB333;H:az84smr01.freescale.net;FPR:;MLV:ovrnspm;PTR:InfoDomainNonexistent;MX:1;LANG:en;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:
X-Forefront-PRVS: 0268246AE7
Authentication-Results: spf=fail (sender IP is 192.88.158.2)
 smtp.mailfrom=Shawn.Guo@freescale.com; 
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 08, 2014 at 12:48:16PM -0600, George Joseph wrote:
> The rev C1 Wandboard uses the Broadcom 4330 for WiFi and Bluetooth instead of
> the 4329.  This changes the PADS assigned for the control lines.  Another
> side effect of the change is that on the rev C1 board, usdhc driver can't
> detect the chip presence correctly so usdhc2 now needs its 'non-removeable'
> property removed.
> 
> So that rev B1 and earlier can continue to work, this patch splits the
> board-specific definitions from imx6qdl-wandboard.dtsi into
> imx6qdl-wandboard-revb1.dtsi and imx6qdl-wandboard-revc1.dtsi.  The new files
> include the original base imx6qdl-wandboard.dtsi which retains the common
> definitions.
> 
> The existing imx6dl-wandboard.dts includes imx6qdl-wandboard-revc1.dtsi and
> imx6dl-wandboard-revb1.dts (new) includes imx6qdl-wandboard-revb1.dtsi.
> This makes the rev C1 board the new default.  The same pattern is used for
> imx6q-wandboard.dts.
> 
> So, from U-Boot on a WB-Quad you use imxq-wandboard-revb1.dtb for the older B1
> board and imxq-wandboard.dtb for the current rev C1 board.
> 
> Signed-off-by: George Joseph <george.joseph@fairview5.com>
> ---
>  arch/arm/boot/dts/imx6dl-wandboard-revb1.dts   | 22 ++++++++++++++
>  arch/arm/boot/dts/imx6dl-wandboard.dts         |  2 +-
>  arch/arm/boot/dts/imx6q-wandboard-revb1.dts    | 26 ++++++++++++++++
>  arch/arm/boot/dts/imx6q-wandboard.dts          |  2 +-
>  arch/arm/boot/dts/imx6qdl-wandboard-revb1.dtsi | 42 ++++++++++++++++++++++++++
>  arch/arm/boot/dts/imx6qdl-wandboard-revc1.dtsi | 41 +++++++++++++++++++++++++
>  arch/arm/boot/dts/imx6qdl-wandboard.dtsi       | 21 -------------
>  7 files changed, 133 insertions(+), 23 deletions(-)
>  create mode 100644 arch/arm/boot/dts/imx6dl-wandboard-revb1.dts
>  create mode 100644 arch/arm/boot/dts/imx6q-wandboard-revb1.dts

These two should be added into arch/arm/boot/dts/Makefile as build
target.

I fixed it up and applied the patch.

Shawn
