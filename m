Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753310AbaFCDUE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jun 2014 23:20:04 -0400
Received: from mail-bn1lp0145.outbound.protection.outlook.com ([207.46.163.145]:4520
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753095AbaFCDUB convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jun 2014 23:20:01 -0400
From: "Li.Xiubo@freescale.com" <Li.Xiubo@freescale.com>
To: Guenter Roeck <linux@roeck-us.net>, "wim@iguana.be" <wim@iguana.be>,
        "linux-watchdog@vger.kernel.org" <linux-watchdog@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH] watchdog: imx2_wdt: adds big endianness support.
Thread-Topic: [PATCH] watchdog: imx2_wdt: adds big endianness support.
Thread-Index: AQHPe9PWWurwnEMpYESZpSUKzyB6bptZMVcAgAWMLOA=
Date: Tue, 3 Jun 2014 03:19:58 +0000
Message-ID: <cc49edeb85294b00af2a2e6a88e542fc@BY2PR03MB505.namprd03.prod.outlook.com>
References: <1401430217-29543-1-git-send-email-Li.Xiubo@freescale.com>
 <5388975A.7040109@roeck-us.net>
In-Reply-To: <5388975A.7040109@roeck-us.net>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [123.151.195.49]
x-microsoft-antispam: BL:0;ACTION:Default;RISK:Low;SCL:0;SPMLVL:NotSpam;PCL:0;RULEID:
x-forefront-prvs: 02318D10FB
x-forefront-antispam-report: SFV:NSPM;SFS:(6009001)(428001)(189002)(164054003)(199002)(51704005)(46102001)(83322001)(4396001)(74502001)(81342001)(77982001)(76176999)(92566001)(2656002)(64706001)(87936001)(80022001)(99286001)(19580395003)(50986999)(21056001)(101416001)(79102001)(74662001)(99396002)(83072002)(54356999)(86362001)(74316001)(85852003)(2201001)(77096999)(76576001)(33646001)(66066001)(81542001)(31966008)(20776003)(76482001)(24736002);DIR:OUT;SFP:;SCL:1;SRVR:BY2PR03MB507;H:BY2PR03MB505.namprd03.prod.outlook.com;FPR:;MLV:sfv;PTR:InfoNoRecords;MX:1;A:1;LANG:en;
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=Li.Xiubo@freescale.com; 
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > @@ -201,6 +204,10 @@ static int __init imx2_wdt_probe(struct platform_device
> *pdev)
> >   	if (!wdev)
> >   		return -ENOMEM;
> >
> > +	big_endian = of_property_read_bool(np, "big-endian");
> > +	if (big_endian)
> > +		imx2_wdt_regmap_config.val_format_endian = REGMAP_ENDIAN_BIG;
> > +
> 
> You'll need to document the use of this property in
> Documentation/devicetree/bindings/watchdog/fsl-imx-wdt.txt.
>

Sorry for late.

Please see the next version.

Thanks,

BRs
Xiubo




> Guenter
> 
> >   	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
> >   	base = devm_ioremap_resource(&pdev->dev, res);
> >   	if (IS_ERR(base))
> >

