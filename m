Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752391Ab3JWNqm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Oct 2013 09:46:42 -0400
Received: from mx1.redhat.com ([209.132.183.28]:6815 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751316Ab3JWNqk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Oct 2013 09:46:40 -0400
Message-ID: <1382535972.1768.68.camel@deneb.redhat.com>
Subject: Re: [PATCH] arm64: allow ioremap_cache() to use existing RAM
 mappings
From: Mark Salter <msalter@redhat.com>
To: Catalin Marinas <catalin.marinas@arm.com>
Cc: Will Deacon <Will.Deacon@arm.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Wed, 23 Oct 2013 09:46:12 -0400
In-Reply-To: <1382519898.10408.1.camel@mbp>
References: <1382362594-24947-1-git-send-email-msalter@redhat.com>
	 <1382519898.10408.1.camel@mbp>
Organization: Red Hat, Inc
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2013-10-23 at 10:18 +0100, Catalin Marinas wrote:
> On Mon, 2013-10-21 at 14:36 +0100, msalter@redhat.com wrote:
> > diff --git a/arch/arm64/mm/ioremap.c b/arch/arm64/mm/ioremap.c
> > index 1725cd6..fb44b3d 100644
> > --- a/arch/arm64/mm/ioremap.c
> > +++ b/arch/arm64/mm/ioremap.c
> > @@ -79,6 +79,21 @@ void __iounmap(volatile void __iomem *io_addr)
> >  {
> >  	void *addr = (void *)(PAGE_MASK & (unsigned long)io_addr);
> >  
> > +	/* Nothing to do for normal memory. See ioremap_cache() */
> > +	if (pfn_valid(__virt_to_phys(addr) >> PAGE_SHIFT))
> > +		return;
> 
> addr here can be some I/O address mapped previously, so __virt_to_phys()
> is not valid (you don't actually get the pfn by shifting).
> 

Yeah, that's ugly. The thought was that only the kernel mapping of RAM
would yield a valid address from __virt_to_phys(). Anything else, like
a mapping of I/O space would lead to an invalid PFN. There's probably a
clearer way of doing that that. Other than that, is the general concept
of the patch reasonable?

--Mark


