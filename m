Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761541Ab3DBQQK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Apr 2013 12:16:10 -0400
Received: from smtp02.citrix.com ([66.165.176.63]:2764 "EHLO SMTP02.CITRIX.COM"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761063Ab3DBQQI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Apr 2013 12:16:08 -0400
X-IronPort-AV: E=Sophos;i="4.87,394,1363132800"; 
   d="scan'208";a="16163716"
Date: Tue, 2 Apr 2013 17:16:03 +0100
From: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
X-X-Sender: sstabellini@kaball.uk.xensource.com
To: <xen-devel@lists.xensource.com>
CC: <linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <will.deacon@arm.com>, Arnd Bergmann <arnd@arndb.de>,
        Nicolas Pitre <nicolas.pitre@linaro.org>,
        Stefano Stabellini <Stefano.Stabellini@eu.citrix.com>,
        <rob.herring@calxeda.com>
Subject: [PATCH 0/3 v5] arm: introduce psci_smp_ops and use them on Xen
Message-ID: <alpine.DEB.2.02.1304021700380.5078@kaball.uk.xensource.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,
this is the fifth version of the patch series to move virt_smp_ops out of
mach-virt and make it a generic set of reusable PSCI based smp_ops.
I added a patch to introduce smp_init to this series.
In the last patch I am using smp_init to switch to psci_smp_ops if Xen
is detected on the platform.


Jon Medhurst (1):
      ARM: Enable selection of SMP operations at boot time

Stefano Stabellini (2):
      arm: introduce psci_smp_ops
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
 arch/arm/xen/enlighten.c              |   27 ++++++++++---
 12 files changed, 144 insertions(+), 75 deletions(-)


A branch based on "xen/arm: move to mach-virt and support SMP" and
3.9-rc3 is available here:

git://xenbits.xen.org/people/sstabellini/linux-pvhvm.git 3.9-rc3-smp-5


Cheers,

Stefano
