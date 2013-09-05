Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756478Ab3IEVHl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Sep 2013 17:07:41 -0400
Received: from out03.mta.xmission.com ([166.70.13.233]:58520 "EHLO
	out03.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753678Ab3IEVHh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Sep 2013 17:07:37 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Linux Containers <containers@lists.linux-foundation.org>,
        <linux-kernel@vger.kernel.org>, <linux-fsdevel@vger.kernel.org>,
        "Serge E. Hallyn" <serge@hallyn.com>
Date: Thu, 05 Sep 2013 14:07:29 -0700
Message-ID: <87mwnrht9q.fsf@xmission.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-XM-AID: U2FsdGVkX19dCbzVCpV8zMUHNobaGkcDP1Q+/vvtUuo=
X-SA-Exim-Connect-IP: 98.207.154.105
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: * -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
	* -3.0 BAYES_00 BODY: Bayes spam probability is 0 to 1%
	*      [score: 0.0000]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa06 1397; Body=1 Fuz1=1 Fuz2=1]
	*  1.2 XMSubMetaSxObfu_03 Obfuscated Sexy Noun-People
	*  1.0 XMSubMetaSx_00 1+ Sexy Words
X-Spam-DCC: XMission; sa06 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;Linus Torvalds <torvalds@linux-foundation.org>
X-Spam-Relay-Country: 
Subject: [GIT PULL] namespace chnages for 3.12
X-Spam-Flag: No
X-SA-Exim-Version: 4.2.1 (built Wed, 14 Nov 2012 14:26:46 -0700)
X-SA-Exim-Scanned: Yes (on in02.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Linus,

Please pull the for-linus git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/ebiederm/user-namespace.git for-linus

   HEAD: c7b96acf1456ef127fef461fcfedb54b81fecfbb userns:  Kill nsown_capable it makes the wrong thing easy

   This tree is against v3.11-rc1

This is an assorted mishmash of small cleanups, enhancements and bug
fixes.  The major theme is user namespace mount restrictions.
nsown_capable is killed as it encourages not thinking about details that
need to be considered.  A very hard to hit pid namespace exiting bug was
finally tracked and fixed.  A couple of cleanups to the basic namespace
infrastructure.

Finally there is an enhancement that makes per user namespace
capabilities usable as capabilities, and an enhancement that allows the
per userns root to nice other processes in the user namespace.

Eric W. Biederman (10):
      vfs: Lock in place mounts from more privileged users
      proc: Restrict mounting the proc filesystem
      vfs: Don't copy mount bind mounts of /proc/<pid>/ns/mnt between namespaces
      userns: Better restrictions on when proc and sysfs can be mounted
      sysfs: Restrict mounting sysfs
      pidns: Fix hang in zap_pid_ns_processes by sending a potentially extra wakeup
      namespaces: Simplify copy_namespaces so it is clear what is going on.
      userns: Allow PR_CAPBSET_DROP in a user namespace.
      pidns: Don't have unshare(CLONE_NEWPID) imply CLONE_THREAD
      userns:  Kill nsown_capable it makes the wrong thing easy

Raphael S.Carvalho (1):
      kernel/nsproxy.c: Improving a snippet of code.

Serge Hallyn (1):
      capabilities: allow nice if we are privileged

 fs/namespace.c                 |  121 +++++++++++++++++++++++++++++++---------
 fs/open.c                      |    2 +-
 fs/pnode.h                     |    5 +-
 fs/proc/root.c                 |    6 ++-
 fs/sysfs/mount.c               |   11 +++-
 include/linux/capability.h     |    1 -
 include/linux/fs.h             |    1 +
 include/linux/kobject_ns.h     |    2 +
 include/linux/mount.h          |    1 +
 include/linux/user_namespace.h |    4 -
 ipc/namespace.c                |    2 +-
 kernel/capability.c            |   12 ----
 kernel/fork.c                  |    5 --
 kernel/groups.c                |    2 +-
 kernel/nsproxy.c               |   36 ++++--------
 kernel/pid.c                   |    1 +
 kernel/pid_namespace.c         |    2 +-
 kernel/sys.c                   |   20 +++---
 kernel/uid16.c                 |    2 +-
 kernel/user.c                  |    2 -
 kernel/user_namespace.c        |    2 -
 kernel/utsname.c               |    2 +-
 lib/kobject.c                  |   15 +++++
 net/core/net-sysfs.c           |    8 +++
 net/core/net_namespace.c       |    2 +-
 net/core/scm.c                 |    4 +-
 security/commoncap.c           |   10 ++--
 27 files changed, 177 insertions(+), 104 deletions(-)
