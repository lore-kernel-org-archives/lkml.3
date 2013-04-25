Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757674Ab3DYKZJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Apr 2013 06:25:09 -0400
Received: from smtp02.citrix.com ([66.165.176.63]:13895 "EHLO
	SMTP02.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754852Ab3DYKZG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Apr 2013 06:25:06 -0400
X-IronPort-AV: E=Sophos;i="4.87,548,1363132800"; 
   d="scan'208";a="20476882"
Date: Thu, 25 Apr 2013 11:25:01 +0100
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
        "olof@lixom.net" <olof@lixom.net>, Jon Medhurst <tixy@linaro.org>
Subject: Re: [PATCH v8 2/2] ARM: Enable selection of SMP operations at boot
 time
In-Reply-To: <20130425084933.GB12848@mudshark.cambridge.arm.com>
Message-ID: <alpine.DEB.2.02.1304251123410.4180@kaball.uk.xensource.com>
References: <alpine.DEB.2.02.1304241935010.4180@kaball.uk.xensource.com> <1366828819-10745-2-git-send-email-stefano.stabellini@eu.citrix.com> <20130425084933.GB12848@mudshark.cambridge.arm.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 25 Apr 2013, Will Deacon wrote:
> On Wed, Apr 24, 2013 at 07:40:19PM +0100, Stefano Stabellini wrote:
> > From: Jon Medhurst <tixy@linaro.org>
> > 
> > Add a new 'smp_init' hook to machine_desc so platforms can specify a
> > function to be used to setup smp ops instead of having a statically
> > defined value.  The hook must return true when smp_ops are initialized.
> > If false the static mdesc->smp_ops will be used by default.
> > 
> > Signed-off-by: Jon Medhurst <tixy@linaro.org>
> > Signed-off-by: Nicolas Pitre <nicolas.pitre@linaro.org>
> > Signed-off-by: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
> > Reviewed-by: Santosh Shilimkar <santosh.shilimkar@ti.com>
> > ---
> >  arch/arm/include/asm/mach/arch.h |    4 ++++
> >  arch/arm/kernel/setup.c          |   10 ++++++----
> >  2 files changed, 10 insertions(+), 4 deletions(-)
> 
> [...]
> 
> >  	if (is_smp()) {
> > -		if (psci_smp_available())
> > -			smp_set_ops(&psci_smp_ops);
> > -		else if (mdesc->smp)
> > -			smp_set_ops(mdesc->smp);
> > +		if (!mdesc->smp_init || !mdesc->smp_init()) {
> 
> Minor nit, but this feels backwards to me. We usually return 0 on success,
> yet we're saying here that if mdesc->smp_init() returns 0, then we go and
> override the smp ops.

I am OK with changing the interface to return an int instead of a bool,
but given that Nicolas is the main user of smp_init at the moment, I'll
wait for his opinion.
