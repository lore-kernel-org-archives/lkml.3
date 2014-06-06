Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752617AbaFFBOI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jun 2014 21:14:08 -0400
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.230]:57149 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751643AbaFFBOG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jun 2014 21:14:06 -0400
Date: Thu, 5 Jun 2014 21:14:03 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: LKML <linux-kernel@vger.kernel.org>, Peter Zijlstra <peterz@infradead.org>,
        Ingo Molnar <mingo@kernel.org>, Brad Mouring <bmouring@ni.com>
Subject: Re: [patch 1/2] rtmutex: Handle deadlock detection smarter
Message-ID: <20140605211403.199fe580@gandalf.local.home>
In-Reply-To: <20140605152801.836501969@linutronix.de>
References: <20140605152544.641846795@linutronix.de>
	<20140605152801.836501969@linutronix.de>
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.23; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-RR-Connecting-IP: 107.14.168.130:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 05 Jun 2014 15:28:32 -0000
Thomas Gleixner <tglx@linutronix.de> wrote:


> @@ -1112,7 +1134,8 @@ int rt_mutex_start_proxy_lock(struct rt_
>  		return 1;
>  	}
>  
> -	ret = task_blocks_on_rt_mutex(lock, waiter, task, detect_deadlock);
> +	/* We enforce deadlock detection for futexes */
> +	ret = task_blocks_on_rt_mutex(lock, waiter, task, 1);

Why bother with passing in detect_deadlock then?

Same goes for rt_mutex_finish_proxy_lock().

-- Steve


