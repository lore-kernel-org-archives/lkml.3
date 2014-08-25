Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933236AbaHYRmD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Aug 2014 13:42:03 -0400
Received: from mx1.redhat.com ([209.132.183.28]:41198 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933147AbaHYRmA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Aug 2014 13:42:00 -0400
Date: Mon, 25 Aug 2014 19:39:30 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Al Viro <viro@zeniv.linux.org.uk>,
        Andrew Morton <akpm@linux-foundation.org>,
        Fenghua Yu <fenghua.yu@intel.com>, Suresh Siddha <sbsiddha@gmail.com>,
        Bean Anderson <bean@azulsystems.com>, "H. Peter Anvin" <hpa@zytor.com>,
        Ingo Molnar <mingo@redhat.com>, Thomas Gleixner <tglx@linutronix.de>,
        the arch/x86 maintainers <x86@kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2/5] x86, fpu: don't drop_fpu() in
	__restore_xstate_sig() if use_eager_fpu()
Message-ID: <20140825173930.GA10376@redhat.com>
References: <20140824194700.GA27281@redhat.com> <20140824194736.GA27441@redhat.com> <CA+55aFyQzvvmWUDA01x69vYkrwUG07q9P3Mv5KaT31pOFsBZGQ@mail.gmail.com> <20140825144111.GB31880@redhat.com> <CA+55aFwNUF+CLWKkDBe56xOtK_JTj9zHWip+_Ep41GJniN+sPw@mail.gmail.com> <20140825170920.GA8338@redhat.com> <CA+55aFw_-_h9Rj8F1H-nRm2-x8wMZ=f0ee122UXCVyJ_seuk2w@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+55aFw_-_h9Rj8F1H-nRm2-x8wMZ=f0ee122UXCVyJ_seuk2w@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/25, Linus Torvalds wrote:
>
> On Mon, Aug 25, 2014 at 10:09 AM, Oleg Nesterov <oleg@redhat.com> wrote:
> >
> > I'd like to change it only because this code is the main source of the
> > nasty special case, used_math() and/or __thread_has_fpu(current) can be
> > false even if use_eager_fpu().
>
> Well, if you think it is correct (apart from missing preemption), then
> I disagree *violently* with your "clean it up by restoring things
> twice" model.

OK.

> The signal handling overhead of floating point restore is not small,
> and it's not theoretical.

Again, this only if 32bit && use_eager_fpu(), and use_eager_fpu() adds
this overhead to every context switch.

But you convinced me anyway. If this hack doesn't look "obviously safe
and correct", lets forget it.

I'll try to play with copy_from_user_in_atomic(), if nothing else just
to complete the discussion and see how the code can look in this case.

Thanks!

Oleg.

