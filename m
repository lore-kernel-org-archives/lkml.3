Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933567Ab3CHMiP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Mar 2013 07:38:15 -0500
Received: from mail-la0-f41.google.com ([209.85.215.41]:41625 "EHLO
	mail-la0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757007Ab3CHMiO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Mar 2013 07:38:14 -0500
MIME-Version: 1.0
In-Reply-To: <5139CEBA.7010704@imgtec.com>
References: <1362742582-26327-1-git-send-email-james.hogan@imgtec.com>
	<5139CEBA.7010704@imgtec.com>
Date: Fri, 8 Mar 2013 13:38:12 +0100
Message-ID: <CAFTL4hxX2cvHw4h4_6g1Zx2X+1YtJOmbXeVLZ_s+sGX8Gr21TA@mail.gmail.com>
Subject: Re: [PATCH 1/1] irq_work.h: fix warning when CONFIG_IRQ_WORK=n
From: Frederic Weisbecker <fweisbec@gmail.com>
To: James Hogan <james.hogan@imgtec.com>
Cc: Steven Rostedt <rostedt@goodmis.org>, linux-kernel@vger.kernel.org,
        Peter Zijlstra <peterz@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Paul Gortmaker <paul.gortmaker@windriver.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2013/3/8 James Hogan <james.hogan@imgtec.com>:
> In addition to this warning I also got the following linker error when
> CONFIG_IRQ_WORK=n:
>
> kernel/built-in.o In function `wake_up_klogd':
> (.text.wake_up_klogd+0xb4): undefined reference to `irq_work_queue'
>
> which appears to be because of the following commit:
>
> commit 74876a98a87a115254b3a66a14b27320b7f0acaa ("printk: Wake up klogd
> using irq_work") also merged in v3.9-rc1.
>
> Can somebody more familiar with that code please fix it.

I see. We need to make a wake_up_klogd() off case when CONFIG_PRINTK=n
I'm working on this.

Thanks.
