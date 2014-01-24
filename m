Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752229AbaAXSIn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Jan 2014 13:08:43 -0500
Received: from userp1040.oracle.com ([156.151.31.81]:38137 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752094AbaAXSIl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Jan 2014 13:08:41 -0500
Date: Fri, 24 Jan 2014 13:07:41 -0500
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: Akinobu Mita <akinobu.mita@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        David Woodhouse <dwmw2@infradead.org>, Don Dutile <ddutile@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Andi Kleen <andi@firstfloor.org>,
        x86@kernel.org, iommu@lists.linux-foundation.org
Subject: Re: [PATCH v2 1/5] x86: make dma_alloc_coherent() return zeroed
 memory if CMA is enabled
Message-ID: <20140124180741.GC15785@phenom.dumpdata.com>
References: <1389708830-5841-1-git-send-email-akinobu.mita@gmail.com>
 <1389708830-5841-2-git-send-email-akinobu.mita@gmail.com>
 <20140115200934.GC5201@phenom.dumpdata.com>
 <CAC5umygcr0a_BfDJ9tB1EDry4UEwThG7WvkA8Dn27zO9RQab8Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAC5umygcr0a_BfDJ9tB1EDry4UEwThG7WvkA8Dn27zO9RQab8Q@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 17, 2014 at 08:34:38AM +0900, Akinobu Mita wrote:
> 2014/1/16 Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>:
> > On Tue, Jan 14, 2014 at 11:13:46PM +0900, Akinobu Mita wrote:
> >> Calling dma_alloc_coherent() with __GFP_ZERO must return zeroed memory.
> >>
> >> But when the contiguous memory allocator (CMA) is enabled on x86 and
> >> the memory region is allocated by dma_alloc_from_contiguous(), it
> >> doesn't return zeroed memory.  Because dma_generic_alloc_coherent()
> >
> > So why not fix it there to return zeroed out memory?
> 
> I thought it looked nicer than this patch as we can remove memset
> from all caller of dma_alloc_from_contiguous().  But if I look at
> the caller on arm, we can't simply remove the memset because
> __dma_clear_buffer() is used there for ensuring cache flushing and
> it is used in many places.

OK, that should be part of the commit description.
> 
> Of course we can do redundant memset in dma_alloc_from_contiguous(),
> but now I think this patch is less impact for fixing this problem.

OK.
