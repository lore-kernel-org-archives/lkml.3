Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752045AbaESEMk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 May 2014 00:12:40 -0400
Received: from [207.46.163.243] ([207.46.163.243]:59169 "EHLO
	na01-by2-obe.outbound.protection.outlook.com"
	rhost-flags-FAIL-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751083AbaESEME convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 May 2014 00:12:04 -0400
From: "Li.Xiubo@freescale.com" <Li.Xiubo@freescale.com>
To: Mark Rutland <mark.rutland@arm.com>
CC: "broonie@kernel.org" <broonie@kernel.org>,
        "ijc+devicetree@hellion.org.uk" <ijc+devicetree@hellion.org.uk>,
        "galak@codeaurora.org" <galak@codeaurora.org>,
        "rdunlap@infradead.org" <rdunlap@infradead.org>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "robh+dt@kernel.org" <robh+dt@kernel.org>,
        Pawel Moll <Pawel.Moll@arm.com>,
        "linux@arm.linux.org.uk" <linux@arm.linux.org.uk>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: RE: [PATCHv4 2/2] regmap: add DT endianness binding support.
Thread-Topic: [PATCHv4 2/2] regmap: add DT endianness binding support.
Thread-Index: AQHPazF1aeJPW4FGwkyvkgMBoKDuEJs4dkuAgA7f/RA=
Date: Mon, 19 May 2014 04:11:35 +0000
Message-ID: <00adcdedcfdf4c828d5fd5a8dd7e28bd@BY2PR03MB505.namprd03.prod.outlook.com>
References: <1399601073-19278-1-git-send-email-Li.Xiubo@freescale.com>
 <1399601073-19278-3-git-send-email-Li.Xiubo@freescale.com>
 <20140509164719.GE16418@e106331-lin.cambridge.arm.com>
In-Reply-To: <20140509164719.GE16418@e106331-lin.cambridge.arm.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [123.151.195.49]
x-forefront-prvs: 021670B4D2
x-forefront-antispam-report: SFV:NSPM;SFS:(6009001)(428001)(164054003)(189002)(199002)(51704005)(24454002)(99286001)(99396002)(64706001)(80022001)(76176999)(50986999)(81342001)(76576001)(81542001)(83072002)(19580395003)(85852003)(66066001)(83322001)(77096999)(92566001)(79102001)(87936001)(101416001)(21056001)(31966008)(74662001)(54356999)(20776003)(33646001)(77982001)(4396001)(86362001)(2656002)(76482001)(74502001)(74316001)(46102001)(24736002);DIR:OUT;SFP:;SCL:1;SRVR:BY2PR03MB507;H:BY2PR03MB505.namprd03.prod.outlook.com;FPR:;MLV:sfv;PTR:InfoNoRecords;MX:1;A:1;LANG:en;
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=Li.Xiubo@freescale.com; 
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Subject: Re: [PATCHv4 2/2] regmap: add DT endianness binding support.
> 
> On Fri, May 09, 2014 at 03:04:33AM +0100, Xiubo Li wrote:
> > For many drivers which will support rich endianness of CPU<-->Dev
> > need define DT properties by itself without the binding support.
> >
> > The endianness using regmap:
> > Index    CPU       Device     Endianess flag for DT bool property
> > ------------------------------------------------------------
> > 1        LE        LE         -
> > 2        LE        BE         'big-endian-{val,reg}'
> > 3        BE        BE         -
> > 4        BE        LE         'little-endian-{val,reg}'
> 
> Get rid of the CPU column. It has precisely _nothing_ to do with the
> device.
> 
> If you happen to have a device that can be integrated with varying
> endianness, the endianness should be described regardless of whether
> this happens to be the same as the CPU endianness. The kernel can then
> choose to do the right thing regardless.
> 
> Assuming LE or BE by default is sane if most implementations are one
> rather than the other. Probing and figuring it out dynamically is also
> fine. Assuming that it's the same as the kernel is broken in general,
> and should be avoided -- those cases _require_ a *-endian property to
> work if the CPU can function in either endianness.
> 

Yes, If my understanding is correct, if we need inverting the bytes order, 
should be add one property here, regardless of the CPU's endianesses.


> > Please see the following documetation for detail:
> >     Documentation/devicetree/bindings/endianness/endianness.txt
> 
> I don't think this is sufficient. That document describes the preferred
> idiom, not the meaning w.r.t. a specific binding.
> 
> [...]
> 
> > +	case REGMAP_ENDIAN_REG:
> > +		if (of_property_read_bool(np, "big-endian-reg"))
> > +			*endian = REGMAP_ENDIAN_BIG;
> > +		else if (of_property_read_bool(np, "little-endian-reg"))
> > +			*endian = REGMAP_ENDIAN_LITTLE;
> 
> While this follows the guidelines you've added, context is still
> required to understand precisely what this means. We need a binding
> document describing what *-endian-reg means for this binding (i.e. what
> does -reg cover? All registers? some? buffers?).
> 

Yes, for now the 'reg' is for all registers of the device.
And the 'val' is for all the values and buffers of the device.

@Mark Brown,
Do you have any correction here ?


> Imagine I added a little-endian-foo property. You'd be able to reason
> that something is little endian, but you'd have no idea of precisely
> what without reading documentation or code. As not everyone wants to
> read several thousand lines of Linux kernel code to write a dts we
> require documentation.
> 

@Mark Rutland, @Mark Brown,
Yes, where should I locate the documentation ?
Is Documentation/devicetree/bindings/regmap/ okay ?


Thanks,

BRs
Xiubo


> > +	case REGMAP_ENDIAN_VAL:
> > +		if (of_property_read_bool(np, "big-endian-val"))
> > +			*endian = REGMAP_ENDIAN_BIG;
> > +		else if (of_property_read_bool(np, "little-endian-val"))
> > +			*endian = REGMAP_ENDIAN_LITTLE;
> 
> Likewise.
> 
> Cheers,
> Mark.
