Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753328AbaLUBLg (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Dec 2014 20:11:36 -0500
Received: from mail-lb0-f178.google.com ([209.85.217.178]:59005 "EHLO
	mail-lb0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752448AbaLUBLe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Dec 2014 20:11:34 -0500
MIME-Version: 1.0
From: Andy Lutomirski <luto@amacapital.net>
Date: Sat, 20 Dec 2014 17:11:12 -0800
Message-ID: <CALCETrUx2xyCn7tmqVKt8A24L+M-EFKrba5kq4Nr75yYsZ4CSQ@mail.gmail.com>
Subject: [GIT PULL] one vdso fix for x86/urgent
To: Ingo Molnar <mingo@kernel.org>, X86 ML <x86@kernel.org>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Kees Cook <keescook@chromium.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Ingo, etc,

Please consider pulling for x86/urgent.  This fixes a longstanding,
albeit relatively minor, issue in the x86 vdso randomization
algorithm.  Note that this isn't super-urgent, as this bug isn't
directly exploitable, and it's as old as the vdso itself.

Thanks,
Andy

The following changes since commit e589c9e13aeb0c5539bf1314b3a78442ea8fc0c2:

  Merge branch 'x86-apic-for-linus' of
git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip (2014-12-19
14:02:02 -0800)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/luto/linux.git
tags/pr-20141220-x86-vdso

for you to fetch changes up to 394f56fe480140877304d342dec46d50dc823d46:

  x86_64, vdso: Fix the vdso address randomization algorithm
(2014-12-20 16:56:57 -0800)

----------------------------------------------------------------
One vdso fix for a longstanding ASLR bug that's been in the news lately.

The vdso base address has always been randomized, and I don't think there's
anything particularly wrong with the range over which it's randomized,
but the implementation seems to have been buggy since the very beginning.

This fixes the implementation to remove a large bias that caused a small
fraction of possible vdso load addresess to be vastly more likely than
the rest of the possible addresses.

----------------------------------------------------------------
Andy Lutomirski (1):
      x86_64, vdso: Fix the vdso address randomization algorithm

 arch/x86/vdso/vma.c | 45 +++++++++++++++++++++++++++++----------------
 1 file changed, 29 insertions(+), 16 deletions(-)
