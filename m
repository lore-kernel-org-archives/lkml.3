Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753507Ab3C0Pp1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Mar 2013 11:45:27 -0400
Received: from mailout1.w1.samsung.com ([210.118.77.11]:18616 "EHLO
	mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752940Ab3C0PpZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Mar 2013 11:45:25 -0400
X-AuditID: cbfec7f5-b7fd76d000007247-67-51531412eda5
Message-id: <51531410.90706@samsung.com>
Date: Wed, 27 Mar 2013 16:45:20 +0100
From: Marek Szyprowski <m.szyprowski@samsung.com>
User-Agent: Mozilla/5.0 (Windows NT 5.1; rv:17.0) Gecko/20130307
 Thunderbird/17.0.4
MIME-version: 1.0
To: Michael Cree <mcree@orcon.net.nz>, Shuah Khan <shuah.khan@hp.com>,
        rth@twiddle.net, ink@jurassic.park.msu.ru, mattst88@gmail.com,
        kyungmin.park@samsung.com, arnd@arndb.de, andrzej.p@samsung.com,
        linux-alpha@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
        shuahkhan@gmail.com
Subject: Re: [PATCH RFT linux-next] alpha: dma-mapping: support
 debug_dma_mapping_error
References: <1351269163.4013.27.camel@lorien2>
 <1353001768.2532.31.camel@lorien2> <20130327065948.GO5042@omega>
In-reply-to: <20130327065948.GO5042@omega>
Content-type: text/plain; charset=UTF-8; format=flowed
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFmplluLIzCtJLcpLzFFi42I5/e/4NV0hkeBAg9n7DCze3T3CaHF51xw2
	ByaPz5vkAhijuGxSUnMyy1KL9O0SuDL+96xjLTjAU3Gq4RFbA+NXzi5GTg4JAROJtRuXMkHY
	YhIX7q1n62Lk4hASWMoo8XN/LyOE08wkceTfC7AqXgENibnXrrGC2CwCqhI/5t9hBrHZBAwl
	ut52sYHYogKhEi+b2qDqBSV+TL7HAjJIRGAJk8Sfg9uBmjk4hAUiJXaulgCpERIolFjw8TZY
	L6eAlsS+F2/BZjILmEk8alkHZctLbF7zlnkCI/8sJGNnISmbhaRsASPzKkbR1NLkguKk9Fwj
	veLE3OLSvHS95PzcTYyQoPu6g3HpMatDjAIcjEo8vCdLgwKFWBPLiitzDzFKcDArifD+4QsO
	FOJNSaysSi3Kjy8qzUktPsTIxMEp1cAo3Nce7X3FtiDHI5tj8WnvKZ88F+pFnFnhe/XIszzP
	J40ekx87c5RsWcJgwKDRdGHSx3M+P5Z+fHNQcJfhRvEVgVsmCHHEP57y883BFF7BpxNv3NiX
	tmvfqqj1ayTM+Qu/l/L9N3vCXHF361/2srdLOQov7PI6KHL66fWjha7pyoUC9mKX5G+ZKLEU
	ZyQaajEXFScCAPl+FHEYAgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On 3/27/2013 7:59 AM, Michael Cree wrote:
> On Thu, Nov 15, 2012 at 10:49:28AM -0700, Shuah Khan wrote:
> > On Fri, 2012-10-26 at 10:32 -0600, Shuah Khan wrote:
> > > Add support for debug_dma_mapping_error() call to avoid warning from
> > > debug_dma_unmap() interface when it checks for mapping error checked
> > > status. Without this patch, device driver failed to check map error
> > > warning is generated.
> > >
> > > Signed-off-by: Shuah Khan <shuah.khan@hp.com>
> > > ---
> > >  arch/alpha/include/asm/dma-mapping.h |    1 +
> > >  1 file changed, 1 insertion(+)
> > >
> > > diff --git a/arch/alpha/include/asm/dma-mapping.h b/arch/alpha/include/asm/dma-mapping.h
> > > index dfa32f0..b4d483b 100644
> > > --- a/arch/alpha/include/asm/dma-mapping.h
> > > +++ b/arch/alpha/include/asm/dma-mapping.h
> > > @@ -32,6 +32,7 @@ static inline void dma_free_attrs(struct device *dev, size_t size,
> > >
> > >  static inline int dma_mapping_error(struct device *dev, dma_addr_t dma_addr)
> > >  {
> > > +	debug_dma_mapping_error(dev, dma_addr);
> > >  	return get_dma_ops(dev)->mapping_error(dev, dma_addr);
> > >  }
> > >
> >
> > Marek,
> >
> > This is for alpha to go through your tree.
>
> Given that this does not appear to be upstream yet I'll take it through
> the Alpha tree.

Those patches in the end went via IOMMU tree. I looks that the patch for 
Alpha has
been missed. It looks that this patch should be merged to v3.9-rcX asap 
to fix the
broken dma-mapping api calls.

Best regards
-- 
Marek Szyprowski
Samsung Poland R&D Center


