Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934131Ab3E3QSu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 May 2013 12:18:50 -0400
Received: from smtp.citrix.com ([66.165.176.89]:18844 "EHLO SMTP.CITRIX.COM"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933826Ab3E3QSm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 May 2013 12:18:42 -0400
X-IronPort-AV: E=Sophos;i="4.87,772,1363132800"; 
   d="scan'208";a="28290699"
Date: Thu, 30 May 2013 17:18:23 +0100
From: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
X-X-Sender: sstabellini@kaball.uk.xensource.com
To: <linux-arm-kernel@lists.infradead.org>
CC: <linux-kernel@vger.kernel.org>, <xen-devel@lists.xensource.com>,
        Stefano Stabellini <Stefano.Stabellini@eu.citrix.com>,
        <will.deacon@arm.com>, <catalin.marinas@arm.com>,
        Ian Campbell <Ian.Campbell@citrix.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Subject: [PATCH RFC 0/6] Introduce Xen support to ARM64
Message-ID: <alpine.DEB.2.02.1305301705500.4799@kaball.uk.xensource.com>
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
under arch/arm/xen (enlighten.c and the stubs in grant-table.c) and all
the header files under arch/arm/include/asm/xen (events.h, hypercall.h,
hypervisor.h, interface.h, page.h) can be reused (almost) as-is.

Not knowning what is the best way forward I have just created symlinks
to the original files under arch/arm, see the first patch.

Please advice on what you think is the best way forward.



Stefano Stabellini (6):
      [HACK!] arm64/xen: create links to arch/arm include files and Xen code
      arm64/xen: arm header changes to compile on arm64
      arm64/xen: use XEN_IO_PROTO_ABI_ARM on ARM64
      arm64/xen: introduce asm/hypervisor.h and sys_bitops.h
      arm64/xen: implement xen_remap on arm64
      arm64/xen: introduce CONFIG_XEN and hypercall.S on ARM64

 arch/arm/include/asm/xen/events.h    |    4 +
 arch/arm/include/asm/xen/page.h      |    6 ++
 arch/arm64/Kconfig                   |   11 ++++
 arch/arm64/Makefile                  |    1 +
 arch/arm64/include/asm/hypervisor.h  |    6 ++
 arch/arm64/include/asm/io.h          |    1 +
 arch/arm64/include/asm/sync_bitops.h |   26 ++++++++
 arch/arm64/include/asm/xen           |    1 +
 arch/arm64/xen/Makefile              |    1 +
 arch/arm64/xen/enlighten.c           |    1 +
 arch/arm64/xen/grant-table.c         |    1 +
 arch/arm64/xen/hypercall.S           |  105 ++++++++++++++++++++++++++++++++++
 include/xen/interface/io/protocols.h |    2 +-
 13 files changed, 165 insertions(+), 1 deletions(-)
 create mode 100644 arch/arm64/include/asm/hypervisor.h
 create mode 100644 arch/arm64/include/asm/sync_bitops.h
 create mode 120000 arch/arm64/include/asm/xen
 create mode 100644 arch/arm64/xen/Makefile
 create mode 120000 arch/arm64/xen/enlighten.c
 create mode 120000 arch/arm64/xen/grant-table.c
 create mode 100644 arch/arm64/xen/hypercall.S

- Stefano
