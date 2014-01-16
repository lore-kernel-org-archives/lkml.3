Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752801AbaAPQ3J (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Jan 2014 11:29:09 -0500
Received: from smtp.citrix.com ([66.165.176.89]:57728 "EHLO SMTP.CITRIX.COM"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752381AbaAPQ3G (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Jan 2014 11:29:06 -0500
X-IronPort-AV: E=Sophos;i="4.95,668,1384300800"; 
   d="scan'208";a="93539355"
Date: Thu, 16 Jan 2014 16:27:55 +0000
From: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
X-X-Sender: sstabellini@kaball.uk.xensource.com
To: Will Deacon <will.deacon@arm.com>
CC: Stefano Stabellini <stefano.stabellini@eu.citrix.com>,
        Arnd Bergmann <arnd@arndb.de>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux@arm.linux.org.uk" <linux@arm.linux.org.uk>,
        Catalin Marinas <Catalin.Marinas@arm.com>,
        "gang.chen@asianux.com" <gang.chen@asianux.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "jaccon.bastiaansen@gmail.com" <jaccon.bastiaansen@gmail.com>
Subject: Re: [PATCH v3] arm: remove !CPU_V6 and !GENERIC_ATOMIC64 build
 dependencies for XEN
In-Reply-To: <20140109184251.GL17838@mudshark.cambridge.arm.com>
Message-ID: <alpine.DEB.2.02.1401161622570.21510@kaball.uk.xensource.com>
References: <1389204023-26912-1-git-send-email-stefano.stabellini@eu.citrix.com> <20140109103004.GB11089@mudshark.cambridge.arm.com> <201401091204.17932.arnd@arndb.de> <alpine.DEB.2.02.1401091247000.21510@kaball.uk.xensource.com>
 <20140109184251.GL17838@mudshark.cambridge.arm.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
X-DLP: MIA2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 9 Jan 2014, Will Deacon wrote:
> On Thu, Jan 09, 2014 at 12:47:24PM +0000, Stefano Stabellini wrote:
> > On Thu, 9 Jan 2014, Arnd Bergmann wrote:
> > > On Thursday 09 January 2014, Will Deacon wrote:
> > > > On Wed, Jan 08, 2014 at 06:00:23PM +0000, Stefano Stabellini wrote:
> > > > > Remove !GENERIC_ATOMIC64 build dependency:
> > > > > - rename atomic64_xchg to armv7_atomic64_xchg and define it even ifdef
> > > > >   GENERIC_ATOMIC64;
> > > > > - call armv7_atomic64_xchg directly from xen/events.h.
> > > > > 
> > > > > Remove !CPU_V6 build dependency:
> > > > > - introduce __cmpxchg8 and __cmpxchg16, compiled even ifdef
> > > > >   CONFIG_CPU_V6;
> > > > > - implement sync_cmpxchg using __cmpxchg8 and __cmpxchg16.
> > > > > 
> > > > > Signed-off-by: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
> > > > > CC: arnd@arndb.de
> > > > > CC: linux@arm.linux.org.uk
> > > > > CC: will.deacon@arm.com
> > > > > CC: gang.chen@asianux.com
> > > > > CC: catalin.marinas@arm.com
> > > > > CC: jaccon.bastiaansen@gmail.com
> > > > > CC: linux-arm-kernel@lists.infradead.org
> > > > > CC: linux-kernel@vger.kernel.org
> > > > > 
> > > > 
> > > > I'm confused here. It looks like you want to call armv7 code in a v6 kernel.
> > > > What am I missing?
> > > 
> > > This is about being able to build a kernel that runs on ARMv6 and ARMv7
> > > and also includes Xen. Because of obvious hardware limitations, Xen
> > > will only run on v7, but currently you cannot even build it once you
> > > enable (pre-v6K) ARMv6 support, since the combined v6+v7 kernel can't
> > > do atomic accesses in a generic way on non-32bit variables.
> > 
> > Yep, that's right.
> 
> Ok, thanks for the explanation. Looking at the patch, I wonder whether it's
> not cleaner just to implement xchg code separately for Xen? The Linux code
> isn't always sufficient (due to the GENERIC_ATOMIC64 stuff) and most of the
> churn coming out of this patch is an attempt to provide some small code
> reuse at the cost of code readability.
> 
> What do others think?

I am OK with that, in fact my first version of the patch did just that:

http://marc.info/?l=linux-arm-kernel&m=138436406724990&w=2

Is that what you had in mind?
