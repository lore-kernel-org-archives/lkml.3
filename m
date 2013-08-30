Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756637Ab3H3RLa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Aug 2013 13:11:30 -0400
Received: from mail-we0-f176.google.com ([74.125.82.176]:47345 "EHLO
	mail-we0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752831Ab3H3RL1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Aug 2013 13:11:27 -0400
MIME-Version: 1.0
Reply-To: sedat.dilek@gmail.com
In-Reply-To: <CA+55aFxwjx30pC=kcfvOzgJvt2KK9DLm2i6JKYYz+mtOOJEnMA@mail.gmail.com>
References: <1375758759-29629-1-git-send-email-Waiman.Long@hp.com>
	<1375758759-29629-2-git-send-email-Waiman.Long@hp.com>
	<CA+55aFyMeK+bAvkqi_HpShqm7Des6uriVP_xp+BJqD0ASCVL0g@mail.gmail.com>
	<1377751465.4028.20.camel@pasglop>
	<20130829070012.GC27322@gmail.com>
	<CA+55aFwzY_1tD5vmaDgwAGLXNSGw4XS8vEp9vOpN6NPm5+Mxow@mail.gmail.com>
	<CA+55aFx1oq7+jce8vLWRitASVMugCojYe3gmhXwhLx4K9Au3XQ@mail.gmail.com>
	<CA+55aFyq7dJnm6tfn12hLOw5qKLW2RXRFERHgZO-sOOnUmjd3g@mail.gmail.com>
	<52200DAE.2020303@hp.com>
	<CA+55aFyhTR15GBS4VNoRkcFyubEJU7a+Pzd-6VZeKoU8qB0q5Q@mail.gmail.com>
	<CA+icZUX3zQEWDoaXk0RMKmbQhDRo0Z7jGZ=9tJu1gZWvGodMkg@mail.gmail.com>
	<CA+icZUUDKExRW3iNXj6jTs8A4DwQNaWvPuUfV5_ExXNPzq=+rA@mail.gmail.com>
	<CA+55aFxvEjdEFK0dXn783eVN0PEXVhb5k8OnrbxSWDpXgyTwWw@mail.gmail.com>
	<CA+icZUXcn6-A+AW5bu_pfRdOcScsNyn3-OZe6n93S5NUEzHtcg@mail.gmail.com>
	<CA+55aFwHx=tCzdo50jJB0ey7-CTVSo6RRQHe6R9fAya7nPn00A@mail.gmail.com>
	<CA+icZUWmQHWHMr1symL7j0iYqUMJBiOuRJ=EJz4F-xkQtdnJLg@mail.gmail.com>
	<CA+55aFxwjx30pC=kcfvOzgJvt2KK9DLm2i6JKYYz+mtOOJEnMA@mail.gmail.com>
Date: Fri, 30 Aug 2013 19:11:26 +0200
Message-ID: <CA+icZUWtEHy3CLadSQBKT5++UOxJuV-uxFf=UdAZLqysfourzw@mail.gmail.com>
Subject: Re: [PATCH v7 1/4] spinlock: A new lockref structure for lockless
 update of refcount
From: Sedat Dilek <sedat.dilek@gmail.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Waiman Long <waiman.long@hp.com>, Ingo Molnar <mingo@kernel.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
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

On Fri, Aug 30, 2013 at 6:52 PM, Linus Torvalds
<torvalds@linux-foundation.org> wrote:
> On Fri, Aug 30, 2013 at 9:37 AM, Sedat Dilek <sedat.dilek@gmail.com> wrote:
>>
>> Where is this a.out file from or how to generate it?
>
> Oh, that's just the silly threaded test-binary. I don't know what you
> called it.
>
> As to your config options, yesh, you have some expensive stuff.
> DEBUG_OBJECTS and DEBUG_MUTEXES in particular tend to cause lots of
> horrible performance issues. I didn't check if there might be other
> things..
>

There is no -f option for record but for report, so I swapped them:

$ sudo ~/src/linux-kernel/linux/tools/perf/perf record -e cycles:pp
./scripts/t_lockref_from-linus
Total loops: 2240273
[ perf record: Woken up 25 times to write data ]
[ perf record: Captured and wrote 6.080 MB perf.data (~265641 samples) ]

$ sudo ~/src/linux-kernel/linux/tools/perf/perf report -f

Samples: 159K of event 'cycles:pp', Event count (approx.): 76535356682
 84,10%  t_lockref_from-  [kernel.kallsyms]     [k] check_poison_obj
  5,22%  t_lockref_from-  [kernel.kallsyms]     [k] memset
  1,15%  t_lockref_from-  [kernel.kallsyms]     [k] irq_return
  0,45%  t_lockref_from-  [kernel.kallsyms]     [k] kmem_cache_alloc
  0,44%  t_lockref_from-  [kernel.kallsyms]     [k] kmem_cache_free
  0,36%  t_lockref_from-  [kernel.kallsyms]     [k] __ticket_spin_lock
  0,35%  t_lockref_from-  [kernel.kallsyms]     [k] cache_free_debugcheck
  0,35%  t_lockref_from-  [kernel.kallsyms]     [k] __acct_update_integrals
  0,34%  t_lockref_from-  [kernel.kallsyms]     [k] user_exit
  0,33%  t_lockref_from-  [kernel.kallsyms]     [k] __d_lookup_rcu
  0,26%  t_lockref_from-  libc-2.15.so          [.] __xstat64
  0,25%  t_lockref_from-  [kernel.kallsyms]     [k] poison_obj
  0,24%  t_lockref_from-  [kernel.kallsyms]     [k] local_clock
  0,19%  t_lockref_from-  [kernel.kallsyms]     [k] lockref_get_or_lock
  0,19%  t_lockref_from-  [kernel.kallsyms]     [k] link_path_walk
  0,19%  t_lockref_from-  [kernel.kallsyms]     [k] rcu_eqs_enter_common.isra.43
  0,19%  t_lockref_from-  [kernel.kallsyms]     [k] rcu_eqs_exit_common.isra.41
  0,17%  t_lockref_from-  [kernel.kallsyms]     [k] native_read_tsc
  0,17%  t_lockref_from-  [kernel.kallsyms]     [k] user_enter
  0,16%  t_lockref_from-  [kernel.kallsyms]     [k] sched_clock_cpu
  0,16%  t_lockref_from-  [kernel.kallsyms]     [k] path_lookupat
  0,14%  t_lockref_from-  [kernel.kallsyms]     [k] vfs_getattr
  0,14%  t_lockref_from-  [kernel.kallsyms]     [k] lockref_put_or_lock
  0,14%  t_lockref_from-  [kernel.kallsyms]     [k] path_init
  0,13%  t_lockref_from-  [kernel.kallsyms]     [k] tracesys
  0,13%  t_lockref_from-  [kernel.kallsyms]     [k] native_sched_clock
  0,13%  t_lockref_from-  [kernel.kallsyms]     [k] strncpy_from_user
  0,12%  t_lockref_from-  [kernel.kallsyms]     [k] cp_new_stat
  0,12%  t_lockref_from-  [kernel.kallsyms]     [k]
cache_alloc_debugcheck_after.isra.61
  0,12%  t_lockref_from-  [kernel.kallsyms]     [k] account_system_time
  0,12%  t_lockref_from-  [kernel.kallsyms]     [k] copy_user_generic_unrolled
  0,12%  t_lockref_from-  [kernel.kallsyms]     [k] syscall_trace_enter
  0,12%  t_lockref_from-  [kernel.kallsyms]     [k] jiffies_to_timeval
  0,11%  t_lockref_from-  [kernel.kallsyms]     [k] get_vtime_delta
  0,11%  t_lockref_from-  t_lockref_from-linus  [.] __stat
  0,10%  t_lockref_from-  [kernel.kallsyms]     [k] check_irq_off
  0,10%  t_lockref_from-  [kernel.kallsyms]     [k] common_perm
  0,10%  t_lockref_from-  [kernel.kallsyms]     [k] lookup_fast
  0,09%  t_lockref_from-  [kernel.kallsyms]     [k] getname_flags
  0,09%  t_lockref_from-  [kernel.kallsyms]     [k] syscall_trace_leave
  0,08%  t_lockref_from-  t_lockref_from-linus  [.] start_routine
  0,08%  t_lockref_from-  [kernel.kallsyms]     [k] vfs_fstatat
  0,08%  t_lockref_from-  [kernel.kallsyms]     [k] system_call_after_swapgs
  0,08%  t_lockref_from-  [kernel.kallsyms]     [k] user_path_at_empty
  0,08%  t_lockref_from-  [kernel.kallsyms]     [k] account_user_time
  0,07%  t_lockref_from-  [kernel.kallsyms]     [k] generic_fillattr
  0,07%  t_lockref_from-  [kernel.kallsyms]     [k] complete_walk
  0,06%  t_lockref_from-  [kernel.kallsyms]     [k] security_inode_getattr
  0,06%  t_lockref_from-  [kernel.kallsyms]     [k] _raw_spin_lock
  0,06%  t_lockref_from-  [kernel.kallsyms]     [k] rcu_eqs_exit
  0,06%  t_lockref_from-  [kernel.kallsyms]     [k] vtime_account_user
  0,06%  t_lockref_from-  [kernel.kallsyms]     [k] dput
  0,06%  t_lockref_from-  [kernel.kallsyms]     [k] rcu_eqs_enter
  0,06%  t_lockref_from-  [kernel.kallsyms]     [k] __virt_addr_valid

- Sedat -
