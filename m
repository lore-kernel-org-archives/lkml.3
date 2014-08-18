Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752168AbaHRKf7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Aug 2014 06:35:59 -0400
Received: from mail-bn1lp0140.outbound.protection.outlook.com ([207.46.163.140]:35025
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750826AbaHRKf5 convert rfc822-to-8bit (ORCPT
	<rfc822;Linux-kernel@vger.kernel.org>);
	Mon, 18 Aug 2014 06:35:57 -0400
From: Peter Chen <Peter.Chen@freescale.com>
To: Shawn Guo <Shawn.Guo@freescale.com>
CC: Philippe Reynes <tremyfr@gmail.com>,
        "Linux-kernel@vger.kernel.org" <Linux-kernel@vger.kernel.org>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "gwenhael.goavec-merou@trabucayre.com" 
	<gwenhael.goavec-merou@trabucayre.com>
Subject: RE: [RFC] usb issue on imx27: 3 clocks are needed
Thread-Topic: [RFC] usb issue on imx27: 3 clocks are needed
Thread-Index: AQHPuWglzmcwvAizxEiTIZwBQMsRnpvWmSSA//+BEICAABAxsA==
Date: Mon, 18 Aug 2014 10:35:53 +0000
Message-ID: <782c806acb464f5781deb32e94548882@BN1PR0301MB0772.namprd03.prod.outlook.com>
References: <53EF7AF6.2000405@gmail.com> <20140818090056.GA29393@peterchendt>
 <20140818092635.GI2114@dragon>
In-Reply-To: <20140818092635.GI2114@dragon>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [123.151.195.50]
x-microsoft-antispam: BCL:0;PCL:0;RULEID:;UriScan:;
x-forefront-prvs: 03077579FF
x-forefront-antispam-report: SFV:NSPM;SFS:(10019005)(6009001)(189002)(51704005)(24454002)(45984002)(53754006)(199003)(99286002)(83322001)(107046002)(81342001)(105586002)(95666004)(99396002)(54356999)(92566001)(76176999)(101416001)(87936001)(79102001)(77982001)(2656002)(81542001)(106116001)(106356001)(83072002)(74502001)(66066001)(4396001)(31966008)(76482001)(46102001)(80022001)(74662001)(64706001)(86362001)(110136001)(76576001)(33646002)(74316001)(21056001)(50986999)(85306004)(20776003)(108616004)(77096002)(24736002);DIR:OUT;SFP:1102;SCL:1;SRVR:DM2PR03MB350;H:BN1PR0301MB0772.namprd03.prod.outlook.com;FPR:;MLV:sfv;PTR:InfoNoRecords;MX:1;A:1;LANG:en;
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

 
> On Mon, Aug 18, 2014 at 05:00:59PM +0800, Peter Chen wrote:
> > On Sat, Aug 16, 2014 at 05:38:30PM +0200, Philippe Reynes wrote:
> > > Hi all,
> > >
> > > i.MX27's usb needs three clocks (usb_ipg_gate, usb_ahb_gate and
> > > usb_div) but the current chipidea driver implementation, and
> > > devicetree, provides only ipg and ahb. Consequently, if the
> > > bootloader don't enable the last one, the kernel will crash.
> > >
> > > Our approach/idea is to add a second, optionnal, clock in
> > > ci_hdrc_imx.c with 'per' name in devicetree  and to add  clock name
> 'main_clk' for mandatory clock.
> > > This approach it correct? Or an other approach seems better?
> > > Thank you very much for your point of view.
> > >
> >
> > It is ok for me to have ipg, ahb and per clocks at driver, but how can
> > you maintain DT consistent?
> 
> Adding new clock as optional one will just maintain the DT compatibility.
> 

How to handle node_usb_soc1's clock which is without clk name to consistent with three
clocks for node_usb_soc2 at driver? Except for adding some platform judge code at
driver, do you have other solutions?

node_usb_soc1: {
	clocks = <&clks IMX6_CLK_USBOH3>;
};

node_usb_soc2: {
	clocks = <&clks IMX27_CLK_USBIPG>, <&clks IMX27_CLK_USBOH3>, <&clks IMX27_CLK_USBPER>;
	clock-names = "ipg", "ahb", "per";
};

Peter
