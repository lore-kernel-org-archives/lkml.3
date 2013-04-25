Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932598Ab3DYQ5R (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Apr 2013 12:57:17 -0400
Received: from smtp.citrix.com ([66.165.176.89]:64392 "EHLO SMTP.CITRIX.COM"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932087Ab3DYQ5Q (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Apr 2013 12:57:16 -0400
X-IronPort-AV: E=Sophos;i="4.87,551,1363132800"; 
   d="scan'208";a="21599399"
Date: Thu, 25 Apr 2013 17:57:11 +0100
From: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
X-X-Sender: sstabellini@kaball.uk.xensource.com
To: "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Stefano Stabellini <Stefano.Stabellini@eu.citrix.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Ian Campbell <Ian.Campbell@citrix.com>
Subject: [PATCH v5 0/7] xen/arm: move to mach-virt and support SMP
Message-ID: <alpine.DEB.2.02.1304251750160.4180@kaball.uk.xensource.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,
this patch series, based on 3.9-rc3, moves xenvm to mach-virt,
introduces SMP support in Xen on ARM and implements machine reboot and
power off via Xen sched_op hypercalls.

Each patch comes with a detailed changelog.


The merge window is approaching, this patch series only contains Xen
specific changes for ARM, if anybody has any objections speak now
please.

I would like an ack from an ARM maintainer on patch #4 and #5 since they
touch generic ARM Makefiles.


Changes in v5:
- allocate xen_vcpu_info dynamically, aligning it to the size of the
struct;
- use VCPUOP_register_vcpu_info on cpu0 too;
- set pm_power_off and arm_pm_restart from the Xen specific
intialization code.



Stefano Stabellini (7):
      xen/arm: actually pass a non-NULL percpu pointer to request_percpu_irq
      xen/arm: implement HYPERVISOR_vcpu_op
      xen/arm: SMP support
      xen: move the xenvm machine to mach-virt
      xen/arm: XEN selects ARM_PSCI
      xenvm: add a simple PSCI node and a second cpu
      xen/arm: use sched_op hypercalls for machine reboot and power off

 arch/arm/Kconfig                     |    1 +
 arch/arm/boot/dts/Makefile           |    4 +-
 arch/arm/boot/dts/xenvm-4.2.dts      |   13 ++++++
 arch/arm/include/asm/xen/hypercall.h |    1 +
 arch/arm/mach-vexpress/v2m.c         |    1 -
 arch/arm/mach-virt/virt.c            |    1 +
 arch/arm/xen/enlighten.c             |   75 ++++++++++++++++++++++++++++++---
 arch/arm/xen/hypercall.S             |    1 +
 8 files changed, 87 insertions(+), 10 deletions(-)


git://git.kernel.org/pub/scm/linux/kernel/git/sstabellini/xen.git 3.9-rc3-smp-5-tag

Cheers,

Stefano
