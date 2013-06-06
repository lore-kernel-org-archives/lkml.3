Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751371Ab3FFQTb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Jun 2013 12:19:31 -0400
Received: from smtp.citrix.com ([66.165.176.89]:64595 "EHLO SMTP.CITRIX.COM"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750857Ab3FFQTa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Jun 2013 12:19:30 -0400
X-IronPort-AV: E=Sophos;i="4.87,816,1363132800"; 
   d="scan'208";a="29677632"
Date: Thu, 6 Jun 2013 17:19:13 +0100
From: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
X-X-Sender: sstabellini@kaball.uk.xensource.com
To: Catalin Marinas <catalin.marinas@arm.com>
CC: Arnd Bergmann <arnd@arndb.de>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Stefano Stabellini <stefano.stabellini@eu.citrix.com>,
        "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>,
        "Ian.Campbell@citrix.com" <Ian.Campbell@citrix.com>,
        "konrad.wilk@oracle.com" <konrad.wilk@oracle.com>,
        Will Deacon <Will.Deacon@arm.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>
Subject: Re: [PATCH v3 5/6] arm64/xen: introduce CONFIG_XEN and hypercall.S
 on ARM64
In-Reply-To: <20130606144212.GK28479@arm.com>
Message-ID: <alpine.DEB.2.02.1306061703570.4589@kaball.uk.xensource.com>
References: <alpine.DEB.2.02.1306041712100.4589@kaball.uk.xensource.com> <1370434530-22428-5-git-send-email-stefano.stabellini@eu.citrix.com> <1471793.18ZhhAHKN9@wuerfel> <20130606144212.GK28479@arm.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 6 Jun 2013, Catalin Marinas wrote:
> Hi Arnd,
> 
> On Wed, Jun 05, 2013 at 01:44:55PM +0100, Arnd Bergmann wrote:
> > On Wednesday 05 June 2013 13:15:29 Stefano Stabellini wrote:
> > > diff --git a/arch/arm64/Makefile b/arch/arm64/Makefile
> > > index c95c5cb..79dd13d 100644
> > > --- a/arch/arm64/Makefile
> > > +++ b/arch/arm64/Makefile
> > > @@ -37,6 +37,7 @@ TEXT_OFFSET := 0x00080000
> > >  export TEXT_OFFSET GZFLAGS
> > >  
> > >  core-y         += arch/arm64/kernel/ arch/arm64/mm/
> > > +core-$(CONFIG_XEN)             += arch/arm64/xen/
> > >  libs-y         := arch/arm64/lib/ $(libs-y)
> > >  libs-y         += $(LIBGCC)
> > >  
> > > diff --git a/arch/arm64/xen/Makefile b/arch/arm64/xen/Makefile
> > > new file mode 100644
> > > index 0000000..be24040
> > > --- /dev/null
> > > +++ b/arch/arm64/xen/Makefile
> > > @@ -0,0 +1,2 @@
> > > +xen-arm-y      += $(addprefix ../../arm/xen/, enlighten.o grant-table.o)
> > > +obj-y          := xen-arm.o hypercall.o
> > 
> > I think it would be nicer to redirect the entire directory, not just
> > the enlighten.o and grant-table.o files. You could do in arch/arm64/Makefile:
> > 
> > core-(CONFIG_XEN) += arch/arm/xen/
> > 
> > That leaves a small difference in hypercall.o, which I think you can
> > handle with an #ifdef.
> 
> Sorry, I missed this part. I want to keep the AArch64 assembly under
> arm64, even if it is small.

That's fine, I don't have a strong opinion on this, I am happy either way.

In this case the v3 of the series is the one we want.
I'll submit a pull request to you for it during the next couple of days.
