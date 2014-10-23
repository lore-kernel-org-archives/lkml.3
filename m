Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932814AbaJWCnj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Oct 2014 22:43:39 -0400
Received: from mx1.redhat.com ([209.132.183.28]:8761 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932353AbaJWCni (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Oct 2014 22:43:38 -0400
Message-ID: <54486B26.30703@redhat.com>
Date: Wed, 22 Oct 2014 22:42:46 -0400
From: Rik van Riel <riel@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.1.1
MIME-Version: 1.0
To: Mike Galbraith <efault@gmx.de>
CC: Mike Turquette <mturquette@linaro.org>,
        Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Preeti U Murthy <preeti@linux.vnet.ibm.com>,
        Morten Rasmussen <Morten.Rasmussen@arm.com>,
        kamalesh@linux.vnet.ibm.com, Nicolas Pitre <nicolas.pitre@linaro.org>,
        "linaro-kernel@lists.linaro.org" <linaro-kernel@lists.linaro.org>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Dietmar Eggemann <dietmar.eggemann@arm.com>,
        Paul Turner <pjt@google.com>, Benjamin Segall <bsegall@google.com>,
        Vincent Guittot <vincent.guittot@linaro.org>,
        Patch Tracking <patches@linaro.org>,
        Tuukka Tikkanen <tuukka.tikkanen@linaro.org>,
        Amit Kucheria <amit.kucheria@linaro.org>
Subject: Re: [PATCH RFC 5/7] sched: cfs: cpu frequency scaling arch functions
References: <1413958051-7103-1-git-send-email-mturquette@linaro.org>	 <1413958051-7103-6-git-send-email-mturquette@linaro.org>	 <54480E58.5060600@redhat.com>	 <CAPtuhThe9dQkbwbXoCV0VpHohrC8UacPoL5vCn2uDqHcjbtKGA@mail.gmail.com>	 <54485D03.9070107@redhat.com> <1414030360.5228.12.camel@marge.simpson.net>
In-Reply-To: <1414030360.5228.12.camel@marge.simpson.net>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

On 10/22/2014 10:12 PM, Mike Galbraith wrote:
> On Wed, 2014-10-22 at 21:42 -0400, Rik van Riel wrote:
>> On 10/22/2014 07:20 PM, Mike Turquette wrote:
>>> On Wed, Oct 22, 2014 at 1:06 PM, Rik van Riel
>>> <riel@redhat.com> wrote: On 10/22/2014 02:07 AM, Mike Turquette
>>> wrote:
>>>>>> arch_eval_cpu_freq and arch_scale_cpu_freq are added to
>>>>>> allow the scheduler to evaluate if cpu frequency should
>>>>>> change and to invoke that change from a safe context.
>>>>>> 
>>>>>> They are weakly defined arch functions that do nothing
>>>>>> by default. A CPUfreq governor could use these functions
>>>>>> to implement a frequency scaling policy based on updates
>>>>>> to per-task statistics or updates to per-cpu
>>>>>> utilization.
>>>>>> 
>>>>>> As discussed at Linux Plumbers Conference 2014, the goal
>>>>>> will be to focus on a single cpu frequency scaling policy
>>>>>> that works for everyone. That may mean that the weak
>>>>>> arch functions definitions can be removed entirely and a
>>>>>> single policy implements that logic for all
>>>>>> architectures.
>>> 
>>> On virtual machines, we probably want to use both frequency and
>>>  steal time to calculate the factor.
>>> 
>>>> You mean for calculating desired cpu frequency on a virtual 
>>>> guest? Is that something we want to do?
>> 
>> A guest will be unable to set the cpu frequency, but it should 
>> know what the frequency is, so it can take the capacity of each 
>> CPU into account when doing things like load balancing.
> 
> Hm.  Why does using vaporite freq/capacity/whatever make any sense,
> the silicon under the V(aporite)PU can/does change at the drop of a
> hat, no?

It can, but IIRC that should cause the kvmclock data for that VCPU
to be regenerated, and the VCPU should be able to use that to figure
out that the frequency changed the next time it runs the scheduler
code on that VCPU.

- -- 
All rights reversed
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQEcBAEBAgAGBQJUSGsmAAoJEM553pKExN6DlhUH/RLmVoHmab2zfPgZfRXWD9PX
yKkx1tmoNPFAdp7l1xgz+fIVtp5I7gUnCo03r0x3JDL8dYiEfU1BfX1bs2WSresL
7q50DVLQe8VXIqgmu1INqzQSJGfF9yOW4Kgg2xHkNBoWUdt+3fjF9JSEMJFxOZOs
pFT85ITTs0zFIRDlwdEBEs0kRLEqh0JBeLx501RSC9VQ9OIZ3lp9O1BnawQ8WI0o
Qq8ODXFgy1BGUE+Ow+skP8MnQUyBgb6b+f0Q6AmK/Er6lzw8PMwNvnmYN14ruR3R
YkTjsyYxlYlzrx2IKZNWuYy5OXguRIslWi67fI0k/yE2WVHy/yXPbRErYQfM2o8=
=PeDr
-----END PGP SIGNATURE-----
