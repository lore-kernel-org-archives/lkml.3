Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932527Ab3DYOmp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Apr 2013 10:42:45 -0400
Received: from mail-qc0-f170.google.com ([209.85.216.170]:59689 "EHLO
	mail-qc0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756916Ab3DYOmo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Apr 2013 10:42:44 -0400
Date: Thu, 25 Apr 2013 10:42:41 -0400 (EDT)
From: Nicolas Pitre <nicolas.pitre@linaro.org>
To: Will Deacon <will.deacon@arm.com>
cc: Stefano Stabellini <stefano.stabellini@eu.citrix.com>,
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
In-Reply-To: <20130425084933.GB12848@mudshark.cambridge.arm.com>
Message-ID: <alpine.LFD.2.03.1304251040430.1258@syhkavp.arg>
References: <alpine.DEB.2.02.1304241935010.4180@kaball.uk.xensource.com> <1366828819-10745-2-git-send-email-stefano.stabellini@eu.citrix.com> <20130425084933.GB12848@mudshark.cambridge.arm.com>
User-Agent: Alpine 2.03 (LFD 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
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

It doesn't return 0, but true or false.  So, semantically, if ->smp_init 
returns false, that means it didn't initialize anything.


Nicolas
