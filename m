Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756922Ab3DZPwH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Apr 2013 11:52:07 -0400
Received: from smtp.citrix.com ([66.165.176.89]:24403 "EHLO SMTP.CITRIX.COM"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756113Ab3DZPwF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Apr 2013 11:52:05 -0400
X-IronPort-AV: E=Sophos;i="4.87,559,1363132800"; 
   d="scan'208";a="21830888"
Date: Fri, 26 Apr 2013 16:36:37 +0100
From: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
X-X-Sender: sstabellini@kaball.uk.xensource.com
To: Nicolas Pitre <nicolas.pitre@linaro.org>
CC: Will Deacon <will.deacon@arm.com>,
        Stefano Stabellini <Stefano.Stabellini@eu.citrix.com>,
        "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "arnd@arndb.de" <arnd@arndb.de>,
        "rob.herring@calxeda.com" <rob.herring@calxeda.com>,
        "linux@arm.linux.org.uk" <linux@arm.linux.org.uk>,
        "olof@lixom.net" <olof@lixom.net>, Jon Medhurst <tixy@linaro.org>
Subject: Re: [PATCH v8 2/2] ARM: Enable selection of SMP operations at boot
 time
In-Reply-To: <alpine.LFD.2.03.1304251040430.1258@syhkavp.arg>
Message-ID: <alpine.DEB.2.02.1304261629300.4180@kaball.uk.xensource.com>
References: <alpine.DEB.2.02.1304241935010.4180@kaball.uk.xensource.com> <1366828819-10745-2-git-send-email-stefano.stabellini@eu.citrix.com> <20130425084933.GB12848@mudshark.cambridge.arm.com> <alpine.LFD.2.03.1304251040430.1258@syhkavp.arg>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 25 Apr 2013, Nicolas Pitre wrote:
> On Thu, 25 Apr 2013, Will Deacon wrote:
> 
> > On Wed, Apr 24, 2013 at 07:40:19PM +0100, Stefano Stabellini wrote:
> > > From: Jon Medhurst <tixy@linaro.org>
> > > 
> > > Add a new 'smp_init' hook to machine_desc so platforms can specify a
> > > function to be used to setup smp ops instead of having a statically
> > > defined value.  The hook must return true when smp_ops are initialized.
> > > If false the static mdesc->smp_ops will be used by default.
> > > 
> > > Signed-off-by: Jon Medhurst <tixy@linaro.org>
> > > Signed-off-by: Nicolas Pitre <nicolas.pitre@linaro.org>
> > > Signed-off-by: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
> > > Reviewed-by: Santosh Shilimkar <santosh.shilimkar@ti.com>
> > > ---
> > >  arch/arm/include/asm/mach/arch.h |    4 ++++
> > >  arch/arm/kernel/setup.c          |   10 ++++++----
> > >  2 files changed, 10 insertions(+), 4 deletions(-)
> > 
> > [...]
> > 
> > >  	if (is_smp()) {
> > > -		if (psci_smp_available())
> > > -			smp_set_ops(&psci_smp_ops);
> > > -		else if (mdesc->smp)
> > > -			smp_set_ops(mdesc->smp);
> > > +		if (!mdesc->smp_init || !mdesc->smp_init()) {
> > 
> > Minor nit, but this feels backwards to me. We usually return 0 on success,
> > yet we're saying here that if mdesc->smp_init() returns 0, then we go and
> > override the smp ops.
> 
> It doesn't return 0, but true or false.  So, semantically, if ->smp_init 
> returns false, that means it didn't initialize anything.

In absence of other comments, I am going to leave as it is now.
