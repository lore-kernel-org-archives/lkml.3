Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753202AbaLARKj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Dec 2014 12:10:39 -0500
Received: from foss-mx-na.foss.arm.com ([217.140.108.86]:42662 "EHLO
	foss-mx-na.foss.arm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752817AbaLARKi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Dec 2014 12:10:38 -0500
Date: Mon, 1 Dec 2014 17:10:37 +0000
From: Will Deacon <will.deacon@arm.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Dave Jones <davej@redhat.com>, Andy Lutomirski <luto@amacapital.net>,
        Don Zickus <dzickus@redhat.com>, Thomas Gleixner <tglx@linutronix.de>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        the arch/x86 maintainers <x86@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>
Subject: Re: frequent lockups in 3.18rc4
Message-ID: <20141201171036.GH18466@arm.com>
References: <alpine.DEB.2.11.1411181914020.3909@nanos>
 <20141118215540.GD35311@redhat.com>
 <20141119021902.GA14216@redhat.com>
 <CA+55aFw13opSu6ETXgVo1tjrP+1PLkbsiKewEqRgdBKyBKALWA@mail.gmail.com>
 <20141119145902.GA13387@redhat.com>
 <546D0530.8040800@mit.edu>
 <20141120152509.GA5412@redhat.com>
 <20141125122217.GA15280@arm.com>
 <20141201114854.GB18466@arm.com>
 <CA+55aFyhB5LBVadA5TfuX8+TrZZWTHwT-2NCYRLat8Fp6eBjgw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+55aFyhB5LBVadA5TfuX8+TrZZWTHwT-2NCYRLat8Fp6eBjgw@mail.gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 01, 2014 at 05:05:06PM +0000, Linus Torvalds wrote:
> On Mon, Dec 1, 2014 at 3:48 AM, Will Deacon <will.deacon@arm.com> wrote:
> > so for some bizarre reason, child1 (27912) managed to execve oom_score
> > from /proc.
> 
> That sounds like you have a binfmt that accepts crap. Possibly
> ARM-specific, although more likely it's just a misc script.
> 
> > We can see the child that did the execve has somehow gained its own
> > child process (27921) that we're unable to backtrace. I can't see any
> > clone/fork syscalls in the log for 27912.
> 
> Well, it wouldn't be trinity any more, it would likely be some execve
> script (think "/bin/sh", except likely through binfmt_misc).
> 
> Do you have anything in /proc/sys/fs/binfmt_misc? I don't see anything
> else that would trigger it.

So I don't even have binfmt-misc compiled in. The two handlers I have are
BINFMT_ELF and BINFMT_SCRIPT, but they both check for headers that we won't
get back from oom_score afaict.

> This doesn't really look anything like DaveJ's issue, but who knows..

It's the only lockup I'm seeing on arm64 with trinity, but I agree that it's
not very helpful.

Will
