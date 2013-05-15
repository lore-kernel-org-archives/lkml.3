Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932736Ab3EOOUu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 May 2013 10:20:50 -0400
Received: from mail-oa0-f44.google.com ([209.85.219.44]:49261 "EHLO
	mail-oa0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932700Ab3EOOUr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 May 2013 10:20:47 -0400
MIME-Version: 1.0
In-Reply-To: <20130503170007.GA30733@dyad.programming.kicks-ass.net>
References: <20130503121122.931661809@chello.nl>
	<20130503121256.083340271@chello.nl>
	<20130503143507.GP19487@tassilo.jf.intel.com>
	<20130503170007.GA30733@dyad.programming.kicks-ass.net>
Date: Wed, 15 May 2013 16:20:46 +0200
Message-ID: <CABPqkBSTMJebZLjvLhdQ1hiemoqvO2t=vi+CG=yLjkFabOr8XQ@mail.gmail.com>
Subject: Re: [PATCH 1/3] perf, x86: Blacklist all MEM_*_RETIRED events for IVB
From: Stephane Eranian <eranian@google.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Andi Kleen <ak@linux.intel.com>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Ingo Molnar <mingo@kernel.org>, LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Based on our testing, it appears the corruption occurs only
when the MEM_* events are used and only on the sibling
counter. In other words, if HT0 has MEM_* in cntr0, then
HT1 cntr0 cannot be used, otherwise whatever is there may
get corrupted. So I think we could enhance Andi's initial patch
to handle this case instead of blacklist those events. They are
very important events.


On Fri, May 3, 2013 at 7:00 PM, Peter Zijlstra <peterz@infradead.org> wrote:
> On Fri, May 03, 2013 at 07:35:07AM -0700, Andi Kleen wrote:
>> On Fri, May 03, 2013 at 02:11:23PM +0200, Peter Zijlstra wrote:
>> > Errata BV98 states that all MEM_*_RETIRED events corrupt the counter
>> > value of the SMT sibling's counters. Blacklist these events
>>
>> I disagree with this patch. This is just overkill and not needed
>> at all.
>
> Then give me a patch that both completely describes the problem and ensures
> isolation so that no counters get corrupted (and isn't too invasive).
>
> So far you've failed on both counts.
>
>
