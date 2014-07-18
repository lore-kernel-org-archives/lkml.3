Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946011AbaGRTTV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jul 2014 15:19:21 -0400
Received: from smtp.outflux.net ([198.145.64.163]:59415 "EHLO smtp.outflux.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757007AbaGRTTS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jul 2014 15:19:18 -0400
Date: Fri, 18 Jul 2014 12:19:08 -0700
From: Kees Cook <keescook@chromium.org>
To: James Morris <jmorris@namei.org>
Cc: linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org,
        Andy Lutomirski <luto@amacapital.net>, Oleg Nesterov <oleg@redhat.com>,
        Will Drewry <wad@chromium.org>, Julien Tinnes <jln@chromium.org>,
        David Drysdale <drysdale@google.com>
Subject: [PULL] seccomp update (3.17)
Message-ID: <20140718191908.GA20534@www.outflux.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-HELO: www.outflux.net
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi James,

Please pull these seccomp changes for 3.17.

(And if I should base off something other than security-next, please
let me know. Or if there are any things I should be doing differently
with this tree.)

Thanks!

-Kees

The following changes since commit 32c2e6752ff0f48fe03b9e1c7c64bde580a840d2:

  ima: provide double buffering for hash calculation (2014-07-17 09:35:11 -0400)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/kees/linux.git tags/seccomp-3.17

for you to fetch changes up to c2e1f2e30daa551db3c670c0ccfeab20a540b9e1:

  seccomp: implement SECCOMP_FILTER_FLAG_TSYNC (2014-07-18 12:13:40 -0700)

----------------------------------------------------------------
seccomp TSYNC support for 3.17

----------------------------------------------------------------
Kees Cook (12):
      MAINTAINERS: create seccomp entry
      seccomp: create internal mode-setting function
      seccomp: extract check/assign mode helpers
      seccomp: split mode setting routines
      seccomp: add "seccomp" syscall
      ARM: add seccomp syscall
      MIPS: add seccomp syscall
      sched: move no_new_privs into new atomic flags
      seccomp: split filter prep from check and apply
      seccomp: introduce writer locking
      seccomp: allow mode setting across threads
      seccomp: implement SECCOMP_FILTER_FLAG_TSYNC

 MAINTAINERS                         |   10 +
 arch/Kconfig                        |    1 +
 arch/arm/include/uapi/asm/unistd.h  |    1 +
 arch/arm/kernel/calls.S             |    1 +
 arch/mips/include/uapi/asm/unistd.h |   15 +-
 arch/mips/kernel/scall32-o32.S      |    1 +
 arch/mips/kernel/scall64-64.S       |    1 +
 arch/mips/kernel/scall64-n32.S      |    1 +
 arch/mips/kernel/scall64-o32.S      |    1 +
 arch/x86/syscalls/syscall_32.tbl    |    1 +
 arch/x86/syscalls/syscall_64.tbl    |    1 +
 fs/exec.c                           |    6 +-
 include/linux/sched.h               |   18 +-
 include/linux/seccomp.h             |    8 +-
 include/linux/syscalls.h            |    2 +
 include/uapi/asm-generic/unistd.h   |    4 +-
 include/uapi/linux/seccomp.h        |    7 +
 kernel/fork.c                       |   49 ++++-
 kernel/seccomp.c                    |  412 ++++++++++++++++++++++++++++++-----
 kernel/sys.c                        |    4 +-
 kernel/sys_ni.c                     |    3 +
 security/apparmor/domain.c          |    4 +-
 22 files changed, 471 insertions(+), 80 deletions(-)

-- 
Kees Cook
Chrome OS Security
