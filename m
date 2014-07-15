Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757588AbaGOFhD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jul 2014 01:37:03 -0400
Received: from mail-bn1lp0144.outbound.protection.outlook.com ([207.46.163.144]:55890
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751087AbaGOFhA convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jul 2014 01:37:00 -0400
From: "Li.Xiubo@freescale.com" <Li.Xiubo@freescale.com>
To: Varka Bhadram <varkabhadram@gmail.com>,
        "broonie@kernel.org" <broonie@kernel.org>,
        "mark.rutland@arm.com" <mark.rutland@arm.com>
CC: "robh+dt@kernel.org" <robh+dt@kernel.org>,
        "pawel.moll@arm.com" <pawel.moll@arm.com>,
        "ijc+devicetree@hellion.org.uk" <ijc+devicetree@hellion.org.uk>,
        "galak@codeaurora.org" <galak@codeaurora.org>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>
Subject: RE: [PATCHv6 2/2] dt/bindings: Add the DT binding documentation for
 endianness
Thread-Topic: [PATCHv6 2/2] dt/bindings: Add the DT binding documentation for
 endianness
Thread-Index: AQHPn+T/m+2KM2DGoEGfjXOtBU3an5ugnM0AgAAAogA=
Date: Tue, 15 Jul 2014 05:36:54 +0000
Message-ID: <54b4550212bb402f957f75bded781e5e@BY2PR0301MB0613.namprd03.prod.outlook.com>
References: <1405398183-31345-1-git-send-email-Li.Xiubo@freescale.com>
 <1405398183-31345-3-git-send-email-Li.Xiubo@freescale.com>
 <53C4BD24.9000503@gmail.com>
In-Reply-To: <53C4BD24.9000503@gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [123.151.195.49]
x-microsoft-antispam: BCL:0;PCL:0;RULEID:
x-forefront-prvs: 027367F73D
x-forefront-antispam-report: SFV:NSPM;SFS:(6009001)(51704005)(189002)(164054003)(199002)(74316001)(101416001)(21056001)(2201001)(99286002)(77982001)(92566001)(74502001)(74662001)(77096002)(64706001)(66066001)(33646002)(2656002)(83322001)(85306003)(107046002)(46102001)(99396002)(76576001)(80022001)(95666004)(54356999)(81542001)(85852003)(79102001)(31966008)(76482001)(4396001)(106356001)(86362001)(19580405001)(76176999)(105586002)(50986999)(106116001)(87936001)(81342001)(20776003)(83072002)(108616002)(24736002);DIR:OUT;SFP:;SCL:1;SRVR:BY2PR0301MB0615;H:BY2PR0301MB0613.namprd03.prod.outlook.com;FPR:;MLV:sfv;PTR:InfoNoRecords;MX:1;LANG:en;
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > +For one device driver, which will run in different scenarios above
> > +on different SoCs using the devicetree, we need one way to simplify
> > +this.
> > +
> > +Required properties:
> > +- {big,little}-endian: these are boolean properties, if absent
> > +  meaning that the CPU and the Device are in the same endianness mode,
> > +  these properties are for register values and all the buffers only.
> > +
> 
> It would be more readable if its like this:
> Required properties:
> - {big,little}-endian:	These are boolean properties, if absent meaning
> 			that the CPU and the Device are in the same
> 			endianness mode, these propperties are for
> 			values and all the buffers only.
> 

Yes, it is.

See the next verison.

Thanks,

BRs
Xiubo



> > +Examples:
> > +Scenario 1 : CPU in LE mode & device in LE mode.
> > +dev: dev@40031000 {
> > +	      compatible = "name";
> > +	      reg = <0x40031000 0x1000>;
> > +	      ...
> > +};
> > +
> > +Scenario 2 : CPU in LE mode & device in BE mode.
> > +dev: dev@40031000 {
> > +	      compatible = "name";
> > +	      reg = <0x40031000 0x1000>;
> > +	      ...
> > +	      big-endian;
> > +};
> > +
> > +Scenario 3 : CPU in BE mode & device in BE mode.
> > +dev: dev@40031000 {
> > +	      compatible = "name";
> > +	      reg = <0x40031000 0x1000>;
> > +	      ...
> > +};
> > +
> > +Scenario 4 : CPU in BE mode & device in LE mode.
> > +dev: dev@40031000 {
> > +	      compatible = "name";
> > +	      reg = <0x40031000 0x1000>;
> > +	      ...
> > +	      little-endian;
> > +};
> 
> 
> --
> Regards,
> Varka Bhadram.

