Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754380Ab3BEMFi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Feb 2013 07:05:38 -0500
Received: from mail-bk0-f52.google.com ([209.85.214.52]:37904 "EHLO
	mail-bk0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750914Ab3BEMFh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Feb 2013 07:05:37 -0500
Date: Tue, 5 Feb 2013 13:05:32 +0100
From: Ingo Molnar <mingo@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Steven Rostedt <rostedt@goodmis.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [GIT PULL] printk: Support for full dynticks mode
Message-ID: <20130205120532.GA21455@gmail.com>
References: <1360025478-32741-1-git-send-email-fweisbec@gmail.com>
 <20130204172001.8bb358b0.akpm@linux-foundation.org>
 <CAFTL4hxHEknUfv0rt73Tb0YAUrypuGJArvCw4wmEPp_8PF_b0A@mail.gmail.com>
 <20130204180948.68c206c0.akpm@linux-foundation.org>
 <1360032122.27007.4.camel@gandalf.local.home>
 <20130204200459.f2a0a1cc.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130204200459.f2a0a1cc.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Andrew Morton <akpm@linux-foundation.org> wrote:

> So what deadlocks was the March 2012 3ccf3e830 ("printk/sched: 
> Introduce special printk_sched() for those awkward moments") 
> supposed to fix? [...]

The wakeup in:

static int console_trylock_for_printk(unsigned int cpu)
...
        if (wake)
                up(&console_sem);

Thanks,

	Ingo
