Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932403Ab3JNUhG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Oct 2013 16:37:06 -0400
Received: from mail-ea0-f178.google.com ([209.85.215.178]:38294 "EHLO
	mail-ea0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932174Ab3JNUhA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Oct 2013 16:37:00 -0400
Message-ID: <525C55E7.7030607@gmail.com>
Date: Mon, 14 Oct 2013 22:36:55 +0200
From: Juri Lelli <juri.lelli@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.0
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>
CC: tglx@linutronix.de, mingo@redhat.com, rostedt@goodmis.org, oleg@redhat.com,
        fweisbec@gmail.com, darren@dvhart.com, johan.eker@ericsson.com,
        p.faure@akatech.ch, linux-kernel@vger.kernel.org,
        claudio@evidence.eu.com, michael@amarulasolutions.com,
        fchecconi@gmail.com, tommaso.cucinotta@sssup.it,
        nicola.manica@disi.unitn.it, luca.abeni@unitn.it,
        dhaval.giani@gmail.com, hgu1972@gmail.com, paulmck@linux.vnet.ibm.com,
        raistlin@linux.it, insop.song@gmail.com, liming.wang@windriver.com,
        jkacur@redhat.com, harald.gustafsson@ericsson.com,
        vincent.guittot@linaro.org
Subject: Re: [PATCH 03/14] sched: SCHED_DEADLINE structures & implementation.
References: <1381747426-31334-1-git-send-email-juri.lelli@gmail.com> <1381747426-31334-4-git-send-email-juri.lelli@gmail.com> <20131014114900.GF3081@twins.programming.kicks-ass.net>
In-Reply-To: <20131014114900.GF3081@twins.programming.kicks-ass.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/14/2013 01:49 PM, Peter Zijlstra wrote:
> On Mon, Oct 14, 2013 at 12:43:35PM +0200, Juri Lelli wrote:
>> +/*
>> + * Yield task semantic for -deadline tasks is:
>> + *
>> + *   get off from the CPU until our next instance, with
>> + *   a new runtime.
>> + */
> 
> Could you amend that comment with a reason for why this is so? I have
> vague recollections of a discussion on this subject but can't recall. It
> seems like a useful thing to have.
> 

I think discussion happened before I started maintaining the patchset, but I'm
quite sure this would be helpful for bandwidth reclaiming mechanisms.
Basically, if I'm able to report that I didn't use all the budget of my current
instance, I could donate that remaining budget to other task instances.
Bandwidth reclaiming is another nice thing to have, and we actually have some
ideas on how to implement it (TODO list always grows :)).

I'll amend the comment saying that this function is of little use now, but will
be helpful in the future.

Thanks,

- Juri
