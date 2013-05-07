Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758880Ab3EGM4p (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 May 2013 08:56:45 -0400
Received: from smtp.eu.citrix.com ([46.33.159.39]:50955 "EHLO
	SMTP.EU.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757143Ab3EGM4n (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 May 2013 08:56:43 -0400
X-IronPort-AV: E=Sophos;i="4.87,552,1363132800"; 
   d="scan'208";a="4300423"
Message-ID: <1367931401.26321.118.camel@zakaz.uk.xensource.com>
Subject: Re: [Xen-devel] [PATCH RFC v2 4/4] xen/arm: account for stolen ticks
From: Ian Campbell <Ian.Campbell@citrix.com>
To: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
CC: "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>,
        "marc.zyngier@arm.com" <marc.zyngier@arm.com>,
        "konrad.wilk@oracle.com" <konrad.wilk@oracle.com>,
        "will.deacon@arm.com" <will.deacon@arm.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Date: Tue, 7 May 2013 13:56:41 +0100
In-Reply-To: <alpine.DEB.2.02.1305071252350.4147@kaball.uk.xensource.com>
References: <alpine.DEB.2.02.1305061532310.4756@kaball.uk.xensource.com>
	 <1367851878-21629-4-git-send-email-stefano.stabellini@eu.citrix.com>
	 <1367918270.26321.39.camel@zakaz.uk.xensource.com>
	 <alpine.DEB.2.02.1305071252350.4147@kaball.uk.xensource.com>
Organization: Citrix Systems, Inc.
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4-1 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > > @@ -301,6 +320,10 @@ static int __init xen_init_events(void)
> > >  
> > >  	on_each_cpu(xen_percpu_init, NULL, 0);
> > >  
> > > +	pv_time_ops.steal_clock = xen_stolen_accounting;
> > > +	static_key_slow_inc(&paravirt_steal_enabled);
> > > +	static_key_slow_inc(&paravirt_steal_rq_enabled);
> > 
> > We don't seem to do this on x86 -- is that a bug on x86 on Xen?
> 
> On x86 we do all the accounting in do_stolen_accounting, called from our
> own interrupt handler (xen_timer_interrupt).
> I don't think we would gain anything by using the common infrastructure,
> we would actually loose the idle ticks accounting we do there.
> 
> Speaking of which, I don't think that pv_time_ops.steal_clock would
> properly increase CPUTIME_IDLE the way we do in do_stolen_accounting.
> 
> How much of an issue is that?

Doesn't the generic account_idle_time handle this?

Ian.

