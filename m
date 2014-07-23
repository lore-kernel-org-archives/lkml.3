Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756241AbaGWLL6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jul 2014 07:11:58 -0400
Received: from mail-by2lp0244.outbound.protection.outlook.com ([207.46.163.244]:19600
	"EHLO na01-by2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751145AbaGWLL4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jul 2014 07:11:56 -0400
From: Yao Yuan <yao.yuan@freescale.com>
To: =?utf-8?B?TG90aGFyIFdhw59tYW5u?= <LW@KARO-electronics.de>
CC: "wsa@the-dreams.de" <wsa@the-dreams.de>, "marex@denx.de" <marex@denx.de>,
        "mark.rutland@arm.com" <mark.rutland@arm.com>,
        "shawn.guo@linaro.org" <shawn.guo@linaro.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-i2c@vger.kernel.org" <linux-i2c@vger.kernel.org>
Subject: RE: [PATCH v5 1/2] i2c: add DMA support for freescale i2c driver
Thread-Topic: [PATCH v5 1/2] i2c: add DMA support for freescale i2c driver
Thread-Index: AQHPplZGZJt1rYr+30mdcMiYBrLa6JutadwAgAAUuKA=
Date: Wed, 23 Jul 2014 11:11:53 +0000
Message-ID: <b1778af62e7b42b39381fb2699b34eb1@BL2PR03MB338.namprd03.prod.outlook.com>
References: <1406103883-3572-1-git-send-email-yao.yuan@freescale.com>
	<1406103883-3572-2-git-send-email-yao.yuan@freescale.com>
 <20140723114834.411f6bb4@ipc1.ka-ro>
In-Reply-To: <20140723114834.411f6bb4@ipc1.ka-ro>
Accept-Language: en-US, zh-CN
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [123.151.195.50]
x-microsoft-antispam: BCL:0;PCL:0;RULEID:
x-forefront-prvs: 028166BF91
x-forefront-antispam-report: SFV:NSPM;SFS:(6009001)(51704005)(199002)(24454002)(189002)(76176999)(46102001)(86362001)(19580405001)(74662001)(64706001)(80022001)(21056001)(106116001)(76482001)(85306003)(79102001)(2656002)(101416001)(4396001)(105586002)(77982001)(95666004)(85852003)(81542001)(20776003)(66066001)(99396002)(87936001)(92566001)(110136001)(83322001)(50986999)(54356999)(107046002)(81342001)(76576001)(99286002)(74316001)(106356001)(19580395003)(31966008)(33646002)(74502001)(83072002)(108616002)(24736002);DIR:OUT;SFP:;SCL:1;SRVR:BL2PR03MB340;H:BL2PR03MB338.namprd03.prod.outlook.com;FPR:;MLV:sfv;PTR:InfoNoRecords;MX:1;LANG:en;
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id s6NBC2ai015372

Hi,

Thanks for your review.

Lothar WaÃŸmann wrote:
> Yuan Yao wrote:
> > Add dma support for i2c. This function depend on DMA driver.
> > You can turn on it by write both the dmas and dma-name properties in dts node.
> >
> > Signed-off-by: Yuan Yao <yao.yuan@freescale.com>
> > ---
> >  drivers/i2c/busses/i2c-imx.c | 377
[...]
> > +
> > +fail_rx:
> > +	dma_release_channel(dma->chan_rx);
> > +fail_tx:
> > +	dma_release_channel(dma->chan_tx);
> > +fail_al:
> > +	devm_kfree(dev, dma);
> >
> No need for this one (that's the whole point of using devm_kzalloc())!
> 

When DMA request failed, I2C will switch to PIO mode. So if the failed reason is just like DMA channel request failed. At this time the DMA should free by devm_kfree(). Is it?

[...]
Thanks.
Yuan Yao
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
