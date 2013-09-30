Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755883Ab3I3SHK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Sep 2013 14:07:10 -0400
Received: from mx1.redhat.com ([209.132.183.28]:16207 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754439Ab3I3SHI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Sep 2013 14:07:08 -0400
Date: Mon, 30 Sep 2013 20:00:06 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Ingo Molnar <mingo@kernel.org>, Paul McKenney <paulmck@linux.vnet.ibm.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/6] sched, wait: Collapse __wait_event macros -v4
Message-ID: <20130930180006.GA29156@redhat.com>
References: <20130930152242.207382649@infradead.org> <20130930174054.GA28129@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130930174054.GA28129@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/30, Oleg Nesterov wrote:
>
> But at first glance, I think that something like below makes sense
> as 7/6.

Well, _something like_ perhaps,

>  	___wait_event(wq, ___wait_cond_timeout(condition),		\
>  		      TASK_INTERRUPTIBLE, 0, ret,	      		\
>  		      spin_unlock_irq(&lock);				\
> -		      __ret = schedule_timeout(__ret);			\
> +		      ___wait_schedule_timeout(__ret);			\

this is obviously wrong ;)

Oleg.

