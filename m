Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753342Ab3C0QS1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Mar 2013 12:18:27 -0400
Received: from g4t0014.houston.hp.com ([15.201.24.17]:27942 "EHLO
	g4t0014.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751849Ab3C0QS0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Mar 2013 12:18:26 -0400
Message-ID: <1364401097.3465.8.camel@lorien2>
Subject: Re: [PATCH RFT linux-next] alpha: dma-mapping: support
 debug_dma_mapping_error
From: Shuah Khan <shuah.khan@hp.com>
Reply-To: shuah.khan@hp.com
To: Marek Szyprowski <m.szyprowski@samsung.com>
Cc: Michael Cree <mcree@orcon.net.nz>, rth@twiddle.net,
        ink@jurassic.park.msu.ru, mattst88@gmail.com,
        kyungmin.park@samsung.com, arnd@arndb.de, andrzej.p@samsung.com,
        linux-alpha@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
        Shuah Khan <shuah.khan@hp.com>
Date: Wed, 27 Mar 2013 10:18:17 -0600
In-Reply-To: <51531410.90706@samsung.com>
References: <1351269163.4013.27.camel@lorien2>
	 <1353001768.2532.31.camel@lorien2> <20130327065948.GO5042@omega>
	 <51531410.90706@samsung.com>
Organization: ISS-Linux
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2013-03-27 at 16:45 +0100, Marek Szyprowski wrote:
> Hello,
> 
> On 3/27/2013 7:59 AM, Michael Cree wrote:
> > On Thu, Nov 15, 2012 at 10:49:28AM -0700, Shuah Khan wrote:
> > > On Fri, 2012-10-26 at 10:32 -0600, Shuah Khan wrote:
> > > > Add support for debug_dma_mapping_error() call to avoid warning from
> > > > debug_dma_unmap() interface when it checks for mapping error checked
> > > > status. Without this patch, device driver failed to check map error
> > > > warning is generated.
> > > >
> > > > Signed-off-by: Shuah Khan <shuah.khan@hp.com>
> > > > ---
> > > >  arch/alpha/include/asm/dma-mapping.h |    1 +
> > > >  1 file changed, 1 insertion(+)
> > > >
> > > > diff --git a/arch/alpha/include/asm/dma-mapping.h b/arch/alpha/include/asm/dma-mapping.h
> > > > index dfa32f0..b4d483b 100644
> > > > --- a/arch/alpha/include/asm/dma-mapping.h
> > > > +++ b/arch/alpha/include/asm/dma-mapping.h
> > > > @@ -32,6 +32,7 @@ static inline void dma_free_attrs(struct device *dev, size_t size,
> > > >
> > > >  static inline int dma_mapping_error(struct device *dev, dma_addr_t dma_addr)
> > > >  {
> > > > +	debug_dma_mapping_error(dev, dma_addr);
> > > >  	return get_dma_ops(dev)->mapping_error(dev, dma_addr);
> > > >  }
> > > >
> > >
> > > Marek,
> > >
> > > This is for alpha to go through your tree.
> >
> > Given that this does not appear to be upstream yet I'll take it through
> > the Alpha tree.
> 
> Those patches in the end went via IOMMU tree. I looks that the patch for 
> Alpha has
> been missed. It looks that this patch should be merged to v3.9-rcX asap 
> to fix the
> broken dma-mapping api calls.
> 

The reason it didn't get pulled into iommu tree was that alpha Kconfig
doesn't support HAVE_DMA_API_DEBUG and DMA_API_DEBUG. I don't see it in
arch/alpha/Kconfig. That said, this patch is needed on alpha, if these
two config options get enabled. I will leave it up to the alpha
maintainers to decide if this patch is needed or not.

thanks,
-- Shuah


