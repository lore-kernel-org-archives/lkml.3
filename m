Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756684Ab3ICPeJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Sep 2013 11:34:09 -0400
Received: from mail-vc0-f175.google.com ([209.85.220.175]:53350 "EHLO
	mail-vc0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755243Ab3ICPeH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Sep 2013 11:34:07 -0400
MIME-Version: 1.0
In-Reply-To: <5225FCEE.7030901@hp.com>
References: <5220F090.5050908@hp.com>
	<20130830194059.GC13318@ZenIV.linux.org.uk>
	<5220F811.9060902@hp.com>
	<20130830202608.GD13318@ZenIV.linux.org.uk>
	<52210225.60805@hp.com>
	<20130830204852.GE13318@ZenIV.linux.org.uk>
	<52214EBC.90100@hp.com>
	<20130831023516.GI13318@ZenIV.linux.org.uk>
	<20130831024233.GJ13318@ZenIV.linux.org.uk>
	<5224E647.80303@hp.com>
	<20130903060130.GD16261@gmail.com>
	<5225FCEE.7030901@hp.com>
Date: Tue, 3 Sep 2013 08:34:06 -0700
X-Google-Sender-Auth: BIyHdJHbF9X152_wI_sbh2DgrRA
Message-ID: <CA+55aFyNmLt9GeR5XyxOs7aGLwH3EBCB+K9D6uGBef3FziP2-A@mail.gmail.com>
Subject: Re: [PATCH v7 1/4] spinlock: A new lockref structure for lockless
 update of refcount
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Waiman Long <waiman.long@hp.com>
Cc: Ingo Molnar <mingo@kernel.org>, Al Viro <viro@zeniv.linux.org.uk>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Jeff Layton <jlayton@redhat.com>, Miklos Szeredi <mszeredi@suse.cz>,
        Ingo Molnar <mingo@redhat.com>, Thomas Gleixner <tglx@linutronix.de>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Steven Rostedt <rostedt@goodmis.org>, Andi Kleen <andi@firstfloor.org>,
        "Chandramouleeswaran, Aswin" <aswin@hp.com>,
        "Norton, Scott J" <scott.norton@hp.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 3, 2013 at 8:14 AM, Waiman Long <waiman.long@hp.com> wrote:
>
> Other than the global tty_ldisc_lock, there is no other major
> bottleneck. I am not that worry about the tty_ldisc_lock bottleneck
> as real world applications probably won't have that many calls to
> set the tty driver.

I suspect the tty_ldisc_lock() could be made to go away if we care.
Making the ldisc be rcu-free'd, coupled with just optimistically
updating the count using "atomic_inc_not_zero()" and re-checking the
ldisc pointer afterwards should probably do it. But I agree that it
probably isn't worth it for any actual real load.

              Linus
