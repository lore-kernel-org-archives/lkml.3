Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753513Ab3BCS5R (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Feb 2013 13:57:17 -0500
Received: from mail-ee0-f49.google.com ([74.125.83.49]:43280 "EHLO
	mail-ee0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753382Ab3BCS5O (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Feb 2013 13:57:14 -0500
Date: Sun, 3 Feb 2013 19:57:09 +0100
From: Ingo Molnar <mingo@kernel.org>
To: Clark Williams <williams@redhat.com>
Cc: Peter Zijlstra <peterz@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        Steven Rostedt <rostedt@goodmis.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCHv2 2/2] sched/rt:  add a tuning knob to allow changing
 SCHED_RR timeslice
Message-ID: <20130203185709.GA22826@gmail.com>
References: <20130131135242.1b77b841@redhat.com>
 <20130203111025.GC11739@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20130203111025.GC11739@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Ingo Molnar <mingo@kernel.org> wrote:

> The first patch looks good, I've applied it.

I've skipped this one after all, as it sometimes generates:

include/linux/sched/sysctl.h:108:41: warning: ‘struct signal_struct’ declared inside parameter list [enabled by default]

Sometimes doesn't built kernel/sched/auto_group.c. So those bits 
probably want to move into a separate sched/auto_group.h header 
or so.

But, more fundamentally, I think sched.h should not include the 
new sched/sysctl.h file. The whole point is to move out bits 
from sched.h and decouple them from sched.h - to shrink sched.h 
in the long run.

Thanks,

	Ingo
