Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751784Ab3KRPjx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Nov 2013 10:39:53 -0500
Received: from mail-ee0-f45.google.com ([74.125.83.45]:33602 "EHLO
	mail-ee0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751319Ab3KRPjp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Nov 2013 10:39:45 -0500
Date: Mon, 18 Nov 2013 16:39:41 +0100
From: Ingo Molnar <mingo@kernel.org>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Stanislaw Gruszka <sgruszka@redhat.com>,
        Christian Engelmayer <cengelma@gmx.at>, Ingo Molnar <mingo@redhat.com>,
        linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PROBLEM] possible divide by 0 in kernel/sched/cputime.c
 scale_stime()
Message-ID: <20131118153941.GA28699@gmail.com>
References: <20131116223740.3cd579cb@spike>
 <20131118140224.GA3330@redhat.com>
 <20131118141956.GB10022@twins.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131118141956.GB10022@twins.programming.kicks-ass.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Peter Zijlstra <peterz@infradead.org> wrote:

> I would be tempted to say you should simply mark the tsc unstable on 
> boot and live with that -- we fully assume the sched_clock stuff is 
> not going backwards in an 'observable' way.

BIOS crap and actual hardware bugs do happen - so kernel code needs to 
consider TSC input with a pinch of salt, assuming that it's untrusted 
external data.

> That said, it might be nice to not crash either..

Indeed, not crashing on weird TSC input is absolutely required!

Thanks,

	Ingo
