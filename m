Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756079AbaFYLFk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jun 2014 07:05:40 -0400
Received: from ip4-83-240-18-248.cust.nbox.cz ([83.240.18.248]:41058 "EHLO
	ip4-83-240-18-248.cust.nbox.cz" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754214AbaFYLFh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jun 2014 07:05:37 -0400
From: Jiri Slaby <jslaby@suse.cz>
To: linux-kernel@vger.kernel.org
Cc: tj@kernel.org, rostedt@goodmis.org, mingo@redhat.com,
        akpm@linux-foundation.org, andi@firstfloor.org,
        paulmck@linux.vnet.ibm.com, pavel@ucw.cz, jirislaby@gmail.com,
        Vojtech Pavlik <vojtech@suse.cz>, Michael Matz <matz@suse.de>,
        Jiri Kosina <jkosina@suse.cz>, Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 00/21] kGraft
Date: Wed, 25 Jun 2014 13:05:29 +0200
Message-Id: <1403694329-3064-1-git-send-email-jslaby@suse.cz>
X-Mailer: git-send-email 2.0.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

this is a repost of the second round of RFC on kGraft, the linux
kernel online patching developed at SUSE. This repost only widened the
target audience for broader review, no code change happened.

Please speak up now (or be silent till the next merge window). That
is, if there are no objections, we plan pushing the tree into -next
and asking Linus in the next merge window for comments.

The patches are posted as a reply to this email and can be also
obtained as a whole tree from:
https://git.kernel.org/cgit/linux/kernel/git/jirislaby/kgraft.git/log/?h=kgraft

Jiri Kosina (6):
  kgr: initial code
  kgr: x86: refuse to build without fentry support
  kgr: add procfs interface for per-process 'kgr_in_progress'
  kgr: make a per-process 'in progress' flag a single bit
  kgr: expose global 'in_progress' state through procfs
  kgr: x86: optimize handling of CPU-bound tasks

Jiri Slaby (14):
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
  kgr: add MAINTAINERS entry
  kgr: add support for missing functions
  kgr: exercise non-present function
  kgr: fix race of stub and patching

Libor Pechacek (1):
  kgr: rephrase the "kGraft failed" message

 Documentation/kgraft.txt           |  44 ++++
 MAINTAINERS                        |   9 +
 arch/x86/Kconfig                   |   2 +
 arch/x86/include/asm/kgraft.h      |  61 ++++++
 arch/x86/include/asm/thread_info.h |   6 +-
 arch/x86/kernel/entry_64.S         |   9 +
 drivers/base/devtmpfs.c            |   1 +
 drivers/scsi/scsi_error.c          |   2 +
 drivers/usb/core/hub.c             |   4 +-
 fs/jbd2/journal.c                  |   2 +
 fs/notify/mark.c                   |   5 +-
 fs/proc/base.c                     |  11 +
 include/linux/freezer.h            |   2 +
 include/linux/ftrace.h             |   4 +
 include/linux/kgraft.h             |  90 ++++++++
 include/linux/sched.h              |   9 +
 kernel/Kconfig.kgraft              |  10 +
 kernel/Makefile                    |   1 +
 kernel/hung_task.c                 |   5 +-
 kernel/kgraft.c                    | 430 +++++++++++++++++++++++++++++++++++++
 kernel/kthread.c                   |   3 +
 kernel/rcu/tree.c                  |   6 +-
 kernel/rcu/tree_plugin.h           |  10 +-
 kernel/smpboot.c                   |   2 +
 kernel/trace/ftrace.c              |  30 +++
 kernel/trace/trace.h               |   2 -
 kernel/workqueue.c                 |   3 +
 mm/huge_memory.c                   |   1 +
 net/bluetooth/rfcomm/core.c        |   2 +
 samples/Kconfig                    |   8 +
 samples/Makefile                   |   3 +-
 samples/kgraft/Makefile            |   1 +
 samples/kgraft/kgraft_patcher.c    |  99 +++++++++
 33 files changed, 864 insertions(+), 13 deletions(-)
 create mode 100644 Documentation/kgraft.txt
 create mode 100644 arch/x86/include/asm/kgraft.h
 create mode 100644 include/linux/kgraft.h
 create mode 100644 kernel/Kconfig.kgraft
 create mode 100644 kernel/kgraft.c
 create mode 100644 samples/kgraft/Makefile
 create mode 100644 samples/kgraft/kgraft_patcher.c

-- 
2.0.0

