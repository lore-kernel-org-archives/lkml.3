Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933587AbaJVXUs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Oct 2014 19:20:48 -0400
Received: from mail-wg0-f48.google.com ([74.125.82.48]:51310 "EHLO
	mail-wg0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933335AbaJVXUo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Oct 2014 19:20:44 -0400
MIME-Version: 1.0
In-Reply-To: <54480E58.5060600@redhat.com>
References: <1413958051-7103-1-git-send-email-mturquette@linaro.org>
 <1413958051-7103-6-git-send-email-mturquette@linaro.org> <54480E58.5060600@redhat.com>
From: Mike Turquette <mturquette@linaro.org>
Date: Wed, 22 Oct 2014 16:20:22 -0700
Message-ID: <CAPtuhThe9dQkbwbXoCV0VpHohrC8UacPoL5vCn2uDqHcjbtKGA@mail.gmail.com>
Subject: Re: [PATCH RFC 5/7] sched: cfs: cpu frequency scaling arch functions
To: Rik van Riel <riel@redhat.com>
Cc: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@kernel.org>,
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
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 22, 2014 at 1:06 PM, Rik van Riel <riel@redhat.com> wrote:
> -----BEGIN PGP SIGNED MESSAGE-----
> Hash: SHA1
>
> On 10/22/2014 02:07 AM, Mike Turquette wrote:
>> arch_eval_cpu_freq and arch_scale_cpu_freq are added to allow the
>> scheduler to evaluate if cpu frequency should change and to invoke
>> that change from a safe context.
>>
>> They are weakly defined arch functions that do nothing by default.
>> A CPUfreq governor could use these functions to implement a
>> frequency scaling policy based on updates to per-task statistics or
>> updates to per-cpu utilization.
>>
>> As discussed at Linux Plumbers Conference 2014, the goal will be
>> to focus on a single cpu frequency scaling policy that works for
>> everyone. That may mean that the weak arch functions definitions
>> can be removed entirely and a single policy implements that logic
>> for all architectures.
>
> On virtual machines, we probably want to use both frequency and
> steal time to calculate the factor.

You mean for calculating desired cpu frequency on a virtual guest? Is
that something we want to do?

Thanks,
Mike

>
> - --
> All rights reversed
> -----BEGIN PGP SIGNATURE-----
> Version: GnuPG v1
>
> iQEcBAEBAgAGBQJUSA5XAAoJEM553pKExN6DeRYH/jeXImjO2/WZFp82Yv6ukMxI
> r8/kzrLMA+NS1XXCWYIcOiBqReEabkZZmypt21Tdnpkvi4GbZPpG0PEApSvOfqWE
> w71J87cpMGV/e4uLcBDcvgHJX8RBQLO/ZqDcMm+zcSoeJ3G3NMK2YlZp3Uf8xqcB
> tE2VGW7o2yEqNJL1fqYb++3upQmc10vIFqxVIJfP+TqZRyaVP+5kBqOMDTWb5qCV
> qZjBKe1jDX5sLLGfY0ddAeuUH1iEJBIUMCcr027ezcqRp4YoqIrHRInHmNxEs5Az
> 9PN8N0yGgqhvkcCfXG7He+tQBHECOnjyQlrM/2K8Cw11RziwDkC/yYIp3DPgjxc=
> =f/8V
> -----END PGP SIGNATURE-----
