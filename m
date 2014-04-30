Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932303AbaD3FJE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Apr 2014 01:09:04 -0400
Received: from mail-bl2lp0208.outbound.protection.outlook.com ([207.46.163.208]:49469
	"EHLO na01-bl2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750965AbaD3FJC convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Apr 2014 01:09:02 -0400
From: "Li.Xiubo@freescale.com" <Li.Xiubo@freescale.com>
To: Mark Rutland <mark.rutland@arm.com>
CC: "broonie@kernel.org" <broonie@kernel.org>,
        "rob@landley.net" <rob@landley.net>,
        "robh+dt@kernel.org" <robh+dt@kernel.org>,
        Pawel Moll <Pawel.Moll@arm.com>,
        "ijc+devicetree@hellion.org.uk" <ijc+devicetree@hellion.org.uk>,
        "galak@codeaurora.org" <galak@codeaurora.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCHv2 1/3] dt/bindings: Add the DT binding documentation for
 endianness
Thread-Topic: [PATCHv2 1/3] dt/bindings: Add the DT binding documentation
 for endianness
Thread-Index: AQHPXsXw941G9fcOpUWOzogqfmIRtJse4A8AgArGTqA=
Date: Wed, 30 Apr 2014 05:08:46 +0000
Message-ID: <aa1caab3c07448319b9e095399b99fd3@BY2PR03MB505.namprd03.prod.outlook.com>
References: <1398235595-13370-1-git-send-email-Li.Xiubo@freescale.com>
 <1398235595-13370-2-git-send-email-Li.Xiubo@freescale.com>
 <20140423083412.GA30036@e106331-lin.cambridge.arm.com>
In-Reply-To: <20140423083412.GA30036@e106331-lin.cambridge.arm.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [123.151.195.49]
x-forefront-prvs: 0197AFBD92
x-forefront-antispam-report: SFV:NSPM;SFS:(10009001)(6009001)(428001)(199002)(189002)(51704005)(164054003)(80022001)(74662001)(76482001)(83322001)(66066001)(92566001)(76576001)(20776003)(4396001)(81542001)(85852003)(19580395003)(81342001)(2656002)(74502001)(31966008)(80976001)(86362001)(54356999)(99396002)(19580405001)(77982001)(46102001)(87936001)(50986999)(99286001)(79102001)(101416001)(74316001)(76176999)(77096999)(33646001)(83072002)(24736002);DIR:OUT;SFP:1101;SCL:1;SRVR:BY2PR03MB507;H:BY2PR03MB505.namprd03.prod.outlook.com;FPR:DCD8F4FF.A0D21425.40F19932.8AE8C201.202E0;MLV:sfv;PTR:InfoNoRecords;A:1;MX:1;LANG:en;
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> > diff --git a/Documentation/devicetree/bindings/endianness/endianness.txt
> b/Documentation/devicetree/bindings/endianness/endianness.txt
> > new file mode 100644
> > index 0000000..64f1d5e
> > --- /dev/null
> > +++ b/Documentation/devicetree/bindings/endianness/endianness.txt
> > @@ -0,0 +1,55 @@
> > +Device-Tree binding for device endianness
> > +
> > +The endianness mode of CPU & Device scenarios:
> > +  Index    CPU      Device
> > +  ------------------------
> > +  1        LE         LE
> > +  2        LE         BE
> > +  3        BE         BE
> > +  4        BE         LE
> > +
> > +For one device driver, which will run in different scenarios above
> > +on different SoCs using the devicetree, we need one way to simplify
> > +this.
> > +
> > +Required properties:
> > +- [prefix]-endian: this is one string property and must be one
> > +  of 'be', 'le' and 'native' if it is present.
> 
> What exactly is the prefix?
> 
> This file name and file heading implies this is a common endianness
> binding, which it is not. There are many existing bindings that have
> mechanisms for describing the endianness of components, and they have
> settled on a different pattern.
> 
> We already have many bindings with {big,little}-endian{,-*} boolean
> properties. It would be better to take that common case and document
> that as the standard way of doing things rather than inventing a
> completely different mechanism.
> 

Well, yes, I'll follow your advice.


> > +The endianness mode:
> > +  'le' : device is in little endian mode,
> > +  'be' : device is in big endian mode,
> > +  'native' : device is in the same endian mode with the CPU.
> 
> What exactly do you mean by native? A device which always matches the
> endianness of the CPU even if it changes? How common is that?
> 

It's originally based the regmap, and the 'native' is make no sense here,
I'll reconstruct this.


> > +
> > +Examples:
> > +Scenario 1 : CPU in LE mode & device in LE mode.
> > +dev: dev@40031000 {
> > +	      compatible = "name";
> > +	      reg = <0x40031000 0x1000>;
> > +	      ...
> > +	      [prefix]-endian = 'native';
> > +};
> 
> If the device is LE, then surely we should describe the device as LE.
> The kernel knows what endianness it is, might choose to change the CPU
> endianness, but regardless can do the right thing. Telling it a device
> is native is useless unless the device changes endianness with the CPU.
> 

Yes, you are right.

> > +
> > +Scenario 2 : CPU in LE mode & device in BE mode.
> > +dev: dev@40031000 {
> > +	      compatible = "name";
> > +	      reg = <0x40031000 0x1000>;
> > +	      ...
> > +	      [prefix]-endian = 'be';
> > +};
> > +
> > +Scenario 3 : CPU in BE mode & device in BE mode.
> > +dev: dev@40031000 {
> > +	      compatible = "name";
> > +	      reg = <0x40031000 0x1000>;
> > +	      ...
> > +	      [prefix]-endian = 'native';
> > +};
> 
> Likewise.
> 
> Thanks,
> Mark.
> 

