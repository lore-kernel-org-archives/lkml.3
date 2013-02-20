Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935673Ab3BTQHT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Feb 2013 11:07:19 -0500
Received: from mail-la0-f52.google.com ([209.85.215.52]:53258 "EHLO
	mail-la0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934944Ab3BTQHR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Feb 2013 11:07:17 -0500
MIME-Version: 1.0
In-Reply-To: <87ehgid6bb.fsf@linaro.org>
References: <1359399845-10568-1-git-send-email-fweisbec@gmail.com>
	<1359399845-10568-3-git-send-email-fweisbec@gmail.com>
	<87ehgid6bb.fsf@linaro.org>
Date: Wed, 20 Feb 2013 17:07:15 +0100
Message-ID: <CAFTL4hyGBR9wmtStRNrm01g5VfKWv9mzXEq2dQh19pAZrXbd=g@mail.gmail.com>
Subject: Re: [PATCH 2/8] cputime: Librarize per nsecs resolution cputime definitions
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Kevin Hilman <khilman@linaro.org>
Cc: Ingo Molnar <mingo@kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Li Zhong <zhong@linux.vnet.ibm.com>,
        Namhyung Kim <namhyung.kim@lge.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Thomas Gleixner <tglx@linutronix.de>, Tony Luck <tony.luck@intel.com>,
        Fenghua Yu <fenghua.yu@intel.com>,
        Nicolas Pitre <nicolas.pitre@linaro.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2013/2/14 Kevin Hilman <khilman@linaro.org>:
> Frederic Weisbecker <fweisbec@gmail.com> writes:
>
>> The full dynticks cputime accounting that we'll soon introduce
>> will rely on sched_clock(). And its clock can have a per
>> nanosecond granularity.
>>
>> To prepare for this, we need to have a cputime_t implementation
>> that has this precision.
>>
>> ia64 virtual cputime accounting already uses that granularity
>> so all we need is to librarize its implementation in the asm
>> generic headers.
>
> ...except that for it to be truly generic (i.e. usable on 32-bit arches),
> it should be using do_div() for 64-bit divides.
>
> I understand this series is targetted at 64-bit platforms currently, but
> I'm looking (again) at getting adaptive NOHZ working on ARM, and this
> was the first obvious obstacle to even compiling.
>
> I see this is already merged into tip/sched/core, so below is a patch on
> top of that to convert to using do_div().  If you're OK with the
> approach, I'll post it formally to LKML.

Yes please, this looks like something we want.

Thanks.
