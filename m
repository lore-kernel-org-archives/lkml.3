Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756706Ab3EHVdy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 May 2013 17:33:54 -0400
Received: from mail-oa0-f52.google.com ([209.85.219.52]:61069 "EHLO
	mail-oa0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753964Ab3EHVdx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 May 2013 17:33:53 -0400
MIME-Version: 1.0
In-Reply-To: <20130508155929.GA8459@dyad.programming.kicks-ass.net>
References: <25394.1367890528@ale.ozlabs.ibm.com>
	<20130508155929.GA8459@dyad.programming.kicks-ass.net>
Date: Wed, 8 May 2013 23:33:52 +0200
Message-ID: <CABPqkBRSMxQK8LJWhD39yo8EQZBd3-dRkeMqvwhWwLiHa6m66g@mail.gmail.com>
Subject: Re: Invalid perf_branch_entry.to entries question
From: Stephane Eranian <eranian@google.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Michael Neuling <mikey@neuling.org>,
        Linux PPC dev <linuxppc-dev@ozlabs.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Michael Ellerman <michael@ellerman.id.au>,
        Anshuman Khandual <anshuman.khandual@in.ibm.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 8, 2013 at 5:59 PM, Peter Zijlstra <peterz@infradead.org> wrote:
> On Tue, May 07, 2013 at 11:35:28AM +1000, Michael Neuling wrote:
>> Peter & Stephane,
>>
>> We are plumbing the POWER8 Branch History Rolling Buffer (BHRB) into
>> struct perf_branch_entry.
>>
>> Sometimes on POWER8 we may not be able to fill out the "to" address.
>
> Just because I'm curious.. however does that happen? Surely the CPU knows where
> next to fetch instructions?
>
>> We
>> initially thought of just making this 0, but it's feasible that this
>> could be a valid address to branch to.
>
> Right, while highly unlikely, x86 actually has some cases where 0 address is
> valid *shudder*..
>
>> The other logical value to indicate an invalid entry would be all 1s
>> which is not possible (on POWER at least).
>>
>> Do you guys have a preference as to what we should use as an invalid
>> entry?  This would have some consequences for the userspace tool also.
>>
>> The alternative would be to add a flag alongside mispred/predicted to
>> indicate the validity of the "to" address.
>
> Either would work with me I suppose.. Stephane do you have any preference?

But if the 'to' is bogus, why not just drop the sample?
That happens on x86 if the HW captured branches which do not correspond to
user filter settings (due to bug).
