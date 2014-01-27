Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753494AbaA0EcN (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 Jan 2014 23:32:13 -0500
Received: from mail-vb0-f46.google.com ([209.85.212.46]:47933 "EHLO
	mail-vb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753445AbaA0EcK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 Jan 2014 23:32:10 -0500
MIME-Version: 1.0
In-Reply-To: <20140127002255.GA10323@ZenIV.linux.org.uk>
References: <CA+55aFzNxTtvNX7zqBELHs489e5mEx1sM=i=red=aQAGviXrNw@mail.gmail.com>
	<20140127002255.GA10323@ZenIV.linux.org.uk>
Date: Sun, 26 Jan 2014 20:32:09 -0800
X-Google-Sender-Auth: UFjgms_YgkapdRbxbva-XQPqGJw
Message-ID: <CA+55aFzCtJ5gfw__3A=zkjJdv9Ag2CAmtHG5MnrRnCZYqz7EQA@mail.gmail.com>
Subject: Re: [RFC] de-asmify the x86-64 system call slowpath
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Al Viro <viro@zeniv.linux.org.uk>
Cc: Peter Anvin <hpa@zytor.com>, Ingo Molnar <mingo@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <peterz@infradead.org>,
        "the arch/x86 maintainers" <x86@kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jan 26, 2014 at 4:22 PM, Al Viro <viro@zeniv.linux.org.uk> wrote:
>
> Umm...  Can't uprobe_notify_resume() modify regs as well?

Probably.

.. and on the other hand, we should actually be able to use 'sysret'
for signal handling on x86-64, because while sysret destroys %rcx and
doesn't allow for returning to odd modes, for calling a signal handler
I don't think we really care..

> While we
> are at it, when we start using the same thing on 32bit kernels, we'll
> need to watch out for execve() - the reason why start_thread() sets
> TIF_NOTIFY_RESUME is to force us away from sysexit path.  IIRC, vm86
> is another thing to watch out for (same reasons).

Yes, the 32-bit code I didn't want to touch, partly because I no
longer have a test-case. And it does end up having some more
interesting cases.

                 Linus
