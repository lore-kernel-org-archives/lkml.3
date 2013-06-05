Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754358Ab3FEMwU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Jun 2013 08:52:20 -0400
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:44039 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753394Ab3FEMwT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Jun 2013 08:52:19 -0400
Date: Wed, 5 Jun 2013 13:50:51 +0100
From: Will Deacon <will.deacon@arm.com>
To: Arnd Bergmann <arnd@arndb.de>
Cc: "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Stefano Stabellini <stefano.stabellini@eu.citrix.com>,
        "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>,
        "Ian.Campbell@citrix.com" <Ian.Campbell@citrix.com>,
        Catalin Marinas <Catalin.Marinas@arm.com>,
        "konrad.wilk@oracle.com" <konrad.wilk@oracle.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>
Subject: Re: [PATCH v3 5/6] arm64/xen: introduce CONFIG_XEN and hypercall.S
 on ARM64
Message-ID: <20130605125051.GB11402@mudshark.cambridge.arm.com>
References: <alpine.DEB.2.02.1306041712100.4589@kaball.uk.xensource.com>
 <1370434530-22428-5-git-send-email-stefano.stabellini@eu.citrix.com>
 <1471793.18ZhhAHKN9@wuerfel>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1471793.18ZhhAHKN9@wuerfel>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 05, 2013 at 01:44:55PM +0100, Arnd Bergmann wrote:
> On Wednesday 05 June 2013 13:15:29 Stefano Stabellini wrote:
> > diff --git a/arch/arm64/Makefile b/arch/arm64/Makefile
> > index c95c5cb..79dd13d 100644
> > --- a/arch/arm64/Makefile
> > +++ b/arch/arm64/Makefile
> > @@ -37,6 +37,7 @@ TEXT_OFFSET := 0x00080000
> >  export TEXT_OFFSET GZFLAGS
> >  
> >  core-y         += arch/arm64/kernel/ arch/arm64/mm/
> > +core-$(CONFIG_XEN)             += arch/arm64/xen/
> >  libs-y         := arch/arm64/lib/ $(libs-y)
> >  libs-y         += $(LIBGCC)
> >  
> > diff --git a/arch/arm64/xen/Makefile b/arch/arm64/xen/Makefile
> > new file mode 100644
> > index 0000000..be24040
> > --- /dev/null
> > +++ b/arch/arm64/xen/Makefile
> > @@ -0,0 +1,2 @@
> > +xen-arm-y      += $(addprefix ../../arm/xen/, enlighten.o grant-table.o)
> > +obj-y          := xen-arm.o hypercall.o
> 
> I think it would be nicer to redirect the entire directory, not just
> the enlighten.o and grant-table.o files. You could do in arch/arm64/Makefile:
> 
> core-(CONFIG_XEN) += arch/arm/xen/
> 
> That leaves a small difference in hypercall.o, which I think you can
> handle with an #ifdef.
> 
> I believe the reason why KVM does the more elaborate variant is that
> they want to be able to build their code as a loadable module that
> also includes code from virt/kvm, which you don't need.

I thought we scrapped the idea of KVM as a loadable module on ARM, mainly
due to the complexities with retrospective initialisation of HYP mode/EL2?

Will
