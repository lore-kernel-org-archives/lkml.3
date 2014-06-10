Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934582AbaFJDbC (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jun 2014 23:31:02 -0400
Received: from cn.fujitsu.com ([59.151.112.132]:50120 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S933225AbaFJDbA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jun 2014 23:31:00 -0400
X-IronPort-AV: E=Sophos;i="4.98,1006,1392134400"; 
   d="scan'208";a="31687424"
Message-ID: <53967D01.5060600@cn.fujitsu.com>
Date: Tue, 10 Jun 2014 11:35:29 +0800
From: Lai Jiangshan <laijs@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.9) Gecko/20100921 Fedora/3.1.4-1.fc14 Thunderbird/3.1.4
MIME-Version: 1.0
To: Steven Rostedt <rostedt@goodmis.org>
CC: Thomas Gleixner <tglx@linutronix.de>, LKML <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@kernel.org>,
        Jason Low <jason.low2@hp.com>, Brad Mouring <bmouring@ni.com>,
        Lai Jiangshan <laijs@cn.fujitsu.com>
Subject: Re: [patch V3 4/7] rtmutex: Siplify remove_waiter()
References: <20140609201118.387571774@linutronix.de>	<20140609202336.248536613@linutronix.de> <20140609205329.52b8c0d5@gandalf.local.home>
In-Reply-To: <20140609205329.52b8c0d5@gandalf.local.home>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.167.226.103]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/10/2014 08:53 AM, Steven Rostedt wrote:
> On Mon, 09 Jun 2014 20:28:08 -0000
> Thomas Gleixner <tglx@linutronix.de> wrote:
> 
>> Exit right away, when the removed waiter was not the top prioriy
>> waiter on the lock. Get rid of the extra indent level.
>>
>> Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
>> ---
>>  kernel/locking/rtmutex.c |   26 ++++++++++----------------
>>  1 file changed, 10 insertions(+), 16 deletions(-)
>>
>> Index: tip/kernel/locking/rtmutex.c
>> ===================================================================
>> --- tip.orig/kernel/locking/rtmutex.c
>> +++ tip/kernel/locking/rtmutex.c
>> @@ -780,7 +780,7 @@ static void remove_waiter(struct rt_mute
>>  {
>>  	int first = (waiter == rt_mutex_top_waiter(lock));
>>  	struct task_struct *owner = rt_mutex_owner(lock);
>> -	struct rt_mutex *next_lock = NULL;
>> +	struct rt_mutex *next_lock;
>>  	unsigned long flags;
>>  
>>  	raw_spin_lock_irqsave(&current->pi_lock, flags);
>> @@ -788,28 +788,22 @@ static void remove_waiter(struct rt_mute
>>  	current->pi_blocked_on = NULL;
>>  	raw_spin_unlock_irqrestore(&current->pi_lock, flags);
>>  
> 
> Add comment here, something like...
> 
> 	/*
> 	 * Only update priority if this task was the highest priority
> 	 * task waiting on the lock, and there is an owner to update.
> 	 */
> 
> Rest looks good.
> 
> Reviewed-by: Steven Rostedt <rostedt@goodmis.org>

Reviewed-by: Lai Jiangshan <laijs@cn.fujitsu.com>

Thanks,
Lai
