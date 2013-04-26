Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755318Ab3DZQKi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Apr 2013 12:10:38 -0400
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:64174 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751276Ab3DZQKh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Apr 2013 12:10:37 -0400
Date: Fri, 26 Apr 2013 17:10:12 +0100
From: Will Deacon <will.deacon@arm.com>
To: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
Cc: Nicolas Pitre <nicolas.pitre@linaro.org>,
        "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "arnd@arndb.de" <arnd@arndb.de>,
        "rob.herring@calxeda.com" <rob.herring@calxeda.com>,
        "linux@arm.linux.org.uk" <linux@arm.linux.org.uk>,
        "olof@lixom.net" <olof@lixom.net>
Subject: Re: [PATCH v8 1/2] arm: introduce psci_smp_ops
Message-ID: <20130426161012.GH30858@mudshark.cambridge.arm.com>
References: <alpine.DEB.2.02.1304241935010.4180@kaball.uk.xensource.com>
 <1366828819-10745-1-git-send-email-stefano.stabellini@eu.citrix.com>
 <20130425084711.GA12848@mudshark.cambridge.arm.com>
 <alpine.DEB.2.02.1304251104090.4180@kaball.uk.xensource.com>
 <20130425104508.GG12848@mudshark.cambridge.arm.com>
 <alpine.LFD.2.03.1304251054420.1258@syhkavp.arg>
 <alpine.DEB.2.02.1304261630110.4180@kaball.uk.xensource.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.02.1304261630110.4180@kaball.uk.xensource.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 26, 2013 at 04:36:26PM +0100, Stefano Stabellini wrote:
> On Thu, 25 Apr 2013, Nicolas Pitre wrote:
> > On Thu, 25 Apr 2013, Will Deacon wrote:
> > > I disagree. You're explicitly stating that we pass the `cpuid of target CPU,
> > > as from MPIDR'. That's simply not true -- the firmware could choose any
> > > numbering scheme to identify the CPUs. For KVM and Xen, it *is* the mpidr,
> > > which is why psci-smp.c works at all, but that's where the comment belongs,
> > > not in this header file.
> > 
> > At some point, the _kernel_ API for interfacing with the firmware's PSCI 
> > will have to ensure uniformity somehow.  The PSCI interface code could 
> > translate the passed MPIDR into whatever the firmware decided to use for 
> > identifying CPUs if needed, keeping this issue localized.
> 
> That is what I had in mind when I said to keep the comment in psci.h
> before.
> We have to draw the line somewhere to expose a uniform internal kernel
> API. However it is a bit difficult to do now given that we have only one
> user of the API.

I see psci.h as representing the firmware interface, and psci-smp.c or
whatever sits on top as exposing the kernel `API'.

> I don't feel to strongly about this, please let me know what is the
> final decision and I'll update the code accordingly. I remind you that
> the merge window is approaching :-)

I'd still like the comment to be in psci-smp.c, or a header separate from
the firmware bits.

Will
