Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S967131Ab3DROtQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Apr 2013 10:49:16 -0400
Received: from smtp02.citrix.com ([66.165.176.63]:7156 "EHLO SMTP02.CITRIX.COM"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965506Ab3DROtO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Apr 2013 10:49:14 -0400
X-IronPort-AV: E=Sophos;i="4.87,502,1363132800"; 
   d="scan'208";a="19252660"
Date: Thu, 18 Apr 2013 15:49:01 +0100
From: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
X-X-Sender: sstabellini@kaball.uk.xensource.com
To: "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Stefano Stabellini <Stefano.Stabellini@eu.citrix.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Ian Campbell <Ian.Campbell@citrix.com>
Subject: [PATCH v3 0/5] xen/arm: move to mach-virt and support SMP
Message-ID: <alpine.DEB.2.02.1304181538160.7254@kaball.uk.xensource.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,
this patch series, based on 3.9-rc3, moves xenvm to mach-virt and
implements SMP support in Xen on ARM.


Changes from v2:
- dropped the RFC patch from the series: PSCI related changes are going
to be handled by a separate series.

Changes from v1:
- move the percpu variable argument fix in xen_init_events to a separate
  patch;
- remove unused variable in xen_init_events;
- add an RFC patch to initialize PSCI from smp_set_ops and use it if
  available.


Stefano Stabellini (5):
      xen/arm: actually pass a non-NULL percpu pointer to request_percpu_irq
      xen/arm: SMP support
      xen: move the xenvm machine to mach-virt
      xen/arm: implement HYPERVISOR_vcpu_op
      xenvm: add a simple PSCI node and a second cpu

 arch/arm/boot/dts/xenvm-4.2.dts      |   12 ++++++++++
 arch/arm/include/asm/xen/hypercall.h |    1 +
 arch/arm/mach-vexpress/v2m.c         |    1 -
 arch/arm/mach-virt/virt.c            |    1 +
 arch/arm/xen/enlighten.c             |   41 ++++++++++++++++++++++++++++++++-
 arch/arm/xen/hypercall.S             |    1 +
 6 files changed, 54 insertions(+), 3 deletions(-)


git://git.kernel.org/pub/scm/linux/kernel/git/sstabellini/xen.git 3.9-rc3-smp-3-tag

Cheers,

Stefano
