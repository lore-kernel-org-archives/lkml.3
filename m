Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753975AbaJWBnP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Oct 2014 21:43:15 -0400
Received: from mx1.redhat.com ([209.132.183.28]:53054 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750941AbaJWBnN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Oct 2014 21:43:13 -0400
Message-ID: <54485D03.9070107@redhat.com>
Date: Wed, 22 Oct 2014 21:42:27 -0400
From: Rik van Riel <riel@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.1.1
MIME-Version: 1.0
To: Mike Turquette <mturquette@linaro.org>
CC: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Preeti U Murthy <preeti@linux.vnet.ibm.com>,
        Morten Rasmussen <Morten.Rasmussen@arm.com>,
        kamalesh@linux.vnet.ibm.com, efault@gmx.de,
        Nicolas Pitre <nicolas.pitre@linaro.org>,
        "linaro-kernel@lists.linaro.org" <linaro-kernel@lists.linaro.org>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Dietmar Eggemann <dietmar.eggemann@arm.com>,
        Paul Turner <pjt@google.com>, Benjamin Segall <bsegall@google.com>,
        Vincent Guittot <vincent.guittot@linaro.org>,
        Patch Tracking <patches@linaro.org>,
        Tuukka Tikkanen <tuukka.tikkanen@linaro.org>,
        Amit Kucheria <amit.kucheria@linaro.org>
Subject: Re: [PATCH RFC 5/7] sched: cfs: cpu frequency scaling arch functions
References: <1413958051-7103-1-git-send-email-mturquette@linaro.org> <1413958051-7103-6-git-send-email-mturquette@linaro.org> <54480E58.5060600@redhat.com> <CAPtuhThe9dQkbwbXoCV0VpHohrC8UacPoL5vCn2uDqHcjbtKGA@mail.gmail.com>
In-Reply-To: <CAPtuhThe9dQkbwbXoCV0VpHohrC8UacPoL5vCn2uDqHcjbtKGA@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

On 10/22/2014 07:20 PM, Mike Turquette wrote:
> On Wed, Oct 22, 2014 at 1:06 PM, Rik van Riel <riel@redhat.com>
> wrote: On 10/22/2014 02:07 AM, Mike Turquette wrote:
>>>> arch_eval_cpu_freq and arch_scale_cpu_freq are added to allow
>>>> the scheduler to evaluate if cpu frequency should change and
>>>> to invoke that change from a safe context.
>>>> 
>>>> They are weakly defined arch functions that do nothing by
>>>> default. A CPUfreq governor could use these functions to
>>>> implement a frequency scaling policy based on updates to
>>>> per-task statistics or updates to per-cpu utilization.
>>>> 
>>>> As discussed at Linux Plumbers Conference 2014, the goal will
>>>> be to focus on a single cpu frequency scaling policy that
>>>> works for everyone. That may mean that the weak arch
>>>> functions definitions can be removed entirely and a single
>>>> policy implements that logic for all architectures.
> 
> On virtual machines, we probably want to use both frequency and 
> steal time to calculate the factor.
> 
>> You mean for calculating desired cpu frequency on a virtual
>> guest? Is that something we want to do?

A guest will be unable to set the cpu frequency, but it should
know what the frequency is, so it can take the capacity of each
CPU into account when doing things like load balancing.

This has little impact on this patch series, the impact is more
in the load balancer, which can see how much compute capacity is
available on each CPU, and adjust the load accordingly.

I have seen some code come by that adjusts each cpu's compute_capacity,
but do not remember whether it looks at cpu frequency, and am pretty
sure it does not look at steal time currently :)

- -- 
All rights reversed
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQEcBAEBAgAGBQJUSF0DAAoJEM553pKExN6DYgkIALSZxKxQhMAJl0VUrBtPEFlr
cXOr0jKS/0FowS22agzpJr/OoWi58mGGm6mKr6LkoZJ34K96Y6/H4ie7Sr7Q4BL/
A4hQpTwxHzGasawQwdQOG/lW2q2oDUqsQuxRQDOs97I4vtYwxsj+D3qDtfIyaosf
f7ctWDQMzBBgLlrDn1wWmDE6K1pxa2eqnf0rRVSRNRXQ/lncHHzPdFOj4sJE9RVQ
E47gqeisDf+m7TyvG1I9MN6ZIHMEfgaQcmVvO8/QGqnb1ZMom6JTCDa4UqAd97XB
1NQ/QSJvQ5ED/cCfLy91YguEr/GY+QFsKeCjL1604e+3lsN4DjuejtcUP9/LQVs=
=On7B
-----END PGP SIGNATURE-----
