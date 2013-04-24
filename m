Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757387Ab3DXTZr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Apr 2013 15:25:47 -0400
Received: from smtp02.citrix.com ([66.165.176.63]:29327 "EHLO
	SMTP02.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757092Ab3DXTZq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Apr 2013 15:25:46 -0400
X-IronPort-AV: E=Sophos;i="4.87,545,1363132800"; 
   d="scan'208";a="20364804"
Date: Wed, 24 Apr 2013 20:25:38 +0100
From: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
X-X-Sender: sstabellini@kaball.uk.xensource.com
To: "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Stefano Stabellini <Stefano.Stabellini@eu.citrix.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Ian Campbell <Ian.Campbell@citrix.com>
Subject: [PATCH v4 0/7] xen/arm: move to mach-virt and support SMP
Message-ID: <alpine.DEB.2.02.1304242012590.4180@kaball.uk.xensource.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,
this patch series, based on 3.9-rc3, moves xenvm to mach-virt and
implements SMP support in Xen on ARM.

Each patch comes with a detailed changelog.


Changes in v4:
- XEN should select ARM_PSCI;
- update arch/arm/boot/dts/Makefile to build the xenvm dts
  if CONFIG_ARCH_VIRT;
- add a patch to introduce Xen shutdown hypercall support to mach-virt.


Stefano Stabellini (7):
      xen/arm: actually pass a non-NULL percpu pointer to request_percpu_irq
      xen/arm: SMP support
      xen: move the xenvm machine to mach-virt
      xen/arm: implement HYPERVISOR_vcpu_op
      xen/arm: XEN selects ARM_PSCI
      xenvm: add a simple PSCI node and a second cpu
      mach-virt: support Xen hypercalls for shutdown and reboot

 arch/arm/Kconfig                     |    1 +
 arch/arm/boot/dts/Makefile           |    4 +-
 arch/arm/boot/dts/xenvm-4.2.dts      |   13 ++++++++++
 arch/arm/include/asm/xen/hypercall.h |    1 +
 arch/arm/mach-vexpress/v2m.c         |    1 -
 arch/arm/mach-virt/virt.c            |   33 +++++++++++++++++++++++++++
 arch/arm/xen/enlighten.c             |   41 ++++++++++++++++++++++++++++++++-
 arch/arm/xen/hypercall.S             |    1 +
 8 files changed, 90 insertions(+), 5 deletions(-)

git://git.kernel.org/pub/scm/linux/kernel/git/sstabellini/xen.git 3.9-rc3-smp-4-tag

Cheers,

Stefano
