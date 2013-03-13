Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934052Ab3CMRxe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Mar 2013 13:53:34 -0400
Received: from mail-la0-f54.google.com ([209.85.215.54]:37412 "EHLO
	mail-la0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933132Ab3CMRxd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Mar 2013 13:53:33 -0400
MIME-Version: 1.0
In-Reply-To: <CAFTL4hy=g=CgZ=LnRKZA4_okw9hJDvreVyaoCwPdKJVcEd1ypA@mail.gmail.com>
References: <1362586015-27951-1-git-send-email-fweisbec@gmail.com>
	<1362586015-27951-3-git-send-email-fweisbec@gmail.com>
	<20130307143246.GB1859@redhat.com>
	<CAFTL4hy=g=CgZ=LnRKZA4_okw9hJDvreVyaoCwPdKJVcEd1ypA@mail.gmail.com>
Date: Wed, 13 Mar 2013 18:53:31 +0100
Message-ID: <CAFTL4hwDZG8eeX3r2-JNosN-axmmpfCTGwRsGSptQSi+3e0y5Q@mail.gmail.com>
Subject: Re: [PATCH 2/2] sched: Lower chances of cputime scaling overflow
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Stanislaw Gruszka <sgruszka@redhat.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Steven Rostedt <rostedt@goodmis.org>,
        Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2013/3/12 Frederic Weisbecker <fweisbec@gmail.com>:
> 2013/3/7 Stanislaw Gruszka <sgruszka@redhat.com>:
>>> +     } else if (!total) {
>>>               stime = rtime;
>>
>> I would prefer stime = rtime/2 (hence utime will be rtime/2 too), but this
>> is not so important.
>
> I can do that.

I eventually kept it that way. Reason is that tasks always spend at
least a bit of time in the kernel when they are scheduled for the
first time. But they might never go to userspace, as in kernel
threads. So I prefer to stuff everything in stime by default. Having
(total == 0 && rtime != 0) should only happen for very low values of
rtime anyway.
