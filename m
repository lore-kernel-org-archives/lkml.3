Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758112Ab3DYLOC (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Apr 2013 07:14:02 -0400
Received: from smtp02.citrix.com ([66.165.176.63]:25793 "EHLO
	SMTP02.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758067Ab3DYLN7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Apr 2013 07:13:59 -0400
X-IronPort-AV: E=Sophos;i="4.87,550,1363132800"; 
   d="scan'208";a="20484906"
Date: Thu, 25 Apr 2013 12:13:54 +0100
From: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
X-X-Sender: sstabellini@kaball.uk.xensource.com
To: Will Deacon <will.deacon@arm.com>
CC: Stefano Stabellini <Stefano.Stabellini@eu.citrix.com>,
        "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "arnd@arndb.de" <arnd@arndb.de>,
        "nicolas.pitre@linaro.org" <nicolas.pitre@linaro.org>,
        "rob.herring@calxeda.com" <rob.herring@calxeda.com>,
        "linux@arm.linux.org.uk" <linux@arm.linux.org.uk>,
        "olof@lixom.net" <olof@lixom.net>
Subject: Re: [PATCH v8 1/2] arm: introduce psci_smp_ops
In-Reply-To: <20130425111125.GI12848@mudshark.cambridge.arm.com>
Message-ID: <alpine.DEB.2.02.1304251212480.4180@kaball.uk.xensource.com>
References: <alpine.DEB.2.02.1304241935010.4180@kaball.uk.xensource.com> <1366828819-10745-1-git-send-email-stefano.stabellini@eu.citrix.com> <20130425084711.GA12848@mudshark.cambridge.arm.com> <alpine.DEB.2.02.1304251104090.4180@kaball.uk.xensource.com>
 <20130425104508.GG12848@mudshark.cambridge.arm.com> <alpine.DEB.2.02.1304251158080.4180@kaball.uk.xensource.com> <20130425111125.GI12848@mudshark.cambridge.arm.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 25 Apr 2013, Will Deacon wrote:
> On Thu, Apr 25, 2013 at 12:08:02PM +0100, Stefano Stabellini wrote:
> > On Thu, 25 Apr 2013, Will Deacon wrote:
> > > On Thu, Apr 25, 2013 at 11:12:54AM +0100, Stefano Stabellini wrote:
> > > > However from the Linux POV these comments should regard the functions
> > > > exported by psci_operations, not the firmware interface, this is why I
> > > > think it makes sense to keep them in psci.h.
> > > > What we are saying is for example that psci_operations.cpu_on returns 0
> > > > on success and < 0 on failure, and it takes a cpuid and an entry point
> > > > as parameters. We are not saying anything about the firmware interface.
> > > 
> > > I disagree. You're explicitly stating that we pass the `cpuid of target CPU,
> > > as from MPIDR'. That's simply not true -- the firmware could choose any
> > > numbering scheme to identify the CPUs. For KVM and Xen, it *is* the mpidr,
> > > which is why psci-smp.c works at all, but that's where the comment belongs,
> > > not in this header file.
> > 
> > I see, you want to keep psci_operations true to the firmware interface
> > while explaining that psci_smp makes some assumptions about it.
> 
> Precisely! :)
> 
> > So the comment should be something like:
> > 
> > /*
> >  * psci_smp assumes that the following is true about PSCI:
> >  * 
> >  * cpu_suspend   Suspend the execution on a CPU
> >  * @state        we don't currently describe affinity levels, so just pass 0.
> >  * @entry_point  the first instruction to be executed on return
> >  * returns 0  success, < 0 on failure
> >  *
> >  * cpu_off       Power down a CPU
> >  * @state        we don't currently describe affinity levels, so just pass 0.
> >  * no return on successful call
> >  *
> >  * cpu_on        Power up a CPU
> >  * @cpuid        cpuid of target CPU, as from MPIDR
> >  * @entry_point  the first instruction to be executed on return
> >  * returns 0  success, < 0 on failure
> >  *
> >  * migrate       Migrate the context to a different CPU
> >  * @cpuid        cpuid of target CPU, as from MPIDR
> >  * returns 0  success, < 0 on failure
> >  *
> >  */
> 
> That's certainly better, but I'd still rather see the comment with the
> implementation as there's a greater potential for confusion having it here.

Yeah, I forgot to write that it was supposed to go in psci_smp.c.
I am OK with that, I'll repost with this change.
