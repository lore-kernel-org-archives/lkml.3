Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933934AbaFJCpX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jun 2014 22:45:23 -0400
Received: from lgeamrelo04.lge.com ([156.147.1.127]:43192 "EHLO
	lgeamrelo04.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754382AbaFJCpW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jun 2014 22:45:22 -0400
X-Original-SENDERIP: 10.177.220.145
X-Original-MAILFROM: iamjoonsoo.kim@lge.com
Date: Tue, 10 Jun 2014 11:49:11 +0900
From: Joonsoo Kim <iamjoonsoo.kim@lge.com>
To: Michal Nazarewicz <mina86@mina86.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Minchan Kim <minchan@kernel.org>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Paolo Bonzini <pbonzini@redhat.com>, Gleb Natapov <gleb@kernel.org>,
        Alexander Graf <agraf@suse.de>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        kvm@vger.kernel.org, kvm-ppc@vger.kernel.org,
        linuxppc-dev@lists.ozlabs.org
Subject: Re: [RFC PATCH 2/3] DMA, CMA: use general CMA reserved area
 management framework
Message-ID: <20140610024910.GB19036@js1304-P5Q-DELUXE>
References: <1401757919-30018-1-git-send-email-iamjoonsoo.kim@lge.com>
 <1401757919-30018-3-git-send-email-iamjoonsoo.kim@lge.com>
 <xa1twqcyjx3z.fsf@mina86.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <xa1twqcyjx3z.fsf@mina86.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 03, 2014 at 09:00:48AM +0200, Michal Nazarewicz wrote:
> On Tue, Jun 03 2014, Joonsoo Kim wrote:
> > Now, we have general CMA reserved area management framework,
> > so use it for future maintainabilty. There is no functional change.
> >
> > Signed-off-by: Joonsoo Kim <iamjoonsoo.kim@lge.com>
> 
> Acked-by: Michal Nazarewicz <mina86@mina86.com>
> 
> > diff --git a/include/linux/dma-contiguous.h b/include/linux/dma-contiguous.h
> > index dfb1dc9..ecb85ac 100644
> > --- a/include/linux/dma-contiguous.h
> > +++ b/include/linux/dma-contiguous.h
> > @@ -53,9 +53,10 @@
> >  
> >  #ifdef __KERNEL__
> >  
> > +#include <linux/device.h>
> > +
> 
> Why is this suddenly required?
> 
> >  struct cma;
> >  struct page;
> > -struct device;
> >  
> >  #ifdef CONFIG_DMA_CMA
> 

Without including device.h, build failure occurs.
In dma-contiguous.h, we try to access to dev->cma_area, so we need
device.h. In the past, we included it luckily by swap.h in
drivers/base/dma-contiguous.c. Swap.h includes node.h and then node.h
includes device.h, so we were happy. But, in this patch, I remove
'include <linux/swap.h>' so we need to include device.h explicitly.

Thanks.
