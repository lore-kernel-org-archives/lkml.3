Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965161Ab3E2SCS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 May 2013 14:02:18 -0400
Received: from aserp1040.oracle.com ([141.146.126.69]:28925 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934995Ab3E2SCJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 May 2013 14:02:09 -0400
Date: Wed, 29 May 2013 14:01:32 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
Cc: xen-devel@lists.xensource.com, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, marc.zyngier@arm.com,
        will.deacon@arm.com, Ian.Campbell@citrix.com
Subject: Re: [PATCH v4 1/4] xen: move xen_setup_runstate_info and
 get_runstate_snapshot to drivers/xen/time.c
Message-ID: <20130529180132.GB10845@phenom.dumpdata.com>
References: <alpine.DEB.2.02.1305281835080.4799@kaball.uk.xensource.com>
 <1369763672-12919-1-git-send-email-stefano.stabellini@eu.citrix.com>
 <20130528181515.GB27718@phenom.dumpdata.com>
 <alpine.DEB.2.02.1305291159220.4799@kaball.uk.xensource.com>
 <20130529155544.GG23775@phenom.dumpdata.com>
 <alpine.DEB.2.02.1305291718430.4799@kaball.uk.xensource.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.02.1305291718430.4799@kaball.uk.xensource.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > > > > +void xen_setup_runstate_info(int cpu)
> > > > > +{
> > > > > +	struct vcpu_register_runstate_memory_area area;
> > > > > +
> > > > > +	area.addr.v = &per_cpu(xen_runstate, cpu);
> > > > > +
> > > > > +	if (HYPERVISOR_vcpu_op(VCPUOP_register_runstate_memory_area,
> > > > > +			       cpu, &area))
> > > > > +		BUG();
> > > > 
> > > > The original code did:
> > > > 
> > > > -       rc = HYPERVISOR_vcpu_op(VCPUOP_register_runstate_memory_area, cpu,
> > > > -                               &area);
> > > > -       WARN_ON(rc && rc != -ENOSYS);
> > > > -
> > > > Any reason not to do this?
> > > 
> > > The original x86 code just BUGs out: I took that version over the ia64
> > > version.
> > 
> > Ah, I see it now. OK, then this looks good to me.
> > 
> 
> Can I add your acked-by? ;-)

How about?

Reviewed-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
