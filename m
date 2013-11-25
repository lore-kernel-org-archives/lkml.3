Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756988Ab3KYQO7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Nov 2013 11:14:59 -0500
Received: from mx1.redhat.com ([209.132.183.28]:61671 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756907Ab3KYQOy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Nov 2013 11:14:54 -0500
From: Mark Salter <msalter@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Mark Salter <msalter@redhat.com>, Arnd Bergmann <arnd@arndb.de>,
        Ralf Baechle <ralf@linux-mips.org>, linux-arch@vger.kernel.org,
        Russell King <linux@arm.linux.org.uk>,
        linux-arm-kernel@lists.infradead.org,
        Richard Kuo <rkuo@codeaurora.org>, linux-hexagon@vger.kernel.org,
        James Hogan <james.hogan@imgtec.com>, linux-metag@vger.kernel.org,
        Michal Simek <monstr@monstr.eu>, microblaze-uclinux@itee.uq.edu.au,
        linux-mips@linux-mips.org,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>, linuxppc-dev@lists.ozlabs.org
Subject: [PATCH v2 00/11] Consolidate asm/fixmap.h files
Date: Mon, 25 Nov 2013 11:13:54 -0500
Message-Id: <1385396045-15852-1-git-send-email-msalter@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Many architectures provide an asm/fixmap.h which defines support for
compile-time 'special' virtual mappings which need to be made before
paging_init() has run. This suport is also used for early ioremap
on x86. Much of this support is identical across the architectures.
This patch consolidates all of the common bits into asm-generic/fixmap.h
which is intended to be included from arch/*/include/asm/fixmap.h.

This has been compiled on x86, arm, powerpc, and sh, but tested
on x86 only.

This is version two of the patch series:

   git://github.com/mosalter/linux.git#fixmap-v2

Version 1 is here:

   git://github.com/mosalter/linux.git#fixmap

Changes from v1:

  * Added acks from feedback.
  * Use BUILD_BUG_ON in fix_to_virt()
  * Fixed ARM patch to make FIXMAP_TOP inclusive of fixmap
    range as is the case in the other architectures.

Mark Salter (11):
  Add generic fixmap.h
  x86: use generic fixmap.h
  arm: use generic fixmap.h
  hexagon: use generic fixmap.h
  metag: use generic fixmap.h
  microblaze: use generic fixmap.h
  mips: use generic fixmap.h
  powerpc: use generic fixmap.h
  sh: use generic fixmap.h
  tile: use generic fixmap.h
  um: use generic fixmap.h

 arch/arm/include/asm/fixmap.h        | 29 +++--------
 arch/arm/mm/init.c                   |  2 +-
 arch/hexagon/include/asm/fixmap.h    | 40 +--------------
 arch/metag/include/asm/fixmap.h      | 32 +-----------
 arch/microblaze/include/asm/fixmap.h | 44 +---------------
 arch/mips/include/asm/fixmap.h       | 33 +-----------
 arch/powerpc/include/asm/fixmap.h    | 44 +---------------
 arch/sh/include/asm/fixmap.h         | 39 +--------------
 arch/tile/include/asm/fixmap.h       | 33 +-----------
 arch/um/include/asm/fixmap.h         | 40 +--------------
 arch/x86/include/asm/fixmap.h        | 59 +---------------------
 include/asm-generic/fixmap.h         | 97 ++++++++++++++++++++++++++++++++++++
 12 files changed, 118 insertions(+), 374 deletions(-)
 create mode 100644 include/asm-generic/fixmap.h

-- 
1.8.3.1

