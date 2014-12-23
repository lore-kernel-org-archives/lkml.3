Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756539AbaLWVUW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Dec 2014 16:20:22 -0500
Received: from mail-la0-f44.google.com ([209.85.215.44]:43352 "EHLO
	mail-la0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751365AbaLWVUV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Dec 2014 16:20:21 -0500
MIME-Version: 1.0
From: Andy Lutomirski <luto@amacapital.net>
Date: Tue, 23 Dec 2014 13:19:59 -0800
Message-ID: <CALCETrWHcme9hyROr-bDcutzGR7ZLFCo0iNp5j4tkDPuxt09Og@mail.gmail.com>
Subject: [GIT PULL] One more vdso fix for 3.19
To: Ingo Molnar <mingo@redhat.com>, X86 ML <x86@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Cc: Paolo Bonzini <pbonzini@redhat.com>, Marcelo Tosatti <mtosatti@redhat.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Ingo et al,

Please consider pulling for x86/urgent.

Thanks,
Andy


The following changes since commit 394f56fe480140877304d342dec46d50dc823d46:

  x86_64, vdso: Fix the vdso address randomization algorithm
(2014-12-20 16:56:57 -0800)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/luto/linux.git
tags/pr-20141223-x86-vdso

for you to fetch changes up to 1ddf0b1b11aa8a90cef6706e935fc31c75c406ba:

  x86, vdso: Use asm volatile in __getcpu (2014-12-23 13:05:30 -0800)

----------------------------------------------------------------
This is hopefully the last vdso fix for 3.19.  It should be very
safe (it just adds a volatile).

I don't think it fixes an actual bug (the __getcpu calls in the
pvclock code may not have been needed in the first place), but
discussion on that point is ongoing.

It also fixes a big performance issue in 3.18 and earlier in which
the lsl instructions in vclock_gettime got hoisted so far up the
function that they happened even when the function they were in was
never called.  n 3.19, the performance issue seems to be gone due to
the whims of my compiler and some interaction with a branch that's
now gone.

I'll hopefully have a much bigger overhaul of the pvclock code
for 3.20, but it needs careful review.

----------------------------------------------------------------
Andy Lutomirski (1):
      x86, vdso: Use asm volatile in __getcpu

 arch/x86/include/asm/vgtod.h | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)
