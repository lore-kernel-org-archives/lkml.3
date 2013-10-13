Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754757Ab3JMQLf (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Oct 2013 12:11:35 -0400
Received: from mout.gmx.net ([212.227.15.18]:57169 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754493Ab3JMQLd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Oct 2013 12:11:33 -0400
Date: Sun, 13 Oct 2013 18:11:30 +0200
From: Helge Deller <deller@gmx.de>
To: Linus Torvalds <torvalds@linux-foundation.org>,
        Linux Kernel Development <linux-kernel@vger.kernel.org>,
        linux-parisc@vger.kernel.org,
        James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: [GIT PULL] parisc updates for v3.12-rc5
Message-ID: <20131013161130.GA19534@p100.box>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Provags-ID: V03:K0:Zud6cuyer+AtjJeBI2dIVA5tmUAJaiTHcW+kAvKDj7vc2Dm4p/d
 unkA4UU9lZyxh3Dz0xd/x0Xaff98zJtnXEavLR4nNd8cRuZvigfGLiZtepvTuuOIbIcjiRD
 j94zZ8msQmr9MUIVmnY1pyOt48Ms6Fie31WeQDta1CraIqX1omTugqACt9qQj5Y+vLJRfLo
 3hSxrwoZoe8b7edNzubrA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Please pull the latest parisc fixes from

  git://git.kernel.org/pub/scm/linux/kernel/git/deller/parisc-linux.git parisc-3.12

This patchset includes a bugfix to prevent a kernel crash when memory in
page zero is accessed by the kernel itself, e.g. via
probe_kernel_read(). Furthermore we now export flush_cache_page() which
is needed (indirectly) by the lustre filesystem.  The other patches
remove unused functions and optimizes the page fault handler to only
evaluate variables if needed, which again protects against possible
kernel crashes.

Thanks,
Helge

----------------------------------------------------------------
Geert Uytterhoeven (1):
      parisc: Export flush_cache_page() (needed by lustre)

Helge Deller (4):
      parisc: remove unused syscall_ipi() function.
      parisc: mark parisc_terminate() noreturn and cold.
      parisc: fix interruption handler to respect pagefault_disable()
      parisc: let probe_kernel_read() capture access to page zero

Jiang Liu (1):
      parisc: kill SMP single function call interrupt

John David Anglin (1):
      parisc: optimize variable initialization in do_page_fault

 arch/parisc/include/asm/traps.h |  2 +-
 arch/parisc/kernel/cache.c      |  1 +
 arch/parisc/kernel/smp.c        |  8 +-------
 arch/parisc/kernel/traps.c      | 11 +++--------
 arch/parisc/lib/memcpy.c        | 15 ++++++++++++++-
 arch/parisc/mm/fault.c          | 15 ++++++++++-----
 6 files changed, 30 insertions(+), 22 deletions(-)
