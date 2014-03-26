Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753967AbaCZF4l (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Mar 2014 01:56:41 -0400
Received: from mail-bn1blp0181.outbound.protection.outlook.com ([207.46.163.181]:34387
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753343AbaCZF4i (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Mar 2014 01:56:38 -0400
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
Thread-Index: AQHPPmRgi32QYprDqku8DK7ziduPl5ruGRqAgASY2hCAABwlAIAAJDMg
Date: Wed, 26 Mar 2014 05:56:34 +0000
Message-ID: <cd88de7e04734400b897c0e2bcf07eab@BL2PR03MB338.namprd03.prod.outlook.com>
References: <1394675277-24913-1-git-send-email-yao.yuan@freescale.com>
 <201403230449.51515.marex@denx.de>
 <1e17ce716618472f9a0146c48f20b976@BL2PR03MB338.namprd03.prod.outlook.com>
 <201403260442.42970.marex@denx.de>
In-Reply-To: <201403260442.42970.marex@denx.de>
Accept-Language: zh-CN, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [123.151.195.50]
x-forefront-prvs: 0162ACCC24
x-forefront-antispam-report: SFV:NSPM;SFS:(10009001)(6009001)(428001)(24454002)(377454003)(189002)(199002)(51704005)(2656002)(98676001)(81816001)(85852003)(93136001)(87266001)(90146001)(53806001)(95416001)(54316002)(94316002)(93516002)(56776001)(97336001)(76482001)(87936001)(80976001)(92566001)(54356001)(47736001)(47976001)(95666003)(47446002)(74502001)(59766001)(51856001)(4396001)(97186001)(94946001)(63696002)(20776003)(80022001)(65816001)(76576001)(81342001)(74876001)(69226001)(46102001)(74662001)(83072002)(86362001)(66066001)(79102001)(77982001)(49866001)(81542001)(33646001)(74366001)(81686001)(85306002)(83322001)(74706001)(74316001)(31966008)(50986001)(24736002);DIR:OUT;SFP:1101;SCL:1;SRVR:BL2PR03MB337;H:BL2PR03MB338.namprd03.prod.outlook.com;FPR:BEBB52EE.B4229513.89FBB544.DCD4FE69.201AE;MLV:sfv;PTR:InfoNoRecords;MX:1;A:1;LANG:en;
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id s2Q5unYf027444

On Wednesday, March 26, 2014 at 11:43:27 AM, Marek Vasut wrote:
> On Wednesday, March 26, 2014 at 04:08:27 AM, Yao Yuan wrote:
> 
> [...]
> 
> > > > +		i2c_imx->use_dma = false;
> > > > +	} else if (i2c_imx_dma_request(i2c_imx, (dma_addr_t)phy_addr))
> {
> > > > +		dev_info(&pdev->dev,
> > > > +				"can't request dma chan, faild use dma.\n");
> > > > +		i2c_imx->use_dma = false;
> > > > +	} else {
> > > > +		i2c_imx->use_dma = true;
> > > > +	}
> > >
> > > Can you not just check if i2c_imx->dma is valid pointer or NULL
> pointer ?
> > > Then you won't need a separate variable, for this purpose ... right ?
> >
> > Sorry and I think what I know is just to check whether it is NULL.
> > Then for the second question, maybe there are some other ways, But I
> > think it is more tidy and easier understanding for using a separate
> > variable, for this purpose.
> 
> You are just wasting space and duplicating data, unless I am wrong.
> 

Well, Do you have a better idea? Although I think it's necessary.


Best regards,
Yuan Yao
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
