Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752741Ab3EaOQw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 May 2013 10:16:52 -0400
Received: from fw-tnat.cambridge.arm.com ([217.140.96.21]:49848 "EHLO
	cam-smtp0.cambridge.arm.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751041Ab3EaOQo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 May 2013 10:16:44 -0400
Date: Fri, 31 May 2013 15:16:01 +0100
From: Catalin Marinas <catalin.marinas@arm.com>
To: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
Cc: "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>,
        Will Deacon <Will.Deacon@arm.com>,
        "Ian.Campbell@citrix.com" <Ian.Campbell@citrix.com>,
        "konrad.wilk@oracle.com" <konrad.wilk@oracle.com>
Subject: Re: [PATCH RFC 5/6] arm64/xen: implement xen_remap on arm64
Message-ID: <20130531141601.GC15551@arm.com>
References: <alpine.DEB.2.02.1305301705500.4799@kaball.uk.xensource.com>
 <1369930713-6063-5-git-send-email-stefano.stabellini@eu.citrix.com>
 <20130531105915.GC18045@localhost.cambridge.arm.com>
 <alpine.DEB.2.02.1305311419280.4799@kaball.uk.xensource.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.02.1305311419280.4799@kaball.uk.xensource.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 31, 2013 at 02:21:16PM +0100, Stefano Stabellini wrote:
> On Fri, 31 May 2013, Catalin Marinas wrote:
> > On Thu, May 30, 2013 at 05:18:32PM +0100, Stefano Stabellini wrote:
> > > --- a/arch/arm/include/asm/xen/page.h
> > > +++ b/arch/arm/include/asm/xen/page.h
> > > @@ -90,6 +90,10 @@ static inline bool set_phys_to_machine(unsigned long pfn, unsigned long mfn)
> > >  	return __set_phys_to_machine(pfn, mfn);
> > >  }
> > >  
> > > +#ifdef CONFIG_ARM64
> > > +#define xen_remap(cookie, size) __ioremap((cookie), (size), __pgprot(PROT_NORMAL))
> > > +#else
> > >  #define xen_remap(cookie, size) __arm_ioremap((cookie), (size), MT_MEMORY);
> > > +#endif
> > 
> > Now I saw the ARM-specific part. Can you not use something like
> > ioremap_cached() which would give normal cacheable memory (at least on
> > ARMv7).
> 
> No, I cannot because ioremap_cached uses MT_DEVICE_CACHED, while this
> needs to be MT_MEMORY. It is used for normal memory pages, not device
> memory.

MT_DEVICE_CACHED is Normal memory for ARMv7.

-- 
Catalin
