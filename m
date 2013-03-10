Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753222Ab3CJSru (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Mar 2013 14:47:50 -0400
Received: from mail-qe0-f51.google.com ([209.85.128.51]:44057 "EHLO
	mail-qe0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752976Ab3CJSrt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Mar 2013 14:47:49 -0400
Message-ID: <513CD568.90409@gmail.com>
Date: Sun, 10 Mar 2013 14:48:08 -0400
From: Sasha Levin <levinsasha928@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130310 Thunderbird/17.0.4
MIME-Version: 1.0
To: paulmck@linux.vnet.ibm.com
CC: Sasha Levin <sasha.levin@oracle.com>, Steven Rostedt <rostedt@goodmis.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        Andrew Morton <akpm@linux-foundation.org>,
        paul.gortmaker@windriver.com, Dave Jones <davej@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: irq_work: WARNING: at kernel/irq_work.c:98 irq_work_needs_cpu+0x8a/0xb0()
References: <51397B96.7030008@oracle.com> <20130308164435.GI3268@linux.vnet.ibm.com> <513A2CF1.9060006@oracle.com> <20130308194608.GK3268@linux.vnet.ibm.com> <513A4E8F.2020704@oracle.com> <20130308222058.GP3268@linux.vnet.ibm.com>
In-Reply-To: <20130308222058.GP3268@linux.vnet.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/08/2013 05:20 PM, Paul E. McKenney wrote:
> Alternatively, given that this is a debug option, how about replacing
> the schedule_timeout_uninterruptible() with something like the following:
> 
> 	{
> 		unsigned long starttime = jiffies + 2;
> 
> 		while (ULONG_CMP_LT(jiffies, starttime))
> 			cpu_relax();
> 	}
> 
> That way the RCU GP kthread would never go to sleep, and thus would not
> have to wait for the timer to wake it up.  If this works, then my next
> thought would be to try to get at the timer state for the wakeup fo
> schedule_timeout_uninterruptible().

It did the trick, I still see those IRQ warnings but the RCU lockup
is gone.


Thanks,
Sasha
