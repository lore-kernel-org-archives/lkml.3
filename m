Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752620Ab3EJKu6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 May 2013 06:50:58 -0400
Received: from mail-da0-f50.google.com ([209.85.210.50]:54150 "EHLO
	mail-da0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751751Ab3EJKu4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 May 2013 06:50:56 -0400
MIME-Version: 1.0
In-Reply-To: <20130510104352.GF31235@dyad.programming.kicks-ass.net>
References: <25394.1367890528@ale.ozlabs.ibm.com>
	<20130508155929.GA8459@dyad.programming.kicks-ass.net>
	<14691.1368052755@ale.ozlabs.ibm.com>
	<20130510104352.GF31235@dyad.programming.kicks-ass.net>
Date: Fri, 10 May 2013 20:50:56 +1000
X-Google-Sender-Auth: NufOuv0tlmNIIvd921drbljFxB0
Message-ID: <CAEjGV6x1=6iFUwQs6=5GY75-J9ZZzs8=CKE=+MGxdwoKycs9jA@mail.gmail.com>
Subject: Re: Invalid perf_branch_entry.to entries question
From: Michael Neuling <mikey@neuling.org>
To: Peter Zijlstra <peterz@infradead.org>
Cc: eranian@google.com, Linux PPC dev <linuxppc-dev@ozlabs.org>,
        linux-kernel@vger.kernel.org,
        Michael Ellerman <michael@ellerman.id.au>,
        Anshuman Khandual <anshuman.khandual@in.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 10, 2013 at 8:43 PM, Peter Zijlstra <peterz@infradead.org> wrote:
> On Thu, May 09, 2013 at 08:39:15AM +1000, Michael Neuling wrote:
>> > Just because I'm curious.. however does that happen? Surely the CPU
>> > knows where next to fetch instructions?
>>
>> For computed gotos (ie. branch to a register value), the hardware gives
>> you the from and to address in the branch history buffer.
>>
>> For branches where the branch target address is an immediate encoded in
>> the instruction, the hardware only logs the from address.  It assumes
>> that software (perf irq handler in this case) can read this branch
>> instruction, calculate the corresponding offset and hence the
>> to/target address.
>>
>> It's entirely possible that when the perf IRQ handler happens, the
>> instruction in question is not readable or is no longer a branch (self
>> modifying code).  Hence we aren't able to calculate a valid to address.
>
> Ohh how cute! You've gotta love lazy hardware :-)

The buffer is in the core (not main memory) and hence only has limited
entries.  So skipping entries that can hopefully be determined in
other ways means we can log more branches.

That being said, it's a PITA for the kernel ;-)

Mikey
