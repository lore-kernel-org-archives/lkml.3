Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965067Ab3DHPc4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Apr 2013 11:32:56 -0400
Received: from mail-bk0-f45.google.com ([209.85.214.45]:49423 "EHLO
	mail-bk0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964942Ab3DHPcz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Apr 2013 11:32:55 -0400
Date: Mon, 8 Apr 2013 17:32:50 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Stanislaw Gruszka <sgruszka@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>,
        "H. Peter Anvin" <hpa@zytor.com>, Steven Rostedt <rostedt@goodmis.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>, Paul Turner <pjt@google.com>
Subject: Re: [PATCH -tip 0/4] do not make cputime scaling in kernel
Message-ID: <20130408153250.GA17500@gmail.com>
References: <1365066635-2959-1-git-send-email-sgruszka@redhat.com>
 <CAFTL4hx-k42Af1qhpf+0jra6HZ3LBxL=1A8J3xabzjWLAxH9GQ@mail.gmail.com>
 <20130404131003.GE1367@redhat.com>
 <CAFTL4hxZ8RJ0Wd-+sScfa90_c5j0bX3eufH+RC+u8i7=7hN+ig@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAFTL4hxZ8RJ0Wd-+sScfa90_c5j0bX3eufH+RC+u8i7=7hN+ig@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Frederic Weisbecker <fweisbec@gmail.com> wrote:

> 2013/4/4 Stanislaw Gruszka <sgruszka@redhat.com>:
> > On Thu, Apr 04, 2013 at 02:31:42PM +0200, Frederic Weisbecker wrote:
> >> I don't know. I'm not convinced userland is the right place to perform
> >> this kind of check. The kernel perhaps doesn't give guarantee about
> >> utime/stime precision but now users may have got used to that scaled
> >> behaviour. It's also a matter of security, a malicous app can hide
> >> from the tick to make its activity less visible from tools like top.
> >>
> >> It's sortof an ABI breakage to remove such an implicit protection. And
> >> fixing that from userspace with a lib or so won't change that fact.
> >
> > I think number of fields in /proc/PID/stat is not part of ABI. For
> > example commit 5b172087f99189416d5f47fd7ab5e6fb762a9ba3 add various
> > new fields at the end of the file. What is imported to keep unchanged
> > ABI is not changing order or meaning of fields we already have.
> 
> Oh I wasn't considering the layout of the proc file but the semantic
> change in its utime/stime fields.

Btw., even the ordering of fields in /proc/PID/stat might be an ABI, iif an 
application relies on it and breaks if we change it.

What matters is what applications do, not what we think they do or what we think 
they should do in an ideal world.

> > Regarding top, I added those additional fields to allow top to detect those 
> > malicious software. Patched top will work well with old and new (patched) 
> > kernel. Problem is old top with new kernel, but I believe users who care about 
> > security update they software regularly.
> 
> The usual rule is that but you can't remove a feature from the kernel and tell 
> userspace to fix it itself. That's basically an ABI breakage.

Correct.

Thanks,

	Ingo
