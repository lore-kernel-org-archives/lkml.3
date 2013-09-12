Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756434Ab3ILSD4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Sep 2013 14:03:56 -0400
Received: from mail-vc0-f171.google.com ([209.85.220.171]:62934 "EHLO
	mail-vc0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756411Ab3ILSDy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Sep 2013 14:03:54 -0400
MIME-Version: 1.0
In-Reply-To: <20130912133855.GA23780@gmail.com>
References: <20130912133855.GA23780@gmail.com>
Date: Thu, 12 Sep 2013 11:03:53 -0700
X-Google-Sender-Auth: 73g0AFr9zjj7Ms78j2ivPXffYls
Message-ID: <CA+55aFwgyjqRHxLaWGxxsg_v07FrxbVTeLdHTGp7MfeSRjrKsQ@mail.gmail.com>
Subject: Re: [GIT PULL] perf fixes
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 12, 2013 at 6:38 AM, Ingo Molnar <mingo@kernel.org> wrote:
>
> Various fixes. (The -g perf report lockup you reported is only partially
> addressed, patches that fix the excessive runtime are still being worked
> on.)

So I pulled this and compiled a new version, and I have a new
complaint. The _bug_ probably is not new, but it happened because I
was compiling the tools/perf/ subdirectory while another terminal was
busy doing a "make allmodconfig" test build (hey, sue me, I do a lot
of them during the merge window).

When I compiled "perf" at the same time as doing a big kernel compile,
the kernel compile failed! I got a few odd "No such file or directory"
for temporary object files in the kernel build. That's not nice. Why
does "make" in the perf tools mess up a "make" of the main kernel?
That implies that the perf tools aren't really independent, and they
try to make at least part of the top-level build. Very annoying.

Another annoyance during that make was that "make install" seems to
want to re-make the thing I just built. That's absolutely horrible,
even if I've seen too many broken projects do that. Now, for perf it's
not as horrible as for some (because you can do "make install" as a
normal user), but it's still a pattern that needs to be called out and
needs to die. It's not just that it slows down "make install", it's
also that a normal pattern *should* be that you build things as a
normal user, and do "make install" as root.

            Linus
