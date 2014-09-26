Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755890AbaIZSRu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Sep 2014 14:17:50 -0400
Received: from smtp.outflux.net ([198.145.64.163]:36991 "EHLO smtp.outflux.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755222AbaIZSRt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Sep 2014 14:17:49 -0400
Date: Fri, 26 Sep 2014 11:16:43 -0700
From: Kees Cook <keescook@chromium.org>
To: linux+pull@arm.linux.org.uk
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Doug Anderson <dianders@chromium.org>,
        Kees Cook <keescook@chromium.org>, Mark Salter <msalter@redhat.com>,
        Nicolas Pitre <nico@linaro.org>,
        Nikolay Borisov <Nikolay.Borisov@arm.com>,
        Rabin Vincent <rabin@rab.in>, Rob Herring <robh@kernel.org>,
        Will Deacon <will.deacon@arm.com>,
        Laura Abbott <lauraa@codeaurora.org>
Subject: [PULL] ARM ro-nx tree (3.18)
Message-ID: <20140926181643.GA25494@www.outflux.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-HELO: www.outflux.net
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Please pull this series for ro-nx support on ARM for 3.18.

Thanks!

-Kees

The following changes since commit cc31d8f887953e9824c4d9333b15c335ee7d1b65:

  Merge branches 'fiq' (early part), 'fixes' and 'misc' into for-next (2014-09-26 14:40:19 +0100)

are available in the git repository at:


  git://git.kernel.org/pub/scm/linux/kernel/git/kees/linux.git tags/ronx-3.18

for you to fetch changes up to 9ad61652b33dba3a4630c1dad401a19b2508179b:

  ARM: mm: allow text and rodata sections to be read-only (2014-09-26 11:11:00 -0700)

----------------------------------------------------------------
ARM support for CONFIG_DEBUG_RODATA
generic fixmaps

----------------------------------------------------------------
Doug Anderson (1):
      arm: kgdb: Handle read-only text / modules

Kees Cook (3):
      arm: fixmap: implement __set_fixmap()
      ARM: mm: allow non-text sections to be non-executable
      ARM: mm: allow text and rodata sections to be read-only

Mark Salter (1):
      arm: use generic fixmap.h

Nikolay Borisov (1):
      ARM: kexec: Make .text R/W in machine_kexec

Rabin Vincent (1):
      arm: use fixmap for text patching when text is RO

Rob Herring (1):
      ARM: expand fixmap region to 3MB

 Documentation/arm/memory.txt      |   2 +-
 arch/arm/include/asm/cacheflush.h |  10 +++
 arch/arm/include/asm/fixmap.h     |  31 ++++----
 arch/arm/kernel/Makefile          |   2 +-
 arch/arm/kernel/ftrace.c          |  19 +++++
 arch/arm/kernel/jump_label.c      |   2 +-
 arch/arm/kernel/kgdb.c            |  29 ++++++++
 arch/arm/kernel/machine_kexec.c   |   9 ++-
 arch/arm/kernel/patch.c           |  92 ++++++++++++++++++-----
 arch/arm/kernel/patch.h           |  12 ++-
 arch/arm/kernel/vmlinux.lds.S     |  20 +++++
 arch/arm/mm/Kconfig               |  21 ++++++
 arch/arm/mm/highmem.c             |  15 ++--
 arch/arm/mm/init.c                | 149 +++++++++++++++++++++++++++++++++++++-
 arch/arm/mm/mmu.c                 |  39 +++++++++-
 15 files changed, 395 insertions(+), 57 deletions(-)

-- 
Kees Cook
Chrome OS Security
