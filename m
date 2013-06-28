Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755641Ab3F1P7b (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Jun 2013 11:59:31 -0400
Received: from aserp1040.oracle.com ([141.146.126.69]:49712 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751230Ab3F1P73 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Jun 2013 11:59:29 -0400
Date: Fri, 28 Jun 2013 11:58:40 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
Cc: "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "marc.zyngier@arm.com" <marc.zyngier@arm.com>,
        Will Deacon <will.deacon@arm.com>,
        Ian Campbell <Ian.Campbell@citrix.com>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Olof Johansson <olof@lixom.net>, arnd@arndb.de,
        Catalin Marinas <catalin.marinas@arm.com>
Subject: Re: [PATCH v7 0/6] xen/arm/arm64: CONFIG_PARAVIRT and stolen ticks
 accounting
Message-ID: <20130628155840.GA13468@phenom.dumpdata.com>
References: <alpine.DEB.2.02.1306271614260.4782@kaball.uk.xensource.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.02.1306271614260.4782@kaball.uk.xensource.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 28, 2013 at 12:19:54PM +0100, Stefano Stabellini wrote:
> Hi all,
> this patch series introduces stolen ticks accounting for Xen on ARM and
> ARM64.
> Stolen ticks are clocksource ticks that have been "stolen" from the cpu,
> typically because Linux is running in a virtual machine and the vcpu has
> been descheduled.
> To account for these ticks we introduce CONFIG_PARAVIRT and pv_time_ops
> so that we can make use of:
> 
> kernel/sched/cputime.c:steal_account_process_tick
> 
> 
> Stefano Stabellini (6):
>       xen: move xen_setup_runstate_info and get_runstate_snapshot to drivers/xen/time.c
>       kernel: missing include in cputime.c
>       arm: introduce CONFIG_PARAVIRT, PARAVIRT_TIME_ACCOUNTING and pv_time_ops
>       arm64: introduce CONFIG_PARAVIRT, PARAVIRT_TIME_ACCOUNTING and pv_time_ops
>       core: remove ifdef CONFIG_PARAVIRT
>       xen/arm: account for stolen ticks
> 
>  arch/arm/Kconfig                  |   20 ++++++++
>  arch/arm/include/asm/paravirt.h   |   20 ++++++++
>  arch/arm/kernel/Makefile          |    1 +
>  arch/arm/kernel/paravirt.c        |   25 ++++++++++
>  arch/arm/xen/enlighten.c          |   21 +++++++++
>  arch/arm64/Kconfig                |   20 ++++++++
>  arch/arm64/include/asm/paravirt.h |   20 ++++++++
>  arch/arm64/kernel/Makefile        |    1 +
>  arch/arm64/kernel/paravirt.c      |   25 ++++++++++
>  arch/ia64/xen/time.c              |   48 +++-----------------
>  arch/x86/xen/time.c               |   76 +------------------------------

This is going to hit some of the patches that David
has sent to tglx, I think. You might want to try to rebase on top
of them (tip/time/for-xen, or something like that ) when they
are ready.

But for the Xen generic maintainer I am OK with these changes
so you can stick Acked-by on them.

Are you thinking to push them yourself or via the arm64 maintainer?

