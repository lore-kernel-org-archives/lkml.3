Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754839AbaHFFJ0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Aug 2014 01:09:26 -0400
Received: from mail-bn1lp0141.outbound.protection.outlook.com ([207.46.163.141]:48900
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751045AbaHFFJZ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Aug 2014 01:09:25 -0400
From: "Li.Xiubo@freescale.com" <Li.Xiubo@freescale.com>
To: Jingoo Han <jg1.han@samsung.com>
CC: "wsa@the-dreams.de" <wsa@the-dreams.de>,
        "linux-i2c@vger.kernel.org" <linux-i2c@vger.kernel.org>,
        "joe@perches.com" <joe@perches.com>,
        "s.hauer@pengutronix.de" <s.hauer@pengutronix.de>,
        "u.kleine-koenig@pengutronix.de" <u.kleine-koenig@pengutronix.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Jingchang Lu <jingchang.lu@freescale.com>
Subject: RE: [PATCHv2] i2c: i2c-imx: Fix format warning for dev_dbg
Thread-Topic: [PATCHv2] i2c: i2c-imx: Fix format warning for dev_dbg
Thread-Index: AQHPsSljjrdhCP6toEecZvfdtz8r+5vC+hmAgAAK28A=
Date: Wed, 6 Aug 2014 05:09:21 +0000
Message-ID: <f4d5bd3b919241a1abcd80419b3b1b51@BY2PR0301MB0613.namprd03.prod.outlook.com>
References: <1407296708-12563-1-git-send-email-Li.Xiubo@freescale.com>
 <002801cfb12e$36620840$a32618c0$%han@samsung.com>
In-Reply-To: <002801cfb12e$36620840$a32618c0$%han@samsung.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [123.151.195.49]
x-microsoft-antispam: BCL:0;PCL:0;RULEID:
x-forefront-prvs: 02951C14DC
x-forefront-antispam-report: SFV:NSPM;SFS:(6009001)(199002)(189002)(24454002)(13464003)(377454003)(51704005)(77096002)(2656002)(87936001)(106116001)(46102001)(105586002)(106356001)(66066001)(74502001)(85306004)(81542001)(81342001)(74662001)(31966008)(95666004)(110136001)(77982001)(33646002)(64706001)(80022001)(20776003)(4396001)(76576001)(76482001)(101416001)(76176999)(92566001)(50986999)(86362001)(19580405001)(99286002)(74316001)(79102001)(19580395003)(21056001)(107046002)(83322001)(85852003)(83072002)(54356999)(99396002)(24736002)(108616003);DIR:OUT;SFP:;SCL:1;SRVR:BLUPR03MB471;H:BY2PR0301MB0613.namprd03.prod.outlook.com;FPR:;MLV:sfv;PTR:InfoNoRecords;MX:1;LANG:en;
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jingoo,

Thanks for your advice.

This patch is mainly resolving the warning issue. And some
thing like : 'i2c: i2c-imx: Fix format warning for dev_db'
Could be more obvious.

I think adding 'printf extension %pR for struct resource'
to the commit comment will better.

BRs
Xiubo
 



> -----Original Message-----
> From: Jingoo Han [mailto:jg1.han@samsung.com]
> Sent: Wednesday, August 06, 2014 12:24 PM
> To: Xiubo Li-B47053
> Cc: wsa@the-dreams.de; linux-i2c@vger.kernel.org; joe@perches.com;
> s.hauer@pengutronix.de; u.kleine-koenig@pengutronix.de; linux-
> kernel@vger.kernel.org; Lu Jingchang-B35083; 'Jingoo Han'
> Subject: Re: [PATCHv2] i2c: i2c-imx: Fix format warning for dev_dbg
> 
> On Wednesday, August 06, 2014 12:45 PM, Xiubo Li wrote:
> 
> The subject of the commit looks too general.
> How about the following?
> 
> i2c: i2c-imx: Use printf extension %pR for struct resource
> 
> Best regards,
> Jingoo Han
> 
> >
> > drivers/i2c/busses/i2c-imx.c: In function i2c_imx_probe()
> > drivers/i2c/busses/i2c-imx.c:689:2: warning: format 0x%x expects argument
> > of type unsigned int, but argument 4 has type resource_size_t [-Wformat=]
> >   dev_dbg(&i2c_imx->adapter.dev, "device resources from 0x%x to 0x%x\n",
> >   ^
> > drivers/i2c/busses/i2c-imx.c:689:2: warning: format 0x%x expects argument
> > of type unsigned int, but argument 5 has type resource_size_t [-Wformat=]
> >
> > drivers/i2c/busses/i2c-imx.c:691:2: warning: format %d expects argument
> > of type int, but argument 4 has type resource_size_t [-Wformat=]
> >   dev_dbg(&i2c_imx->adapter.dev, "allocated %d bytes at 0x%x\n",
> >   ^
> > drivers/i2c/busses/i2c-imx.c:691:2: warning: format 0x%x expects argument
> > of type unsigned int, but argument 5 has type resource_size_t [-Wformat=]
> >
> > Signed-off-by: Xiubo Li <Li.Xiubo@freescale.com>
> > ---
> >
> > Change in v2:
> > - Follow Joe Perches's advice.
> >
> >
> >
> >
> >
> >  drivers/i2c/busses/i2c-imx.c | 5 +----
> >  1 file changed, 1 insertion(+), 4 deletions(-)
> >
> > diff --git a/drivers/i2c/busses/i2c-imx.c b/drivers/i2c/busses/i2c-imx.c
> > index 1d7efa3..b8a9543 100644
> > --- a/drivers/i2c/busses/i2c-imx.c
> > +++ b/drivers/i2c/busses/i2c-imx.c
> > @@ -686,10 +686,7 @@ static int i2c_imx_probe(struct platform_device *pdev)
> >  	clk_disable_unprepare(i2c_imx->clk);
> >
> >  	dev_dbg(&i2c_imx->adapter.dev, "claimed irq %d\n", irq);
> > -	dev_dbg(&i2c_imx->adapter.dev, "device resources from 0x%x to 0x%x\n",
> > -		res->start, res->end);
> > -	dev_dbg(&i2c_imx->adapter.dev, "allocated %d bytes at 0x%x\n",
> > -		resource_size(res), res->start);
> > +	dev_dbg(&i2c_imx->adapter.dev, "device resources: %pR\n", res);
> >  	dev_dbg(&i2c_imx->adapter.dev, "adapter name: \"%s\"\n",
> >  		i2c_imx->adapter.name);
> >  	dev_info(&i2c_imx->adapter.dev, "IMX I2C adapter registered\n");
> > --
> > 1.8.5

