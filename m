Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752062AbaJEXPK (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Oct 2014 19:15:10 -0400
Received: from relay3-d.mail.gandi.net ([217.70.183.195]:60396 "EHLO
	relay3-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751596AbaJEXPH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Oct 2014 19:15:07 -0400
X-Originating-IP: 50.43.41.112
Date: Sun, 5 Oct 2014 16:14:59 -0700
From: Josh Triplett <josh@joshtriplett.org>
To: torvalds@linux-foundation.org
Cc: linux-kernel@vger.kernel.org
Subject: [GIT PULL 3.18] tinification for 3.18
Message-ID: <20141005231459.GA17951@thin>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Resending this for the 3.18 merge window.

The following changes since commit 7d1311b93e58ed55f3a31cc8f94c4b8fe988a2b9:

  Linux 3.17-rc1 (2014-08-16 10:40:26 -0600)

are available in the git repository at:

  https://git.kernel.org/pub/scm/linux/kernel/git/josh/linux.git tags/tiny/for-3.18

for you to fetch changes up to 3cf6b0151ba584714f6eafb99bc66d7326efeed7:

  Merge branches 'tiny/bloat-o-meter-no-SyS', 'tiny/more-procless', 'tiny/no-advice', 'tiny/tinyconfig' and 'tiny/x86-boot-compressed-use-yn' into tiny/next (2014-09-22 23:14:40 -0700)

----------------------------------------------------------------
Tinification for 3.18

----------------------------------------------------------------
Josh Triplett (10):
      x86, platform, kconfig: move kvmconfig functionality to a helper
      x86: Add "make tinyconfig" to configure the tiniest possible kernel
      x86, boot: Use the usual -y -n mechanism for objects in vmlinux
      x86, boot: Don't compile aslr.c when !CONFIG_RANDOMIZE_BASE
      x86, boot: Don't compile early_serial_console.c when !CONFIG_EARLY_PRINTK
      x86: Drop support for /proc files when !CONFIG_PROC_FS
      x86: Support compiling out human-friendly processor feature names
      mm: Support compiling out madvise and fadvise
      bloat-o-meter: Ignore syscall aliases SyS_ and compat_SyS_
      Merge branches 'tiny/bloat-o-meter-no-SyS', 'tiny/more-procless', 'tiny/no-advice', 'tiny/tinyconfig' and 'tiny/x86-boot-compressed-use-yn' into tiny/next

 arch/x86/Kconfig                                | 12 +++++
 arch/x86/Makefile                               |  7 ---
 arch/x86/boot/Makefile                          |  7 ++-
 arch/x86/boot/compressed/Makefile               | 19 +++----
 arch/x86/boot/compressed/aslr.c                 |  3 --
 arch/x86/boot/compressed/early_serial_console.c |  4 --
 arch/x86/boot/cpu.c                             | 68 +++++++++++++++----------
 arch/x86/configs/tiny.config                    |  1 +
 arch/x86/include/asm/cpufeature.h               |  7 +++
 arch/x86/kernel/cpu/Makefile                    |  7 ++-
 arch/x86/kernel/cpu/common.c                    |  4 +-
 init/Kconfig                                    | 10 ++++
 kernel/configs/tiny.config                      |  4 ++
 kernel/sys_ni.c                                 |  3 ++
 mm/Makefile                                     |  7 ++-
 scripts/bloat-o-meter                           |  2 +
 scripts/kconfig/Makefile                        | 19 +++++++
 17 files changed, 127 insertions(+), 57 deletions(-)
 create mode 100644 arch/x86/configs/tiny.config
 create mode 100644 kernel/configs/tiny.config
