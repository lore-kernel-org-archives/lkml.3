Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752114Ab3DSRGQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Apr 2013 13:06:16 -0400
Received: from smtp.citrix.com ([66.165.176.89]:53572 "EHLO SMTP.CITRIX.COM"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751959Ab3DSRGP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Apr 2013 13:06:15 -0400
X-IronPort-AV: E=Sophos;i="4.87,510,1363132800"; 
   d="scan'208";a="20499641"
Date: Fri, 19 Apr 2013 18:06:01 +0100
From: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
X-X-Sender: sstabellini@kaball.uk.xensource.com
To: Nicolas Pitre <nicolas.pitre@linaro.org>
CC: Ian Campbell <Ian.Campbell@citrix.com>,
        Stefano Stabellini <Stefano.Stabellini@eu.citrix.com>,
        "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        "arnd@arndb.de" <arnd@arndb.de>,
        "marc.zyngier@arm.com" <marc.zyngier@arm.com>,
        "will.deacon@arm.com" <will.deacon@arm.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "rob.herring@calxeda.com" <rob.herring@calxeda.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [Xen-devel] [PATCH v6 1/4] arm: introduce psci_smp_ops
In-Reply-To: <alpine.LFD.2.03.1304191223280.17375@syhkavp.arg>
Message-ID: <alpine.DEB.2.02.1304191739120.7254@kaball.uk.xensource.com>
References: <alpine.DEB.2.02.1304031239550.5078@kaball.uk.xensource.com> <1365167495-18508-1-git-send-email-stefano.stabellini@eu.citrix.com> <20130418161341.GB14496@n2100.arm.linux.org.uk> <alpine.DEB.2.02.1304181714560.7254@kaball.uk.xensource.com>
 <alpine.LFD.2.03.1304181237480.17375@syhkavp.arg> <alpine.DEB.2.02.1304181749260.7254@kaball.uk.xensource.com> <alpine.LFD.2.03.1304181336280.17375@syhkavp.arg> <alpine.DEB.2.02.1304191035360.7254@kaball.uk.xensource.com> <alpine.LFD.2.03.1304191146230.17375@syhkavp.arg>
 <1366388166.29403.2.camel@dagon.hellion.org.uk> <alpine.LFD.2.03.1304191223280.17375@syhkavp.arg>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 19 Apr 2013, Nicolas Pitre wrote:
> On Fri, 19 Apr 2013, Ian Campbell wrote:
> 
> > On Fri, 2013-04-19 at 16:47 +0100, Nicolas Pitre wrote:
> > > No one should be probing registers without making sure it is safe to do 
> > > so.  Even on non virtualized hardware this can be a dangerous thing to 
> > > do.
> > 
> > Won't people writing per machine code consider, not unreasonably, that
> > having been called through a mdesc machine specific hook constitutes
> > enough "making sure" that they think it is safe to touch registers which
> > are specific to that machine?
> 
> Remember that this hook was introduced to decide at run time between 
> different possibilities for SMP ops on the _same_ machine configuration.  
> That machine shouldn't do things which is not permitted on either 
> possible alternatives already.  So far the actual usage of that hook 
> only looks in the DT to make a decision.  But even if it were to touch 
> the hardware, that means it has to be safe to do so on all the possible 
> hardware variations this mdesc is associated to.

This last sentence is the key.

It is not guaranteed that being safe on "all the possible hardware
variations this mdesc is associated to" and being safe on Xen are the
same thing.

What if the same magic configuration register exists on all the possible
variations of the platform?
I understand that it is unlikely but I think it is a possibility.

If we don't take further precautions I'll be forced to regularly scan
the list for smp_init implementations and look for possible breakages,
pointing the unaware author of the patches to this conversation.
Honestly it is not my idea of fun.


> And if Xen wants to emulate one of those hardware alternatives, then it 
> better be ready to emulate it properly, or manage for _another_ mdesc to 
> be selected instead.  That's why mach-virt was introduced.

I don't mean to argue pointlessly here, but I thought that it was clear
that Xen does not emulate any hardware interfaces at all.

Of course when a convenient virtualization aware hardware interface is
available (the vGIC for example) Xen is going to use it, but other than
that no emulation is going to be done.


> So in my opinion there is just no issue here.

Not now, and maybe not even in the near future.
But I feel that we are taking an error prone approach.
