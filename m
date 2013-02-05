Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755405Ab3BEBUH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Feb 2013 20:20:07 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:50332 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754530Ab3BEBUF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Feb 2013 20:20:05 -0500
Date: Mon, 4 Feb 2013 17:20:01 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [GIT PULL] printk: Support for full dynticks mode
Message-Id: <20130204172001.8bb358b0.akpm@linux-foundation.org>
In-Reply-To: <1360025478-32741-1-git-send-email-fweisbec@gmail.com>
References: <1360025478-32741-1-git-send-email-fweisbec@gmail.com>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue,  5 Feb 2013 01:51:18 +0100
Frederic Weisbecker <fweisbec@gmail.com> wrote:

>       printk: Wake up klogd using irq_work

That seems reasonable.

I'm wondering if we can now remove the printk_sched() special-case. 
iirc, that was needed because wake_up(klogd) would deadlock when called
from sched internals.  But now that wakeup is punted to the timer tick,
perhaps this is now unnecessary?

(Maybe there were other problems, but the 3ccf3e8306 is poor, and its
author is unavailable.  There's a lesson there!)
