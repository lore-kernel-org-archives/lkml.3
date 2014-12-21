Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753448AbaLUKSf (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Dec 2014 05:18:35 -0500
Received: from mail-wi0-f176.google.com ([209.85.212.176]:37349 "EHLO
	mail-wi0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751020AbaLUKSc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Dec 2014 05:18:32 -0500
Date: Sun, 21 Dec 2014 11:18:27 +0100
From: Ingo Molnar <mingo@kernel.org>
To: Andy Lutomirski <luto@amacapital.net>
Cc: X86 ML <x86@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Kees Cook <keescook@chromium.org>
Subject: Re: [GIT PULL] one vdso fix for x86/urgent
Message-ID: <20141221101827.GA769@gmail.com>
References: <CALCETrUx2xyCn7tmqVKt8A24L+M-EFKrba5kq4Nr75yYsZ4CSQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CALCETrUx2xyCn7tmqVKt8A24L+M-EFKrba5kq4Nr75yYsZ4CSQ@mail.gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Andy Lutomirski <luto@amacapital.net> wrote:

> Hi Ingo, etc,
> 
> Please consider pulling for x86/urgent.  This fixes a longstanding,
> albeit relatively minor, issue in the x86 vdso randomization
> algorithm.  Note that this isn't super-urgent, as this bug isn't
> directly exploitable, and it's as old as the vdso itself.
> 
> Thanks,
> Andy
> 
> The following changes since commit e589c9e13aeb0c5539bf1314b3a78442ea8fc0c2:
> 
>   Merge branch 'x86-apic-for-linus' of
> git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip (2014-12-19
> 14:02:02 -0800)
> 
> are available in the git repository at:
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/luto/linux.git
> tags/pr-20141220-x86-vdso
> 
> for you to fetch changes up to 394f56fe480140877304d342dec46d50dc823d46:
> 
>   x86_64, vdso: Fix the vdso address randomization algorithm
> (2014-12-20 16:56:57 -0800)
> 
> ----------------------------------------------------------------
> One vdso fix for a longstanding ASLR bug that's been in the news lately.
> 
> The vdso base address has always been randomized, and I don't think there's
> anything particularly wrong with the range over which it's randomized,
> but the implementation seems to have been buggy since the very beginning.
> 
> This fixes the implementation to remove a large bias that caused a small
> fraction of possible vdso load addresess to be vastly more likely than
> the rest of the possible addresses.
> 
> ----------------------------------------------------------------
> Andy Lutomirski (1):
>       x86_64, vdso: Fix the vdso address randomization algorithm
> 
>  arch/x86/vdso/vma.c | 45 +++++++++++++++++++++++++++++----------------
>  1 file changed, 29 insertions(+), 16 deletions(-)

Pulled into tip:x86/urgent, thanks a lot Andy!

	Ingo
