Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760433Ab3DBQrJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Apr 2013 12:47:09 -0400
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:54627 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755747Ab3DBQrH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Apr 2013 12:47:07 -0400
Date: Tue, 2 Apr 2013 17:46:38 +0100
From: Will Deacon <will.deacon@arm.com>
To: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
Cc: "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "arnd@arndb.de" <arnd@arndb.de>,
        "nicolas.pitre@linaro.org" <nicolas.pitre@linaro.org>,
        "rob.herring@calxeda.com" <rob.herring@calxeda.com>,
        Marc Zyngier <Marc.Zyngier@arm.com>,
        "linux@arm.linux.org.uk" <linux@arm.linux.org.uk>,
        "nico@linaro.org" <nico@linaro.org>
Subject: Re: [PATCH v5 1/3] arm: introduce psci_smp_ops
Message-ID: <20130402164638.GG6608@mudshark.cambridge.arm.com>
References: <alpine.DEB.2.02.1304021700380.5078@kaball.uk.xensource.com>
 <1364919374-7836-1-git-send-email-stefano.stabellini@eu.citrix.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1364919374-7836-1-git-send-email-stefano.stabellini@eu.citrix.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 02, 2013 at 05:16:12PM +0100, Stefano Stabellini wrote:
> Rename virt_smp_ops to psci_smp_ops and move them to arch/arm/kernel/psci_smp.c.
> Remove mach-virt/platsmp.c, now unused.
> Compile psci_smp if CONFIG_ARM_PSCI and CONFIG_SMP.
> 
> Add a cpu_die smp_op based on psci_ops.cpu_off.
> 
> Initialize PSCI before setting smp_ops in setup_arch.
> Use psci_smp_ops if the platform doesn't provide its own smp_ops.
> 
> 
> Changes in v5:
> - document psci_operations;
> - psci_init returns NULL.
> 
> 
> Signed-off-by: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
> Acked-by: Nicolas Pitre <nico@linaro.org>
> Acked-by: Rob Herring <rob.herring@calxeda.com>
> 
> CC: will.deacon@arm.com
> CC: arnd@arndb.de
> CC: marc.zyngier@arm.com
> CC: linux@arm.linux.org.uk
> CC: nico@linaro.org
> ---
>  arch/arm/include/asm/psci.h  |   29 ++++++++++++++++++
>  arch/arm/kernel/Makefile     |    5 ++-
>  arch/arm/kernel/psci.c       |    7 ++--
>  arch/arm/kernel/psci_smp.c   |   67 ++++++++++++++++++++++++++++++++++++++++++
>  arch/arm/kernel/setup.c      |    7 ++++-
>  arch/arm/mach-virt/Makefile  |    1 -
>  arch/arm/mach-virt/platsmp.c |   58 ------------------------------------
>  arch/arm/mach-virt/virt.c    |    3 --
>  8 files changed, 109 insertions(+), 68 deletions(-)
>  create mode 100644 arch/arm/kernel/psci_smp.c
>  delete mode 100644 arch/arm/mach-virt/platsmp.c

Reviewed-by: Will Deacon <will.deacon@arm.com>

Will
