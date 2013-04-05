Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161720Ab3DENKc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Apr 2013 09:10:32 -0400
Received: from smtp.citrix.com ([66.165.176.89]:1437 "EHLO SMTP.CITRIX.COM"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161328Ab3DENKb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Apr 2013 09:10:31 -0400
X-IronPort-AV: E=Sophos;i="4.87,414,1363132800"; 
   d="scan'208";a="17719307"
Date: Fri, 5 Apr 2013 14:10:24 +0100
From: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
X-X-Sender: sstabellini@kaball.uk.xensource.com
To: "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "will.deacon@arm.com" <will.deacon@arm.com>,
        Arnd Bergmann <arnd@arndb.de>,
        Nicolas Pitre <nicolas.pitre@linaro.org>,
        Stefano Stabellini <Stefano.Stabellini@eu.citrix.com>,
        "rob.herring@calxeda.com" <rob.herring@calxeda.com>
Subject: [PATCH 0/4 v6] arm: introduce psci_smp_ops and use them on Xen
Message-ID: <alpine.DEB.2.02.1304031239550.5078@kaball.uk.xensource.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,
this is the sixth version of the patch series to move virt_smp_ops out of
mach-virt and make it a generic set of reusable PSCI based smp_ops.
psci_smp_ops are preferred over the platform smp_ops.
I added a patch to introduce smp_init to this series.
In the last patch I am using smp_init to switch to psci_smp_ops if Xen
is detected on the platform.


Jon Medhurst (1):
      ARM: Enable selection of SMP operations at boot time

Stefano Stabellini (3):
      arm: introduce psci_smp_ops
      arm: prefer psci_smp_ops over mdesc->smp
      xen/arm: introduce xen_early_init, use PSCI on xen

 arch/arm/Kconfig                      |    1 +
 arch/arm/include/asm/mach/arch.h      |    3 +
 arch/arm/include/asm/psci.h           |   29 ++++++++++++++
 arch/arm/include/asm/xen/hypervisor.h |    6 +++
 arch/arm/kernel/Makefile              |    5 ++-
 arch/arm/kernel/psci.c                |    7 +--
 arch/arm/kernel/psci_smp.c            |   67 +++++++++++++++++++++++++++++++++
 arch/arm/kernel/setup.c               |   12 +++++-
 arch/arm/mach-virt/Makefile           |    1 -
 arch/arm/mach-virt/platsmp.c          |   58 ----------------------------
 arch/arm/mach-virt/virt.c             |    3 -
 arch/arm/xen/enlighten.c              |   36 ++++++++++++++----
 12 files changed, 152 insertions(+), 76 deletions(-)

    
git://xenbits.xen.org/people/sstabellini/linux-pvhvm.git 3.9-rc3-smp-6


Cheers,

Stefano
