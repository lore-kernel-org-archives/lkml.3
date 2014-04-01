Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752163AbaDAHCv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Apr 2014 03:02:51 -0400
Received: from mail-oa0-f48.google.com ([209.85.219.48]:43413 "EHLO
	mail-oa0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752099AbaDAHCh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Apr 2014 03:02:37 -0400
MIME-Version: 1.0
In-Reply-To: <CAKohpon-YbK05yZMsJ68pTycFrU6UsBvmRyssS_j6RZeaVdD7w@mail.gmail.com>
References: <cover.1396006658.git.viresh.kumar@linaro.org>
	<alpine.DEB.2.02.1403311522080.14882@ionos.tec.linutronix.de>
	<CAKohpon-YbK05yZMsJ68pTycFrU6UsBvmRyssS_j6RZeaVdD7w@mail.gmail.com>
Date: Tue, 1 Apr 2014 12:32:36 +0530
Message-ID: <CAKohpo=85=5NwrTxGQ4MbYQa6eEuxv--pukHMmfkvzVfBgF=nA@mail.gmail.com>
Subject: Re: [PATCH 00/16] timers/hrtimers: Minor cleanups: Part II
From: Viresh Kumar <viresh.kumar@linaro.org>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Lists linaro-kernel <linaro-kernel@lists.linaro.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        =?ISO-8859-1?Q?Fr=E9d=E9ric_Weisbecker?= <fweisbec@gmail.com>,
        Linaro Networking <linaro-networking@linaro.org>,
        Arvind Chauhan <Arvind.Chauhan@arm.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 1 April 2014 12:03, Viresh Kumar <viresh.kumar@linaro.org> wrote:
> So here is the patch by patch analysis (With x86_64_defconfig):
>
> Initial details:
>    text   data    bss    dec    hex filename
>    7989    408      0   8397   20cd ../bx86/kernel/hrtimer.o
>
>> 73a6cd8 hrtimer: replace 'tab' with 'space' after comma ','
>> 04223a8 hrtimer: Coalesce format fragments in printk()
>> 52fac3f hrtimer: call hrtimer_set_expires_range() from hrtimer_set_expires_range_ns()
>> 535a552 hrtimer: use base->index instead of basenum in switch_hrtimer_base()
>    7989    408      0   8397   20cd ../bx86/kernel/hrtimer.o
>
>> f3a2cdd hrtimer: no need to rewrite '1' to hrtimer_hres_enabled
>    7974    408      0   8382   20be ../bx86/kernel/hrtimer.o
>
> This one actually made a smaller :)
>
>> 479d66f hrtimer: don't rewrite same value to expires_next in hrtimer_force_reprogram()
>    7990    408      0   8398   20ce ../bx86/kernel/hrtimer.o
>> 0e134df hrtimer: use base->hres_active directly instead of hrtimer_hres_active()
>    8006    408      0   8414   20de ../bx86/kernel/hrtimer.o
>
> So, reading from a per-cpu variable is efficient as compared to
> base->hres_active. In that case this patch can be dropped :)

Its a bit awkward now. When I keep this patch at this location
it exactly generates above numbers, i.e. 7990 -> 8006.

But if I revert this patch over top of all 30 commits I have, it
doesn't make a difference. Even applying it again over the
revert doesn't make a difference.

There are no other changes to the concerned routine,
retrigger_next_event() in my commits..
