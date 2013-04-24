Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756417Ab3DXSNV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Apr 2013 14:13:21 -0400
Received: from smtp.citrix.com ([66.165.176.89]:33676 "EHLO SMTP.CITRIX.COM"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755277Ab3DXSNT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Apr 2013 14:13:19 -0400
X-IronPort-AV: E=Sophos;i="4.87,545,1363132800"; 
   d="scan'208";a="21362095"
Date: Wed, 24 Apr 2013 19:13:15 +0100
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
In-Reply-To: <alpine.LFD.2.03.1304221151200.17375@syhkavp.arg>
Message-ID: <alpine.DEB.2.02.1304241911420.4180@kaball.uk.xensource.com>
References: <alpine.DEB.2.02.1304031239550.5078@kaball.uk.xensource.com> <1365167495-18508-1-git-send-email-stefano.stabellini@eu.citrix.com> <20130418161341.GB14496@n2100.arm.linux.org.uk> <alpine.DEB.2.02.1304181714560.7254@kaball.uk.xensource.com>
 <alpine.LFD.2.03.1304181237480.17375@syhkavp.arg> <alpine.DEB.2.02.1304181749260.7254@kaball.uk.xensource.com> <alpine.LFD.2.03.1304181336280.17375@syhkavp.arg> <alpine.DEB.2.02.1304191035360.7254@kaball.uk.xensource.com> <alpine.LFD.2.03.1304191146230.17375@syhkavp.arg>
 <1366388166.29403.2.camel@dagon.hellion.org.uk> <alpine.LFD.2.03.1304191223280.17375@syhkavp.arg> <alpine.DEB.2.02.1304191739120.7254@kaball.uk.xensource.com> <1366644069.20256.8.camel@zakaz.uk.xensource.com>
 <alpine.LFD.2.03.1304221151200.17375@syhkavp.arg>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 22 Apr 2013, Nicolas Pitre wrote:
> > I think the key thing that non-Xen folks aren't aware of is that
> > although Xen passes the majority of the underlying hardware to the dom0
> > kernel to manage one of the few things it does not expose to guests
> > (where "guests" includes dom0) is the SMP topology of the underlying system.
> 
> I suspect it is unlikely to pass on the DT information about the CCI 
> either.  Which means that, in the case that started this thread, the 
> smp_init function needed by MCPM will simply return false and the next 
> priority in the list i.e. plain PSCI will be initialized instead.
> 
> I don't forsee the need to poke at the hardware directly within 
> ->smp_init, not since everything is moving to DT now.
> 
> Sure there are ways to screw up Xen support from within this hook, but 
> that can be achieved in many other places.  Will Xen take over every 
> possible hooks in the kernel to prevent that from happening?
> 
> So please let's not cry wolf needlessly.

OK, you convinced me :-)
I'll drop the patch.
