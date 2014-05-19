Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752188AbaESXvs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 May 2014 19:51:48 -0400
Received: from mail-bl2lp0212.outbound.protection.outlook.com ([207.46.163.212]:56453
	"EHLO na01-bl2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751074AbaESXvr convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 May 2014 19:51:47 -0400
From: "Li.Xiubo@freescale.com" <Li.Xiubo@freescale.com>
To: Mark Brown <broonie@kernel.org>
CC: "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH] regmap: irq: Fix possible ZERO_SIZE_PTR pointer
 dereferencing error.
Thread-Topic: [PATCH] regmap: irq: Fix possible ZERO_SIZE_PTR pointer
 dereferencing error.
Thread-Index: AQHPczh2O7W9mxz9mEKdCDMbGttfZ5tIFL8AgAB+ptA=
Date: Mon, 19 May 2014 23:51:26 +0000
Message-ID: <a9148f4a1b3e4bab928365e455edf1cc@BY2PR03MB505.namprd03.prod.outlook.com>
References: <1400483625-29312-1-git-send-email-Li.Xiubo@freescale.com>
 <20140519161548.GZ12304@sirena.org.uk>
In-Reply-To: <20140519161548.GZ12304@sirena.org.uk>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [123.151.195.49]
x-forefront-prvs: 021670B4D2
x-forefront-antispam-report: SFV:NSPM;SFS:(6009001)(428001)(24454002)(51704005)(199002)(189002)(164054003)(79102001)(81542001)(83072002)(85852003)(81342001)(46102001)(66066001)(74502001)(80022001)(31966008)(74662001)(64706001)(20776003)(77982001)(4396001)(83322001)(33646001)(99396002)(86362001)(99286001)(92566001)(21056001)(76576001)(76482001)(74316001)(77096999)(54356999)(101416001)(76176999)(50986999)(2656002)(87936001)(24736002);DIR:OUT;SFP:;SCL:1;SRVR:BY2PR03MB506;H:BY2PR03MB505.namprd03.prod.outlook.com;FPR:;MLV:sfv;PTR:InfoNoRecords;A:1;MX:1;LANG:en;
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=Li.Xiubo@freescale.com; 
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Subject: Re: [PATCH] regmap: irq: Fix possible ZERO_SIZE_PTR pointer
> dereferencing error.
> 
> On Mon, May 19, 2014 at 03:13:45PM +0800, Xiubo Li wrote:
> > Since we cannot make sure the 'chip->num_regs' will always be none zero
> > from the users, and then if 'chip->num_regs' equals to zero by mistake
> > or other reasons, the kzalloc() will return ZERO_SIZE_PTR, which equals
> > to ((void *)16).
> >
> > So this patch fix this with just checking the 'chip->num_regs' before
> > calling kzalloc().
> 
> Where is the actual dereference that's being protected against here?
> 

Such as:
        d->mask_buf = kzalloc(sizeof(unsigned int) * chip->num_regs,
                              GFP_KERNEL);
        if (!d->mask_buf)
                goto err_alloc;

And then:
        d->mask_buf[irq_data->reg_offset / map->reg_stride] |= irq_data->mask;



> > This also sorts the header files in alphabetical order at the same time.
> 
> No, don't do things like this.  It just makes things harder to review.

Okay, I'll follow your advice.

Thanks,

BRs
Xiubo

