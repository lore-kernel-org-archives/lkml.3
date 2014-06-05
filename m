Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751977AbaFEKRP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jun 2014 06:17:15 -0400
Received: from mail-wg0-f47.google.com ([74.125.82.47]:53753 "EHLO
	mail-wg0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751241AbaFEKRO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jun 2014 06:17:14 -0400
Date: Thu, 5 Jun 2014 12:17:09 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Daniel Lezcano <daniel.lezcano@linaro.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] sched: Move enum CPU_[xxx_]IDLE to private sched.h
Message-ID: <20140605101709.GA24277@gmail.com>
References: <1401800345-29468-1-git-send-email-daniel.lezcano@linaro.org>
 <20140604080214.GJ30445@twins.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20140604080214.GJ30445@twins.programming.kicks-ass.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Peter Zijlstra <peterz@infradead.org> wrote:

> On Tue, Jun 03, 2014 at 02:59:05PM +0200, Daniel Lezcano wrote:
> > The different enum CPU_IDLE, CPU_NOT_IDLE, CPU_NEWLY_IDLE and
> > CPU_MAX_IDLE_TYPES are only used in kernel/sched/fair.c and
> > kernel/sched/stats.c.
> > 
> > Move their definitions in the private 'sched.h' file located in the
> > same place than the files above.
> > 
> 
> Thanks!


So this patch breaks x86 64-bit and 32-bit defconfigs:

In file included from
/home/mingo/tip/arch/x86/kernel/asm-offsets.c:9:0:
/home/mingo/tip/include/linux/sched.h:939:24: error:
‘CPU_MAX_IDLE_TYPES’ undeclared here (not in a function)
  unsigned int lb_count[CPU_MAX_IDLE_TYPES];
                        ^
make[2]: *** [arch/x86/kernel/asm-offsets.s] Error 1
make[1]: *** [prepare0] Error 2
make: *** [sub-make] Error 2

Thanks,

	Ingo
