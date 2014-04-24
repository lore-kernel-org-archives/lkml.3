Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755215AbaDXJjo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Apr 2014 05:39:44 -0400
Received: from mail-bn1blp0190.outbound.protection.outlook.com ([207.46.163.190]:40880
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753145AbaDXJjh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Apr 2014 05:39:37 -0400
Date: Thu, 24 Apr 2014 17:45:42 +0800
From: Robin Gong <b38343@freescale.com>
To: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
CC: <vinod.koul@intel.com>, <dan.j.williams@intel.com>,
        <dmaengine@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2] dma: imx-sdma: add support for sdma memory copy
Message-ID: <20140424094537.GA26556@Robin-OptiPlex-780>
References: <1398316184-16824-1-git-send-email-b38343@freescale.com>
 <1398329406.11914.258.camel@smile.fi.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <1398329406.11914.258.camel@smile.fi.intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:192.88.158.246;CTRY:US;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(10009001)(6009001)(428001)(24454002)(189002)(199002)(164054003)(377424004)(51704005)(83322001)(81342001)(19580405001)(76482001)(46102001)(76176999)(23726002)(80976001)(99396002)(33656001)(50986999)(50466002)(46406003)(6806004)(54356999)(83506001)(74502001)(20776003)(83072002)(80022001)(77982001)(47776003)(92566001)(4396001)(87936001)(19580395003)(77096999)(33716001)(44976005)(81542001)(79102001)(92726001)(97756001)(85852003)(31966008)(74662001)(42262001);DIR:OUT;SFP:1101;SCL:1;SRVR:SN2PR03MB030;H:az84smr01.freescale.net;FPR:FE36FB6A.A0E09C35.B1F063E8.5E5419F3.201AB;MLV:sfv;PTR:gate-az5.freescale.com;MX:1;A:1;LANG:en;
X-Forefront-PRVS: 01917B1794
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 24, 2014 at 11:50:06AM +0300, Andy Shevchenko wrote:
> On Thu, 2014-04-24 at 13:09 +0800, Robin Gong wrote:
> > add "device_prep_dma_memcpy" and "device_prep_dma_sg" for memory copy by sdma.
> > 
> > Signed-off-by: Robin Gong <b38343@freescale.com>
> > 
> > ---
> > change:
> > --v2:
> >   1. correct some printk format, such as %pad for dma_addr_t
> >   2. split duplicated code in prep_dma_memcpy and prep_dma_sg to make code clean.
> 
> Thanks for an update. One small comment below.
> 
> > +
> > +static int check_bd_buswidth(struct sdma_buffer_descriptor *bd,
> > +			     struct sdma_channel *sdmac, int count,
> > +			     dma_addr_t dma_dst, dma_addr_t dma_src)
> > +{
> > +	int ret = 0;
> > +
> > +	if (sdmac->word_size > DMA_SLAVE_BUSWIDTH_4_BYTES)
> > +		ret =  -EINVAL;
> 
> I think two lines above are redundant since you have default path in the
> switch.
>
Thanks, will remove it in next version.
