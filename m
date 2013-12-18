Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755217Ab3LRPW7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Dec 2013 10:22:59 -0500
Received: from smtp.citrix.com ([66.165.176.89]:65142 "EHLO SMTP.CITRIX.COM"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754878Ab3LRPW5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Dec 2013 10:22:57 -0500
X-IronPort-AV: E=Sophos;i="4.95,508,1384300800"; 
   d="scan'208";a="85775257"
Date: Wed, 18 Dec 2013 15:22:23 +0000
From: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
X-X-Sender: sstabellini@kaball.uk.xensource.com
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
CC: Stefano Stabellini <stefano.stabellini@eu.citrix.com>,
        <xen-devel@lists.xenproject.org>, <linux-kernel@vger.kernel.org>,
        <boris.ostrovsky@oracle.com>, <david.vrabel@citrix.com>,
        <mukesh.rathor@oracle.com>, <jbeulich@suse.com>
Subject: Re: [Xen-devel] [PATCH v11 11/12] xen/pvh: Disable PV code that does
 not work with PVH.
In-Reply-To: <20131218145602.GA4934@phenom.dumpdata.com>
Message-ID: <alpine.DEB.2.02.1312181519430.8667@kaball.uk.xensource.com>
References: <1387313503-31362-1-git-send-email-konrad.wilk@oracle.com> <1387313503-31362-12-git-send-email-konrad.wilk@oracle.com> <alpine.DEB.2.02.1312181416230.8667@kaball.uk.xensource.com> <20131218145602.GA4934@phenom.dumpdata.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
X-DLP: MIA1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 18 Dec 2013, Konrad Rzeszutek Wilk wrote:
> On Wed, Dec 18, 2013 at 02:19:28PM +0000, Stefano Stabellini wrote:
> > On Tue, 17 Dec 2013, Konrad Rzeszutek Wilk wrote:
> > > From: Mukesh Rathor <mukesh.rathor@oracle.com>
> > > 
> > > As we do not have yet a mechanism for that.
> > > 
> > > Signed-off-by: Mukesh Rathor <mukesh.rathor@oracle.com>
> > > Signed-off-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
> > 
> > Even though we don't even compile cpu_hotplug on ARM yet, I don't like
> > this change because it affects ARM guests too.
> 
> Perhaps then just #ifdef it with CONFIG_X86 for right now?

That or a comment.


> > Please add a note about ARM guests in the FIXME line.
> 
> Good idea. Is the offline/online part working in ARM? Or is that it
> has not been tested?

At the moment we are using PSCI only on ARM (that is a firmware
interface that we are "emulating" in the hypervisor), but it is not
exactly the same: PSCI is about enabling secondary cpus or
disabling/suspending cpus. It is not about cpu-hotplug. So one day we
might want both.



> > >  drivers/xen/cpu_hotplug.c | 4 +++-
> > >  1 file changed, 3 insertions(+), 1 deletion(-)
> > > 
> > > diff --git a/drivers/xen/cpu_hotplug.c b/drivers/xen/cpu_hotplug.c
> > > index cc6513a..cbb02af 100644
> > > --- a/drivers/xen/cpu_hotplug.c
> > > +++ b/drivers/xen/cpu_hotplug.c
> > > @@ -4,6 +4,7 @@
> > >  
> > >  #include <xen/xen.h>
> > >  #include <xen/xenbus.h>
> > > +#include <xen/features.h>
> > >  
> > >  #include <asm/xen/hypervisor.h>
> > >  #include <asm/cpu.h>
> > > @@ -102,7 +103,8 @@ static int __init setup_vcpu_hotplug_event(void)
> > >  	static struct notifier_block xsn_cpu = {
> > >  		.notifier_call = setup_cpu_watcher };
> > >  
> > > -	if (!xen_pv_domain())
> > > +	/* PVH TBD/FIXME: future work */
> > > +	if (!xen_pv_domain() || xen_feature(XENFEAT_auto_translated_physmap))
> > >  		return -ENODEV;
> > >  
> > >  	register_xenstore_notifier(&xsn_cpu);
> > 
> 
