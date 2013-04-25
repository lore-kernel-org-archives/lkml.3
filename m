Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758763Ab3DYO6Y (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Apr 2013 10:58:24 -0400
Received: from mail-qe0-f44.google.com ([209.85.128.44]:65339 "EHLO
	mail-qe0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757895Ab3DYO6X (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Apr 2013 10:58:23 -0400
Date: Thu, 25 Apr 2013 10:58:19 -0400 (EDT)
From: Nicolas Pitre <nicolas.pitre@linaro.org>
To: Will Deacon <will.deacon@arm.com>
cc: Stefano Stabellini <stefano.stabellini@eu.citrix.com>,
        "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "arnd@arndb.de" <arnd@arndb.de>,
        "rob.herring@calxeda.com" <rob.herring@calxeda.com>,
        "linux@arm.linux.org.uk" <linux@arm.linux.org.uk>,
        "olof@lixom.net" <olof@lixom.net>
Subject: Re: [PATCH v8 1/2] arm: introduce psci_smp_ops
In-Reply-To: <20130425104508.GG12848@mudshark.cambridge.arm.com>
Message-ID: <alpine.LFD.2.03.1304251054420.1258@syhkavp.arg>
References: <alpine.DEB.2.02.1304241935010.4180@kaball.uk.xensource.com> <1366828819-10745-1-git-send-email-stefano.stabellini@eu.citrix.com> <20130425084711.GA12848@mudshark.cambridge.arm.com> <alpine.DEB.2.02.1304251104090.4180@kaball.uk.xensource.com>
 <20130425104508.GG12848@mudshark.cambridge.arm.com>
User-Agent: Alpine 2.03 (LFD 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 25 Apr 2013, Will Deacon wrote:

> On Thu, Apr 25, 2013 at 11:12:54AM +0100, Stefano Stabellini wrote:
> > On Thu, 25 Apr 2013, Will Deacon wrote:
> > > > +/*
> > > > + * cpu_suspend   Suspend the execution on a CPU
> > > > + * @state        we don't currently describe affinity levels, so just pass 0.
> > > > + * @entry_point  the first instruction to be executed on return
> > > > + * returns 0  success, < 0 on failure
> > > > + *
> > > > + * cpu_off       Power down a CPU
> > > > + * @state        we don't currently describe affinity levels, so just pass 0.
> > > > + * no return on successful call
> > > > + *
> > > > + * cpu_on        Power up a CPU
> > > > + * @cpuid        cpuid of target CPU, as from MPIDR
> > > > + * @entry_point  the first instruction to be executed on return
> > > > + * returns 0  success, < 0 on failure
> > > > + *
> > > > + * migrate       Migrate the context to a different CPU
> > > > + * @cpuid        cpuid of target CPU, as from MPIDR
> > > > + * returns 0  success, < 0 on failure
> > > > + *
> > > > + */
> > > 
> > > Can you move these comments into psci-smp.c please? They're really specific
> > > to the implementation there, and if we put them in a header we're lying to
> > > ourselves about the parameters actually described by the PSCI specification.
> > 
> > You have a good point about the PSCI spec.
> > 
> > However from the Linux POV these comments should regard the functions
> > exported by psci_operations, not the firmware interface, this is why I
> > think it makes sense to keep them in psci.h.
> > What we are saying is for example that psci_operations.cpu_on returns 0
> > on success and < 0 on failure, and it takes a cpuid and an entry point
> > as parameters. We are not saying anything about the firmware interface.
> 
> I disagree. You're explicitly stating that we pass the `cpuid of target CPU,
> as from MPIDR'. That's simply not true -- the firmware could choose any
> numbering scheme to identify the CPUs. For KVM and Xen, it *is* the mpidr,
> which is why psci-smp.c works at all, but that's where the comment belongs,
> not in this header file.

At some point, the _kernel_ API for interfacing with the firmware's PSCI 
will have to ensure uniformity somehow.  The PSCI interface code could 
translate the passed MPIDR into whatever the firmware decided to use for 
identifying CPUs if needed, keeping this issue localized.


Nicolas
