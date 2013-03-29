Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756770Ab3C2SKz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Mar 2013 14:10:55 -0400
Received: from smtp.citrix.com ([66.165.176.89]:47266 "EHLO SMTP.CITRIX.COM"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756522Ab3C2SKy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Mar 2013 14:10:54 -0400
X-IronPort-AV: E=Sophos;i="4.87,374,1363132800"; 
   d="scan'208";a="16428519"
Date: Fri, 29 Mar 2013 18:10:48 +0000
From: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
X-X-Sender: sstabellini@kaball.uk.xensource.com
To: Nicolas Pitre <nicolas.pitre@linaro.org>
CC: Stefano Stabellini <Stefano.Stabellini@eu.citrix.com>,
        "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Will Deacon <will.deacon@arm.com>, Arnd Bergmann <arnd@arndb.de>,
        "marc.zyngier@arm.com" <marc.zyngier@arm.com>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>
Subject: Re: [PATCH v4 2/2] arm: prefer PSCI for SMP bringup
In-Reply-To: <alpine.LFD.2.03.1303291400190.1372@syhkavp.arg>
Message-ID: <alpine.DEB.2.02.1303291807270.4430@kaball.uk.xensource.com>
References: <1364575371-8926-2-git-send-email-stefano.stabellini@eu.citrix.com> <alpine.LFD.2.03.1303291320580.1372@syhkavp.arg> <alpine.DEB.2.02.1303291735080.4430@kaball.uk.xensource.com> <alpine.LFD.2.03.1303291400190.1372@syhkavp.arg>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 29 Mar 2013, Nicolas Pitre wrote:
> On Fri, 29 Mar 2013, Stefano Stabellini wrote:
> 
> > On Fri, 29 Mar 2013, Nicolas Pitre wrote:
> > > This way the 
> > > priority order would be:
> > > 
> > > - If mdesc->smp_init is non null then use that.
> > > 
> > > - Otherwise, if PSCI is available then use that.
> > > 
> > > - Otherwise use mdesc->smp.
> > > 
> > > This way, if the PSCI default has to be overriden (like in the MCPM case 
> > > because it needs to wrap PSCI itself, or to cover Rob's concern) then 
> > > this can be achieved at run time on a per mdesc basis.
> > 
> > Actually that's not a bad idea, it could make everybody happy.
> > What about the following, in this precise order:
> > 
> > - if a xen hypervisor node is present on device tree, use PSCI;
> > - otherwise if mdesc->smp_init is non null then use it;
> > - otherwise if PSCI is available then use it;
> > - otherwise use mdesc->smp.
> > 
> > It's the most practical solution to satisfy everybody's needs.
> 
> Regardless of my previous email suggesting a mdesc for xen, I still 
> don't understand why you need this absolute priority for Xen.  Isn't my 
> original suggestion sufficient?
> 
> The likely reason why mdesc->smp_init might be needed is to provide an 
> extra encapsulation layer before actually using PSCI instead of using it 
> directly.  Why would you need to bypass that?

Uhm.. maybe I wouldn't, I am not 100% sure TBH.

I am expecting that this "extra encapsulation layer" would read/write
some platform specific registers that Xen doesn't export.
If this is the case, then we would need to bypass it.

But if it's just to mangle parameters, then it should be OK.
