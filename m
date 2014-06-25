Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754234AbaFYGtA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jun 2014 02:49:00 -0400
Received: from mail-bn1blp0181.outbound.protection.outlook.com ([207.46.163.181]:41789
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752947AbaFYGs5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jun 2014 02:48:57 -0400
Date: Wed, 25 Jun 2014 14:48:43 +0800
From: Shawn Guo <shawn.guo@freescale.com>
To: Lothar =?iso-8859-1?Q?Wa=DFmann?= <LW@KARO-electronics.de>
CC: Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>, Mark Rutland <mark.rutland@arm.com>,
        Pawel Moll <pawel.moll@arm.com>, Rob Herring <robh+dt@kernel.org>,
        Russell King <linux@arm.linux.org.uk>,
        Sascha Hauer <kernel@pengutronix.de>, <devicetree@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] ARM: dts: add support for Ka-Ro TX51
Message-ID: <20140625064841.GA2224@dragon>
References: <1402578584-12640-1-git-send-email-LW@KARO-electronics.de>
 <20140618150152.GP8860@dragon> <20140623121839.679f35ee@ipc1.ka-ro>
MIME-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20140623121839.679f35ee@ipc1.ka-ro>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:192.88.158.2;CTRY:US;IPV:CAL;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(6009001)(51704005)(199002)(189002)(24454002)(86362001)(84676001)(99396002)(33656002)(46102001)(74662001)(81342001)(74502001)(31966008)(50986999)(76176999)(77982001)(26826002)(81542001)(54356999)(83506001)(76482001)(87936001)(20776003)(81156004)(64706001)(23756003)(47776003)(21056001)(15975445006)(85306003)(106466001)(4396001)(79102001)(104016002)(50466002)(95666004)(97736001)(105606002)(68736004)(44976005)(69596002)(57986006)(33716001)(83322001)(15202345003)(19580395003)(19580405001)(92726001)(102836001)(6806004)(92566001)(85852003)(83072002)(107046001)(80022001);DIR:OUT;SFP:;SCL:1;SRVR:BY2PR03MB090;H:az84smr01.freescale.net;FPR:;MLV:ovrnspm;PTR:InfoDomainNonexistent;A:1;MX:1;LANG:en;
X-Microsoft-Antispam: BL:0;ACTION:Default;RISK:Low;SCL:0;SPMLVL:NotSpam;PCL:0;RULEID:
X-Forefront-PRVS: 02530BD3AA
Authentication-Results: spf=fail (sender IP is 192.88.158.2)
 smtp.mailfrom=Shawn.Guo@freescale.com; 
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 23, 2014 at 12:18:39PM +0200, Lothar Waßmann wrote:
...
> > > +	phy-handle = <&phy0>;
> > > +	mac-address = [000000000000]; /* will be set by U-Boot */
> > 
> > Shouldn't it be local-mac-address?
> > 
> probably yes, but both 'mac-address' and 'local-mac-address' are being
> set up by U-Boot anyway.

Okay, never mind.  I just realized kernel supports both properties.

...

> > > +&esdhc1 {
> > > +	cd-gpios = <&gpio3 8 GPIO_ACTIVE_LOW>;
> > > +	fsl,wp-controller;
> > 
> > Does it work for you, since the driver does not support it as of today?
> > 
> What driver doesn't support what?
> AFAICT the sdhci-esdhc-imx.c driver supports both of these properties.

That was the case before, but it's not the case since commit
89d7e5c13122 (mmc: sdhci-esdhc-imx: add runtime pm support).

http://thread.gmane.org/gmane.linux.kernel.mmc/27287

...

> > > +	spidev0: spi@0 {
> > > +		compatible = "spidev";
> > > +		reg = <0>;
> > > +		spi-max-frequency = <54000000>;
> > > +	};
> > > +
> > > +	spidev1: spi@1 {
> > > +		compatible = "spidev";
> > > +		reg = <1>;
> > > +		spi-max-frequency = <54000000>;
> > > +	};
> > 
> > I'm not sure we should have these two devices.
> > 
> Why not? With this the SPI bus can readily be used with the spidev
> driver from Documentation/spi/spidev_test.c (which is what most of our
> customers are asking for)!

Is this something that has been approved by DT maintainers?  I do not
see "spidev" documented as a compatible in any bindings doc.

Shawn
