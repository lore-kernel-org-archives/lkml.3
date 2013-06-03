Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758746Ab3FCPdE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Jun 2013 11:33:04 -0400
Received: from smtp.citrix.com ([66.165.176.89]:17639 "EHLO SMTP.CITRIX.COM"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756526Ab3FCPc7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Jun 2013 11:32:59 -0400
X-IronPort-AV: E=Sophos;i="4.87,793,1363132800"; 
   d="scan'208";a="28900622"
Date: Mon, 3 Jun 2013 16:32:55 +0100
From: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
X-X-Sender: sstabellini@kaball.uk.xensource.com
To: <linux-arm-kernel@lists.infradead.org>
CC: <linux-kernel@vger.kernel.org>, <xen-devel@lists.xensource.com>,
        Stefano Stabellini <Stefano.Stabellini@eu.citrix.com>,
        <will.deacon@arm.com>, <catalin.marinas@arm.com>,
        Ian Campbell <Ian.Campbell@citrix.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Subject: [PATCH v2 0/5] Introduce Xen support to ARM64
Message-ID: <alpine.DEB.2.02.1306031157020.4589@kaball.uk.xensource.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,
this patch series introduces Xen support to arch/arm64.

As you can see from the following patches, there is very little arm64
specific code here, basically only one assembly file
(arch/arm64/xen/hypercall.S).

Everything else is common with Xen for ARMv7, in particular the code
under arch/arm/xen (enlighten.c and the stubs in grant-table.c) and most
of the header files under arch/arm/include/asm/xen (hypercall.h,
hypervisor.h, interface.h, page.h) can be reused as-is.


Stefano Stabellini (5):
      arm/xen: define xen_remap as ioremap_cached
      arm64/xen: introduce asm/xen header files on arm64
      arm64/xen: implement ioremap_cached on arm64
      arm64/xen: use XEN_IO_PROTO_ABI_ARM on ARM64
      arm64/xen: introduce CONFIG_XEN and hypercall.S on ARM64

 arch/arm/include/asm/xen/page.h         |    3 +-
 arch/arm64/Kconfig                      |   10 +++
 arch/arm64/Makefile                     |    1 +
 arch/arm64/include/asm/hypervisor.h     |    6 ++
 arch/arm64/include/asm/io.h             |    2 +
 arch/arm64/include/asm/sync_bitops.h    |   26 +++++++++
 arch/arm64/include/asm/xen/events.h     |   21 +++++++
 arch/arm64/include/asm/xen/hypercall.h  |    1 +
 arch/arm64/include/asm/xen/hypervisor.h |    1 +
 arch/arm64/include/asm/xen/interface.h  |    1 +
 arch/arm64/include/asm/xen/page.h       |    1 +
 arch/arm64/xen/Makefile                 |    2 +
 arch/arm64/xen/hypercall.S              |   94 +++++++++++++++++++++++++++++++
 include/xen/interface/io/protocols.h    |    2 +-
 14 files changed, 168 insertions(+), 3 deletions(-)
 create mode 100644 arch/arm64/include/asm/hypervisor.h
 create mode 100644 arch/arm64/include/asm/sync_bitops.h
 create mode 100644 arch/arm64/include/asm/xen/events.h
 create mode 100644 arch/arm64/include/asm/xen/hypercall.h
 create mode 100644 arch/arm64/include/asm/xen/hypervisor.h
 create mode 100644 arch/arm64/include/asm/xen/interface.h
 create mode 100644 arch/arm64/include/asm/xen/page.h
 create mode 100644 arch/arm64/xen/Makefile
 create mode 100644 arch/arm64/xen/hypercall.S


git://git.kernel.org/pub/scm/linux/kernel/git/sstabellini/xen.git xen-arm64-2

- Stefano
