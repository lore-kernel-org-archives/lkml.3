Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755870AbaEDQNV (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 May 2014 12:13:21 -0400
Received: from casper.infradead.org ([85.118.1.10]:51949 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755475AbaEDQNQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 May 2014 12:13:16 -0400
Date: Sun, 4 May 2014 18:13:12 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Jan Kara <jack@suse.cz>
Cc: John Stultz <john.stultz@linaro.org>, LKML <linux-kernel@vger.kernel.org>,
        Jiri Bohac <jbohac@suse.cz>, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Steven Rostedt <rostedt@goodmis.org>
Subject: Re: [PATCH 1/4] printk: Re-add irqsave/restore in printk_sched
Message-ID: <20140504161312.GL17778@laptop.programming.kicks-ass.net>
References: <1399068558-2373-1-git-send-email-john.stultz@linaro.org>
 <1399068558-2373-2-git-send-email-john.stultz@linaro.org>
 <20140504145847.GA7433@quack.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140504145847.GA7433@quack.suse.cz>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, May 04, 2014 at 04:58:47PM +0200, Jan Kara wrote:
> On Fri 02-05-14 15:09:15, John Stultz wrote:
> > A commit in akpm's tree (printk: remove separate printk_sched
> > buffers...), removed the printk_sched irqsave/restore lines
> > since it was safe for current users. Since we may be expanding
> > usage of printk_sched(), re-add the irqsave/restore logic
> > to make the functionality more generally safe.
>   So I'm just wondering: Do you have anything particular for which you need
> interrupts disabled? Won't e.g. disabling preemption be enough?

Yeah, I think preemption disabled is sufficient.
