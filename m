Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753918AbaDDPpe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Apr 2014 11:45:34 -0400
Received: from mail-bl2lp0206.outbound.protection.outlook.com ([207.46.163.206]:35008
	"EHLO na01-bl2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753809AbaDDPpb convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Apr 2014 11:45:31 -0400
From: Yao Yuan <yao.yuan@freescale.com>
To: Marek Vasut <marex@denx.de>
CC: "wsa@the-dreams.de" <wsa@the-dreams.de>,
        "mark.rutland@arm.com" <mark.rutland@arm.com>,
        "shawn.guo@linaro.org" <shawn.guo@linaro.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-i2c@vger.kernel.org" <linux-i2c@vger.kernel.org>
Subject: Re: [PATCH v4 1/2] i2c: add DMA support for freescale i2c driver
Thread-Topic: [PATCH v4 1/2] i2c: add DMA support for freescale i2c driver
Thread-Index: AQHPT7WKIG/+iHMwf0iZO9vAQDtI9JsBhP+AgAAE3p4=
Date: Fri, 4 Apr 2014 15:45:15 +0000
Message-ID: <aab78696ac364d9c832993c08915bad3@BL2PR03MB338.namprd03.prod.outlook.com>
References: <1396579272-19542-1-git-send-email-yao.yuan@freescale.com>
 <1396579272-19542-2-git-send-email-yao.yuan@freescale.com>,<201404041628.55471.marex@denx.de>
In-Reply-To: <201404041628.55471.marex@denx.de>
Accept-Language: zh-CN, en-US
Content-Language: zh-CN
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [111.204.254.46]
x-forefront-prvs: 01713B2841
x-forefront-antispam-report: SFV:NSPM;SFS:(10009001)(6009001)(428001)(199002)(189002)(377454003)(51704005)(24454002)(86362001)(92566001)(2656002)(83072002)(56816005)(69226001)(51856001)(97186001)(47446002)(79102001)(97336001)(4396001)(85852003)(54356001)(94946001)(94316002)(99396002)(50986001)(31966008)(87936001)(87266001)(53806001)(93516002)(49866001)(74662001)(47736001)(47976001)(80976001)(74502001)(56776001)(90146001)(95666003)(74706001)(93136001)(99286001)(76482001)(46102001)(19580405001)(20776003)(66066001)(83322001)(81542001)(33646001)(63696002)(98676001)(54316002)(81816001)(76576001)(76796001)(81686001)(19580395003)(81342001)(74876001)(59766001)(85306002)(80022001)(65816001)(74366001)(76786001)(95416001)(77982001)(74316001)(24736002);DIR:OUT;SFP:1101;SCL:1;SRVR:BL2PR03MB340;H:BL2PR03MB338.namprd03.prod.outlook.com;FPR:7C37FDD9.125509.B2E7B5EB.46ECD072.20246;MLV:sfv;PTR:InfoNoRecords;A:1;MX:1;LANG:en;
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday, April 04, 2014 at 22:29:32 PM, Marek Vasut wrote:
> On Friday, April 04, 2014 at 04:41:11 AM, Yuan Yao wrote:
> > Add dma support for i2c. This function depend on DMA driver.
> > You can turn on it by write both the dmas and dma-name properties in dts
> > node.
> >
> > Signed-off-by: Yuan Yao <yao.yuan@freescale.com>

[...]

> Since you will be fixing that superfluous return 0; (I actually wonder, did you
> really test the driver at all before submitting it?) ...

I'm sorry for the leftover. It's a serious bug. The support by DMA will be disabled always.
Thanks for your consideration. But subjective assume may not suitable. Testing is a essential link . 
But the bug can't be found by normal test . The testing may not be  imperfect, it's my 
serious fault, but please don't doubt my work attitude.
The ugly is my work or even the ability but not the attitude, I think.

At last, Thank you for giving me a lot of help, it's very important for me.

> > +static int i2c_imx_dma_xfer(struct imx_i2c_struct *i2c_imx,
> > +                                     struct i2c_msg *msgs)
> > +{
> > +     struct imx_i2c_dma *dma = i2c_imx->dma;
> > +     struct dma_async_tx_descriptor *txdesc;
> > +     struct device *dev = &i2c_imx->adapter.dev;
> +
> +     dma->dma_buf = dma_map_single(dma->chan_using->device->dev, msgs->buf,
[...]

>  Reviewed-by: Marek Vasut <marex@denx.de>

