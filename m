Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752590AbaGBMMX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jul 2014 08:12:23 -0400
Received: from mail-wg0-f44.google.com ([74.125.82.44]:63392 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752064AbaGBMMV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jul 2014 08:12:21 -0400
Message-ID: <53B3F556.7050002@suse.cz>
Date: Wed, 02 Jul 2014 14:04:38 +0200
From: Jiri Slaby <jslaby@suse.cz>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Stephen Rothwell <sfr@canb.auug.org.au>
CC: linux-kernel@vger.kernel.org, tj@kernel.org, rostedt@goodmis.org,
        mingo@redhat.com, akpm@linux-foundation.org, andi@firstfloor.org,
        paulmck@linux.vnet.ibm.com, pavel@ucw.cz, jirislaby@gmail.com,
        Vojtech Pavlik <vojtech@suse.cz>, Michael Matz <matz@suse.de>,
        Jiri Kosina <jkosina@suse.cz>
Subject: kGraft to -next [was: 00/21 kGraft]
References: <1403694329-3064-1-git-send-email-jslaby@suse.cz>
In-Reply-To: <1403694329-3064-1-git-send-email-jslaby@suse.cz>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=ISO-8859-2
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/25/2014 01:05 PM, Jiri Slaby wrote:
> Hi,
> 
> this is a repost of the second round of RFC on kGraft, the linux
> kernel online patching developed at SUSE. This repost only widened the
> target audience for broader review, no code change happened.
> 
> Please speak up now (or be silent till the next merge window). That
> is, if there are no objections, we plan pushing the tree into -next
> and asking Linus in the next merge window for comments.
> 
> The patches are posted as a reply to this email and can be also
> obtained as a whole tree from:
> https://git.kernel.org/cgit/linux/kernel/git/jirislaby/kgraft.git/log/?h=kgraft

Stephen,

may I ask you to add the kGraft tree to -next?

git://git.kernel.org/pub/scm/linux/kernel/git/jirislaby/kgraft.git#kgraft

Thank you.

 Documentation/kgraft.txt           |  44 ++++
 MAINTAINERS                        |   9 +
 arch/x86/Kconfig                   |   2 +
 arch/x86/include/asm/kgraft.h      |  61 +++++
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
 include/linux/kgraft.h             | 130 ++++++++++
 include/linux/sched.h              |   9 +
 kernel/Kconfig.kgraft              |  12 +
 kernel/Makefile                    |   1 +
 kernel/hung_task.c                 |   5 +-
 kernel/kgraft.c                    | 477 ++++++++++++++++++++++++++++++
 kernel/kgraft_files.c              | 150 ++++++++++++
 kernel/kthread.c                   |   3 +
 kernel/rcu/tree.c                  |   6 +-
 kernel/rcu/tree_plugin.h           |  10 +-
 kernel/smpboot.c                   |   2 +
 kernel/trace/ftrace.c              |  30 +++
 kernel/trace/trace.h               |   2 -
 kernel/workqueue.c                 |   3 +
 mm/huge_memory.c                   |   6 +-
 net/bluetooth/rfcomm/core.c        |   2 +
 samples/Kconfig                    |   8 +
 samples/Makefile                   |   3 +-
 samples/kgraft/Makefile            |   1 +
 samples/kgraft/kgraft_patcher.c    |  97 ++++++++
 34 files changed, 1104 insertions(+), 15 deletions(-)
 create mode 100644 Documentation/kgraft.txt
 create mode 100644 arch/x86/include/asm/kgraft.h
 create mode 100644 include/linux/kgraft.h
 create mode 100644 kernel/Kconfig.kgraft
 create mode 100644 kernel/kgraft.c
 create mode 100644 kernel/kgraft_files.c
 create mode 100644 samples/kgraft/Makefile
 create mode 100644 samples/kgraft/kgraft_patcher.c

-- 
js
suse labs
