Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754187AbaCCKXp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Mar 2014 05:23:45 -0500
Received: from mail-by2lp0236.outbound.protection.outlook.com ([207.46.163.236]:1090
	"EHLO na01-by2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754149AbaCCKXh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Mar 2014 05:23:37 -0500
From: Yao Yuan <yao.yuan@freescale.com>
To: Marek Vasut <marex@denx.de>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
CC: "wsa@the-dreams.de" <wsa@the-dreams.de>,
        "mark.rutland@arm.com" <mark.rutland@arm.com>,
        "shawn.guo@linaro.org" <shawn.guo@linaro.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-i2c@vger.kernel.org" <linux-i2c@vger.kernel.org>
Subject: RE: [PATCH 1/3] i2c: add DMA support for freescale i2c driver
Thread-Topic: [PATCH 1/3] i2c: add DMA support for freescale i2c driver
Thread-Index: AQHPM4sizgrOvCG4PUOY3HGRfTyOT5rJkPaAgAV1QJA=
Date: Mon, 3 Mar 2014 10:23:33 +0000
Message-ID: <3bbad0af0bc74f04bc386b141dadedb3@BL2PR03MB338.namprd03.prod.outlook.com>
References: <1393481115-22136-1-git-send-email-yao.yuan@freescale.com>
 <1393481115-22136-2-git-send-email-yao.yuan@freescale.com>
 <201402272139.36076.marex@denx.de>
In-Reply-To: <201402272139.36076.marex@denx.de>
Accept-Language: zh-CN, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [123.151.195.50]
x-forefront-prvs: 0139052FDB
x-forefront-antispam-report: SFV:NSPM;SFS:(10009001)(6009001)(428001)(24454002)(189002)(199002)(84964002)(377454003)(51704005)(76482001)(54356001)(81816001)(94946001)(53806001)(47446002)(74502001)(51856001)(83322001)(31966008)(94316002)(74706001)(33646001)(79102001)(74662001)(2656002)(81342001)(85306002)(81542001)(87266001)(69226001)(80976001)(74316001)(54316002)(56776001)(74366001)(95416001)(87936001)(81686001)(77982001)(59766001)(76796001)(76786001)(80022001)(4396001)(66066001)(83072002)(76576001)(90146001)(65816001)(93136001)(56816005)(95666003)(92566001)(74876001)(86362001)(93516002)(46102001)(47736001)(47976001)(50986001)(49866001)(63696002)(24736002);DIR:OUT;SFP:1101;SCL:1;SRVR:BL2PR03MB404;H:BL2PR03MB338.namprd03.prod.outlook.com;CLIP:123.151.195.50;FPR:4CF7D70E.C325C05.A1EFADBB.84E9D13C.201CC;MLV:sfv;PTR:InfoNoRecords;MX:1;A:1;LANG:en;
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id s23AO1T6027525

Hi, Marek

Marek Vasut wrote:
> On Thursday, February 27, 2014 at 07:05:14 AM, Yuan Yao wrote:
> 
> [...]
> 
> > +static void i2c_imx_dma_free(struct imx_i2c_struct *i2c_imx) {
> > +	struct imx_i2c_dma *dma = i2c_imx->dma;
> > +	struct dma_chan *dma_chan;
> > +
> > +	dma_chan = dma->chan_tx;
> > +	dma->chan_tx = NULL;
> > +	dma->buf_tx = 0;
> > +	dma->len_tx = 0;
> > +	dma_release_channel(dma_chan);
> > +
> > +	dma_chan = dma->chan_rx;
> > +	dma->chan_tx = NULL;
> > +	dma->buf_rx = 0;
> > +	dma->len_rx = 0;
> > +	dma_release_channel(dma_chan);
> 
> You must make _DEAD_ _SURE_ this function is not ever called while the
> DMA is still active. In your case, I have a feeling that's not handled.
>

Thanks for your attention.
This few days I look up the code for the realization of dma_release_channel(). 
I found that it will disable the dma request first. So it's may safe. 
And drivers hadn't check whether dma is still active before dma_release_channel() as a usually usage.
Because it will be disabled automatic.

The only problem is that, it will be forced to cancel the transfer which was not yet completed.
Looking forward to hearing from you.

Best regards,
Yuan Yao
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
