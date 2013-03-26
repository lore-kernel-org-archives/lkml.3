Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759832Ab3CZOmL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Mar 2013 10:42:11 -0400
Received: from smtp.citrix.com ([66.165.176.89]:61951 "EHLO SMTP.CITRIX.COM"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758366Ab3CZOmI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Mar 2013 10:42:08 -0400
X-IronPort-AV: E=Sophos;i="4.84,911,1355097600"; 
   d="scan'208";a="15626850"
Date: Tue, 26 Mar 2013 14:40:56 +0000
From: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
X-X-Sender: sstabellini@kaball.uk.xensource.com
To: "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Stefano Stabellini <Stefano.Stabellini@eu.citrix.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Ian Campbell <Ian.Campbell@citrix.com>
Subject: [PATCH v2 0/6] xen/arm: move to mach-virt and support SMP
Message-ID: <alpine.DEB.2.02.1303261423530.4430@kaball.uk.xensource.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,
this patch series, based on 3.9-rc3, moves xenvm to mach-virt and
implements SMP support in Xen on ARM.


Changes from v1:
- move the percpu variable argument fix in xen_init_events to a separate
  patch;
- remove unused variable in xen_init_events;
- add an RFC patch to initialize PSCI from smp_set_ops and use it if
  available.


Stefano Stabellini (6):
      xen/arm: actually pass a non-NULL percpu pointer to request_percpu_irq
      xen/arm: SMP support
      xen: move the xenvm machine to mach-virt
      xen/arm: implement HYPERVISOR_vcpu_op
      xenvm: add a simple PSCI node and a second cpu
      [RFC] arm: use PSCI if available

 arch/arm/boot/dts/xenvm-4.2.dts      |   12 +++++++
 arch/arm/include/asm/psci.h          |    1 +
 arch/arm/include/asm/xen/hypercall.h |    1 +
 arch/arm/kernel/psci.c               |   42 ++++++++++++++++++++++--
 arch/arm/kernel/smp.c                |    7 +++-
 arch/arm/mach-vexpress/v2m.c         |    1 -
 arch/arm/mach-virt/Makefile          |    1 -
 arch/arm/mach-virt/platsmp.c         |   58 ----------------------------------
 arch/arm/mach-virt/virt.c            |    4 +--
 arch/arm/xen/enlighten.c             |   41 +++++++++++++++++++++++-
 arch/arm/xen/hypercall.S             |    1 +
 11 files changed, 99 insertions(+), 70 deletions(-)

git://xenbits.xen.org/people/sstabellini/linux-pvhvm.git 3.9-rc3-smp-2

Cheers,

Stefano
