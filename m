Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758444Ab3EHQHM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 May 2013 12:07:12 -0400
Received: from smtp02.citrix.com ([66.165.176.63]:51270 "EHLO
	SMTP02.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758279Ab3EHQHJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 May 2013 12:07:09 -0400
X-IronPort-AV: E=Sophos;i="4.87,635,1363132800"; 
   d="scan'208";a="22916354"
Date: Wed, 8 May 2013 17:07:06 +0100
From: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
X-X-Sender: sstabellini@kaball.uk.xensource.com
To: Marc Zyngier <marc.zyngier@arm.com>
CC: Stefano Stabellini <Stefano.Stabellini@eu.citrix.com>,
        "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "konrad.wilk@oracle.com" <konrad.wilk@oracle.com>,
        Will Deacon <Will.Deacon@arm.com>,
        "linux@arm.linux.org.uk" <linux@arm.linux.org.uk>,
        "nico@linaro.org" <nico@linaro.org>,
        "cov@codeaurora.org" <cov@codeaurora.org>,
        "arnd@arndb.de" <arnd@arndb.de>, "olof@lixom.net" <olof@lixom.net>
Subject: Re: [PATCH v3 3/4] arm: introduce CONFIG_PARAVIRT, PARAVIRT_TIME_ACCOUNTING
 and pv_time_ops
In-Reply-To: <518A7763.4050509@arm.com>
Message-ID: <alpine.DEB.2.02.1305081704530.18865@kaball.uk.xensource.com>
References: <alpine.DEB.2.02.1305081446580.18865@kaball.uk.xensource.com> <1368027714-14506-3-git-send-email-stefano.stabellini@eu.citrix.com> <518A7763.4050509@arm.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 8 May 2013, Marc Zyngier wrote:
> Hi Stefano,
> 
> On 08/05/13 16:41, Stefano Stabellini wrote:
> > Introduce CONFIG_PARAVIRT and PARAVIRT_TIME_ACCOUNTING on ARM.
> > 
> > The only paravirt interface supported is pv_time_ops.steal_clock, so no
> > runtime pvops patching needed.
> > 
> > This allows us to make use of steal_account_process_tick for stolen
> > ticks accounting.
> > 
> > Changes in v3:
> > - improve commit description and Kconfig help text;
> > - no need to initialize pv_time_ops;
> > - add PARAVIRT_TIME_ACCOUNTING.
> > 
> > Signed-off-by: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
> > CC: linux@arm.linux.org.uk
> > CC: will.deacon@arm.com
> > CC: nico@linaro.org
> > CC: marc.zyngier@arm.com
> > CC: cov@codeaurora.org
> > CC: arnd@arndb.de
> > CC: olof@lixom.net
> > ---
> >  arch/arm/Kconfig                |   20 ++++++++++++++++++++
> >  arch/arm/include/asm/paravirt.h |   19 +++++++++++++++++++
> >  arch/arm/kernel/Makefile        |    1 +
> >  arch/arm/kernel/paravirt.c      |   25 +++++++++++++++++++++++++
> >  4 files changed, 65 insertions(+), 0 deletions(-)
> >  create mode 100644 arch/arm/include/asm/paravirt.h
> >  create mode 100644 arch/arm/kernel/paravirt.c
> > 
> > diff --git a/arch/arm/Kconfig b/arch/arm/Kconfig
> > index 344e299..89ee2f1 100644
> > --- a/arch/arm/Kconfig
> > +++ b/arch/arm/Kconfig
> > @@ -1887,12 +1887,32 @@ config XEN_DOM0
> >  	def_bool y
> >  	depends on XEN
> >  
> > +config PARAVIRT
> > +	bool "Enable paravirtualization code"
> > +	---help---
> > +	  This changes the kernel so it can modify itself when it is run
> > +	  under a hypervisor, potentially improving performance significantly
> > +	  over full virtualization.
> > +
> > +config PARAVIRT_TIME_ACCOUNTING
> > +	bool "Paravirtual steal time accounting"
> > +	select PARAVIRT
> 
> Surely you meant "depends on" instead of "select" here? Otherwise I
> don't really see the point of PARAVIRT...

I agree with you that "depends on" seems to be the right thing here, but
on x86 is actually select.

The original commit is 095c0aa83e52d6c3dd7168610746703921f570af.
