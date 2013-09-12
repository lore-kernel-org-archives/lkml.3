Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752208Ab3ILNe2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Sep 2013 09:34:28 -0400
Received: from www.linutronix.de ([62.245.132.108]:58721 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751228Ab3ILNe1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Sep 2013 09:34:27 -0400
Date: Thu, 12 Sep 2013 15:33:48 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Libin <huawei.libin@huawei.com>
cc: akpm@linux-foundation.org, tj@kernel.org, viro@zeniv.linux.org.uk,
        eparis@redhat.com, rusty@rustcorp.com.au, ebiederm@xmission.com,
        paulmck@linux.vnet.ibm.com, john.stultz@linaro.org, mingo@redhat.com,
        peterz@infradead.org, gregkh@linuxfoundation.org,
        linux-kernel@vger.kernel.org, lizefan@huawei.com,
        jovi.zhangwei@huawei.com, guohanjun@huawei.com,
        zhangdianfang@huawei.com, wangyijing@huawei.com
Subject: Re: [PATCH 05/14] hrtimer: Fix invalid wakeup in do_nanosleep
In-Reply-To: <1377784669-28140-6-git-send-email-huawei.libin@huawei.com>
Message-ID: <alpine.DEB.2.02.1309121527320.4089@ionos.tec.linutronix.de>
References: <1377784669-28140-1-git-send-email-huawei.libin@huawei.com> <1377784669-28140-6-git-send-email-huawei.libin@huawei.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 29 Aug 2013, Libin wrote:

> If thread is preempted before calling set_current_state(TASK_INTERRUPTIBLE),
> and the other thread set the condition followed with wake_up_process. After
> that when this thread is re-scheduled, calling set_current_state to set itself
> as state TASK_INTERRUPTIBLE, if it is preempted again after that and before
> __set_current_state(TASK_RUNNING), it triggers the invalid wakeup problem.

do_nanosleep() is only called from sys_nanosleep() and
sys_clock_nanosleep() user space interfaces.

So the task is not going to be woken up by some magic other thread
except by a signal. The latter is handled by the scheduler which will
return with state running. So what kind of problem are you trying to
solve?

Thanks,

	tglx



 
