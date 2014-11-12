Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752838AbaKLNX2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Nov 2014 08:23:28 -0500
Received: from eusmtp01.atmel.com ([212.144.249.242]:34117 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752337AbaKLNX1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Nov 2014 08:23:27 -0500
Date: Wed, 12 Nov 2014 14:23:38 +0100
From: Ludovic Desroches <ludovic.desroches@atmel.com>
To: Vinod Koul <vinod.koul@intel.com>
CC: Stephen Rothwell <sfr@canb.auug.org.au>, <linux-next@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>,
        Ludovic Desroches <ludovic.desroches@atmel.com>,
        Nicolas Ferre <nicolas.ferre@atmel.com>
Subject: Re: linux-next: build failure after merge of the slave-dma tree
Message-ID: <20141112132338.GK3639@ldesroches-Latitude-E6320>
References: <20141110115846.390ce45e@canb.auug.org.au>
 <20141110050616.GA18555@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20141110050616.GA18555@intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Vinod,

On Mon, Nov 10, 2014 at 10:36:16AM +0530, Vinod Koul wrote:
> On Mon, Nov 10, 2014 at 11:58:46AM +1100, Stephen Rothwell wrote:
> > Hi Vinod,
> > 
> > After merging the slave-dma tree, today's linux-next build (x86_64 allmodconfig)
> > failed like this:
> > 
> > drivers/dma/at_xdmac.c: In function 'at_xdmac_off':
> > drivers/dma/at_xdmac.c:317:2: error: implicit declaration of function 'writel_relaxed' [-Werror=implicit-function-declaration]
> >   at_xdmac_write(atxdmac, AT_XDMAC_GD, -1L);
> >   ^
> > 
> > Caused by commit e1f7c9eee707 ("dmaengine: at_xdmac: creation of the
> > atmel eXtended DMA Controller driver").
> Thanks Stephen,
> 
> I have fixed this error and warning, the tree is updated now

Thanks to manage it, sorry I didn't have the time to send a fix for
it. I will send you a patch to reintroduce _relaxed version of readl and
writel but I will remove COMPILE_TEST since _relaxed is not implemented
on other architectures.

Regards

Ludovic

> 
> -- 
> ~Vinod
> 
> > 
> > Also, lots of warnings like:
> > 
> > drivers/dma/at_xdmac.c: In function 'at_xdmac_prep_slave_sg':
> > include/linux/dynamic_debug.h:64:16: warning: format '%x' expects argument of type 'unsigned int', but argument 5 has type 'dma_addr_t' [-Wformat=]
> >   static struct _ddebug  __aligned(8)   \
> >                 ^
> > include/linux/dynamic_debug.h:84:2: note: in expansion of macro 'DEFINE_DYNAMIC_DEBUG_METADATA'
> >   DEFINE_DYNAMIC_DEBUG_METADATA(descriptor, fmt);  \
> >   ^
> > include/linux/device.h:1107:2: note: in expansion of macro 'dynamic_dev_dbg'
> >   dynamic_dev_dbg(dev, format, ##__VA_ARGS__); \
> >   ^
> > drivers/dma/at_xdmac.c:621:3: note: in expansion of macro 'dev_dbg'
> >    dev_dbg(chan2dev(chan),
> >    ^
> > 
> > I have used the slave-dma tree from next-20141106 for today.
> > -- 
> > Cheers,
> > Stephen Rothwell                    sfr@canb.auug.org.au
> 
> 
> 
> -- 


