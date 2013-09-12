Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752452Ab3ILNh2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Sep 2013 09:37:28 -0400
Received: from www.linutronix.de ([62.245.132.108]:58762 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751201Ab3ILNh1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Sep 2013 09:37:27 -0400
Date: Thu, 12 Sep 2013 15:36:56 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Libin <huawei.libin@huawei.com>
cc: akpm@linux-foundation.org, tj@kernel.org, viro@zeniv.linux.org.uk,
        eparis@redhat.com, rusty@rustcorp.com.au, ebiederm@xmission.com,
        paulmck@linux.vnet.ibm.com, john.stultz@linaro.org, mingo@redhat.com,
        peterz@infradead.org, gregkh@linuxfoundation.org,
        linux-kernel@vger.kernel.org, lizefan@huawei.com,
        jovi.zhangwei@huawei.com, guohanjun@huawei.com,
        zhangdianfang@huawei.com, wangyijing@huawei.com
Subject: Re: [PATCH 10/14] time: Fix invalid wakeup in alarmtimer_do_nsleep
In-Reply-To: <1377784669-28140-11-git-send-email-huawei.libin@huawei.com>
Message-ID: <alpine.DEB.2.02.1309121536210.4089@ionos.tec.linutronix.de>
References: <1377784669-28140-1-git-send-email-huawei.libin@huawei.com> <1377784669-28140-11-git-send-email-huawei.libin@huawei.com>
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
> 
> To solve this problem, using preempt_disable() to bound the operaion that
> setting the task state and the conditions(set by the wake thread) validation.

See the reply to the hrtimer patch. You're solving a non issue.

Thanks,

	tglx
