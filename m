Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751788Ab3FYN0K (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Jun 2013 09:26:10 -0400
Received: from fw-tnat.cambridge.arm.com ([217.140.96.21]:48140 "EHLO
	cam-smtp0.cambridge.arm.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1750830Ab3FYN0I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Jun 2013 09:26:08 -0400
Date: Tue, 25 Jun 2013 14:25:19 +0100
From: Catalin Marinas <catalin.marinas@arm.com>
To: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
Cc: Chen Gang <gang.chen@asianux.com>, Will Deacon <Will.Deacon@arm.com>,
        Tony Lindgren <tony@atomide.com>, "olof@lixom.net" <olof@lixom.net>,
        Santosh Shilimkar <santosh.shilimkar@ti.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Linux-Arch <linux-arch@vger.kernel.org>
Subject: Re: [Suggestion] arch: arm64: xen: "ln -s" the paravirt.h from arm.
Message-ID: <20130625132519.GA7222@arm.com>
References: <51C53C06.7050205@asianux.com>
 <51C81115.4070803@asianux.com>
 <51C81A39.5060909@asianux.com>
 <alpine.DEB.2.02.1306241639260.4782@kaball.uk.xensource.com>
 <alpine.DEB.2.02.1306241747360.4782@kaball.uk.xensource.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.02.1306241747360.4782@kaball.uk.xensource.com>
Thread-Topic: [Suggestion] arch: arm64: xen: "ln -s" the paravirt.h from
 arm.
Accept-Language: en-GB, en-US
Content-Language: en-US
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 24, 2013 at 05:50:46PM +0100, Stefano Stabellini wrote:
> On Mon, 24 Jun 2013, Stefano Stabellini wrote:
> > On Mon, 24 Jun 2013, Chen Gang wrote:
> > > Hello Maintainers:
> > > 
> > > if 'CONFIG_XEN'
> > > 
> > >   CC      arch/arm64/xen/../../arm/xen/enlighten.o
> > > arch/arm64/xen/../../arm/xen/enlighten.c:19:26: fatal error: asm/paravirt.h: No such file or directory
> > > 
> > > The related .config file for next-20130624 is in attachment.
> > > 
> > > 
> > > If "ln -s ../../../arm/include/asm/paravirt.h paravirt.h", it can pass
> > > compiling, but I do not know how to make a patch for it ("ln -s ..."),
> > > Do we have another more suitable ways for it (or another fixing ways) ?
> > > 
> > > Welcome any suggestions or completions.
> > 
> > The problem is caused by:
> > 
> > commit 3a885582a366caf868b0782041c44854ff4c3568
> > Author: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
> > Date:   Wed May 29 10:56:34 2013 +0000
> > 
> >     xen/arm: account for stolen ticks
> > 
> > that is in my tree for linux-next (even though I have not received any
> > replies from the ARM maintainers so I don't know when and if it is going
> > to go upstream).
> > 
> > I think that the best thing to do would be to add a couple of ifdef
> > CONFIG_PARAVIRT in arch/arm/xen/enlighten.c. I'll add them to my tree.
> 
> Actually now that we have XEN support under arm64, we can just introduce the
> same pv_time_op struct and paravirt header that this patch
> 
> http://marc.info/?l=linux-arm-kernel&m=136992435301890&w=2
> 
> is introducing under arm.

I'm not sure whether I replied to your Xen pull request but the patches
have been merged into my 'upstream' branch on git.kernel.org and they'll
be going in for 3.11-rc1.

> diff --git a/arch/arm64/Kconfig b/arch/arm64/Kconfig
> index 19c1cde..47bd26b 100644
> --- a/arch/arm64/Kconfig
> +++ b/arch/arm64/Kconfig
> @@ -207,6 +207,25 @@ config FORCE_MAX_ZONEORDER
>  	default "14" if (ARM64_64K_PAGES && TRANSPARENT_HUGEPAGE)
>  	default "11"
>  
> +config PARAVIRT
> +	bool "Enable paravirtualization code"
> +	---help---
> +	  This changes the kernel so it can modify itself when it is run
> +	  under a hypervisor, potentially improving performance significantly
> +	  over full virtualization.
> +
> +config PARAVIRT_TIME_ACCOUNTING
> +	bool "Paravirtual steal time accounting"
> +	select PARAVIRT
> +	default n

No need for "default n".

If you want, I can apply this patch on top (or send me another pull
request but don't rebase your original Xen branch which I merged).

-- 
Catalin
