Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755421AbaEHSrd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 May 2014 14:47:33 -0400
Received: from mail-ob0-f180.google.com ([209.85.214.180]:51172 "EHLO
	mail-ob0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752485AbaEHSrc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 May 2014 14:47:32 -0400
Message-ID: <536BD141.7030000@mvista.com>
Date: Thu, 08 May 2014 13:47:29 -0500
From: Corey Minyard <cminyard@mvista.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>, minyard@acm.org
CC: Ingo Molnar <mingo@redhat.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] sched: Initialize rq->age_stamp on processor start
References: <1399405857-14056-1-git-send-email-minyard@acm.org> <20140508161337.GF30445@twins.programming.kicks-ass.net>
In-Reply-To: <20140508161337.GF30445@twins.programming.kicks-ass.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/08/2014 11:13 AM, Peter Zijlstra wrote:
> On Tue, May 06, 2014 at 02:50:57PM -0500, minyard@acm.org wrote:
>> From: Corey Minyard <cminyard@mvista.com>
>>
>> If the sched_clock time starts at a large value, the kernel will spin
>> in sched_avg_update for a long time while rq->age_stamp catches up
>> with rq->clock.
>>
>> The comment in kernel/sched/clock.c says that there is no strict promise
>> that it starts at zero.  So initialize rq->age_stamp when a cpu starts up
>> to avoid this.
>>
>> I was seeing long delays on a simulator that didn't start the clock at
>> zero.  This might also be an issue on reboots on processors that don't
>> re-initialize the timer to zero on reset, and when using kexec.
>>
>> Signed-off-by: Corey Minyard <cminyard@mvista.com>
> This patch made my cris-defconfig build fail.
Dang, I missed propagating a change.  Yes, it's broken.  One more time...

-corey
