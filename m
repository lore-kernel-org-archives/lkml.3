Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753703AbaLARFJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Dec 2014 12:05:09 -0500
Received: from mail-qg0-f44.google.com ([209.85.192.44]:42931 "EHLO
	mail-qg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752982AbaLARFG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Dec 2014 12:05:06 -0500
MIME-Version: 1.0
In-Reply-To: <20141201114854.GB18466@arm.com>
References: <CA+55aFyOTpVQiku0xn=UHnXdYweKHZ5AsEUN9wUvOqH9XX4ENg@mail.gmail.com>
	<20141118145234.GA7487@redhat.com>
	<alpine.DEB.2.11.1411181914020.3909@nanos>
	<20141118215540.GD35311@redhat.com>
	<20141119021902.GA14216@redhat.com>
	<CA+55aFw13opSu6ETXgVo1tjrP+1PLkbsiKewEqRgdBKyBKALWA@mail.gmail.com>
	<20141119145902.GA13387@redhat.com>
	<546D0530.8040800@mit.edu>
	<20141120152509.GA5412@redhat.com>
	<20141125122217.GA15280@arm.com>
	<20141201114854.GB18466@arm.com>
Date: Mon, 1 Dec 2014 09:05:06 -0800
X-Google-Sender-Auth: UA3Jr1hWfcxFZqDBgtm2yxayOqE
Message-ID: <CA+55aFyhB5LBVadA5TfuX8+TrZZWTHwT-2NCYRLat8Fp6eBjgw@mail.gmail.com>
Subject: Re: frequent lockups in 3.18rc4
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Will Deacon <will.deacon@arm.com>
Cc: Dave Jones <davej@redhat.com>, Andy Lutomirski <luto@amacapital.net>,
        Don Zickus <dzickus@redhat.com>, Thomas Gleixner <tglx@linutronix.de>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        "the arch/x86 maintainers" <x86@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 1, 2014 at 3:48 AM, Will Deacon <will.deacon@arm.com> wrote:
>
> so for some bizarre reason, child1 (27912) managed to execve oom_score
> from /proc.

That sounds like you have a binfmt that accepts crap. Possibly
ARM-specific, although more likely it's just a misc script.

> We can see the child that did the execve has somehow gained its own
> child process (27921) that we're unable to backtrace. I can't see any
> clone/fork syscalls in the log for 27912.

Well, it wouldn't be trinity any more, it would likely be some execve
script (think "/bin/sh", except likely through binfmt_misc).

Do you have anything in /proc/sys/fs/binfmt_misc? I don't see anything
else that would trigger it.

This doesn't really look anything like DaveJ's issue, but who knows..

                       Linus
