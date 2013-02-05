Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755732Ab3BEDTJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Feb 2013 22:19:09 -0500
Received: from mail-bk0-f42.google.com ([209.85.214.42]:38888 "EHLO
	mail-bk0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754484Ab3BEDTH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Feb 2013 22:19:07 -0500
MIME-Version: 1.0
In-Reply-To: <1360034041.27007.6.camel@gandalf.local.home>
References: <1360025478-32741-1-git-send-email-fweisbec@gmail.com>
	<20130204172001.8bb358b0.akpm@linux-foundation.org>
	<CAFTL4hxHEknUfv0rt73Tb0YAUrypuGJArvCw4wmEPp_8PF_b0A@mail.gmail.com>
	<20130204180948.68c206c0.akpm@linux-foundation.org>
	<1360034041.27007.6.camel@gandalf.local.home>
Date: Tue, 5 Feb 2013 04:19:05 +0100
Message-ID: <CAFTL4hyvvpqw2KwFzHLN5V5izKh4d0rp9mQhadZwRp8actRr+g@mail.gmail.com>
Subject: Re: [GIT PULL] printk: Support for full dynticks mode
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2013/2/5 Steven Rostedt <rostedt@goodmis.org>:
> On Mon, 2013-02-04 at 18:09 -0800, Andrew Morton wrote:
>
>> Maybe there were other deadlock scenarios, dunno.  That knowledge
>> appears to be disappearing into the mists of time :(
>
> Discussing this on IRC with Frederic, he brought up that the
> up(&console_sem) can do a wake_up as well. I guess that's the issue we
> have :-/

Also if we delay the wakeup on klogd but not on the console_sem
waiters, it looks like a general printk() problem. Not something that
only printk_sched() would like to avoid.
