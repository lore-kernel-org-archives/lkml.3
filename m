Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932773Ab3DYQ7s (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Apr 2013 12:59:48 -0400
Received: from smtp.eu.citrix.com ([46.33.159.39]:64525 "EHLO
	SMTP.EU.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932692Ab3DYQ7r (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Apr 2013 12:59:47 -0400
X-IronPort-AV: E=Sophos;i="4.87,551,1363132800"; 
   d="scan'208";a="3945943"
Message-ID: <1366909184.3142.0.camel@zakaz.uk.xensource.com>
Subject: Re: [PATCH v4 2/7] xen/arm: SMP support
From: Ian Campbell <Ian.Campbell@citrix.com>
To: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
CC: "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "konrad.wilk@oracle.com" <konrad.wilk@oracle.com>
Date: Thu, 25 Apr 2013 17:59:44 +0100
In-Reply-To: <alpine.DEB.2.02.1304251503100.4180@kaball.uk.xensource.com>
References: <alpine.DEB.2.02.1304242012590.4180@kaball.uk.xensource.com>
	 <1366831695-13214-2-git-send-email-stefano.stabellini@eu.citrix.com>
	 <1366897221.20256.544.camel@zakaz.uk.xensource.com>
	 <alpine.DEB.2.02.1304251503100.4180@kaball.uk.xensource.com>
Organization: Citrix Systems, Inc.
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4-1 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> > > @@ -216,6 +245,8 @@ static int __init xen_guest_init(void)
> > >  	 * is required to use VCPUOP_register_vcpu_info to place vcpu info
> > >  	 * for secondary CPUs as they are brought up. */
> > >  	per_cpu(xen_vcpu, 0) = &HYPERVISOR_shared_info->vcpu_info[0];
> > > +	for_each_online_cpu(i)
> > > +		xen_secondary_init(i);
> > >  
> > >  	gnttab_init();
> > >  	if (!xen_initial_domain())
> > [...]
> > > @@ -244,7 +280,7 @@ static int __init xen_init_events(void)
> > >  		return -EINVAL;
> > >  	}
> > >  
> > > -	enable_percpu_irq(xen_events_irq, 0);
> > > +	on_each_cpu(xen_percpu_enable_events, NULL, 0);
> > 
> > It feels like there ought to be some sort of per-cpu bringup callback
> > which takes care of these dynamically. Maybe that doesn't matter until
> > we get vcpu hotplug going?
> 
> I suspect there isn't one, considering that on_each_cpu is also used by 
> kvm_vgic_hyp_init, kvm_timer_hyp_init and others.

Could we use cpu_notifiers for this?


