Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753708Ab3IERk0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Sep 2013 13:40:26 -0400
Received: from mail-ea0-f177.google.com ([209.85.215.177]:51406 "EHLO
	mail-ea0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752158Ab3IERkX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Sep 2013 13:40:23 -0400
Date: Thu, 5 Sep 2013 19:40:19 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Waiman Long <waiman.long@hp.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Al Viro <viro@zeniv.linux.org.uk>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Jeff Layton <jlayton@redhat.com>, Miklos Szeredi <mszeredi@suse.cz>,
        Ingo Molnar <mingo@redhat.com>, Thomas Gleixner <tglx@linutronix.de>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Steven Rostedt <rostedt@goodmis.org>, Andi Kleen <andi@firstfloor.org>,
        "Chandramouleeswaran, Aswin" <aswin@hp.com>,
        "Norton, Scott J" <scott.norton@hp.com>
Subject: Re: [PATCH v7 1/4] spinlock: A new lockref structure for lockless
 update of refcount
Message-ID: <20130905174019.GA30435@gmail.com>
References: <20130831023516.GI13318@ZenIV.linux.org.uk>
 <20130831024233.GJ13318@ZenIV.linux.org.uk>
 <5224E647.80303@hp.com>
 <20130903060130.GD16261@gmail.com>
 <5225FCEE.7030901@hp.com>
 <CA+55aFyNmLt9GeR5XyxOs7aGLwH3EBCB+K9D6uGBef3FziP2-A@mail.gmail.com>
 <CA+55aFw0jme+qK5b_VJVqoVD6cZuSjVsm-Sgjf_YkPXgMToqUA@mail.gmail.com>
 <52274943.1040005@hp.com>
 <20130905133123.GA24351@gmail.com>
 <5228C062.7030106@hp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5228C062.7030106@hp.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Waiman Long <waiman.long@hp.com> wrote:

> On 09/05/2013 09:31 AM, Ingo Molnar wrote:
> >* Waiman Long<waiman.long@hp.com>  wrote:
> >
> >
> >>The latest tty patches did work. The tty related spinlock contention
> >>is now completely gone. The short workload can now reach over 8M JPM
> >>which is the highest I have ever seen.
> >>
> >>The perf profile was:
> >>
> >>5.85%     reaim  reaim                 [.] mul_short
> >>4.87%     reaim  [kernel.kallsyms]     [k] ebitmap_get_bit
> >>4.72%     reaim  reaim                 [.] mul_int
> >>4.71%     reaim  reaim                 [.] mul_long
> >>2.67%     reaim  libc-2.12.so          [.] __random_r
> >>2.64%     reaim  [kernel.kallsyms]     [k] lockref_get_not_zero
> >>1.58%     reaim  [kernel.kallsyms]     [k] copy_user_generic_string
> >>1.48%     reaim  [kernel.kallsyms]     [k] mls_level_isvalid
> >>1.35%     reaim  [kernel.kallsyms]     [k] find_next_bit
> >6%+ spent in ebitmap_get_bit() and mls_level_isvalid() looks like
> >something worth optimizing.
> >
> >Is that called very often, or is it perhaps cache-bouncing for some
> >reason?
> 
> The high cycle count is due more to inefficient algorithm in the 
> mls_level_isvalid() function than cacheline contention in the code. The 
> attached patch should address this problem. It is in linux-next and 
> hopefully will be merged in 3.12.

Great!

If/when you happen to boot the latest & greatest kernel that has all these 
scalability patches applied it would be nice if you could send an updated 
profile into this thread.

Thanks,

	Ingo
