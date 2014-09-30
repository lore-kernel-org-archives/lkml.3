Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751874AbaI3Mju (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Sep 2014 08:39:50 -0400
Received: from mail-bl2on0118.outbound.protection.outlook.com ([65.55.169.118]:32736
	"EHLO na01-bl2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751044AbaI3Mjs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Sep 2014 08:39:48 -0400
Date: Tue, 30 Sep 2014 20:39:34 +0800
From: Peter Chen <peter.chen@freescale.com>
To: Arnd Bergmann <arnd@arndb.de>
CC: <linux-arm-kernel@lists.infradead.org>,
        Antoine Tenart <antoine.tenart@free-electrons.com>,
        <thomas.petazzoni@free-electrons.com>, <zmxu@marvell.com>,
        <devicetree@vger.kernel.org>, <linux-usb@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <balbi@ti.com>,
        <alexandre.belloni@free-electrons.com>, <p.zabel@pengutronix.de>,
        <jszhang@marvell.com>, <sebastian.hesselbarth@gmail.com>
Subject: Re: [PATCH v6 07/12] usb: chipidea: add a usb2 driver for ci13xxx
Message-ID: <20140930123933.GA25395@peterchendt>
References: <1411468088-5702-1-git-send-email-antoine.tenart@free-electrons.com>
 <1411468088-5702-8-git-send-email-antoine.tenart@free-electrons.com>
 <20140930001206.GA11657@peterchendt> <3366285.QN2R3CQNzG@wuerfel>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <3366285.QN2R3CQNzG@wuerfel>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:192.88.158.2;CTRY:US;IPV:CAL;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(10019020)(6009001)(199003)(51704005)(189002)(164054003)(24454002)(92566001)(85852003)(110136001)(57986006)(44976005)(87936001)(86362001)(102836001)(92726001)(4396001)(6806004)(76482002)(26826002)(84676001)(46406003)(104016003)(47776003)(97756001)(50466002)(23726002)(68736004)(76176999)(50986999)(107046002)(54356999)(81156004)(80022003)(106466001)(31966008)(85306004)(99396003)(105606002)(10300001)(83506001)(69596002)(33656002)(20776003)(64706001)(21056001)(97736003)(33716001)(120916001)(46102003)(95666004)(93886004);DIR:OUT;SFP:1102;SCL:1;SRVR:BY2PR0301MB0631;H:az84smr01.freescale.net;FPR:;MLV:ovrnspm;PTR:InfoDomainNonexistent;A:1;MX:1;LANG:en;
X-Microsoft-Antispam: UriScan:;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;SRVR:BY2PR0301MB0631;
X-Forefront-PRVS: 0350D7A55D
Authentication-Results: spf=fail (sender IP is 192.88.158.2)
 smtp.mailfrom=Peter.Chen@freescale.com; 
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 30, 2014 at 12:03:42PM +0200, Arnd Bergmann wrote:
> On Tuesday 30 September 2014 08:12:07 Peter Chen wrote:
> > > +
> > > +     if (dev->of_node) {
> > > +             ret = ci_hdrc_usb2_dt_probe(dev, ci_pdata);
> > > +             if (ret)
> > > +                     goto clk_err;
> > > +     } else {
> > > +             ret = dma_set_mask_and_coherent(&pdev->dev, DMA_BIT_MASK(32));
> > > +             if (ret)
> > > +                     goto clk_err;
> > > +     }
> > 
> > My suggestion:
> > 
> > - call dma_coerce_mask_and_coherent(&dev->dev, DMA_BIT_MASK(32)) for both 
> > dt and non-dt
> 
> No, as I explained before, hardcoding the dma mask is always wrong, don't
> do that. Call dma_set_mask_and_coherent and check the return value.
> It's not wrong to do that for both DT and ATAGS.
> 

Thanks, Arnd. I had not thought setting dma mask is so complicated, yes, it
should check the return value, two things to confirm:

- dma_coerce_mask_and_coherent or dma_set_mask_and_coherent, the only difference
of these two API is the first one do "dev->dma_mask = &dev->coherent_dma_mask;"
The reason you suggest choosing dma_set_mask_and_coherent is you do not want
assign dev->dma_mask?
- The second parameter for dma_set_mask_and_coherent is DMA_BIT_MASK(32), is it
ok?

I just a little confused of what's the operation is "hardcoding the dma mask"?

-- 
Best Regards,
Peter Chen
