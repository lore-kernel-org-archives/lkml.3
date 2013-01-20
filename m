Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752505Ab3ATUxm (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Jan 2013 15:53:42 -0500
Received: from mail-vb0-f43.google.com ([209.85.212.43]:51438 "EHLO
	mail-vb0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752474Ab3ATUxl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Jan 2013 15:53:41 -0500
MIME-Version: 1.0
In-Reply-To: <20130120031253.GO4939@ZenIV.linux.org.uk>
References: <50F3D2F2.3080200@6wind.com> <20130119063808.GN4939@ZenIV.linux.org.uk>
 <20130120031253.GO4939@ZenIV.linux.org.uk>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Sun, 20 Jan 2013 12:53:20 -0800
X-Google-Sender-Auth: 6JL4okHvMfZ1EqY3SNqH7AFFEik
Message-ID: <CA+55aFyRMC43_H1hL5goAQxX4EdTuXOu5A9CoBk9fpGoJT_nig@mail.gmail.com>
Subject: Re: Issues with "x86, um: switch to generic fork/vfork/clone" commit
To: Al Viro <viro@zeniv.linux.org.uk>
Cc: Nicolas Dichtel <nicolas.dichtel@6wind.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jan 19, 2013 at 7:12 PM, Al Viro <viro@zeniv.linux.org.uk> wrote:
>
> OK...  I think I understand what's going on.  We need asmlinkage_protect
> in sys_clone() ;-/  For what it's worth, I really wonder if we ought to
> treat that as syscall wrappers - i.e. have SYSCALL_DEFINEx on i386 add
> a wrapper that would do asmlinkage_protect itself.  IMO it's the same kind
> of thing as argument normalization handled by syscall wrappers - we make
> sure that C function plays well with what asm glue is doing and expecting.

Actually, I think we should do it *unconditionally* in the syscall wrappers.

It's up to the architecture code to make asmlinkage_protect() be a
no-op or not, depending on how it does things. Right now I think only
x86 actually defines it, although I suspect there might be others that
should (anybody who passes arguments on the stack and also uses the
stack for save-area).

But in the meantime, I guess I should just take the do_fork() one. Can
I get a sign-off and a changelog?

                   Linus
