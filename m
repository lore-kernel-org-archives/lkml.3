Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S967156Ab3DRPE7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Apr 2013 11:04:59 -0400
Received: from smtp02.citrix.com ([66.165.176.63]:28017 "EHLO
	SMTP02.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965506Ab3DRPE5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Apr 2013 11:04:57 -0400
X-IronPort-AV: E=Sophos;i="4.87,502,1363132800"; 
   d="scan'208";a="19257070"
Date: Thu, 18 Apr 2013 16:04:44 +0100
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
        "rob.herring@calxeda.com" <rob.herring@calxeda.com>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Olof Johansson <olof@lixom.net>
Subject: [PATCH 0/3 v7] arm: introduce psci_smp_ops
Message-ID: <alpine.DEB.2.02.1304181556210.7254@kaball.uk.xensource.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,
this is the seventh version of the patch series to move virt_smp_ops out
of mach-virt and make it a generic set of reusable PSCI based smp_ops.
psci_smp_ops are preferred over the platform smp_ops.
The last patch introduces smp_init.

I removed the patch that makes use of smp_init in Xen, because it
depends on other Xen changes. I'll send it separately.
This version of the series is independent of other changes.


Jon Medhurst (1):
      ARM: Enable selection of SMP operations at boot time

Stefano Stabellini (2):
      arm: introduce psci_smp_ops
      arm: prefer psci_smp_ops over mdesc->smp

 arch/arm/include/asm/mach/arch.h |    3 ++
 arch/arm/include/asm/psci.h      |   29 ++++++++++++++++
 arch/arm/kernel/Makefile         |    5 ++-
 arch/arm/kernel/psci.c           |    7 ++--
 arch/arm/kernel/psci_smp.c       |   67 ++++++++++++++++++++++++++++++++++++++
 arch/arm/kernel/setup.c          |    9 ++++-
 arch/arm/mach-virt/Makefile      |    1 -
 arch/arm/mach-virt/platsmp.c     |   58 --------------------------------
 arch/arm/mach-virt/virt.c        |    3 --
 9 files changed, 114 insertions(+), 68 deletions(-)


git://git.kernel.org/pub/scm/linux/kernel/git/sstabellini/xen.git 3.9-rc3-psci-ops-7-tag

Cheers,

Stefano
