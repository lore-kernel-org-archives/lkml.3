Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751650AbaLNR31 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Dec 2014 12:29:27 -0500
Received: from mail.efficios.com ([78.47.125.74]:47730 "EHLO mail.efficios.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751018AbaLNR30 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Dec 2014 12:29:26 -0500
Date: Sun, 14 Dec 2014 17:29:28 +0000 (UTC)
From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-kernel@vger.kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Ingo Molnar <mingo@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Message-ID: <759389895.27358.1418578168225.JavaMail.zimbra@efficios.com>
In-Reply-To: <20141214122136.1664e104@gandalf.local.home>
References: <20141214164104.307127356@goodmis.org> <20141214164803.991954802@goodmis.org> <1556965801.27338.1418576749817.JavaMail.zimbra@efficios.com> <20141214121457.59b22354@gandalf.local.home> <20141214122136.1664e104@gandalf.local.home>
Subject: Re: [PATCH 1/3] tracepoints: Do not use call_rcu_sched() before
 early_initcall()
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
X-Originating-IP: [206.248.138.119]
X-Mailer: Zimbra 8.0.7_GA_6021 (ZimbraWebClient - FF34 (Linux)/8.0.7_GA_6021)
Thread-Topic: tracepoints: Do not use call_rcu_sched() before early_initcall()
Thread-Index: YVnvAxA4FoliblRTyQIxKyjuiypHNA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

----- Original Message -----
> From: "Steven Rostedt" <rostedt@goodmis.org>
> To: "Mathieu Desnoyers" <mathieu.desnoyers@efficios.com>
> Cc: linux-kernel@vger.kernel.org, "Linus Torvalds" <torvalds@linux-foundation.org>, "Ingo Molnar" <mingo@kernel.org>,
> "Andrew Morton" <akpm@linux-foundation.org>, "Thomas Gleixner" <tglx@linutronix.de>, "Paul E. McKenney"
> <paulmck@linux.vnet.ibm.com>
> Sent: Sunday, December 14, 2014 12:21:36 PM
> Subject: Re: [PATCH 1/3] tracepoints: Do not use call_rcu_sched() before early_initcall()
> 
> On Sun, 14 Dec 2014 12:14:57 -0500
> Steven Rostedt <rostedt@goodmis.org> wrote:
> 
> > If IRQ setup, or other core pieces of code can use this, then I would
> > agree that rcu should be changed. But until then, I rather not add
> > another conditional to the core RCU code.
> 
> Also, call_rcu*() is called from several hot paths. This location is
> not a hot path, and actually, it is in fact rather slow. That's another
> reason not to add the logic into the RCU code if just adding it to
> tracepoints is sufficient.

Given that your reason for having this RCU-specific logic in tracepoint.c
rather than within call_rcu*() is not slowing down a fast-path, how about
creating a new call_rcu_early() and call_rcu_sched_early() which can be
called in normal operation and at early boot ?

This would allow us to keep the RCU logic within the RCU implementation
rather than strongly coupling it with the tracepoint code.

Thanks,

Mathieu

-- 
Mathieu Desnoyers
EfficiOS Inc.
http://www.efficios.com
