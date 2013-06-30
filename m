Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752522Ab3F3V3w (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Jun 2013 17:29:52 -0400
Received: from merlin.infradead.org ([205.233.59.134]:54443 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752437Ab3F3V3u (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Jun 2013 17:29:50 -0400
Date: Sun, 30 Jun 2013 23:29:40 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Mike Galbraith <bitbucket@online.de>
Cc: LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>
Subject: Re: sched: context tracking demolishes pipe-test
Message-ID: <20130630212940.GK6626@twins.programming.kicks-ass.net>
References: <1372579056.6607.16.camel@marge.simpson.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1372579056.6607.16.camel@marge.simpson.net>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jun 30, 2013 at 09:57:36AM +0200, Mike Galbraith wrote:
> taskset -c 3 pipe-test 1
> 
>                   switch-rate
> 3.10.0-master     426.4 KHz
> 3.10.0-masterx    591.8 Khz     1.387 (591=notgood, 426=omfg)
> 
>      3.10.0-master                                    3.10.0-masterx
>      7.13%  [k] __schedule                            9.58%  [k] __schedule
> !    6.02%  [.] __read_nocancel                       8.25%  [k] system_call
> !    5.82%  [.] __write_nocancel                      5.34%  [k] _raw_spin_lock_irqsave
> !    4.28%  [k] system_call                           4.26%  [k] pipe_read
> !    4.13%  [k] user_exit                             3.53%  [k] copy_user_generic_string
>      3.64%  [k] _raw_spin_lock_irqsave                3.52%  [k] native_sched_clock
>      3.37%  [k] pipe_read                             3.43%  [k] __switch_to
>      2.72%  [k] copy_user_generic_string              3.21%  [.] main
>      2.60%  [.] main                                  2.96%  [k] mutex_lock
>      2.59%  [k] native_sched_clock                    2.89%  [k] mutex_unlock
>      2.47%  [k] __switch_to                           2.86%  [k] sched_clock_local
>      2.10%  [k] mutex_unlock                          2.63%  [.] __read_nocancel
>      2.08%  [k] sched_clock_local                     2.47%  [k] pipe_write
>      2.05%  [k] mutex_lock                            2.37%  [k] _raw_spin_unlock_irqrestore
>      1.91%  [k] pipe_write                            1.96%  [.] __write_nocancel
>      1.89%  [k] user_enter                            1.62%  [k] vfs_write
>      1.72%  [k] _raw_spin_unlock_irqrestore           1.54%  [k] do_sync_write
>      1.51%  [k] rcu_eqs_enter_common.isra.47          1.52%  [k] fget_light
>      1.41%  [k] rcu_eqs_exit_common.isra.45           1.48%  [k] fsnotify
>      1.30%  [k] tracesys                              1.39%  [k] dequeue_task_fair
>      1.23%  [k] fsnotify                              1.39%  [k] update_curr
>      1.23%  [k] int_check_syscall_exit_worka          1.37%  [k] do_sync_read
>      1.20%  [k] fget_light                            1.33%  [.] __GI___libc_write
>      1.16%  [k] vfs_write                             1.29%  [k] try_to_wake_up
>      1.05%  [k] syscall_trace_enter                   1.09%  [k] _raw_spin_lock_irq
>      1.04%  [k] do_sync_write                         1.08%  [k] pipe_iov_copy_from_user
>      1.03%  [k] context_tracking_task_switch          1.05%  [k] finish_task_switch
>      0.99%  [k] update_curr                           1.04%  [k] prepare_to_wait
> 

Yeah, who'd have thought that putting stuff in the syscall path would've
made syscalls more expensive ;-)

But yeah, that's a _lot_ more expensive.. I'd not be surprised if more
people would find that objectionable.
