Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754043AbaBQR4E (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Feb 2014 12:56:04 -0500
Received: from fw-tnat.austin.arm.com ([217.140.110.23]:51446 "EHLO
	collaborate-mta1.arm.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752436AbaBQR4C (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Feb 2014 12:56:02 -0500
Date: Mon, 17 Feb 2014 17:55:52 +0000
From: Catalin Marinas <catalin.marinas@arm.com>
To: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
Cc: "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "konrad.wilk@oracle.com" <konrad.wilk@oracle.com>,
        Marc Zyngier <Marc.Zyngier@arm.com>, Will Deacon <Will.Deacon@arm.com>,
        Ian Campbell <Ian.Campbell@citrix.com>,
        "linux@arm.linux.org.uk" <linux@arm.linux.org.uk>,
        "olof@lixom.net" <olof@lixom.net>, "arnd@arndb.de" <arnd@arndb.de>,
        "nico@linaro.org" <nico@linaro.org>,
        "cov@codeaurora.org" <cov@codeaurora.org>
Subject: Re: [PATCH v9 4/5] arm64: introduce CONFIG_PARAVIRT,
 PARAVIRT_TIME_ACCOUNTING and pv_time_ops
Message-ID: <20140217175552.GB8361@arm.com>
References: <alpine.DEB.2.02.1401091755390.21510@kaball.uk.xensource.com>
 <1389292336-9292-4-git-send-email-stefano.stabellini@eu.citrix.com>
 <alpine.DEB.2.02.1402171225000.27926@kaball.uk.xensource.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.02.1402171225000.27926@kaball.uk.xensource.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 17, 2014 at 12:25:42PM +0000, Stefano Stabellini wrote:
> On Thu, 9 Jan 2014, Stefano Stabellini wrote:
> > Introduce CONFIG_PARAVIRT and PARAVIRT_TIME_ACCOUNTING on ARM64.
> > Necessary duplication of paravirt.h and paravirt.c with ARM.
> > 
> > The only paravirt interface supported is pv_time_ops.steal_clock, so no
> > runtime pvops patching needed.
> > 
> > This allows us to make use of steal_account_process_tick for stolen
> > ticks accounting.
> > 
> > Signed-off-by: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
> > CC: will.deacon@arm.com
> > CC: nico@linaro.org
> > CC: marc.zyngier@arm.com
> > CC: cov@codeaurora.org
> > CC: arnd@arndb.de
> > CC: olof@lixom.net
> > CC: Catalin.Marinas@arm.com
> 
> Catalin, Will, are you happy with this patch for 3.15?

It's pretty small and looks fine to me. However, I would like someone
with more virtualisation experience than me to ack it (e.g. Marc Z).

Some nitpicks:

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
> > +	default n
> > +	---help---

For consistency with this file, just use "help" rather than
"---help---".

> > --- /dev/null
> > +++ b/arch/arm64/include/asm/paravirt.h
> > @@ -0,0 +1,20 @@
> > +#ifndef _ASM_ARM64_PARAVIRT_H
> > +#define _ASM_ARM64_PARAVIRT_H

__ASM_PARAVIRT_H for consistency.

-- 
Catalin
