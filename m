Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751166AbaJAGgE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Oct 2014 02:36:04 -0400
Received: from mail-by2on0101.outbound.protection.outlook.com ([207.46.100.101]:63009
	"EHLO na01-by2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750868AbaJAGgD convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Oct 2014 02:36:03 -0400
From: Peter Chen <Peter.Chen@freescale.com>
To: Arnd Bergmann <arnd@arndb.de>
CC: "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Antoine Tenart <antoine.tenart@free-electrons.com>,
        "thomas.petazzoni@free-electrons.com" 
	<thomas.petazzoni@free-electrons.com>,
        "zmxu@marvell.com" <zmxu@marvell.com>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "balbi@ti.com" <balbi@ti.com>,
        "alexandre.belloni@free-electrons.com" 
	<alexandre.belloni@free-electrons.com>,
        "p.zabel@pengutronix.de" <p.zabel@pengutronix.de>,
        "jszhang@marvell.com" <jszhang@marvell.com>,
        "sebastian.hesselbarth@gmail.com" <sebastian.hesselbarth@gmail.com>
Subject: RE: [PATCH v6 07/12] usb: chipidea: add a usb2 driver for ci13xxx
Thread-Topic: [PATCH v6 07/12] usb: chipidea: add a usb2 driver for ci13xxx
Thread-Index: AQHP1xkurfkrdRvKVEqm7ahNs/szPpwZXj8AgAAfLwCAALGngP//i84AgAEaS8A=
Date: Wed, 1 Oct 2014 06:35:58 +0000
Message-ID: <abb0c775ec2549e3abb0a2218b4eef98@BN1PR0301MB0772.namprd03.prod.outlook.com>
References: <1411468088-5702-1-git-send-email-antoine.tenart@free-electrons.com>
 <3366285.QN2R3CQNzG@wuerfel> <20140930123933.GA25395@peterchendt>
 <10249326.XCThPmSrfL@wuerfel>
In-Reply-To: <10249326.XCThPmSrfL@wuerfel>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-exchange-transport-fromentityheader: Hosted
x-originating-ip: [192.88.158.211]
x-microsoft-antispam: BCL:0;PCL:0;RULEID:;SRVR:BN1PR0301MB0772;
x-forefront-prvs: 0351D213B3
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(6009001)(51704005)(164054003)(24454002)(199003)(189002)(99396003)(64706001)(80022003)(92566001)(33646002)(77096002)(10300001)(120916001)(107046002)(46102003)(86362001)(66066001)(108616004)(20776003)(110136001)(99286002)(105586002)(31966008)(95666004)(76482002)(50986999)(76176999)(106356001)(106116001)(76576001)(87936001)(85306004)(21056001)(101416001)(74316001)(54356999)(4396001)(85852003)(93886004)(2656002)(97736003)(24736002);DIR:OUT;SFP:1102;SCL:1;SRVR:BN1PR0301MB0772;H:BN1PR0301MB0772.namprd03.prod.outlook.com;FPR:;MLV:sfv;PTR:InfoNoRecords;A:1;MX:1;LANG:en;
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

 
> Subject: Re: [PATCH v6 07/12] usb: chipidea: add a usb2 driver for ci13xxx
> 
> On Tuesday 30 September 2014 20:39:34 Peter Chen wrote:
> > Thanks, Arnd. I had not thought setting dma mask is so complicated,
> > yes, it should check the return value, two things to confirm:
> >
> > - dma_coerce_mask_and_coherent or dma_set_mask_and_coherent, the
> only
> > difference of these two API is the first one do "dev->dma_mask = &dev-
> >coherent_dma_mask;"
> > The reason you suggest choosing dma_set_mask_and_coherent is you do
> > not want assign dev->dma_mask?
> 
> No, that is just the current definition on ARM32 with
> CONFIG_ARCH_MULTIPLATFORM, and that is going to change soon to be DT
> aware.
> dma_set_mask_and_coherent() is supposed to check whether the platform
> can support the respective mask and return an error if it cannot.
> 
> > - The second parameter for dma_set_mask_and_coherent is
> > DMA_BIT_MASK(32), is it ok?
> >
> > I just a little confused of what's the operation is "hardcoding the dma mask"?
> 
> dma_coerce_mask_and_coherent() will hardcode the dma mask and override
> whatever the platform says is necessary.
> 

So, we should use dma_set_mask_and_coherent() in most of cases in device driver,
and use dma_coerce_mask_and_coherent() only  when the device's dma_mask is wrong?

Peter

