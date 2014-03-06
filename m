Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752048AbaCFNzb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Mar 2014 08:55:31 -0500
Received: from mail-bl2lp0203.outbound.protection.outlook.com ([207.46.163.203]:20702
	"EHLO na01-bl2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751055AbaCFNz3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Mar 2014 08:55:29 -0500
From: Yao Yuan <yao.yuan@freescale.com>
To: Marek Vasut <marex@denx.de>
CC: "wsa@the-dreams.de" <wsa@the-dreams.de>,
        "mark.rutland@arm.com" <mark.rutland@arm.com>,
        "shawn.guo@linaro.org" <shawn.guo@linaro.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-i2c@vger.kernel.org" <linux-i2c@vger.kernel.org>
Subject: =?big5?B?tarOYDogW1BBVENIIHYyIDEvMl0gaTJjOiBhZGQgRE1BIHN1cHBvcnQgZm9yIGZy?=
 =?big5?Q?eescale_i2c_driver?=
Thread-Topic: [PATCH v2 1/2] i2c: add DMA support for freescale i2c driver
Thread-Index: AQHPOEj6II9jTAb8MUaErre9ZA32b5rTWhmAgAALnECAABZdgIAAALzwgAB5LgCAAB4vQg==
Date: Thu, 6 Mar 2014 13:55:09 +0000
Message-ID: <cee5c8cc0e7543ee89ee7dbb7cd94a3d@BL2PR03MB338.namprd03.prod.outlook.com>
References: <1394002352-8380-1-git-send-email-yao.yuan@freescale.com>
 <201403060541.21665.marex@denx.de>
 <50e0997786a0459eb08c9d92813253f9@BL2PR03MB338.namprd03.prod.outlook.com>,<201403061257.42755.marex@denx.de>
In-Reply-To: <201403061257.42755.marex@denx.de>
Accept-Language: zh-CN, en-US
Content-Language: zh-CN
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [125.39.108.73]
x-forefront-prvs: 0142F22657
x-forefront-antispam-report: SFV:NSPM;SFS:(10009001)(6009001)(428001)(377454003)(24454002)(189002)(199002)(51704005)(69226001)(79102001)(54356001)(74366001)(87936001)(53806001)(224303002)(92566001)(95416001)(2656002)(51856001)(33646001)(76482001)(90146001)(83072002)(56816005)(74876001)(85852003)(97336001)(77982001)(81542001)(59766001)(95666003)(63696002)(46102001)(81342001)(76576001)(76796001)(93136001)(83322001)(80976001)(4396001)(19580395003)(19580405001)(74502001)(74662001)(31966008)(81816001)(66066001)(87266001)(81686001)(50986001)(93516002)(47976001)(76786001)(47446002)(94946001)(80022001)(85306002)(20776003)(97186001)(47736001)(56776001)(86362001)(54316002)(74706001)(94316002)(74316001)(49866001)(65816001)(24736002);DIR:OUT;SFP:1101;SCL:1;SRVR:BL2PR03MB337;H:BL2PR03MB338.namprd03.prod.outlook.com;FPR:FABEDCEE.FD90A571.B7CDBBCC.73E2A0B2.20130;MLV:sfv;PTR:InfoNoRecords;MX:1;A:1;LANG:en;
Content-Type: text/plain; charset="big5"
MIME-Version: 1.0
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id s26Dtd6U025892

On Thursday, March 06, 2014 at 09:46:03 PM, Marek Vasut wrote:
>On Thursday, March 06, 2014 at 06:02:03 AM, Yao Yuan wrote:
> > On Thu, March 06, 2014 at 12:44:14 PM, Marek Vasut wrote:
> > > On Thursday, March 06, 2014 at 05:36:14 AM, Yao Yuan wrote:
> > > > On Thu, March 06, 2014 at 11:23:50 AM, Marek Vasut wrote:
> > > > > On Wednesday, March 05, 2014 at 07:52:31 AM, Yuan Yao wrote:
> > > > > > Add dma support for i2c. This function depend on DMA driver.
> > > > > > You can turn on it by write both the dmas and dma-name properties
> > > > > > in dts node.
> > > > > >
> > > > > > Signed-off-by: Yuan Yao <yao.yuan@freescale.com>
> > > > > > ---
> > > > >
> > > > > [...]
> > > > >
> > > > > > @@ -601,6 +826,7 @@ static int i2c_imx_probe(struct
> > > > > > platform_device
> > > > >
> > > > > *pdev)
> > > > >
> > > > > >       void __iomem *base;
> > > > > >       int irq, ret;
> > > > > >       u32 bitrate;
> > > > > >
> > > > > >+     u32 phy_addr;
> > > > > >
> > > > > >       dev_dbg(&pdev->dev, "<%s>\n", __func__);
> > > > > >
> > > > > > @@ -611,6 +837,7 @@ static int i2c_imx_probe(struct
> > > > > > platform_device
> > > > >
> > > > > *pdev)
> > > > >
> > > > > >       }
> > > > > >
> > > > > >       res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
> > > > > >
> > > > > > +     phy_addr = res->start;
> > > > >
> > > > > Uh ... Shawn, I really think I am lost here. Don't you need to map
> > > > > this memory before you can use it for DMA ? The DMA mapping function
> > > > > should give you the physical address and is the right way to go
> > > > > about this instead of pulling the address from here, no ?
> > > > >
> > > > > I might be wrong here, I am rather uncertain, so please help me out.
> > > > > Thanks!
> > > >
> > > > Hi, Marek, Thanks for your suggestion.
> > > > Here you can review the code in include/linux/ioport.h The
> > > > resource->start describes the entity on the CPU bus as a starting
> > > > physical address. So I thinks it can used for dma directly.
> > >
> > > This doesn't feel right for some reason. If this is a register area, you
> > > should
> > > ioremap() it. If it's a memory area you do DMA to/from, you need to make
> > > sure you correctly flush/invalidate caches and properly handle the
> > > effects the write buffer might have. But I have a feeling you actually do
> > > DMA to/from register space here ?
> >
> > Yes, It's a register area. But I don't know why I should ioremap() it? It's
> > a bus address and DMA can use it directly. Is there some problem for my
> > understanding ?
>
> I am not too sure here, thus I am poking someone who can clearly answer this.

OK, and thank you for pointing out many ugly code in my patch. It's very useful for me. ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
