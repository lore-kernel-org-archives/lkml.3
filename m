Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756877AbbAHQiN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Jan 2015 11:38:13 -0500
Received: from mail1.windriver.com ([147.11.146.13]:43146 "EHLO
	mail1.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754622AbbAHQiL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Jan 2015 11:38:11 -0500
From: Jason Wessel <jason.wessel@windriver.com>
To: <torvalds@linux-foundation.org>
CC: <linux-kernel@vger.kernel.org>, <kgdb-bugreport@lists.sourceforge.net>
Subject: [GIT PULL] KGDB/KDB fixes for 3.19-rc4
Date: Thu, 8 Jan 2015 10:37:59 -0600
Message-ID: <1420735079-28822-1-git-send-email-jason.wessel@windriver.com>
X-Mailer: git-send-email 1.9.1
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull the kgdb tree bug fixes.

These have been around since 3.17 and in kgdb-next for the last 9
weeks and some will go back to -stable.

Summary of changes:

KGDB/KDB fixes and cleanups
 Cleanups
   kdb: Remove unused command flags, repeat flags and KDB_REPEAT_NONE

 Fixes
   kgdb/kdb: Allow access on a single core, if a CPU round up is deemed
      impossible, which will allow inspection of the now "trashed" kernel
   kdb: Add enable mask for the command groups
   kdb: access controls to restrict sensitive commands 


git://git.kernel.org/pub/scm/linux/kernel/git/jwessel/kgdb.git tags/for_linus-3.19-rc4

Thanks,
Jason.

The following changes since commit 206c5f60a3d902bc4b56dab2de3e88de5eb06108:

  Linux 3.18-rc4 (2014-11-09 14:55:29 -0800)

are available in the git repository at:

  . kgdb-next

for you to fetch changes up to 0f16996cf2ed7c368dd95b4c517ce572b96a10f5:

  kernel/debug/debug_core.c: Logging clean-up (2014-11-11 09:31:53 -0600)

----------------------------------------------------------------
Anton Vorontsov (6):
      kdb: Remove currently unused kdbtab_t->cmd_flags
      kdb: Rename kdb_repeat_t to kdb_cmdflags_t, cmd_repeat to cmd_flags
      kdb: Rename kdb_register_repeat() to kdb_register_flags()
      kdb: Use KDB_REPEAT_* values as flags
      kdb: Remove KDB_REPEAT_NONE flag
      kdb: Add enable mask for groups of commands

Daniel Thompson (3):
      kdb: Categorize kdb commands (similar to SysRq categorization)
      kdb: Allow access to sensitive commands to be restricted by default
      kgdb: timeout if secondary CPUs ignore the roundup

Fabian Frederick (1):
      kernel/debug/debug_core.c: Logging clean-up

 include/linux/kdb.h             |  62 ++++++++--
 kernel/debug/debug_core.c       |  52 ++++----
 kernel/debug/kdb/kdb_bp.c       |  37 +++---
 kernel/debug/kdb/kdb_debugger.c |   4 +
 kernel/debug/kdb/kdb_main.c     | 267 +++++++++++++++++++++++++---------------
 kernel/debug/kdb/kdb_private.h  |   3 +-
 kernel/trace/trace_kdb.c        |   4 +-
 lib/Kconfig.kgdb                |  25 ++++
 8 files changed, 306 insertions(+), 148 deletions(-)
