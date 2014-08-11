Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752081AbaHKCor (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Aug 2014 22:44:47 -0400
Received: from ozlabs.org ([103.22.144.67]:52588 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751735AbaHKCoq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Aug 2014 22:44:46 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: "Linus Torvalds" <torvalds@linux-foundation.org>
Cc: "LKML" <linux-kernel@vger.kernel.org>
Cc: Alexey Dobriyan <adobriyan@gmail.com>
Cc: Dave Jones <davej@redhat.com>
Cc: Joe Perches <joe@perches.com>
Cc: Michal Nazarewicz <mina86@mina86.com>
Cc: Petr Mladek <pmladek@suse.cz>
Cc: Rasmus Villemoes <linux@rasmusvillemoes.dk>
Cc: Russell King <rmk+kernel@arm.linux.org.uk>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Stewart Smith <stewart@linux.vnet.ibm.com>
Subject: [PULL] modules-next
User-Agent: Notmuch/0.17 (http://notmuchmail.org) Emacs/24.3.1 (x86_64-pc-linux-gnu)
Date: Mon, 11 Aug 2014 12:02:30 +0930
Message-ID: <87sil3ah8h.fsf@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following changes since commit 15ba2236f3556fc01b9ca91394465152b5ea74b6:

  Merge git://git.kernel.org/pub/scm/linux/kernel/git/davem/net (2014-07-21 22:46:01 -0700)

are available in the git repository at:


  git://git.kernel.org/pub/scm/linux/kernel/git/rusty/linux.git tags/modules-next-for-linus

for you to fetch changes up to 76215b04fd297c008b91ece732ed36e67e0181fa:

  arch/powerpc/platforms/powernv/opal-dump.c: fix world-writable sysfs files (2014-08-07 22:38:55 +0930)

----------------------------------------------------------------
This finally applies the stricter sysfs perms checking we pulled out
before last merge window.  A few stragglers are fixed (thanks linux-next!)

Cheers,
Rusty.

----------------------------------------------------------------
Michal Nazarewicz (1):
      scripts: modpost: fix compilation warning

Petr Mladek (2):
      module: add within_module() function
      module: return bool from within_module*()

Rasmus Villemoes (1):
      scripts: modpost: Remove numeric suffix pattern matching

Russell King (1):
      ARM: avoid ARM binutils leaking ELF local symbols

Rusty Russell (5):
      modules: Fix build error in moduleloader.h
      sysfs: disallow world-writable files.
      drivers/video/fbdev/s3c2410fb.c: don't make debug world-writable.
      arch/powerpc/platforms/powernv/opal-elog.c: fix world-writable sysfs files
      arch/powerpc/platforms/powernv/opal-dump.c: fix world-writable sysfs files

 arch/powerpc/platforms/powernv/opal-dump.c |  4 +--
 arch/powerpc/platforms/powernv/opal-elog.c |  4 +--
 drivers/video/fbdev/s3c2410fb.c            |  2 +-
 include/linux/kernel.h                     |  2 ++
 include/linux/module.h                     | 11 ++++--
 include/linux/moduleloader.h               |  6 ++--
 kernel/module.c                            | 14 ++++----
 scripts/mod/modpost.c                      | 58 ++++++++----------------------
 8 files changed, 40 insertions(+), 61 deletions(-)
