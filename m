Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758331Ab3DSJku (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Apr 2013 05:40:50 -0400
Received: from smtp02.citrix.com ([66.165.176.63]:41139 "EHLO
	SMTP02.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757430Ab3DSJks (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Apr 2013 05:40:48 -0400
X-IronPort-AV: E=Sophos;i="4.87,508,1363132800"; 
   d="scan'208";a="19443410"
Date: Fri, 19 Apr 2013 10:40:34 +0100
From: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
X-X-Sender: sstabellini@kaball.uk.xensource.com
To: Nicolas Pitre <nicolas.pitre@linaro.org>
CC: Stefano Stabellini <Stefano.Stabellini@eu.citrix.com>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "will.deacon@arm.com" <will.deacon@arm.com>,
        "arnd@arndb.de" <arnd@arndb.de>,
        "rob.herring@calxeda.com" <rob.herring@calxeda.com>,
        "marc.zyngier@arm.com" <marc.zyngier@arm.com>
Subject: Re: [PATCH v6 1/4] arm: introduce psci_smp_ops
In-Reply-To: <alpine.LFD.2.03.1304181336280.17375@syhkavp.arg>
Message-ID: <alpine.DEB.2.02.1304191035360.7254@kaball.uk.xensource.com>
References: <alpine.DEB.2.02.1304031239550.5078@kaball.uk.xensource.com> <1365167495-18508-1-git-send-email-stefano.stabellini@eu.citrix.com> <20130418161341.GB14496@n2100.arm.linux.org.uk> <alpine.DEB.2.02.1304181714560.7254@kaball.uk.xensource.com>
 <alpine.LFD.2.03.1304181237480.17375@syhkavp.arg> <alpine.DEB.2.02.1304181749260.7254@kaball.uk.xensource.com> <alpine.LFD.2.03.1304181336280.17375@syhkavp.arg>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 18 Apr 2013, Nicolas Pitre wrote:
> On Thu, 18 Apr 2013, Stefano Stabellini wrote:
> 
> > On Thu, 18 Apr 2013, Nicolas Pitre wrote:
> > > On Thu, 18 Apr 2013, Stefano Stabellini wrote:
> > > 
> > > > On Thu, 18 Apr 2013, Russell King - ARM Linux wrote:
> > > > > This should allow the Xen problem to be resolved, because Xen will
> > > > > provide the PSCI operations, and it's correct in that case to override
> > > > > the platform's SMP operations.
> > > > 
> > > > Yes, increasing the priority of PSCI helps Xen a lot.
> > > > In order to completely solve the issue for Xen though, another patch is
> > > > needed (http://marc.info/?l=linux-kernel&m=136630106201968&w=2) because
> > > > of the introduction of smp_init.
> > > 
> > > Please look at the latest smp_init patch version I sent to you.  It 
> > > shouldn't conflict with Xen any longer.  It now returns a bool result 
> > > depending on whether it did set up smp_ops or not.
> > 
> > CPUs are virtualized by Xen and do not reflect or expose the underlying
> > SMP hardware and firmware features, so an hardware specific smp_init
> > cannot run.
> > 
> > So the smp_init patch still breaks Xen because even if smp_init can fail
> > graciously, executing a platform specific smp_init function that tries
> > to access registers and memory regions that are not present is going to
> > cause an undefined behaviour.
> 
> It won't access hardware but just look into the DT and return false if 
> nothing interesting is found.  At which point the next attempt in the 
> priority list is PSCI by default.

OK, that should work.
I am going to drop "xen/arm: introduce xen_early_init, use PSCI on xen".

We'll have to be careful enforcing that future smp_init implementations
use DT rather than probing registers. Maybe I should add a comment to
the smp_init patch to clarify that?
