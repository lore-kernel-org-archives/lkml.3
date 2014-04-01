Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751393AbaDACYS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Mar 2014 22:24:18 -0400
Received: from mail-bn1lp0141.outbound.protection.outlook.com ([207.46.163.141]:53559
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750777AbaDACYR convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Mar 2014 22:24:17 -0400
From: "Li.Xiubo@freescale.com" <Li.Xiubo@freescale.com>
To: Guenter Roeck <linux@roeck-us.net>, "wim@iguana.be" <wim@iguana.be>,
        "w.sang@pengutronix.de" <w.sang@pengutronix.de>,
        "linux-watchdog@vger.kernel.org" <linux-watchdog@vger.kernel.org>,
        "broonie@linaro.org" <broonie@linaro.org>,
        "broonie@kernel.org" <broonie@kernel.org>,
        "swarren@nvidia.com" <swarren@nvidia.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCHv2 2/2] watchdog: imx2_wdt: Add big-endian support
Thread-Topic: [PATCHv2 2/2] watchdog: imx2_wdt: Add big-endian support
Thread-Index: AQHPSKDVcbPU6SPqA024POxEUieEfpr6ko0AgAAGE3CAAW5SgIAAAFPg
Date: Tue, 1 Apr 2014 02:24:12 +0000
Message-ID: <1c79a81bbd7b4cc79689cb907e81e893@BY2PR03MB505.namprd03.prod.outlook.com>
References: <1395800500-22655-1-git-send-email-Li.Xiubo@freescale.com>
 <1395800500-22655-3-git-send-email-Li.Xiubo@freescale.com>
 <5338E1E8.4030700@roeck-us.net>
 <28375308b05f4cf4bc7d1559f2524c1b@BY2PR03MB505.namprd03.prod.outlook.com>
 <533A1A4B.2090503@roeck-us.net>
In-Reply-To: <533A1A4B.2090503@roeck-us.net>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [123.151.195.49]
x-forefront-prvs: 016885DD9B
x-forefront-antispam-report: SFV:NSPM;SFS:(10009001)(6009001)(428001)(189002)(199002)(51704005)(479174003)(164054003)(90146001)(81816001)(15975445006)(66066001)(85306002)(2656002)(80976001)(87266001)(74502001)(80022001)(47446002)(79102001)(65816001)(56816005)(20776003)(63696002)(83072002)(85852003)(74662001)(87936001)(31966008)(97186001)(74366001)(81686001)(95416001)(99396001)(94946001)(99286001)(74316001)(95666003)(86362001)(94316002)(93516002)(77982001)(59766001)(92566001)(2201001)(15202345003)(93136001)(51856001)(81542001)(74876001)(69226001)(49866001)(50986001)(47736001)(47976001)(81342001)(33646001)(56776001)(54356001)(98676001)(53806001)(46102001)(4396001)(19300405004)(76576001)(19580395003)(54316002)(76482001)(83322001)(76786001)(24736002)(562404015);DIR:OUT;SFP:1101;SCL:1;SRVR:BY2PR03MB506;H:BY2PR03MB505.namprd03.prod.outlook.com;FPR:8EF6F58D.2BC13D11.7D59342.44E8F27D.2022B;MLV:sfv;PTR:InfoNoRecords;MX:1;A:1;LANG:en;
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > It's actually the following ones first, which will support 16-bits
> > Values for regmap-mmio:
> >
> > https://patchwork.kernel.org/patch/3896321/
> > https://patchwork.kernel.org/patch/3896331/
> > https://patchwork.kernel.org/patch/3901021/
> >
> > And the then the following one, which will support the LE endian:
> > http://www.spinics.net/lists/kernel/msg1714375.html
> >
> So what is the plan for this patch ? Seems to me it would make more sense
> to convert the driver to regmap.
> 

@Guenter, @Mark,

Yes, I do think so too and there has already regmap-mmio version patch
Series about the IMX2 Watchdog driver, but those regmap patches for
supporting the 16-bit values are in Mark's tree and the IMX2 Watchdog
will depend on them.

How to deal with this situation ?


The regmap patches depended by IMX2 Watchdog:

1, https://patchwork.kernel.org/patch/3896321/   ===> <applied>
   regmap: mmio: add regmap_mmio_{regsize, count}_check. 
   https://patchwork.kernel.org/patch/3896331/   ===> <applied>
   regmap: mmio: Add support for 1/2/8 bytes wide register address.
   https://patchwork.kernel.org/patch/3901021/   ===> <applied>
   regmap: mmio: Add regmap_mmio_regbits_check.


2, The above three and this one are a must.
   https://patchwork.kernel.org/patch/3912671/   ===> <pending>
   regmap: mmio: Fix the bug of 'offset' value parsing.


3, The following ones are not a must, but will make the IMX2
   Watchdog much simplifier.
   https://patchwork.kernel.org/patch/3912401/   ===> <pending>
   regmap: implement LE formatting/parsing for 16/32-bit values.
   https://patchwork.kernel.org/patch/3912751/   ===> <pending>
   regmap: add DT endianness binding support.
   https://patchwork.kernel.org/patch/3912741/   ===> <pending>
   regmap: Add the DT binding documentation for endianness


The above all have been test using SAI(32-bit regmap-mmio), 
SGTL5000(codec 16-bit regmap-i2c) and IMX2 Watchdog(16-bit
regmap-mmio).


I'll send the regmap-mmio based patch series for IMX2 Watchdog.


Thanks,

Best Regards,
Xiubo
