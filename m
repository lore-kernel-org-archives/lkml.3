Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752771AbaACSBI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Jan 2014 13:01:08 -0500
Received: from userp1040.oracle.com ([156.151.31.81]:47033 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751125AbaACSBH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Jan 2014 13:01:07 -0500
Date: Fri, 3 Jan 2014 12:59:49 -0500
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
Cc: linux-kernel@vger.kernel.org, xen-devel@lists.xenproject.org,
        boris.ostrovsky@oracle.com, david.vrabel@citrix.com,
        mukesh.rathor@oracle.com
Subject: Re: [PATCH v12 17/18] xen/pvh/arm/arm64: Disable PV code that does
 not work with PVH (v2)
Message-ID: <20140103175949.GA28551@phenom.dumpdata.com>
References: <1388550945-25499-1-git-send-email-konrad.wilk@oracle.com>
 <1388550945-25499-18-git-send-email-konrad.wilk@oracle.com>
 <alpine.DEB.2.02.1401031610470.8667@kaball.uk.xensource.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.02.1401031610470.8667@kaball.uk.xensource.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 03, 2014 at 04:22:01PM +0000, Stefano Stabellini wrote:
> On Tue, 31 Dec 2013, Konrad Rzeszutek Wilk wrote:
> > From: Mukesh Rathor <mukesh.rathor@oracle.com>
> > 
> > As we do not have yet a mechanism for that.
> > 
> > This also impacts the ARM/ARM64 code (which does not have
> > hotplug support yet).
> > 
> > Signed-off-by: Mukesh Rathor <mukesh.rathor@oracle.com>
> > Signed-off-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
> > ---
> >  drivers/xen/cpu_hotplug.c | 4 +++-
> >  1 file changed, 3 insertions(+), 1 deletion(-)
> > 
> > diff --git a/drivers/xen/cpu_hotplug.c b/drivers/xen/cpu_hotplug.c
> > index cc6513a..5f80802 100644
> > --- a/drivers/xen/cpu_hotplug.c
> > +++ b/drivers/xen/cpu_hotplug.c
> > @@ -4,6 +4,7 @@
> >  
> >  #include <xen/xen.h>
> >  #include <xen/xenbus.h>
> > +#include <xen/features.h>
> >  
> >  #include <asm/xen/hypervisor.h>
> >  #include <asm/cpu.h>
> > @@ -102,7 +103,8 @@ static int __init setup_vcpu_hotplug_event(void)
> >  	static struct notifier_block xsn_cpu = {
> >  		.notifier_call = setup_cpu_watcher };
> >  
> > -	if (!xen_pv_domain())
> > +	/* PVH/ARM/ARM64 TBD/FIXME: future work */
> > +	if (!xen_pv_domain() || xen_feature(XENFEAT_auto_translated_physmap))
> >  		return -ENODEV;
> >  
> >  	register_xenstore_notifier(&xsn_cpu);
> 
> Sorry for being a bit obnoxious but I was thinking that using a
> xen_feature(XENFEAT_auto_translated_physmap) check is conceptually
> wrong, because cpu hotplug and nested paging are orthogonal.

Yeah, you should be sorry :-) (Just joking - appreciate your
input and review)
> 
> Given that we most probably want to follow the PV path for cpu_hotplug
> (that is using drivers/xen/cpu_hotplug.c), is there actually a problem
> with building and initializing it on PVH guests?

It hasn't been tested..

> If it works as it is, I would be tempted to leave it for now.

..until now and it actually looks to work.

> 
> Otherwise the patch is OK and you can add my Acked-by.
