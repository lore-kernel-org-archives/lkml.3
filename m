Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757056Ab3D2KaJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Apr 2013 06:30:09 -0400
Received: from smtp02.citrix.com ([66.165.176.63]:46867 "EHLO
	SMTP02.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751660Ab3D2KaH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Apr 2013 06:30:07 -0400
X-IronPort-AV: E=Sophos;i="4.87,572,1363132800"; 
   d="scan'208";a="21044754"
Date: Mon, 29 Apr 2013 11:30:03 +0100
From: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
X-X-Sender: sstabellini@kaball.uk.xensource.com
To: Will Deacon <will.deacon@arm.com>
CC: Stefano Stabellini <Stefano.Stabellini@eu.citrix.com>,
        "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "arnd@arndb.de" <arnd@arndb.de>,
        "nicolas.pitre@linaro.org" <nicolas.pitre@linaro.org>,
        "rob.herring@calxeda.com" <rob.herring@calxeda.com>,
        "linux@arm.linux.org.uk" <linux@arm.linux.org.uk>,
        "olof@lixom.net" <olof@lixom.net>, Nicolas Pitre <nico@linaro.org>,
        Marc Zyngier <Marc.Zyngier@arm.com>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>
Subject: Re: [PATCH v9 1/2] arm: introduce psci_smp_ops
In-Reply-To: <20130429085916.GB8805@mudshark.cambridge.arm.com>
Message-ID: <alpine.DEB.2.02.1304291126210.5398@kaball.uk.xensource.com>
References: <alpine.DEB.2.02.1304281544240.5398@kaball.uk.xensource.com> <1367160650-4888-1-git-send-email-stefano.stabellini@eu.citrix.com> <20130429085916.GB8805@mudshark.cambridge.arm.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Russell,
are you OK with this series now?

Olof, Arnd,
when you merge this series don't forget to include this fix from Stephen
Rothwell:

http://marc.info/?l=linux-arm-kernel&m=136722292031420&w=2


On Mon, 29 Apr 2013, Will Deacon wrote:
> On Sun, Apr 28, 2013 at 03:50:49PM +0100, Stefano Stabellini wrote:
> > Rename virt_smp_ops to psci_smp_ops and move them to arch/arm/kernel/psci_smp.c.
> > Remove mach-virt/platsmp.c, now unused.
> > Compile psci_smp if CONFIG_ARM_PSCI and CONFIG_SMP.
> > 
> > Add a cpu_die smp_op based on psci_ops.cpu_off.
> > 
> > Initialize PSCI before setting smp_ops in setup_arch.
> > 
> > If PSCI is available on the platform, prefer psci_smp_ops over the
> > platform smp_ops.
> > 
> > Changes in v9:
> > - move comment about PSCI interface from psci.h to psci_smp.c.
> > 
> > Changes in v8:
> > - merge "prefer psci_smp_ops over mdesc->smp" into this patch.
> > 
> > Changes in v6:
> > - fixed return values for psci_smp_available and psci_init ifndef
> > CONFIG_ARM_PSCI.
> > 
> > Changes in v5:
> > - document psci_operations;
> > - psci_init returns NULL.
> > 
> > Signed-off-by: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
> > CC: Nicolas Pitre <nico@linaro.org>
> > CC: Rob Herring <rob.herring@calxeda.com>
> > CC: Will Deacon <will.deacon@arm.com>
> > CC: arnd@arndb.de
> > CC: marc.zyngier@arm.com
> > CC: linux@arm.linux.org.uk
> 
> 
> Acked-by: Will Deacon <will.deacon@arm.com>
