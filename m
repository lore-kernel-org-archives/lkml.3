Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932845Ab3DBQLa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Apr 2013 12:11:30 -0400
Received: from mail-qe0-f44.google.com ([209.85.128.44]:54743 "EHLO
	mail-qe0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932791Ab3DBQL2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Apr 2013 12:11:28 -0400
Date: Tue, 2 Apr 2013 12:11:25 -0400 (EDT)
From: Nicolas Pitre <nicolas.pitre@linaro.org>
To: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
cc: Rob Herring <robherring2@gmail.com>,
        "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Arnd Bergmann <arnd@arndb.de>,
        "marc.zyngier@arm.com" <marc.zyngier@arm.com>,
        Will Deacon <will.deacon@arm.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH v4 2/2] arm: prefer PSCI for SMP bringup
In-Reply-To: <alpine.DEB.2.02.1304021522230.5078@kaball.uk.xensource.com>
Message-ID: <alpine.LFD.2.03.1304021202520.1171@syhkavp.arg>
References: <1364575371-8926-2-git-send-email-stefano.stabellini@eu.citrix.com> <alpine.LFD.2.03.1303291320580.1372@syhkavp.arg> <alpine.DEB.2.02.1303291735080.4430@kaball.uk.xensource.com> <alpine.LFD.2.03.1303291349150.1372@syhkavp.arg> <5155EC28.8050608@gmail.com>
 <alpine.DEB.2.02.1304011541010.5078@kaball.uk.xensource.com> <alpine.LFD.2.03.1304011412030.1171@syhkavp.arg> <alpine.DEB.2.02.1304021522230.5078@kaball.uk.xensource.com>
User-Agent: Alpine 2.03 (LFD 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2 Apr 2013, Stefano Stabellini wrote:

> On Mon, 1 Apr 2013, Nicolas Pitre wrote:
> > On Mon, 1 Apr 2013, Stefano Stabellini wrote:
> > > What are the platforms that are going to use smp_init? Do we know how do
> > > they intend to use it?
> > 
> > VExpress for one.  When booting on a big.LITTLE system such as TC2 on 
> > VExpress, the MCPM layer needs to arbitrate power management operations 
> > on a per cluster basis.  In that case there is a MCPM specific set of 
> > SMP ops to be used, even if it may end up calling into PSCI.
> > 
> > But the important point is that we don't know beforehand what to use, 
> > especially with a kernel that can boot on multiple different VExpress 
> > configurations.  The decision has to be made at run time, and therefore 
> > a static default or mdesc->smp ops doesn't cut it.
> 
> I certainly like the principle and I am in favor of anything that moves
> the decisions at runtime. I have pulled the patch in the series, it's
> going to be in the next version.
> 
> However I am concerned that these platform specific operations won't
> work with Xen at all.
> I am getting increasingly certain that we need a Xen specific check in
> setup_arch to bump up of the priority of PSCI over anything else if Xen
> is running. 

I'm concerned about mixing big.LITTLE and Xen as well.  I don't think 
this is going to make an easy match.  KVM might have an easier fit here.

But, in any case, even if the MCPM layer gets involved, if Xen is there 
then PSCI will end up being the ultimate interface anyway.

But let's cross that bridge when we get to it.  For now this is still a 
non existing problem.


Nicolas
