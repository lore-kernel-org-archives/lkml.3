Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752927AbaDXIl5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Apr 2014 04:41:57 -0400
Received: from mail-ob0-f169.google.com ([209.85.214.169]:39724 "EHLO
	mail-ob0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752457AbaDXIlx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Apr 2014 04:41:53 -0400
MIME-Version: 1.0
In-Reply-To: <201404240832.s3O8WHd0011014@toshiba.co.jp>
References: <cover.1395322529.git.viresh.kumar@linaro.org>
	<201404240725.s3O7PrUv003720@toshiba.co.jp>
	<CAKohpokt-O3BAGMzE_=heVBZQOwp0C7eT8ZA2485DgNi3+Xcqg@mail.gmail.com>
	<201404240832.s3O8WHd0011014@toshiba.co.jp>
Date: Thu, 24 Apr 2014 14:11:52 +0530
Message-ID: <CAKohpokk4rGeP3QfVT5_HBO4pc=22yPBLV78D++y1Ab72y1OJQ@mail.gmail.com>
Subject: Re: [RFC 0/4] Migrate timers away from cpuset on setting cpuset.quiesce
From: Viresh Kumar <viresh.kumar@linaro.org>
To: Daniel Sangorrin <daniel.sangorrin@toshiba.co.jp>
Cc: Thomas Gleixner <tglx@linutronix.de>,
        =?UTF-8?B?RnLDqWTDqXJpYyBXZWlzYmVja2Vy?= <fweisbec@gmail.com>,
        Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@kernel.org>,
        Tejun Heo <tj@kernel.org>, Li Zefan <lizefan@huawei.com>,
        Lists linaro-kernel <linaro-kernel@lists.linaro.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Cgroups <cgroups@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 24 April 2014 14:01, Daniel Sangorrin <daniel.sangorrin@toshiba.co.jp> wrote:
> In kernel/cpuset.c:quiesce_cpuset() you are using the function
> 'smp_call_function_any' which asks CPU cores in 'cpumask' to
> execute the functions 'hrtimer_quiesce_cpu' and 'timer_quiesce_cpu'.
>
> In the case above, 'cpumask' corresponds to core 0. Since I'm forcing
> the call to be executed from core 1 (by using taskset),
> an inter-processor interrupt is sent to core 0 for those functions
> to be executed.

Ahh, I understood that now :) .. So we are setting cpuset.quiesce from CPU1
which will do a IPI to get migrate_timers called on CPU0.. I was setting quiesce
from CPU0 only in my tests :)

But how does this work fine on x86 then? There we should have exactly same
problem, isn't it?

> Ok, thank you! I see that you have already fixed the problem. I tested
> your tree on ARM and now it seems to work correctly.

Yeah, I just pushed your changes as well at the time I wrote last mail :)
