Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754338AbaFQCXW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jun 2014 22:23:22 -0400
Received: from mail-pa0-f53.google.com ([209.85.220.53]:63363 "EHLO
	mail-pa0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753384AbaFQCXV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jun 2014 22:23:21 -0400
From: Andy Lutomirski <luto@amacapital.net>
To: x86@kernel.org, linux-kernel@vger.kernel.org
Cc: Andy Lutomirski <luto@amacapital.net>
Subject: [PATCH 0/8] x86: vdso and vsyscall round 1 for 3.17
Date: Mon, 16 Jun 2014 19:23:07 -0700
Message-Id: <cover.1402971639.git.luto@amacapital.net>
X-Mailer: git-send-email 1.9.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is mostly cleanups.  Patch 1 fixes a minor bug; it might make sense
to backport it.

Patch 3 removes the vsyscall mapping when vsyscall=none.

Patches 4 and 5 remove everything except gtod from the vvar page; the
other vvars weren't really necessary.

Patch 2, 6, 7, and 8 are pure cleanups.

This is based on tip/x86/vdso.

Andy Lutomirski (8):
  x86_64,vsyscall: Fix warn_bad_vsyscall log output
  x86_64,vsyscall: Move all of the gate_area code to vsyscall_64.c
  x86_64,vsyscall: Turn vsyscalls all the way off when vsyscall=none
  x86_64,vdso: Remove jiffies from the vvar page
  x86,vdso: Replace vgetcpu_mode with static_cpu_has
  x86_64: Move getcpu code from vsyscall_64.c to vdso/vma.c
  x86_64,vsyscall: Rewrite comment and clean up headers in vsyscall code
  x86_64,vdso: Clean up vgetcpu init and merge the vdso initcalls

 arch/x86/include/asm/vgtod.h    |  21 ++++++
 arch/x86/include/asm/vsyscall.h |  29 --------
 arch/x86/include/asm/vvar.h     |   2 -
 arch/x86/kernel/cpu/common.c    |  10 ---
 arch/x86/kernel/time.c          |   2 +-
 arch/x86/kernel/vsyscall_64.c   | 155 +++++++++++++++++-----------------------
 arch/x86/mm/init_64.c           |  49 -------------
 arch/x86/vdso/vclock_gettime.c  |   3 +
 arch/x86/vdso/vgetcpu.c         |   5 +-
 arch/x86/vdso/vma.c             |  81 ++++++++++++++++-----
 10 files changed, 158 insertions(+), 199 deletions(-)

-- 
1.9.3

