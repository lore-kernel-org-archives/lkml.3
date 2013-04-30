Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932632Ab3D3Qaj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Apr 2013 12:30:39 -0400
Received: from mail-ea0-f180.google.com ([209.85.215.180]:55911 "EHLO
	mail-ea0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932382Ab3D3Qag (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Apr 2013 12:30:36 -0400
Date: Tue, 30 Apr 2013 18:30:32 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Stanislaw Gruszka <sgruszka@redhat.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Fr?d?ric Weisbecker <fweisbec@gmail.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [GIT PULL] scheduler changes for v3.10
Message-ID: <20130430163032.GA3999@gmail.com>
References: <20130430065808.GA19736@gmail.com>
 <CA+55aFwcX3oKYCFbq4XcX7Y2Yk6BWWKY4TRNOyfeZ9rYrQMRNQ@mail.gmail.com>
 <20130430153512.GA21930@redhat.com>
 <20130430162300.GB28821@gmail.com>
 <CA+55aFwsv+p3wqx5eMr3iNPxmPZhSx-h5s5R7s9yd314Muajvg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+55aFwsv+p3wqx5eMr3iNPxmPZhSx-h5s5R7s9yd314Muajvg@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Linus Torvalds <torvalds@linux-foundation.org> wrote:

> On Tue, Apr 30, 2013 at 9:23 AM, Ingo Molnar <mingo@kernel.org> wrote:
> >
> > Linus, would you like me to revert d9a3c9823a2e and re-send the pull
> > request?
> 
> I took the pull request, but I'd like to see the non-64-bit divide 
> version before the merge window ends. [...]

Yeah, wanted to apply it later today or tomorrow, and push it to you this 
week - well before the end of the merge window.

> [...] And with no more div_rem users I think we should at least 
> double-check that the new div64_u64() (that uses the new div64_u64_rem) 
> isn't noticeably slower than the old one. If it is, we should revert 
> that new (and then unused) div64 code too.

Correct, this is what Stanislaw's series from earlier today does:

 [PATCH -tip 1/4] sched: Avoid cputime scaling overflow
 [PATCH -tip 2/4] sched: Do not account bogus utime
 [PATCH -tip 3/4] sched: Avoid prev->stime underflow
 [PATCH -tip 4/4] Revert "math64: New div64_u64_rem helper"

so it gets rid of the div64_u64_rem() bits as well.

Thanks,

	Ingo
