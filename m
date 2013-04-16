Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754513Ab3DPKI5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Apr 2013 06:08:57 -0400
Received: from mail.skyhub.de ([78.46.96.112]:37318 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753280Ab3DPKIz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Apr 2013 06:08:55 -0400
Date: Tue, 16 Apr 2013 12:08:53 +0200
From: Borislav Petkov <bp@alien8.de>
To: Ingo Molnar <mingo@kernel.org>
Cc: "H. Peter Anvin" <hpa@zytor.com>, X86 ML <x86@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, Borislav Petkov <bp@suse.de>
Subject: [GIT PULL] Rebase tip:x86/cpu
Message-ID: <20130416100853.GC5332@pd.tnic>
References: <f3a4fce2-090e-4a08-b05c-0281a95e8943@email.android.com>
 <20130412094724.GA2368@pd.tnic>
 <20130412112628.GB2368@pd.tnic>
 <20130415100858.GB18024@gmail.com>
 <20130415101734.GB26524@pd.tnic>
 <20130415101825.GD18024@gmail.com>
 <20130415155415.GB12144@pd.tnic>
 <20130415220406.GD12144@pd.tnic>
 <20130416092528.GF9569@gmail.com>
 <20130416094852.GA5332@pd.tnic>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20130416094852.GA5332@pd.tnic>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

here it is.

Original tip:x86/cpu tree state is this:

3019653a5758 x86/fpu: Fix FPU initialization
042c16f14161 x86, CPU, AMD: Drop useless label
982f33db626e x86, AMD: Correct {rd,wr}msr_amd_safe warnings
e277a4938574 x86: Fold-in trivial check_config function
c70293d0e3fe x86: Get rid of ->hard_math and all the FPU asm fu
7d7dc116e56c x86, cpu: Convert AMD Erratum 400
e6ee94d58dfd x86, cpu: Convert AMD Erratum 383
c5b41a67505c x86, cpu: Convert Cyrix coma bug detection
93a829e8e2c2 x86, cpu: Convert FDIV bug detection
e2604b49e8a8 x86, cpu: Convert F00F bug detection
65fc985b37dc x86, cpu: Expand cpufeature facility to include cpu bugs

and the rebased one is this:

1077c932db63 x86, CPU, AMD: Drop useless label
682469a5db6f x86, AMD: Correct {rd,wr}msr_amd_safe warnings
55a36b65ee71 x86: Fold-in trivial check_config function
7d7dc116e56c x86, cpu: Convert AMD Erratum 400
e6ee94d58dfd x86, cpu: Convert AMD Erratum 383
c5b41a67505c x86, cpu: Convert Cyrix coma bug detection
93a829e8e2c2 x86, cpu: Convert FDIV bug detection
e2604b49e8a8 x86, cpu: Convert F00F bug detection
65fc985b37dc x86, cpu: Expand cpufeature facility to include cpu bugs

Commits c70293d0e3fe and 3019653a5758 are gone and the three commits
in-between have received new commit ids. Those 6 before that are
unchanged, as their commit ids show.

Please pull,
thanks.

The following changes since commit 07961ac7c0ee8b546658717034fe692fd12eefa9:

  Linux 3.9-rc5 (2013-03-31 15:12:43 -0700)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/bp/bp.git tags/tip_x86_cpu_rebased

for you to fetch changes up to 1077c932db63ecc571c31df1c24d4a44e30928e5:

  x86, CPU, AMD: Drop useless label (2013-04-16 11:50:51 +0200)

----------------------------------------------------------------
Rebase tip:x86/cpu to drop two patches which trigger a random corruption
on 32-bit.

----------------------------------------------------------------
Borislav Petkov (9):
      x86, cpu: Expand cpufeature facility to include cpu bugs
      x86, cpu: Convert F00F bug detection
      x86, cpu: Convert FDIV bug detection
      x86, cpu: Convert Cyrix coma bug detection
      x86, cpu: Convert AMD Erratum 383
      x86, cpu: Convert AMD Erratum 400
      x86: Fold-in trivial check_config function
      x86, AMD: Correct {rd,wr}msr_amd_safe warnings
      x86, CPU, AMD: Drop useless label

 arch/x86/include/asm/cpufeature.h | 19 +++++++++++++++++++
 arch/x86/include/asm/processor.h  | 25 +------------------------
 arch/x86/kernel/alternative.c     |  2 +-
 arch/x86/kernel/cpu/amd.c         | 48 +++++++++++++++++++++++++++++-------------------
 arch/x86/kernel/cpu/bugs.c        | 34 +++++++++++++++-------------------
 arch/x86/kernel/cpu/common.c      |  4 ++++
 arch/x86/kernel/cpu/cyrix.c       |  5 +++--
 arch/x86/kernel/cpu/intel.c       |  4 ++--
 arch/x86/kernel/cpu/proc.c        |  6 +++---
 arch/x86/kernel/process.c         |  2 +-
 arch/x86/kernel/setup.c           |  2 --
 arch/x86/kvm/svm.c                |  2 +-
 arch/x86/mm/fault.c               |  2 +-
 13 files changed, 80 insertions(+), 75 deletions(-)

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
