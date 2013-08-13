Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754609Ab3HMISJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Aug 2013 04:18:09 -0400
Received: from mail-lb0-f170.google.com ([209.85.217.170]:43076 "EHLO
	mail-lb0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753301Ab3HMISG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Aug 2013 04:18:06 -0400
MIME-Version: 1.0
In-Reply-To: <CAPM31R+FDXUNb_X9R6O+kqjsAJftEzmyk+Ji=KoAyzEsTDWLew@mail.gmail.com>
References: <CALZhoSQgw_-UaF0VOMjMqRJC8D4oQTBp4Bv=zJS+x0Wu97f2FQ@mail.gmail.com>
	<20130812144309.GK27162@twins.programming.kicks-ass.net>
	<CALZhoSRyfE78GbiJqVRvUrbJRq_NhSqYbK8vnxNP8kS9xz9qVQ@mail.gmail.com>
	<20130813073842.GP27162@twins.programming.kicks-ass.net>
	<CAPM31R+FDXUNb_X9R6O+kqjsAJftEzmyk+Ji=KoAyzEsTDWLew@mail.gmail.com>
Date: Tue, 13 Aug 2013 16:18:04 +0800
Message-ID: <CALZhoSRszVz9=xm78u5r4ujgShDcajjs=WFOCAqHmzB+VZWBqQ@mail.gmail.com>
Subject: Re: false nr_running check in load balance?
From: Lei Wen <adrian.wenl@gmail.com>
To: Paul Turner <pjt@google.com>
Cc: Peter Zijlstra <peterz@infradead.org>, LKML <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@kernel.org>, Lei Wen <leiwen@marvell.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Paul,

On Tue, Aug 13, 2013 at 4:08 PM, Paul Turner <pjt@google.com> wrote:
> On Tue, Aug 13, 2013 at 12:38 AM, Peter Zijlstra <peterz@infradead.org> wrote:
>> On Tue, Aug 13, 2013 at 12:45:12PM +0800, Lei Wen wrote:
>>> > Not quite right; I think you need busiest->cfs.h_nr_running.
>>> > cfs.nr_running is the number of entries running in this 'group'. If
>>> > you've got nested groups like:
>>> >
>>> >  'root'
>>> >    \
>>> >    'A'
>>> >    / \
>>> >   t1 t2
>>> >
>>> > root.nr_running := 1 'A', even though you've got multiple running tasks.
>>> >
>>>
>>> You're absolutely right for this. :)
>>> I miss it for not considering the group case...
>>>
>>> Then do you think it is necessary to do below change in load_balance() code?
>>>  -       if (busiest->nr_running > 1) {
>>>  +       if (busiest->cfs.h_nr_running > 1) {
>>>
>>
>> Yes I think that would be fine.
>
> If we pivot to use h_nr_running we should probably also update
> call-sites such as cpu_load_avg_per_task() for consistency.

I didn't find cpu_load_avg_per_task in the latest linux git...
Is it a new patch pending while not being submitted?

Thanks,
Lei
