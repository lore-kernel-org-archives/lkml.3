Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759337AbaD3Oeg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Apr 2014 10:34:36 -0400
Received: from ip4-83-240-18-248.cust.nbox.cz ([83.240.18.248]:52335 "EHLO
	ip4-83-240-18-248.cust.nbox.cz" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759213AbaD3Oav (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Apr 2014 10:30:51 -0400
From: Jiri Slaby <jslaby@suse.cz>
To: linux-kernel@vger.kernel.org
Cc: jirislaby@gmail.com, Vojtech Pavlik <vojtech@suse.cz>,
        Michael Matz <matz@suse.de>, Jiri Kosina <jkosina@suse.cz>,
        Jiri Slaby <jslaby@suse.cz>
Subject: [RFC 00/16] kGraft
Date: Wed, 30 Apr 2014 16:30:33 +0200
Message-Id: <1398868249-26169-1-git-send-email-jslaby@suse.cz>
X-Mailer: git-send-email 1.9.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

this is the first RFC on kGraft, the linux kernel online patching
developed at SUSE.

The patches are posted as a reply to this email and can be also
obtained as a whole tree at:
https://git.kernel.org/cgit/linux/kernel/git/jirislaby/kgraft.git/log/?h=kgraft

Jiri Kosina (4):
  kgr: initial code
  kgr: x86: refuse to build without fentry support
  kgr: add procfs interface for per-process 'kgr_in_progress'
  kgr: make a per-process 'in progress' flag a single bit

Jiri Slaby (12):
  ftrace: Add function to find fentry of function
  ftrace: Make ftrace_is_dead available globally
  kgr: add testing kgraft patch
  kgr: update Kconfig documentation
  kgr: add Documentation
  kgr: trigger the first check earlier
  kgr: sched.h, introduce kgr_task_safe helper
  kgr: mark task_safe in some kthreads
  kgr: kthreads support
  kgr: handle irqs
  kgr: add tools
  kgr: add MAINTAINERS entry

 Documentation/kgr.txt              |   26 +
 MAINTAINERS                        |    9 +
 arch/x86/Kconfig                   |    2 +
 arch/x86/include/asm/kgr.h         |   45 +
 arch/x86/include/asm/thread_info.h |    6 +-
 arch/x86/kernel/entry_64.S         |    9 +
 arch/x86/kernel/x8664_ksyms_64.c   |    1 +
 drivers/base/devtmpfs.c            |    1 +
 fs/jbd2/journal.c                  |    2 +
 fs/notify/mark.c                   |    5 +-
 fs/proc/base.c                     |   11 +
 include/linux/ftrace.h             |    4 +
 include/linux/kgr.h                |   86 +
 include/linux/sched.h              |    9 +
 kernel/Kconfig.kgr                 |   10 +
 kernel/Makefile                    |    1 +
 kernel/hung_task.c                 |    5 +-
 kernel/kgr.c                       |  338 +++
 kernel/kthread.c                   |    3 +
 kernel/rcu/tree.c                  |    6 +-
 kernel/rcu/tree_plugin.h           |    9 +-
 kernel/trace/ftrace.c              |   29 +
 kernel/trace/trace.h               |    2 -
 kernel/workqueue.c                 |    1 +
 samples/Kconfig                    |    8 +
 samples/Makefile                   |    3 +-
 samples/kgr/Makefile               |    1 +
 samples/kgr/kgr_patcher.c          |   97 +
 tools/Makefile                     |   13 +-
 tools/kgraft/Makefile              |   30 +
 tools/kgraft/README                |   50 +
 tools/kgraft/TODO                  |   20 +
 tools/kgraft/app.c                 |   35 +
 tools/kgraft/app.h                 |    7 +
 tools/kgraft/create-kgrmodule.sh   |   25 +
 tools/kgraft/create-stub.sh        |   53 +
 tools/kgraft/dwarf-inline-tree.c   |  544 +++++
 tools/kgraft/dwarf_names.awk       |  126 ++
 tools/kgraft/dwarf_names.c         | 4366 ++++++++++++++++++++++++++++++++++++
 tools/kgraft/dwarf_names.h         |   53 +
 tools/kgraft/extract-syms.sh       |   18 +
 tools/kgraft/it2rev.pl             |   40 +
 tools/kgraft/objcopy.diff          |  131 ++
 tools/kgraft/symlist               |    1 +
 44 files changed, 6225 insertions(+), 16 deletions(-)
 create mode 100644 Documentation/kgr.txt
 create mode 100644 arch/x86/include/asm/kgr.h
 create mode 100644 include/linux/kgr.h
 create mode 100644 kernel/Kconfig.kgr
 create mode 100644 kernel/kgr.c
 create mode 100644 samples/kgr/Makefile
 create mode 100644 samples/kgr/kgr_patcher.c
 create mode 100644 tools/kgraft/Makefile
 create mode 100644 tools/kgraft/README
 create mode 100644 tools/kgraft/TODO
 create mode 100644 tools/kgraft/app.c
 create mode 100644 tools/kgraft/app.h
 create mode 100755 tools/kgraft/create-kgrmodule.sh
 create mode 100755 tools/kgraft/create-stub.sh
 create mode 100644 tools/kgraft/dwarf-inline-tree.c
 create mode 100644 tools/kgraft/dwarf_names.awk
 create mode 100644 tools/kgraft/dwarf_names.c
 create mode 100644 tools/kgraft/dwarf_names.h
 create mode 100755 tools/kgraft/extract-syms.sh
 create mode 100644 tools/kgraft/it2rev.pl
 create mode 100644 tools/kgraft/objcopy.diff
 create mode 100644 tools/kgraft/symlist

-- 
1.9.2

