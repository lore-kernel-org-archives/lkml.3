Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755177AbaHFC0S (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Aug 2014 22:26:18 -0400
Received: from mail-by2lp0240.outbound.protection.outlook.com ([207.46.163.240]:48567
	"EHLO na01-by2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751981AbaHFC0R convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Aug 2014 22:26:17 -0400
From: Yao Yuan <yao.yuan@freescale.com>
To: Varka Bhadram <varkabhadram@gmail.com>,
        "wsa@the-dreams.de" <wsa@the-dreams.de>,
        "marex@denx.de" <marex@denx.de>
CC: "LW@KARO-electronics.de" <LW@KARO-electronics.de>,
        "mark.rutland@arm.com" <mark.rutland@arm.com>,
        "shawn.guo@linaro.org" <shawn.guo@linaro.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-i2c@vger.kernel.org" <linux-i2c@vger.kernel.org>
Subject: RE: [PATCH v6 1/2] i2c: imx: add DMA support for freescale i2c driver
Thread-Topic: [PATCH v6 1/2] i2c: imx: add DMA support for freescale i2c
 driver
Thread-Index: AQHPsJpytXwYr0w2ukaT/Ol6wOf2kpvB5TEAgADvL5A=
Date: Wed, 6 Aug 2014 02:26:07 +0000
Message-ID: <30487e0abf4b4564af296d17f5cebf49@BL2PR03MB338.namprd03.prod.outlook.com>
References: <1407232563-10856-1-git-send-email-yao.yuan@freescale.com>
 <1407232563-10856-2-git-send-email-yao.yuan@freescale.com>
 <53E0C498.6070608@gmail.com>
In-Reply-To: <53E0C498.6070608@gmail.com>
Accept-Language: en-US, zh-CN
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [123.151.195.50]
x-microsoft-antispam: BCL:0;PCL:0;RULEID:;UriScan:;UriScan:;
x-forefront-prvs: 02951C14DC
x-forefront-antispam-report: SFV:NSPM;SFS:(6009001)(24454002)(189002)(199002)(377454003)(479174003)(51704005)(46102001)(76576001)(2656002)(4396001)(87936001)(83072002)(106356001)(106116001)(21056001)(105586002)(2201001)(74316001)(79102001)(77982001)(85306004)(101416001)(85852003)(81542001)(92566001)(80022001)(76482001)(81342001)(86362001)(19580395003)(74502001)(64706001)(50986999)(83322001)(66066001)(33646002)(31966008)(76176999)(20776003)(95666004)(74662001)(99286002)(99396002)(107046002)(54356999)(24736002)(108616003);DIR:OUT;SFP:;SCL:1;SRVR:BL2PR03MB337;H:BL2PR03MB338.namprd03.prod.outlook.com;FPR:;MLV:sfv;PTR:InfoNoRecords;MX:1;LANG:en;
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thanks for your review.

Varka Bhadram wrote:
> On 08/05/2014 03:26 PM, Yuan Yao wrote:
> 
> (...)
> > +fail_rx:
> > +	dma_release_channel(dma->chan_rx);
> > +fail_tx:
> > +	dma_release_channel(dma->chan_tx);
> > +fail_al:
> > +	devm_kfree(dev, dma);
> 
> no need to use devm_kfree() if we use devm_kzalloc()...
> 
We have discussed it before.
As Lothar Waßmann said:
"The devm_kfree() is not in the failure path of the driver's probe() function, but in the function that tries to initialize the optional DMA support."
So It seems need to use devm_kfree().
Do you have some other opinions?

> > +	dev_info(dev, "can't use DMA\n");
> > +
> > +	return ret;
> > +}

(...)

> > +static int i2c_imx_dma_write(struct imx_i2c_struct *i2c_imx,
> > +					struct i2c_msg *msgs)
> 
> static int i2c_imx_dma_write(struct imx_i2c_struct *i2c_imx,
> 			     struct i2c_msg *msgs)
> 
> run checkpatch.pl on this patch...

Sorry for my code style. I will match open parenthesis in this case.

I had run this script before, just one warning.


> --
> Regards,
> Varka Bhadram.

