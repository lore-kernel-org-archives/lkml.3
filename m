Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752202AbaE0NUS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 May 2014 09:20:18 -0400
Received: from mail-wi0-f178.google.com ([209.85.212.178]:59667 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751941AbaE0NUO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 May 2014 09:20:14 -0400
Message-ID: <1401196807.5134.132.camel@marge.simpson.net>
Subject: Re: balance storm
From: Mike Galbraith <umgwanakikbuti@gmail.com>
To: Libo Chen <libo.chen@huawei.com>
Cc: tglx@linutronix.de, mingo@elte.hu, LKML <linux-kernel@vger.kernel.org>,
        Greg KH <gregkh@linuxfoundation.org>, Li Zefan <lizefan@huawei.com>,
        peterz@infradead.org
Date: Tue, 27 May 2014 15:20:07 +0200
In-Reply-To: <53848A2C.5010209@huawei.com>
References: <5382AF2E.1040407@huawei.com>
	 <1401081082.5339.41.camel@marge.simpson.net> <538330B7.5070503@huawei.com>
	 <1401113960.23186.41.camel@marge.simpson.net> <53844510.1040502@huawei.com>
	 <1401184553.5134.115.camel@marge.simpson.net> <53848A2C.5010209@huawei.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2014-05-27 at 20:50 +0800, Libo Chen wrote:

> in my box:
> 
> perf top -g --sort=symbol
> 
> Events: 3K cycles
>  73.27%  [k] read_hpet
>   4.30%  [k] _raw_spin_lock_irqsave
>   1.88%  [k] __schedule
>   1.00%  [k] idle_cpu
>   0.91%  [k] native_write_msr_safe
>   0.68%  [k] select_task_rq_fair
>   0.51%  [k] module_get_kallsym
>   0.49%  [.] sem_post
>   0.44%  [.] main
>   0.41%  [k] menu_select
>   0.39%  [k] _raw_spin_lock
>   0.38%  [k] __switch_to
>   0.33%  [k] _raw_spin_lock_irq
>   0.32%  [k] format_decode
>   0.29%  [.] usleep
>   0.28%  [.] symbols__insert
>   0.27%  [k] tick_nohz_stop_sched_tick
>   0.27%  [k] update_stats_wait_end
>   0.26%  [k] apic_timer_interrupt
>   0.25%  [k] enqueue_entity
>   0.25%  [k] sched_clock_local
>   0.24%  [k] _raw_spin_unlock_irqrestore
>   0.24%  [k] select_idle_sibling

read_hpet?  Are you booting box notsc or something?  Migration cost is
the least of your worries.

-Mike

