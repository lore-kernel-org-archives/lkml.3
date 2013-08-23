Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756115Ab3HWMd7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Aug 2013 08:33:59 -0400
Received: from s3.sipsolutions.net ([144.76.43.152]:38905 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755698Ab3HWMd5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Aug 2013 08:33:57 -0400
Message-ID: <1377261222.14021.23.camel@jlt4.sipsolutions.net>
Subject: Re: [sched_delayed] sched: RT throttling activated
From: Johannes Berg <johannes@sipsolutions.net>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Martin Mokrejs <mmokrejs@fold.natur.cuni.cz>, Theodore Tso <tytso@mit.edu>,
        Thomas Gleixner <tglx@linutronix.de>, mingo@redhat.com,
        LKML <linux-kernel@vger.kernel.org>
Date: Fri, 23 Aug 2013 14:33:42 +0200
In-Reply-To: <20130823121004.GW31370@twins.programming.kicks-ass.net>
References: <521722EE.70209@fold.natur.cuni.cz>
	 <20130823100913.GQ31370@twins.programming.kicks-ass.net>
	 <52173BBD.3050803@fold.natur.cuni.cz>
	 <20130823110254.GU31370@twins.programming.kicks-ass.net>
	 <521748FC.10809@fold.natur.cuni.cz>
	 <20130823121004.GW31370@twins.programming.kicks-ass.net>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.3-1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2013-08-23 at 14:10 +0200, Peter Zijlstra wrote:

> >  2161  FF [irq/50-iwlwifi]
> 
> Oh a threaded interrupt, I presume you're not using "threadiqrs" since
> this is the only interrupt thread around and I see a
> 'request_threaded_irq()' call in
> drivers/net/wireless/iwlwifi/pcie/trans.c
> 
> And wow, why would that thing consume that much cpu. 

How much is "that much"?

> Johill, ever seen the iwlwifi interrupt go 'funny' and consume gobs of
> cpu-time?

Not really, no, though if you do a lot of data transfer it can actually
consume a fair bit of CPU - made better by two somewhat recent patches,
commits 01911dab97cb3e21e640aaca82689acec00ed848 and
68972c46f2975d3d61f9dc9f311f77bfc8a8b12b.

johannes

