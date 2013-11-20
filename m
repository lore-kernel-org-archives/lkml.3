Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754860Ab3KTTAX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Nov 2013 14:00:23 -0500
Received: from merlin.infradead.org ([205.233.59.134]:52040 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754424Ab3KTTAU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Nov 2013 14:00:20 -0500
Date: Wed, 20 Nov 2013 20:00:11 +0100
From: Peter Zijlstra <peterz@infradead.org>
To: Jacob Pan <jacob.jun.pan@linux.intel.com>
Cc: Arjan van de Ven <arjan@linux.intel.com>, lenb@kernel.org,
        rjw@rjwysocki.net, Eliezer Tamir <eliezer.tamir@linux.intel.com>,
        Chris Leech <christopher.leech@intel.com>,
        David Miller <davem@davemloft.net>, rui.zhang@intel.com,
        Mike Galbraith <bitbucket@online.de>, Ingo Molnar <mingo@kernel.org>,
        hpa@zytor.com, Thomas Gleixner <tglx@linutronix.de>,
        linux-kernel@vger.kernel.org, linux-pm@vger.kernel.org,
        Rusty Russell <rusty@rustcorp.com.au>
Subject: Re: [PATCH 7/7] preempt: Take away preempt_enable_no_resched() from
 modules
Message-ID: <20131120190011.GX16796@laptop.programming.kicks-ass.net>
References: <20131120160450.072555619@infradead.org>
 <20131120162736.760865926@infradead.org>
 <20131120105457.04f6e51e@ultegra>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20131120105457.04f6e51e@ultegra>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 20, 2013 at 10:54:57AM -0800, Jacob Pan wrote:
> run into a couple of compile issues.
> 
> 1)
> include/linux/rcupdate.h: In function ‘rcu_read_unlock_sched_notrace’:
> include/linux/rcupdate.h:889:2: error: implicit declaration of function
> ‘preempt_enable_no_resched_notrace’ [-Werror=implicit-function-declaration]
> 
> 2)
> In file included from drivers/cpufreq/acpi-cpufreq.c:41:0:
> include/linux/uaccess.h: In function ‘pagefault_enable’:
> include/linux/uaccess.h:34:2: error: implicit declaration of function
> ‘preempt_check_resched’ [-Werror=implicit-function-declaration]
> 
> 1) happens when CONFIG_PREEMPT is not set, perhaps add a dummy function?

Ah, indeed, will fix.

> 2) I am not sure if we should take pagefault_enable away from modules

We can't I think, I'll have to fix that up. Easiest would be to make
preempt_check_resched() available again. That function actually adds
preemption points so its not bad.
