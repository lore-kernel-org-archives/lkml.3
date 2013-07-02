Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755028Ab3GBRoF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Jul 2013 13:44:05 -0400
Received: from mail1.windriver.com ([147.11.146.13]:59706 "EHLO
	mail1.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753988Ab3GBRoD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Jul 2013 13:44:03 -0400
Date: Tue, 2 Jul 2013 13:44:02 -0400
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: [GIT PULL] Stage 1 of __cpuinit removal
Message-ID: <20130702174402.GA21817@windriver.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull the following to get stage one of the __cpuinit removal.

The two commits here 1) dummy out all the __cpuinit macros so that we no
longer generate such sections, and then 2) remove all the section
processing that we used to do for those sections.

This makes all the __cpuinit and friends no-ops, so that we can remove
the use cases of it at our leisure.  Expect stage 2, which does the
tree wide removal sweep at the end of the merge window.

Note that you will get a conflict on vmlinux.lds -- from the final
__devinit removal change from Greg's device pull.  It isn't complex,
but a resolved version of the file (and a __devinit removal aware
version of the modpost commit) is present in any linux-next tree from
the past week if a double check is desired.

Thanks,
Paul.

---

The following changes since commit 9e895ace5d82df8929b16f58e9f515f6d54ab82d:

  Linux 3.10-rc7 (2013-06-22 09:47:31 -1000)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/paulg/linux.git cpuinit-delete

for you to fetch changes up to e24f6628811e2d4531b443684b598f7050932012:

  modpost: remove all traces of cpuinit/cpuexit sections (2013-06-26 12:17:06 -0400)

----------------------------------------------------------------
Paul Gortmaker (2):
      init.h: remove __cpuinit sections from the kernel
      modpost: remove all traces of cpuinit/cpuexit sections

 include/asm-generic/vmlinux.lds.h | 12 ---------
 include/linux/init.h              | 19 +++++++-------
 scripts/mod/modpost.c             | 52 +++++++--------------------------------
 3 files changed, 19 insertions(+), 65 deletions(-)
