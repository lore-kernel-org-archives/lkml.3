Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751502AbaHRLtT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Aug 2014 07:49:19 -0400
Received: from mail-bl2lp0205.outbound.protection.outlook.com ([207.46.163.205]:57184
	"EHLO na01-bl2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750710AbaHRLtR (ORCPT <rfc822;Linux-kernel@vger.kernel.org>);
	Mon, 18 Aug 2014 07:49:17 -0400
Date: Mon, 18 Aug 2014 19:48:53 +0800
From: Shawn Guo <shawn.guo@freescale.com>
To: Chen Peter-B29397 <Peter.Chen@freescale.com>
CC: Philippe Reynes <tremyfr@gmail.com>,
        "Linux-kernel@vger.kernel.org" <Linux-kernel@vger.kernel.org>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "gwenhael.goavec-merou@trabucayre.com" 
	<gwenhael.goavec-merou@trabucayre.com>
Subject: Re: [RFC] usb issue on imx27: 3 clocks are needed
Message-ID: <20140818114850.GJ2114@dragon>
References: <53EF7AF6.2000405@gmail.com> <20140818090056.GA29393@peterchendt>
 <20140818092635.GI2114@dragon>
 <782c806acb464f5781deb32e94548882@BN1PR0301MB0772.namprd03.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <782c806acb464f5781deb32e94548882@BN1PR0301MB0772.namprd03.prod.outlook.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:192.88.168.50;CTRY:US;IPV:CAL;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(10019005)(6009001)(199003)(189002)(51704005)(45984002)(53754006)(24454002)(46406003)(81542001)(76482001)(50986999)(81342001)(79102001)(99396002)(83072002)(20776003)(47776003)(64706001)(4396001)(54356999)(76176999)(50466002)(80022001)(86362001)(74502001)(74662001)(31966008)(77982001)(33716001)(92566001)(92726001)(87936001)(85852003)(57986006)(107046002)(106466001)(33656002)(84676001)(6806004)(85306004)(102836001)(46102001)(93886004)(104016003)(110136001)(21056001)(23726002)(44976005)(83322001)(95666004)(68736004)(105606002)(97736001)(26826002)(83506001)(97756001);DIR:OUT;SFP:1102;SCL:1;SRVR:BY2PR0301MB0773;H:tx30smr01.am.freescale.net;FPR:;MLV:ovrnspm;PTR:InfoDomainNonexistent;A:1;MX:1;LANG:en;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;UriScan:;
X-Forefront-PRVS: 03077579FF
Authentication-Results: spf=fail (sender IP is 192.88.168.50)
 smtp.mailfrom=Shawn.Guo@freescale.com; 
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 18, 2014 at 06:35:53PM +0800, Chen Peter-B29397 wrote:
>  
> > On Mon, Aug 18, 2014 at 05:00:59PM +0800, Peter Chen wrote:
> > > On Sat, Aug 16, 2014 at 05:38:30PM +0200, Philippe Reynes wrote:
> > > > Hi all,
> > > >
> > > > i.MX27's usb needs three clocks (usb_ipg_gate, usb_ahb_gate and
> > > > usb_div) but the current chipidea driver implementation, and
> > > > devicetree, provides only ipg and ahb. Consequently, if the
> > > > bootloader don't enable the last one, the kernel will crash.
> > > >
> > > > Our approach/idea is to add a second, optionnal, clock in
> > > > ci_hdrc_imx.c with 'per' name in devicetree  and to add  clock name
> > 'main_clk' for mandatory clock.
> > > > This approach it correct? Or an other approach seems better?
> > > > Thank you very much for your point of view.
> > > >
> > >
> > > It is ok for me to have ipg, ahb and per clocks at driver, but how can
> > > you maintain DT consistent?
> > 
> > Adding new clock as optional one will just maintain the DT compatibility.
> > 
> 
> How to handle node_usb_soc1's clock which is without clk name to consistent with three
> clocks for node_usb_soc2 at driver? Except for adding some platform judge code at
> driver, do you have other solutions?
> 
> node_usb_soc1: {
> 	clocks = <&clks IMX6_CLK_USBOH3>;
> };
> 
> node_usb_soc2: {
> 	clocks = <&clks IMX27_CLK_USBIPG>, <&clks IMX27_CLK_USBOH3>, <&clks IMX27_CLK_USBPER>;
> 	clock-names = "ipg", "ahb", "per";
> };

Oh, what I was talking about is we need to ensure the new kernel
(handling additional clocks) doesn't break old/existing DTB.  That's
what we call DT compatibility.

There is no DT consistency to maintain.  If there is only one clock for
USB on i.MX6 while 3 clocks on i.MX27, that's something USB driver needs
to handle, as clearly these two SoCs have different programming model on
USB device.

Shawn
