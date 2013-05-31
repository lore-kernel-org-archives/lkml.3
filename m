Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754237Ab3EaNn5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 May 2013 09:43:57 -0400
Received: from fw-tnat.cambridge.arm.com ([217.140.96.21]:44184 "EHLO
	cam-smtp0.cambridge.arm.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1750910Ab3EaNnw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 May 2013 09:43:52 -0400
Date: Fri, 31 May 2013 14:10:38 +0100
From: Catalin Marinas <catalin.marinas@arm.com>
To: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
Cc: "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>,
        Will Deacon <Will.Deacon@arm.com>,
        "Ian.Campbell@citrix.com" <Ian.Campbell@citrix.com>,
        "konrad.wilk@oracle.com" <konrad.wilk@oracle.com>
Subject: Re: [PATCH RFC 1/6] [HACK!] arm64/xen: create links to arch/arm
 include files and Xen code
Message-ID: <20130531131038.GA15551@arm.com>
References: <alpine.DEB.2.02.1305301705500.4799@kaball.uk.xensource.com>
 <1369930713-6063-1-git-send-email-stefano.stabellini@eu.citrix.com>
 <20130531103617.GA18045@localhost.cambridge.arm.com>
 <alpine.DEB.2.02.1305311259090.4799@kaball.uk.xensource.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.02.1305311259090.4799@kaball.uk.xensource.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 31, 2013 at 01:02:04PM +0100, Stefano Stabellini wrote:
> On Fri, 31 May 2013, Catalin Marinas wrote:
> > On Thu, May 30, 2013 at 05:18:28PM +0100, Stefano Stabellini wrote:
> > > Most of Xen support for ARM is common between ARMv7 and ARMv8.
> > > Create links to the code under arch/arm (bleah).
> > > 
> > > Other, probably better alternatives:
> > > 
> > > - move the code to a different location, maybe the header files to
> > > include/xen/arm and the code to drivers/xen/arm (still pretty ugly)?
> > > 
> > > - create a copy of the code to arch/arm64 (even worse);
> > 
> > KVM handles this in the Makefile by referencing back to arch/arm or even
> > the generic kvm directory. I think that's the 'cleanest' ;)
> 
> Do you mean creating links in the Makefile or generating header file
> copies from the Makefile?
> Or do you mean using something like "-I arch/arm/include/asm/xen" in the
> arch/arm64 Makefile?

I meant C files being compiled directly from arch/arm (no links).

For headers, if they are specific to arm or arm64, just copy the header
in each place (e.g. not using regs->pstate in the arch/arm code with
#ifdef's). For the rest, if they cannot be made generic, one way is to
have a dummy file including the arm equivalent:

#include <../../arm/include/asm/xen/events.h>

Passing -I is dangerous as you actually need "-I arch/arm/include" which
could bring other files.

-- 
Catalin
