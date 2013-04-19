Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758325Ab3DSQd0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Apr 2013 12:33:26 -0400
Received: from mail-qe0-f47.google.com ([209.85.128.47]:54856 "EHLO
	mail-qe0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757625Ab3DSQdZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Apr 2013 12:33:25 -0400
Date: Fri, 19 Apr 2013 12:33:22 -0400 (EDT)
From: Nicolas Pitre <nicolas.pitre@linaro.org>
To: Ian Campbell <Ian.Campbell@citrix.com>
cc: Stefano Stabellini <Stefano.Stabellini@eu.citrix.com>,
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
In-Reply-To: <1366388166.29403.2.camel@dagon.hellion.org.uk>
Message-ID: <alpine.LFD.2.03.1304191223280.17375@syhkavp.arg>
References: <alpine.DEB.2.02.1304031239550.5078@kaball.uk.xensource.com> <1365167495-18508-1-git-send-email-stefano.stabellini@eu.citrix.com> <20130418161341.GB14496@n2100.arm.linux.org.uk> <alpine.DEB.2.02.1304181714560.7254@kaball.uk.xensource.com>
 <alpine.LFD.2.03.1304181237480.17375@syhkavp.arg> <alpine.DEB.2.02.1304181749260.7254@kaball.uk.xensource.com> <alpine.LFD.2.03.1304181336280.17375@syhkavp.arg> <alpine.DEB.2.02.1304191035360.7254@kaball.uk.xensource.com> <alpine.LFD.2.03.1304191146230.17375@syhkavp.arg>
 <1366388166.29403.2.camel@dagon.hellion.org.uk>
User-Agent: Alpine 2.03 (LFD 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 19 Apr 2013, Ian Campbell wrote:

> On Fri, 2013-04-19 at 16:47 +0100, Nicolas Pitre wrote:
> > No one should be probing registers without making sure it is safe to do 
> > so.  Even on non virtualized hardware this can be a dangerous thing to 
> > do.
> 
> Won't people writing per machine code consider, not unreasonably, that
> having been called through a mdesc machine specific hook constitutes
> enough "making sure" that they think it is safe to touch registers which
> are specific to that machine?

Remember that this hook was introduced to decide at run time between 
different possibilities for SMP ops on the _same_ machine configuration.  
That machine shouldn't do things which is not permitted on either 
possible alternatives already.  So far the actual usage of that hook 
only looks in the DT to make a decision.  But even if it were to touch 
the hardware, that means it has to be safe to do so on all the possible 
hardware variations this mdesc is associated to.

And if Xen wants to emulate one of those hardware alternatives, then it 
better be ready to emulate it properly, or manage for _another_ mdesc to 
be selected instead.  That's why mach-virt was introduced.

So in my opinion there is just no issue here.


Nicolas
