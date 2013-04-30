Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932531Ab3D3Ovk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Apr 2013 10:51:40 -0400
Received: from smtp.citrix.com ([66.165.176.89]:43523 "EHLO SMTP.CITRIX.COM"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932285Ab3D3Ovi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Apr 2013 10:51:38 -0400
X-IronPort-AV: E=Sophos;i="4.87,582,1363132800"; 
   d="scan'208";a="22396642"
Date: Tue, 30 Apr 2013 15:51:33 +0100
From: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
X-X-Sender: sstabellini@kaball.uk.xensource.com
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Olof Johansson <olof@lixom.net>, Arnd Bergmann <arnd@arndb.de>,
        <xen-devel@lists.xensource.com>,
        <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
        "stefano.stabellini@eu.citrix.com" <stefano.stabellini@eu.citrix.com>
Subject: [GIT PULL] (arm/xen) 3.9-rc3-smp-6-tag
Message-ID: <alpine.DEB.2.02.1304301515490.5398@kaball.uk.xensource.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,
this is my first pull request to you, Konrad decided to let me deal
with the Xen/ARM stuff myself recently.
Please pull the following tag (based on 3.9-rc3):

git://git.kernel.org/pub/scm/linux/kernel/git/sstabellini/xen.git 3.9-rc3-smp-6-tag

It contains a bunch of Xen/ARM specific changes, including some fixes,
SMP support for Xen on ARM, and moving the xenvm machine from
mach-vexpress to mach-virt.

The non-Xen files that are touched are arch/arm/Kconfig, to select
ARM_PSCI on XEN, and arch/arm/boot/dts/Makefile, to build the xenvm DTB
if CONFIG_ARCH_VIRT.


Stefano Stabellini (7):
      xen/arm: actually pass a non-NULL percpu pointer to request_percpu_irq
      xen/arm: implement HYPERVISOR_vcpu_op
      xen/arm: SMP support
      xen: move the xenvm machine to mach-virt
      xen/arm: XEN selects ARM_PSCI
      xenvm: add a simple PSCI node and a second cpu
      xen/arm: use sched_op hypercalls for machine reboot and power off

Wei Yongjun (1):
      xen/arm: remove duplicated include from enlighten.c

 arch/arm/Kconfig                     |    1 +
 arch/arm/boot/dts/Makefile           |    4 +-
 arch/arm/boot/dts/xenvm-4.2.dts      |   13 ++++++
 arch/arm/include/asm/xen/hypercall.h |    1 +
 arch/arm/mach-vexpress/v2m.c         |    1 -
 arch/arm/mach-virt/virt.c            |    1 +
 arch/arm/xen/enlighten.c             |   74 ++++++++++++++++++++++++++++++---
 arch/arm/xen/hypercall.S             |    1 +
 8 files changed, 86 insertions(+), 10 deletions(-)


Cheers,
Stefano
