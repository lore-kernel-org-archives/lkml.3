Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751805AbaFDRE4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jun 2014 13:04:56 -0400
Received: from mail-by2lp0237.outbound.protection.outlook.com ([207.46.163.237]:5654
	"EHLO na01-by2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750822AbaFDREz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jun 2014 13:04:55 -0400
From: "Bharat.Bhushan@freescale.com" <Bharat.Bhushan@freescale.com>
To: Scott Wood <scottwood@freescale.com>
CC: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "linuxppc-dev@lists.ozlabs.org" <linuxppc-dev@lists.ozlabs.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [RESEND PATCH] memory: Freescale CoreNet Coherency Fabric error
 reporting driver
Thread-Topic: [RESEND PATCH] memory: Freescale CoreNet Coherency Fabric error
 reporting driver
Thread-Index: AQHPfFZ5AO8lYHxFT069YHO6X2X6YptgmrRggACUZICAAAVDUA==
Date: Wed, 4 Jun 2014 17:04:50 +0000
Message-ID: <35f1762b80694ba4835cd7902a2faa0a@BLUPR03MB566.namprd03.prod.outlook.com>
References: <20140530222743.GA6918@home.buserror.net>
	 <967d9a5e0f7e4d0a8f5e7ec6b8e88ff2@BLUPR03MB566.namprd03.prod.outlook.com>
 <1401900111.6603.325.camel@snotra.buserror.net>
In-Reply-To: <1401900111.6603.325.camel@snotra.buserror.net>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [122.176.128.73]
x-microsoft-antispam: BL:0;ACTION:Default;RISK:Low;SCL:0;SPMLVL:NotSpam;PCL:0;RULEID:
x-forefront-prvs: 0232B30BBC
x-forefront-antispam-report: SFV:NSPM;SFS:(6009001)(428001)(52604005)(377454003)(189002)(199002)(377424004)(51704005)(24454002)(13464003)(74502001)(21056001)(99286001)(99396002)(101416001)(86362001)(92566001)(83072002)(31966008)(77096999)(50986999)(54356999)(76176999)(74662001)(83322001)(19580405001)(575784001)(19580395003)(80022001)(85852003)(2656002)(66066001)(81342001)(33646001)(4396001)(81542001)(74316001)(64706001)(76482001)(77982001)(87936001)(76576001)(46102001)(20776003)(79102001)(24736002);DIR:OUT;SFP:;SCL:1;SRVR:BLUPR03MB391;H:BLUPR03MB566.namprd03.prod.outlook.com;FPR:;MLV:sfv;PTR:InfoNoRecords;MX:1;A:1;LANG:en;
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=Bharat.Bhushan@freescale.com; 
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
X-Microsoft-Antispam: BL:0;ACTION:Default;RISK:Low;SCL:0;SPMLVL:NotSpam;PCL:0;RULEID:
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id s54H514x015963



> -----Original Message-----
> From: Wood Scott-B07421
> Sent: Wednesday, June 04, 2014 10:12 PM
> To: Bhushan Bharat-R65777
> Cc: Greg Kroah-Hartman; linuxppc-dev@lists.ozlabs.org; linux-
> kernel@vger.kernel.org
> Subject: Re: [RESEND PATCH] memory: Freescale CoreNet Coherency Fabric error
> reporting driver
> 
> On Wed, 2014-06-04 at 03:17 -0500, Bhushan Bharat-R65777 wrote:
> > > +struct ccf_err_regs {
> > > +	u32 errdet;		/* 0x00 Error Detect Register */
> > > +	/* 0x04 Error Enable (ccf1)/Disable (ccf2) Register */
> > > +	u32 errdis;
> > > +	/* 0x08 Error Interrupt Enable Register (ccf2 only) */
> > > +	u32 errinten;
> > > +	u32 cecar;		/* 0x0c Error Capture Attribute Register */
> > > +	u32 cecadrh;		/* 0x10 Error Capture Address High */
> >
> > s/cecadrh/cecaddrh/g
> > This way we will be consistent with Reference manual.
> 
> It's "cecadrh" in ccf1 and "cecaddrh" in ccf2.  I suppose I should use the
> latter since "errdet/errdis/errinten" are the ccf2 names.
> 
> > > +	u32 cecadrl;		/* 0x14 Error Capture Address Low */
> >
> > s/cecadrl/cecaddrl/g
> >
> > > +	u32 cecar2;		/* 0x18 Error Capture Attribute Register 2 */
> > > +};
> > > +
> > > +/* LAE/CV also valid for errdis and errinten */
> > > +#define ERRDET_LAE		(1 << 0)  /* Local Access Error */
> > > +#define ERRDET_CV		(1 << 1)  /* Coherency Violation */
> > > +#define ERRDET_CTYPE_SHIFT	26	  /* Capture Type (ccf2 only) */
> > > +#define ERRDET_CTYPE_MASK	(0x3f << ERRDET_CTYPE_SHIFT)
> >
> > Should not this be (0x1f << ERRDET_CTYPE_SHIFT)
> 
> Yes, thanks for catching that.
> 
> > > +#define ERRDET_CAP		(1 << 31) /* Capture Valid (ccf2 only) */
> > > +
> > > +#define CECAR_VAL		(1 << 0)  /* Valid (ccf1 only) */
> > > +#define CECAR_UVT		(1 << 15) /* Unavailable target ID (ccf1) */
> > > +#define CECAR_SRCID_SHIFT_CCF1	24
> > > +#define CECAR_SRCID_MASK_CCF1	(0xff << CECAR_SRCID_SHIFT_CCF1)
> > > +#define CECAR_SRCID_SHIFT_CCF2	18
> > > +#define CECAR_SRCID_MASK_CCF2	(0xff << CECAR_SRCID_SHIFT_CCF2)
> > > +
> > > +#define CECADRH_ADDRH		0xf
> >
> > On ccf2 this id 0xff.
> 
> OK.  I think we can get away with using 0xff on both.
> 
> > > +static int ccf_remove(struct platform_device *pdev) {
> > > +	struct ccf_private *ccf = dev_get_drvdata(&pdev->dev);
> > > +
> > > +	switch (ccf->info->version) {
> > > +	case CCF1:
> > > +		iowrite32be(0, &ccf->err_regs->errdis);
> > > +		break;
> > > +
> > > +	case CCF2:
> > > +		iowrite32be(0, &ccf->err_regs->errinten);
> >
> > Do you think it is same to disable detection bits in ccf->err_regs->errdis?
> 
> Disabling the interrupt is what we're aiming for here, but ccf1 doesn't provide
> a way to do that separate from disabling detection.

What I wanted to say that do we also need to disable detection (set ERRDET_LAE | ERRDET_CV bits in errdis) apart from clearing errinten on ccf2 ?

Thanks
-Bharat

> 
> -Scott
> 

ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
