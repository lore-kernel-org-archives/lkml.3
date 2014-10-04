Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751197AbaJDQD4 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 4 Oct 2014 12:03:56 -0400
Received: from mail-vc0-f181.google.com ([209.85.220.181]:61683 "EHLO
	mail-vc0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750920AbaJDQDy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 4 Oct 2014 12:03:54 -0400
MIME-Version: 1.0
In-Reply-To: <20141004082307.GS10583@worktop.programming.kicks-ass.net>
References: <20141004030438.28569.85536.stgit@linux-yegoshin>
	<20141004082307.GS10583@worktop.programming.kicks-ass.net>
Date: Sat, 4 Oct 2014 09:03:53 -0700
X-Google-Sender-Auth: a5LSQBCKbsHbsdRVmigCIx0FDaE
Message-ID: <CA+55aFynSp90n=jdUdmY7nq-9t4pHS82Tj-WfZOBfot7ip0hBw@mail.gmail.com>
Subject: Re: [PATCH 0/3] MIPS executable stack protection
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Leonid Yegoshin <Leonid.Yegoshin@imgtec.com>,
        linux-mips <linux-mips@linux-mips.org>, Zubair.Kakakhel@imgtec.com,
        David Daney <david.daney@cavium.com>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        Davidlohr Bueso <davidlohr@hp.com>,
        "Maciej W. Rozycki" <macro@linux-mips.org>, chenhc@lemote.com,
        =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>,
        James Hogan <james.hogan@imgtec.com>,
        Kees Cook <keescook@chromium.org>, alex@alex-smith.me.uk,
        Thomas Gleixner <tglx@linutronix.de>,
        John Crispin <blogic@openwrt.org>, jchandra@broadcom.com,
        paul.burton@imgtec.com, qais.yousef@imgtec.com,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Ralf Baechle <ralf@linux-mips.org>, markos.chandras@imgtec.com,
        Manuel Lauss <manuel.lauss@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>, lars.persson@axis.com
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Oct 4, 2014 at 1:23 AM, Peter Zijlstra <peterz@infradead.org> wrote:
> On Fri, Oct 03, 2014 at 08:17:14PM -0700, Leonid Yegoshin wrote:
>> The following series implements an executable stack protection in MIPS.
>>
>> It sets up a per-thread 'VDSO' page and appropriate TLB support.
>
> So traditionally we've always avoided per-thread pages like that. What
> makes it worth it on MIPS?

Nothing makes it worth it on MIPS.

It may be easy to implement when you have all software-fill of TLB's,
but it's a mistake even then - because it means that you'll never be
able to do hardware TLB walkers.

And MIPS *does* have hardware TLB walkers, even if they are not
necessarily available everywhere.

So this is a horrible idea. Don't do it. Page tables need to be
per-process, not per thread, so that page tables can be shared.

              Linus
