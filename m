Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756918Ab3K0QX7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Nov 2013 11:23:59 -0500
Received: from mx1.redhat.com ([209.132.183.28]:34300 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751810Ab3K0QX5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Nov 2013 11:23:57 -0500
Date: Wed, 27 Nov 2013 17:24:06 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Ingo Molnar <mingo@kernel.org>, Steven Rostedt <rostedt@goodmis.org>,
        Juri Lelli <juri.lelli@gmail.com>, tglx@linutronix.de,
        mingo@redhat.com, fweisbec@gmail.com, darren@dvhart.com,
        johan.eker@ericsson.com, p.faure@akatech.ch,
        linux-kernel@vger.kernel.org, claudio@evidence.eu.com,
        michael@amarulasolutions.com, fchecconi@gmail.com,
        tommaso.cucinotta@sssup.it, nicola.manica@disi.unitn.it,
        luca.abeni@unitn.it, dhaval.giani@gmail.com, hgu1972@gmail.com,
        paulmck@linux.vnet.ibm.com, raistlin@linux.it, insop.song@gmail.com,
        liming.wang@windriver.com, jkacur@redhat.com,
        harald.gustafsson@ericsson.com, vincent.guittot@linaro.org,
        bruce.ashfield@windriver.com
Subject: Re: [PATCH 08/14] sched: add latency tracing for -deadline tasks.
Message-ID: <20131127162405.GB24773@redhat.com>
References: <1383831828-15501-1-git-send-email-juri.lelli@gmail.com> <1383831828-15501-9-git-send-email-juri.lelli@gmail.com> <20131120163318.10253e43@gandalf.local.home> <5295F711.5010708@gmail.com> <20131127091647.4e16ce53@gandalf.local.home> <20131127142649.GC13532@twins.programming.kicks-ass.net> <20131127143435.GD25043@gmail.com> <20131127145837.GE16796@laptop.programming.kicks-ass.net> <20131127153519.GA26095@gmail.com> <20131127154015.GG789@laptop.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131127154015.GG789@laptop.programming.kicks-ass.net>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/27, Peter Zijlstra wrote:
>
> Anyway, yes GCC seems to behave as we 'expect' it to; I just can't find
> the language spec actually guaranteeing this.

And the kernel already assumes that gcc should do this, for example

	struct siginfo info = {};

in do_tkill().

(this initialization should prevent the leak of uninitialized members
 to userspace).

Oleg.

