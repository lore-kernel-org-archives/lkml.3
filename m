Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754060AbaHFD2a (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Aug 2014 23:28:30 -0400
Received: from mail-bn1blp0189.outbound.protection.outlook.com ([207.46.163.189]:5525
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751026AbaHFD22 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Aug 2014 23:28:28 -0400
From: "Li.Xiubo@freescale.com" <Li.Xiubo@freescale.com>
To: Joe Perches <joe@perches.com>
CC: "wsa@the-dreams.de" <wsa@the-dreams.de>,
        "linux-i2c@vger.kernel.org" <linux-i2c@vger.kernel.org>,
        "s.hauer@pengutronix.de" <s.hauer@pengutronix.de>,
        "jg1.han@samsung.com" <jg1.han@samsung.com>,
        "u.kleine-koenig@pengutronix.de" <u.kleine-koenig@pengutronix.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Jingchang Lu <jingchang.lu@freescale.com>
Subject: RE: [PATCH] i2c: i2c-imx: Fix format warning for dev_dbg
Thread-Topic: [PATCH] i2c: i2c-imx: Fix format warning for dev_dbg
Thread-Index: AQHPsSLQ5r3fyNTLqUGYaK3mHkf5AJvC5YeAgAADWDA=
Date: Wed, 6 Aug 2014 03:28:23 +0000
Message-ID: <665de450db8e4edd8c76ce7175106b0d@BY2PR0301MB0613.namprd03.prod.outlook.com>
References: <1407293685-7003-1-git-send-email-Li.Xiubo@freescale.com>
 <1407294597.31231.2.camel@joe-AO725>
In-Reply-To: <1407294597.31231.2.camel@joe-AO725>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [123.151.195.49]
x-microsoft-antispam: BCL:0;PCL:0;RULEID:
x-forefront-prvs: 02951C14DC
x-forefront-antispam-report: SFV:NSPM;SFS:(6009001)(164054003)(199002)(189002)(51704005)(77982001)(76176999)(76482001)(85852003)(83072002)(19580395003)(83322001)(74316001)(54356999)(50986999)(99396002)(80022001)(110136001)(66066001)(2656002)(87936001)(74502001)(74662001)(76576001)(106116001)(31966008)(105586002)(85306004)(4396001)(106356001)(99286002)(95666004)(92566001)(101416001)(77096002)(46102001)(20776003)(64706001)(107046002)(81542001)(79102001)(33646002)(21056001)(86362001)(81342001)(24736002)(108616003);DIR:OUT;SFP:;SCL:1;SRVR:BY2PR03MB473;H:BY2PR0301MB0613.namprd03.prod.outlook.com;FPR:;MLV:sfv;PTR:InfoNoRecords;MX:1;LANG:en;
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > drivers/i2c/busses/i2c-imx.c: In function i2c_imx_probe()
> > drivers/i2c/busses/i2c-imx.c:689:2: warning: format 0x%x expects argument
> > of type unsigned int, but argument 4 has type resource_size_t [-Wformat=]
> >   dev_dbg(&i2c_imx->adapter.dev, "device resources from 0x%x to 0x%x\n",
> []
> > diff --git a/drivers/i2c/busses/i2c-imx.c b/drivers/i2c/busses/i2c-imx.c
> []
> > @@ -687,9 +687,9 @@ static int i2c_imx_probe(struct platform_device *pdev)
> >
> >  	dev_dbg(&i2c_imx->adapter.dev, "claimed irq %d\n", irq);
> >  	dev_dbg(&i2c_imx->adapter.dev, "device resources from 0x%x to 0x%x\n",
> > -		res->start, res->end);
> > +		(unsigned int)res->start, (unsigned int)res->end);
> 
> Probably better to use:
> 
> 	dev_dbg(&i2c_imx->adapter.dev, "device resources: %pR\n, res);
> 

Yes, this is perfect.

> >  	dev_dbg(&i2c_imx->adapter.dev, "allocated %d bytes at 0x%x\n",
> > -		resource_size(res), res->start);
> > +		(unsigned int)resource_size(res), (unsigned int)res->start);
> 
> and remove this.
> 

I will follow your advice.

Thanks,
BRs
Xiubo



