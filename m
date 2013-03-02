Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752153Ab3CBNGF (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Mar 2013 08:06:05 -0500
Received: from mail.windriver.com ([147.11.1.11]:49586 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750933Ab3CBNGD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Mar 2013 08:06:03 -0500
From: Jason Wessel <jason.wessel@windriver.com>
To: <torvalds@linux-foundation.org>
CC: <linux-kernel@vger.kernel.org>, <kgdb-bugreport@lists.sourceforge.net>
Subject: [GIT PULL] KGDB/KDB fixes for 3.9
Date: Sat, 2 Mar 2013 07:05:52 -0600
Message-ID: <1362229552-28314-1-git-send-email-jason.wessel@windriver.com>
X-Mailer: git-send-email 1.7.9.5
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull the kgdb tree's fixes/improvements.

For a change we removed more code than we added.  If people aren't using
it we shouldn't be carrying it. :-)

git://git.kernel.org/pub/scm/linux/kernel/git/jwessel/kgdb.git tags/for_linus-3.9

Thanks,
Jason.

The following changes since commit d895cb1af15c04c522a25c79cc429076987c089b:

  Merge branch 'for-linus' of git://git.kernel.org/pub/scm/linux/kernel/git/viro/vfs (2013-02-26 20:16:07 -0800)

are available in the git repository at:


  git://git.kernel.org/pub/scm/linux/kernel/git/jwessel/kgdb.git tags/for_linux-3.9

for you to fetch changes up to 397884d2e367aed778de69761181d85e348393bf:

  kdb: Remove unhandled ssb command (2013-03-02 06:53:22 -0600)

----------------------------------------------------------------
KGDB/KDB fixes and cleanups
 Cleanups
   Remove kdb ssb command - there is no in kernel disassembler to support it
   Remove kdb ll command - Always caused a kernel oops and there were no
       bug reports so no one was using this command
   Use kernel ARRAY_SIZE macro instead of array computations

 Fixes
   Stop oops in kdb if user executes kdb_defcmd with args
   kdb help command truncated text
   ppc64 support for kgdbts
   Add missing kconfig option from original kdb port for dealing with
      catastrophic kernel crashes such that you can reboot automatically
      on continue from kdb

----------------------------------------------------------------
Jason Wessel (4):
      kdb: Fix overlap in buffers with strcpy
      kdb_main: fix help print
      kdb: Remove the ll command
      kdb: Prevent kernel oops with kdb_defcmd

John Blackwood (1):
      kdb: A fix for kdb command table expansion

Matt Klein (1):
      kdb: Setup basic kdb state before invoking commands via kgdb

Robert Obermeier (1):
      Fixed dead ifdef block by adding missing Kconfig option.

Sasha Levin (1):
      kdb: use ARRAY_SIZE where possible

Tiejun Chen (1):
      kgdb/kgdbts: support ppc64

Vincent (1):
      kdb: Remove unhandled ssb command

 drivers/misc/kgdbts.c           |    2 +
 kernel/debug/debug_core.h       |    2 +
 kernel/debug/gdbstub.c          |    3 +
 kernel/debug/kdb/kdb_bp.c       |   20 +-----
 kernel/debug/kdb/kdb_debugger.c |   25 ++++++--
 kernel/debug/kdb/kdb_main.c     |  135 +++++++++++----------------------------
 kernel/debug/kdb/kdb_private.h  |    4 --
 lib/Kconfig.kgdb                |   18 ++++++
 8 files changed, 82 insertions(+), 127 deletions(-)
