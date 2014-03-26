Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752163AbaCZHIe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Mar 2014 03:08:34 -0400
Received: from mail-bn1lp0142.outbound.protection.outlook.com ([207.46.163.142]:56647
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751918AbaCZHIb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Mar 2014 03:08:31 -0400
From: Yao Yuan <yao.yuan@freescale.com>
To: Marek Vasut <marex@denx.de>
CC: "wsa@the-dreams.de" <wsa@the-dreams.de>,
        "mark.rutland@arm.com" <mark.rutland@arm.com>,
        "shawn.guo@linaro.org" <shawn.guo@linaro.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-i2c@vger.kernel.org" <linux-i2c@vger.kernel.org>
Subject: RE: [PATCH v3 1/2] i2c: add DMA support for freescale i2c driver
Thread-Topic: [PATCH v3 1/2] i2c: add DMA support for freescale i2c driver
Thread-Index: AQHPPmRgi32QYprDqku8DK7ziduPl5ruGRqAgASY2hCAABwlAIAAJDMggAAJmACAAAme0A==
Date: Wed, 26 Mar 2014 07:08:28 +0000
Message-ID: <8984936f9e914442995d79039543cb58@BL2PR03MB338.namprd03.prod.outlook.com>
References: <1394675277-24913-1-git-send-email-yao.yuan@freescale.com>
 <201403260442.42970.marex@denx.de>
 <cd88de7e04734400b897c0e2bcf07eab@BL2PR03MB338.namprd03.prod.outlook.com>
 <201403260726.36812.marex@denx.de>
In-Reply-To: <201403260726.36812.marex@denx.de>
Accept-Language: zh-CN, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [123.151.195.50]
x-forefront-prvs: 0162ACCC24
x-forefront-antispam-report: SFV:NSPM;SFS:(10009001)(6009001)(428001)(189002)(199002)(24454002)(377454003)(51704005)(31966008)(83322001)(47446002)(74662001)(74502001)(53806001)(85306002)(94316002)(80976001)(95416001)(74316001)(81816001)(95666003)(90146001)(81542001)(93516002)(54316002)(76796001)(76576001)(76786001)(81686001)(74706001)(94946001)(86362001)(74876001)(92566001)(87266001)(63696002)(81342001)(51856001)(65816001)(47736001)(4396001)(59766001)(77982001)(49866001)(69226001)(47976001)(50986001)(80022001)(56776001)(97336001)(83072002)(98676001)(93136001)(79102001)(66066001)(54356001)(74366001)(46102001)(76482001)(56816005)(2656002)(33646001)(87936001)(97186001)(20776003)(85852003)(24736002);DIR:OUT;SFP:1101;SCL:1;SRVR:BL2PR03MB338;H:BL2PR03MB338.namprd03.prod.outlook.com;FPR:BCBB52EE.B402A513.81FBB544.DCD7FE69.20202;MLV:sfv;PTR:InfoNoRecords;MX:1;A:1;LANG:en;
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id s2Q78fIu027640

On Wednesday, March 26, 2014 at 02:27:46 PM, Marek Vasut wrote:
> On Wednesday, March 26, 2014 at 06:56:34 AM, Yao Yuan wrote:
> > On Wednesday, March 26, 2014 at 11:43:27 AM, Marek Vasut wrote:
> > > On Wednesday, March 26, 2014 at 04:08:27 AM, Yao Yuan wrote:
> > >
> > > [...]
> > >
> > > > > > +		i2c_imx->use_dma = false;
> > > > > > +	} else if (i2c_imx_dma_request(i2c_imx,
> > > > > > +(dma_addr_t)phy_addr))
> > >
> > > {
> > >
> > > > > > +		dev_info(&pdev->dev,
> > > > > > +				"can't request dma chan, faild use dma.
> \n");
> > > > > > +		i2c_imx->use_dma = false;
> > > > > > +	} else {
> > > > > > +		i2c_imx->use_dma = true;
> > > > > > +	}
> > > > >
> > > > > Can you not just check if i2c_imx->dma is valid pointer or NULL
> > >
> > > pointer ?
> > >
> > > > > Then you won't need a separate variable, for this purpose ...
> right ?
> > > >
> > > > Sorry and I think what I know is just to check whether it is NULL.
> > > > Then for the second question, maybe there are some other ways, But
> > > > I think it is more tidy and easier understanding for using a
> > > > separate variable, for this purpose.
> > >
> > > You are just wasting space and duplicating data, unless I am wrong.
> >
> > Well, Do you have a better idea? Although I think it's necessary.
> 
> I think we disconnected here, sorry. Why can you not use (i2c_imx->dma !=
> NULL) instead of (i2c_imx->use_dma == true) please ?
> 

But there are two judge conditions. But only the "i2c_imx->dma", but also whether "i2c_imx_dma_request" success.

"i2c_imx->use_dma == true" be equivalent to "i2c_imx->dma != NULL && !i2c_imx_dma_request()" 

ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
