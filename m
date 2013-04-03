Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759786Ab3DCOAI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Apr 2013 10:00:08 -0400
Received: from mail-qc0-f178.google.com ([209.85.216.178]:64295 "EHLO
	mail-qc0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757691Ab3DCOAG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Apr 2013 10:00:06 -0400
Date: Wed, 3 Apr 2013 10:00:02 -0400 (EDT)
From: Nicolas Pitre <nicolas.pitre@linaro.org>
To: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
cc: "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Will Deacon <will.deacon@arm.com>, Arnd Bergmann <arnd@arndb.de>,
        "rob.herring@calxeda.com" <rob.herring@calxeda.com>
Subject: Re: [PATCH v5 3/3] xen/arm: introduce xen_early_init, use PSCI on
 xen
In-Reply-To: <alpine.DEB.2.02.1304031217310.5078@kaball.uk.xensource.com>
Message-ID: <alpine.LFD.2.03.1304030955180.1171@syhkavp.arg>
References: <alpine.DEB.2.02.1304021700380.5078@kaball.uk.xensource.com> <1364919374-7836-3-git-send-email-stefano.stabellini@eu.citrix.com> <alpine.LFD.2.03.1304021325230.1171@syhkavp.arg> <alpine.DEB.2.02.1304031217310.5078@kaball.uk.xensource.com>
User-Agent: Alpine 2.03 (LFD 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 3 Apr 2013, Stefano Stabellini wrote:

> On Tue, 2 Apr 2013, Nicolas Pitre wrote:
> > On Tue, 2 Apr 2013, Stefano Stabellini wrote:
> > 
> > > @@ -176,27 +178,30 @@ static int __init xen_secondary_init(unsigned int cpu)
> > >  	return 0;
> > >  }
> > >  
> > > +static void __init xen_smp_init(void)
> > > +{
> > > +	if (psci_smp_available())
> > > +		smp_set_ops(&psci_smp_ops);
> > > +}
> > > +
> > 
> > I still don't understand why you need to do this.  Why can't you just 
> > rely on the next priority which is to set PSCI ops by default if 
> > available?  Using this hook for Xen doesn't look justified. As it is, 
> > you break MCPM.
> > 
> > As I explained to you, MCPM will end up using PSCI as well when 
> > available, which I think should be sufficient for your concern.
> 
> The smp_init hook is not limited to MCPM or the versatile express
> platform. It's a generic hook that can be used by any platform and can
> override the platform smp_ops or the psci_smp_ops depending on platform
> specific configurations.
> 
> Configurations that I am pretty sure won't be available on Xen anyway,
> while I am certain that using psci_smp_ops would work.
> 
> It seems to me that relying on the fact that only versatile express and
> only MCPM use smp_init, even though it might work today, it's very
> fragile and could break tomorrow without any of us noticing.

I claim: this breaks MCPM today.

You claim: the alternative _could_ break with Xen tomorrow.

Could we please wait until there is an actual problem with Xen before 
being overly defensive in the code?


Nicolas
