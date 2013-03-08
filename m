Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756937Ab3CHLnx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Mar 2013 06:43:53 -0500
Received: from multi.imgtec.com ([194.200.65.239]:47835 "EHLO multi.imgtec.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756734Ab3CHLnw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Mar 2013 06:43:52 -0500
Message-ID: <5139CEBA.7010704@imgtec.com>
Date: Fri, 8 Mar 2013 11:42:50 +0000
From: James Hogan <james.hogan@imgtec.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130110 Thunderbird/17.0.2
MIME-Version: 1.0
To: Steven Rostedt <rostedt@goodmis.org>,
        Frederic Weisbecker <fweisbec@gmail.com>
CC: James Hogan <james.hogan@imgtec.com>, <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Paul Gortmaker <paul.gortmaker@windriver.com>
Subject: Re: [PATCH 1/1] irq_work.h: fix warning when CONFIG_IRQ_WORK=n
References: <1362742582-26327-1-git-send-email-james.hogan@imgtec.com>
In-Reply-To: <1362742582-26327-1-git-send-email-james.hogan@imgtec.com>
X-Enigmail-Version: 1.4.6
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [192.168.154.65]
X-SEF-Processed: 7_3_0_01181__2013_03_08_11_43_50
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/03/13 11:36, James Hogan wrote:
> A randconfig caught repeated compiler warnings when CONFIG_IRQ_WORK=n
> due to the definition of a non-inline static function in
> <linux/irq_work.h>:
> 
> include/linux/irq_work.h +40 : warning: 'irq_work_needs_cpu' defined but not used

In addition to this warning I also got the following linker error when
CONFIG_IRQ_WORK=n:

kernel/built-in.o In function `wake_up_klogd':
(.text.wake_up_klogd+0xb4): undefined reference to `irq_work_queue'

which appears to be because of the following commit:

commit 74876a98a87a115254b3a66a14b27320b7f0acaa ("printk: Wake up klogd
using irq_work") also merged in v3.9-rc1.

Can somebody more familiar with that code please fix it.

Cheers
James

