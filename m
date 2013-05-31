Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756279Ab3EaPU3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 May 2013 11:20:29 -0400
Received: from smtp02.citrix.com ([66.165.176.63]:23571 "EHLO
	SMTP02.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752731Ab3EaPUW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 May 2013 11:20:22 -0400
X-IronPort-AV: E=Sophos;i="4.87,779,1363132800"; 
   d="scan'208";a="27188935"
Date: Fri, 31 May 2013 16:20:02 +0100
From: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
X-X-Sender: sstabellini@kaball.uk.xensource.com
To: Catalin Marinas <catalin.marinas@arm.com>
CC: Stefano Stabellini <stefano.stabellini@eu.citrix.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>,
        Will Deacon <Will.Deacon@arm.com>,
        "Ian.Campbell@citrix.com" <Ian.Campbell@citrix.com>,
        "konrad.wilk@oracle.com" <konrad.wilk@oracle.com>
Subject: Re: [PATCH RFC 1/6] [HACK!] arm64/xen: create links to arch/arm
 include files and Xen code
In-Reply-To: <20130531131038.GA15551@arm.com>
Message-ID: <alpine.DEB.2.02.1305311446360.4799@kaball.uk.xensource.com>
References: <alpine.DEB.2.02.1305301705500.4799@kaball.uk.xensource.com> <1369930713-6063-1-git-send-email-stefano.stabellini@eu.citrix.com> <20130531103617.GA18045@localhost.cambridge.arm.com> <alpine.DEB.2.02.1305311259090.4799@kaball.uk.xensource.com>
 <20130531131038.GA15551@arm.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 31 May 2013, Catalin Marinas wrote:
> On Fri, May 31, 2013 at 01:02:04PM +0100, Stefano Stabellini wrote:
> > On Fri, 31 May 2013, Catalin Marinas wrote:
> > > On Thu, May 30, 2013 at 05:18:28PM +0100, Stefano Stabellini wrote:
> > > > Most of Xen support for ARM is common between ARMv7 and ARMv8.
> > > > Create links to the code under arch/arm (bleah).
> > > > 
> > > > Other, probably better alternatives:
> > > > 
> > > > - move the code to a different location, maybe the header files to
> > > > include/xen/arm and the code to drivers/xen/arm (still pretty ugly)?
> > > > 
> > > > - create a copy of the code to arch/arm64 (even worse);
> > > 
> > > KVM handles this in the Makefile by referencing back to arch/arm or even
> > > the generic kvm directory. I think that's the 'cleanest' ;)
> > 
> > Do you mean creating links in the Makefile or generating header file
> > copies from the Makefile?
> > Or do you mean using something like "-I arch/arm/include/asm/xen" in the
> > arch/arm64 Makefile?
> 
> I meant C files being compiled directly from arch/arm (no links).

OK.


> For headers, if they are specific to arm or arm64, just copy the header
> in each place (e.g. not using regs->pstate in the arch/arm code with
> #ifdef's). For the rest, if they cannot be made generic, one way is to
> have a dummy file including the arm equivalent:
> 
> #include <../../arm/include/asm/xen/events.h>
> 
> Passing -I is dangerous as you actually need "-I arch/arm/include" which
> could bring other files.

Thanks, that is a good idea, I'll do that.
