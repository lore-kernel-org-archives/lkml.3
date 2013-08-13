Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753228Ab3HMIIw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Aug 2013 04:08:52 -0400
Received: from mail-qc0-f169.google.com ([209.85.216.169]:38550 "EHLO
	mail-qc0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750929Ab3HMIIs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Aug 2013 04:08:48 -0400
MIME-Version: 1.0
In-Reply-To: <20130813073842.GP27162@twins.programming.kicks-ass.net>
References: <CALZhoSQgw_-UaF0VOMjMqRJC8D4oQTBp4Bv=zJS+x0Wu97f2FQ@mail.gmail.com>
 <20130812144309.GK27162@twins.programming.kicks-ass.net> <CALZhoSRyfE78GbiJqVRvUrbJRq_NhSqYbK8vnxNP8kS9xz9qVQ@mail.gmail.com>
 <20130813073842.GP27162@twins.programming.kicks-ass.net>
From: Paul Turner <pjt@google.com>
Date: Tue, 13 Aug 2013 01:08:17 -0700
Message-ID: <CAPM31R+FDXUNb_X9R6O+kqjsAJftEzmyk+Ji=KoAyzEsTDWLew@mail.gmail.com>
Subject: Re: false nr_running check in load balance?
To: Peter Zijlstra <peterz@infradead.org>
Cc: Lei Wen <adrian.wenl@gmail.com>, LKML <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@kernel.org>, Lei Wen <leiwen@marvell.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 13, 2013 at 12:38 AM, Peter Zijlstra <peterz@infradead.org> wrote:
> On Tue, Aug 13, 2013 at 12:45:12PM +0800, Lei Wen wrote:
>> > Not quite right; I think you need busiest->cfs.h_nr_running.
>> > cfs.nr_running is the number of entries running in this 'group'. If
>> > you've got nested groups like:
>> >
>> >  'root'
>> >    \
>> >    'A'
>> >    / \
>> >   t1 t2
>> >
>> > root.nr_running := 1 'A', even though you've got multiple running tasks.
>> >
>>
>> You're absolutely right for this. :)
>> I miss it for not considering the group case...
>>
>> Then do you think it is necessary to do below change in load_balance() code?
>>  -       if (busiest->nr_running > 1) {
>>  +       if (busiest->cfs.h_nr_running > 1) {
>>
>
> Yes I think that would be fine.

If we pivot to use h_nr_running we should probably also update
call-sites such as cpu_load_avg_per_task() for consistency.
