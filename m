Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965273Ab3CZP4G (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Mar 2013 11:56:06 -0400
Received: from smtp.citrix.com ([66.165.176.89]:59372 "EHLO SMTP.CITRIX.COM"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965006Ab3CZPz7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Mar 2013 11:55:59 -0400
X-IronPort-AV: E=Sophos;i="4.84,913,1355097600"; 
   d="scan'208";a="15654845"
Date: Tue, 26 Mar 2013 15:55:55 +0000
From: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
X-X-Sender: sstabellini@kaball.uk.xensource.com
To: Arnd Bergmann <arnd@arndb.de>
CC: Will Deacon <will.deacon@arm.com>,
        Stefano Stabellini <Stefano.Stabellini@eu.citrix.com>,
        "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "konrad.wilk@oracle.com" <konrad.wilk@oracle.com>,
        Ian Campbell <Ian.Campbell@citrix.com>,
        Marc Zyngier <Marc.Zyngier@arm.com>,
        "linux@arm.linux.org.uk" <linux@arm.linux.org.uk>,
        "nico@linaro.org" <nico@linaro.org>
Subject: Re: [PATCH v2 6/6] [RFC] arm: use PSCI if available
In-Reply-To: <201303261546.50194.arnd@arndb.de>
Message-ID: <alpine.DEB.2.02.1303261553120.4430@kaball.uk.xensource.com>
References: <alpine.DEB.2.02.1303261423530.4430@kaball.uk.xensource.com> <alpine.DEB.2.02.1303261509080.4430@kaball.uk.xensource.com> <20130326153730.GA22368@mudshark.cambridge.arm.com> <201303261546.50194.arnd@arndb.de>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 26 Mar 2013, Arnd Bergmann wrote:
> On Tuesday 26 March 2013, Will Deacon wrote:
> > > They can even base the implementation of their smp_ops on the current
> > > psci code, in order to facilitate that I could get rid of psci_ops
> > > (which initialization is based on device tree) and export the psci_cpu_*
> > > functions instead, so that they can be called directly by other smp_ops.
> > 
> > Again, I think this destroys the layering. The whole point is that the PSCI
> > functions are called from within something that understands precisely how to
> > talk to the firmware and what it is capable of.
> 
> Right, we probably the psci smp ops to be separate from the rest of the psci
> code, but I also think that Stefano is right that we should let any platform
> use the psci smp ops if possible, rather than having to implement their own.

[...]
 
> The part that I'm most interested in is making it possible for a platform
> to kill off its native smp ops in the kernel by implementing the psci
> ops. I think it's a good strategy to use psci by default if both 
> platform and psci implementations are available.

I fully agree, and Xen would use it as is.

If the psci node on DT only signifies the presence of psci, not that it
should be used for smp_ops, then we need another DT node or property to
say "this machine uses smp_psci_ops".
