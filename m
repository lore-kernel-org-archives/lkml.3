Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751942AbaJPVqo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Oct 2014 17:46:44 -0400
Received: from smtp.outflux.net ([198.145.64.163]:57664 "EHLO smtp.outflux.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751106AbaJPVqn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Oct 2014 17:46:43 -0400
Date: Thu, 16 Oct 2014 14:45:42 -0700
From: Kees Cook <keescook@chromium.org>
To: linux+pull@arm.linux.org.uk
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Doug Anderson <dianders@chromium.org>,
        Kees Cook <keescook@chromium.org>, Mark Salter <msalter@redhat.com>,
        Nicolas Pitre <nico@linaro.org>,
        Nikolay Borisov <Nikolay.Borisov@arm.com>,
        Rabin Vincent <rabin@rab.in>, Rob Herring <robh@kernel.org>,
        Will Deacon <will.deacon@arm.com>
Subject: [PULL v2] ARM ro-nx tree (next)
Message-ID: <20141016214542.GA12587@www.outflux.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-HELO: www.outflux.net
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Please pull this series for ro-nx support on ARM for next.

Thanks!

-Kees

The following changes since commit bfe01a5ba2490f299e1d2d5508cbbbadd897bbe9:

  Linux 3.17 (2014-10-05 12:23:04 -0700)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/kees/linux.git tags/ronx-next

for you to fetch changes up to 80d6b0c2eed2a504f6740cd1f5ea76dc50abfc4d:

  ARM: mm: allow text and rodata sections to be read-only (2014-10-16 14:38:54 -0700)

----------------------------------------------------------------
generic fixmaps
ARM support for CONFIG_DEBUG_RODATA

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
 arch/arm/kernel/vmlinux.lds.S     |  19 +++++
 arch/arm/mm/Kconfig               |  21 ++++++
 arch/arm/mm/highmem.c             |  15 ++--
 arch/arm/mm/init.c                | 149 +++++++++++++++++++++++++++++++++++++-
 arch/arm/mm/mmu.c                 |  39 +++++++++-
 15 files changed, 394 insertions(+), 57 deletions(-)

-- 
Kees Cook
Chrome OS Security
