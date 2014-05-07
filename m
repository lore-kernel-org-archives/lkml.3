Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751478AbaEGVES (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 May 2014 17:04:18 -0400
Received: from bombadil.infradead.org ([198.137.202.9]:57885 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751033AbaEGVEQ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 May 2014 17:04:16 -0400
Date: Wed, 7 May 2014 23:04:11 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Fabian Frederick <fabf@skynet.be>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
        akpm <akpm@linux-foundation.org>
Subject: Re: [PATCH 2/2] kernel/stop_machine.c: remove false assignment to
 static
Message-ID: <20140507210411.GB2844@laptop.programming.kicks-ass.net>
References: <20140507224656.e06286af4392251135862718@skynet.be>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: 8BIT
In-Reply-To: <20140507224656.e06286af4392251135862718@skynet.be>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 07, 2014 at 10:46:56PM +0200, Fabian Frederick wrote:
> This patch also fixes function prototype over 80 characters

And does it wrong.. Also does it really matter to GCC that we init the
bool? Surely it can see its 0 and put it in .bss anyway?

> Cc: Peter Zijlstra <peterz@infradead.org>
> Cc: Andrew Morton <akpm@linux-foundation.org>
> Signed-off-by: Fabian Frederick <fabf@skynet.be>
> ---
>  kernel/stop_machine.c | 5 +++--
>  1 file changed, 3 insertions(+), 2 deletions(-)
> 
> diff --git a/kernel/stop_machine.c b/kernel/stop_machine.c
> index 695f0c6..8d29ee2 100644
> --- a/kernel/stop_machine.c
> +++ b/kernel/stop_machine.c
> @@ -42,7 +42,7 @@ struct cpu_stopper {
>  
>  static DEFINE_PER_CPU(struct cpu_stopper, cpu_stopper);
>  static DEFINE_PER_CPU(struct task_struct *, cpu_stopper_task);
> -static bool stop_machine_initialized = false;
> +static bool stop_machine_initialized;
>  
>  /*
>   * Avoids a race between stop_two_cpus and global stop_cpus, where
> @@ -241,7 +241,8 @@ static void irq_cpu_stop_queue_work(void *arg)
>   *
>   * returns when both are completed.
>   */
> -int stop_two_cpus(unsigned int cpu1, unsigned int cpu2, cpu_stop_fn_t fn, void *arg)
> +int stop_two_cpus(unsigned int cpu1, unsigned int cpu2, cpu_stop_fn_t fn,
> +		  void *arg)

Its only 84, so I didn't care to wrap it, its more readable this way,
but if you want it split split it like:

int
stop_two_cpus(unsigned int cpu1, unsigned int cpu2, cpu_stop_fn_t fn, void *arg)

Or if you really have to split arguments to it in groups that make
sense; like:

int stop_two_cpus(unsigned int cpu1, unsigned int cpu2,
		  cpu_stop_fn_t fn, void *arg)

But really, these are two unrelated changes, and should therefore not be
in a single patch.
