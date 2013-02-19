Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934643Ab3BSXPk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Feb 2013 18:15:40 -0500
Received: from ozlabs.org ([203.10.76.45]:37920 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932846Ab3BSXPj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Feb 2013 18:15:39 -0500
From: Rusty Russell <rusty@rustcorp.com.au>
To: <torvalds@linux-foundation.org>
Cc: "LKML" <linux-kernel@vger.kernel.org>
Cc: Chris Samuel <chris@csamuel.org>
Cc: David Howells <dhowells@redhat.com>
Cc: Michal Marek <mmarek@suse.cz>
Cc: Sam Ravnborg <sam@ravnborg.org>
Cc: Sasha Levin <sasha.levin@oracle.com>
Cc: Vineet Gupta <vgupta@synopsys.com>
Subject: [PULL] modules-next
User-Agent: Notmuch/0.14 (http://notmuchmail.org) Emacs/23.4.1 (i686-pc-linux-gnu)
Date: Wed, 20 Feb 2013 09:44:59 +1030
Message-ID: <874nh7j3po.fsf@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following changes since commit 9a9284153d965a57edc7162a8e57c14c97f3a935:

  Merge branch 'drm-fixes' of git://people.freedesktop.org/~airlied/linux (2013-01-20 20:55:49 -0800)

are available in the git repository at:


  git://git.kernel.org/pub/scm/linux/kernel/git/rusty/linux.git tags/modules-next-for-linus

for you to fetch changes up to d9d8d7ed498ec65bea72dd24be7b9cd35af0c200:

  MODSIGN: Add option to not sign modules during modules_install (2013-01-25 16:55:37 +1030)

----------------------------------------------------------------
The sweeping change is to make add_taint() explicitly indicate whether to disable
lockdep, but it's a mechanical change.

Cheers,
Rusty.

----------------------------------------------------------------
Michal Marek (4):
      MODSIGN: Simplify Makefile with a Kconfig helper
      MODSIGN: Specify the hash algorithm on sign-file command line
      MODSIGN: Add -s <signature> option to sign-file
      MODSIGN: Add option to not sign modules during modules_install

Rusty Russell (3):
      module: printk message when module signature fail taints kernel.
      taint: add explicit flag to show whether lock dep is still OK.
      module: clean up load_module a little more.

Sasha Levin (1):
      module: constify within_module_*

Vineet Gupta (1):
      modpost: Ignore ARC specific non-alloc sections

 Makefile                             |    4 +-
 arch/alpha/kernel/traps.c            |    2 +-
 arch/arm/kernel/traps.c              |    2 +-
 arch/arm64/kernel/traps.c            |    2 +-
 arch/avr32/kernel/traps.c            |    2 +-
 arch/hexagon/kernel/traps.c          |    2 +-
 arch/ia64/kernel/traps.c             |    2 +-
 arch/m68k/kernel/traps.c             |    2 +-
 arch/mips/kernel/traps.c             |    2 +-
 arch/parisc/kernel/traps.c           |    2 +-
 arch/powerpc/kernel/traps.c          |    2 +-
 arch/s390/kernel/traps.c             |    2 +-
 arch/sh/kernel/traps.c               |    2 +-
 arch/sparc/kernel/setup_64.c         |    2 +-
 arch/sparc/kernel/traps_32.c         |    2 +-
 arch/sparc/kernel/traps_64.c         |    2 +-
 arch/unicore32/kernel/traps.c        |    2 +-
 arch/x86/kernel/cpu/amd.c            |    3 +-
 arch/x86/kernel/cpu/mcheck/mce.c     |    2 +-
 arch/x86/kernel/cpu/mcheck/p5.c      |    2 +-
 arch/x86/kernel/cpu/mcheck/winchip.c |    2 +-
 arch/x86/kernel/cpu/mtrr/generic.c   |    2 +-
 arch/x86/kernel/dumpstack.c          |    2 +-
 arch/xtensa/kernel/traps.c           |    2 +-
 drivers/acpi/custom_method.c         |    2 +-
 drivers/acpi/osl.c                   |    2 +-
 drivers/base/regmap/regmap-debugfs.c |    2 +-
 include/linux/kernel.h               |    6 +-
 include/linux/module.h               |    4 +-
 init/Kconfig                         |   20 +++++
 kernel/Makefile                      |   22 +-----
 kernel/module.c                      |  140 +++++++++++++++++++++-------------
 kernel/panic.c                       |   34 ++++-----
 kernel/sched/core.c                  |    2 +-
 kernel/sysctl.c                      |    2 +-
 lib/bug.c                            |    3 +-
 mm/memory.c                          |    2 +-
 mm/page_alloc.c                      |    2 +-
 mm/slab.c                            |    2 +-
 mm/slub.c                            |    2 +-
 scripts/mod/modpost.c                |    2 +
 scripts/sign-file                    |  134 +++++++++++++++-----------------
 sound/soc/soc-core.c                 |    2 +-
