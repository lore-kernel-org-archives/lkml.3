Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751931AbaB1LgJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Feb 2014 06:36:09 -0500
Received: from mail-bn1blp0183.outbound.protection.outlook.com ([207.46.163.183]:13232
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751688AbaB1LgH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Feb 2014 06:36:07 -0500
From: Yao Yuan <yao.yuan@freescale.com>
To: Marek Vasut <marex@denx.de>
CC: "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "wsa@the-dreams.de" <wsa@the-dreams.de>,
        "mark.rutland@arm.com" <mark.rutland@arm.com>,
        "shawn.guo@linaro.org" <shawn.guo@linaro.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-i2c@vger.kernel.org" <linux-i2c@vger.kernel.org>
Subject: RE: [PATCH 1/3] i2c: add DMA support for freescale i2c driver
Thread-Topic: [PATCH 1/3] i2c: add DMA support for freescale i2c driver
Thread-Index: AQHPM4sizgrOvCG4PUOY3HGRfTyOT5rJkPaAgABWrGCAAHldAIAAHVug
Date: Fri, 28 Feb 2014 11:36:01 +0000
Message-ID: <3d65fc9a0c5444b485c93de4087634e0@BL2PR03MB338.namprd03.prod.outlook.com>
References: <1393481115-22136-1-git-send-email-yao.yuan@freescale.com>
 <201402272139.36076.marex@denx.de>
 <3f58a8abdda74100b4f7b14d0c31c90e@BL2PR03MB338.namprd03.prod.outlook.com>
 <201402281004.10238.marex@denx.de>
In-Reply-To: <201402281004.10238.marex@denx.de>
Accept-Language: zh-CN, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [123.151.195.50]
x-forefront-prvs: 0136C1DDA4
x-forefront-antispam-report: SFV:NSPM;SFS:(10009001)(979002)(6009001)(428001)(24454002)(189002)(377454003)(199002)(51704005)(49866001)(47736001)(50986001)(85852003)(83072002)(80976001)(83322001)(81686001)(46102001)(56816005)(76482001)(92566001)(94946001)(95416001)(56776001)(90146001)(47976001)(87936001)(87266001)(74502001)(2656002)(81816001)(74662001)(54316002)(95666003)(54356001)(53806001)(47446002)(77982001)(4396001)(31966008)(65816001)(94316002)(76576001)(79102001)(74876001)(74706001)(76796001)(69226001)(81542001)(81342001)(74316001)(74366001)(33646001)(59766001)(76786001)(85306002)(93136001)(93516002)(86362001)(80022001)(66066001)(63696002)(51856001)(24736002)(969003)(989001)(999001)(1009001)(1019001);DIR:OUT;SFP:1101;SCL:1;SRVR:BL2PR03MB417;H:BL2PR03MB338.namprd03.prod.outlook.com;CLIP:123.151.195.50;FPR:F81AFB25.2FE0610F.B2D1A9D4.84C6DEBF.20274;MLV:ovrnspm;PTR:InfoNoRecords;MX:1;A:1;LANG:en;
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id s1SBaIu5014633

Hi Marek,
> On Friday, February 28, 2014 at 06:19:18 AM, Yao Yuan wrote:
> 
> [...]
> 
> > > > @@ -213,6 +238,7 @@ static struct imx_i2c_hwdata vf610_i2c_hwdata
> > > > = {
> > > >
> > > >  	.ndivs			= ARRAY_SIZE(vf610_i2c_clk_div),
> > > >  	.i2sr_clr_opcode	= I2SR_CLR_OPCODE_W1C,
> > > >  	.i2cr_ien_opcode	= I2CR_IEN_OPCODE_0,
> > > >
> > > > +	.has_dma_support	= true,
> > >
> > > So why exactly don't we have a DT prop for determining whether the
> > > controller has DMA support ?
> > >
> > > What about the other controllers, do they not support DMA for some
> > > specific reason? Please elaborate on that, thank you !
> >
> > Sorry for my fault. I will modify it.
> 
> I would prefer if you could explain why other controllers do have DMA
> disabled even if the hardware does support the DMA operation.
> 

Well, Because of the I2C in I.MX hardware don't support the DMA operation. 
But here I also think has_dma_support isn't necessary.

> > > Also, can the DMA not do full-duplex operation ? What I see here is
> > > just
> > > half- duplex operations , one for RX and the other one for TX .
> >
> > Yes, here have two dma channels, one for RX and the other one for TX.
> > When we request the channel we should determine it for TX or RX.
> 
> Sorry, I don't quite understand this. If you have two DMA channels, can
> you not use them both to do full-duplex SPI transfer ?
> 

Sorry, There are also hard for me. I don't understand what is full-duplex for dma? 
A DMA engine can only read or write at the same time. And a dma channel request for only DMA_MEM_TO_DEV or DMA_DEV_TO_MEM almost.
Also i2c is a half-duplex bus.
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
