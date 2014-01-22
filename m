Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754806AbaAVDv1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Jan 2014 22:51:27 -0500
Received: from mx1.redhat.com ([209.132.183.28]:53362 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753338AbaAVDvZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Jan 2014 22:51:25 -0500
Message-ID: <1390362683.21885.46.camel@localhost>
Subject: [GIT PULL] audit subsystem for 3.14
From: Eric Paris <eparis@redhat.com>
To: torvalds@linux-foundation.org
Cc: rgb@redhat.com, linux-audit@redhat.com, linux-kernel@vger.kernel.org
Date: Tue, 21 Jan 2014 22:51:23 -0500
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please consider pulling the following audit changes.  Again we stayed
pretty well contained inside the audit system.  Venturing out was fixing
a couple of function prototypes which were inconsistent (didn't hurt
anything, but we used the same value as an int, uint, u32, and I think
even a long in a couple of places).  We also made a couple of minor
changes to when a couple of LSMs called the audit system.  We hoped to
add aarch64 audit support this go round, but it wasn't ready.

There is one merge issue.  Take your code, then convert the prototype
for the first 4 functions changing the "u32 ses" to "unsigned int ses".
(Do not change the u32 secid)

I'm disappearing on vacation on Thursday.  I should have internet
access, but it'll be spotty.  If anything goes wrong please be sure to
cc rgb@redhat.com.  He'll make fixing things his top priority.

-Eric

The following changes since commit fc582aef7dcc27a7120cf232c1e76c569c7b6eab:

  Merge tag 'v3.12' (2013-11-22 18:57:54 -0500)

are available in the git repository at:


  git://git.infradead.org/users/eparis/audit.git master

for you to fetch changes up to f3411cb2b2e396a41ed3a439863f028db7140a34:

  audit: whitespace fix in kernel-parameters.txt (2014-01-17 17:15:02 -0500)

----------------------------------------------------------------
AKASHI Takahiro (2):
      audit: correct a type mismatch in audit_syscall_exit()
      audit: Modify a set of system calls in audit class definitions

Dan Duval (2):
      audit: efficiency fix 1: only wake up if queue shorter than backlog limit
      audit: efficiency fix 2: request exclusive wait since all need same resource

Eric Paris (8):
      audit: convert all sessionid declaration to unsigned int
      audit: wait_for_auditd rework for readability
      audit: documentation of audit= kernel parameter
      audit: use define's for audit version
      audit: remove needless switch in AUDIT_SET
      audit: rework AUDIT_TTY_SET to only grab spin_lock once
      audit: reorder AUDIT_TTY_SET arguments
      audit: remove pr_info for every network namespace

Eric W. Biederman (1):
      audit: Simplify and correct audit_log_capset

Gao feng (7):
      audit: remove useless code in audit_enable
      audit: fix incorrect order of log new and old feature
      audit: don't generate audit feature changed log when audit disabled
      audit: use old_lock in audit_set_feature
      audit: don't generate loginuid log when audit disabled
      audit: print error message when fail to create audit socket
      audit: fix incorrect set of audit_sock

Joe Perches (3):
      audit: Use hex_byte_pack_upper
      audit: Use more current logging style
      audit: Convert int limit uses to u32

Paul Davies C (2):
      audit: drop audit_log_abend()
      audit: Added exe field to audit core dump signal log

Richard Guy Briggs (24):
      audit: fix netlink portid naming and types
      audit: restore order of tty and ses fields in log output
      audit: listen in all network namespaces
      audit: reset audit backlog wait time after error recovery
      audit: make use of remaining sleep time from wait_for_auditd
      documentation: document the audit= kernel start-up parameter
      audit: add kernel set-up parameter to override default backlog limit
      audit: clean up AUDIT_GET/SET local variables and future-proof API
      audit: add audit_backlog_wait_time configuration option
      audit: fix incorrect type of sessionid
      audit: allow unlimited backlog queue
      audit: get rid of *NO* daemon at audit_pid=0 message
      audit: log AUDIT_TTY_SET config changes
      audit: refactor audit_receive_msg() to clarify AUDIT_*_RULE* cases
      audit: prevent an older auditd shutdown from orphaning a newer auditd startup
      selinux: call WARN_ONCE() instead of calling audit_log_start()
      smack: call WARN_ONCE() instead of calling audit_log_start()
      audit: drop audit_cmd_lock in AUDIT_USER family of cases
      audit: log on errors from filter user rules
      audit: fix dangling keywords in audit_log_set_loginuid() output
      audit: log task info on feature change
      audit: update MAINTAINERS
      audit: fix location of __net_initdata for audit_net_ops
      audit: whitespace fix in kernel-parameters.txt

Toshiyuki Okajima (1):
      audit: audit_log_start running on auditd should not stop

 Documentation/kernel-parameters.txt     |  16 ++++++
 MAINTAINERS                             |   3 +-
 drivers/tty/tty_audit.c                 |   2 +-
 include/asm-generic/audit_change_attr.h |   4 +-
 include/asm-generic/audit_write.h       |   6 +++
 include/linux/audit.h                   |  22 ++++----
 include/linux/init_task.h               |   2 +-
 include/net/netlabel.h                  |   2 +-
 include/net/xfrm.h                      |  20 +++----
 include/uapi/linux/audit.h              |   8 +++
 kernel/audit.c                          | 365 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++----------------------------------------------
 kernel/audit.h                          |  15 ++++--
 kernel/auditfilter.c                    |  93 +++++++++++++++++++--------------
 kernel/auditsc.c                        |  44 +++++++++-------
 kernel/capability.c                     |   2 +-
 net/xfrm/xfrm_policy.c                  |   8 +--
 net/xfrm/xfrm_state.c                   |   6 +--
 net/xfrm/xfrm_user.c                    |  12 ++---
 security/selinux/ss/services.c          |  12 ++---
 security/smack/smack_lsm.c              |   5 +-
 20 files changed, 404 insertions(+), 243 deletions(-)

