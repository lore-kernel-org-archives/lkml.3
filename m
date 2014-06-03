Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932559AbaFCOCl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jun 2014 10:02:41 -0400
Received: from mail-ob0-f177.google.com ([209.85.214.177]:33916 "EHLO
	mail-ob0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754425AbaFCOCj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jun 2014 10:02:39 -0400
MIME-Version: 1.0
In-Reply-To: <20140603132217.GD29593@e103034-lin>
References: <1400860385-14555-1-git-send-email-vincent.guittot@linaro.org>
 <1400860385-14555-5-git-send-email-vincent.guittot@linaro.org> <20140603132217.GD29593@e103034-lin>
From: Vincent Guittot <vincent.guittot@linaro.org>
Date: Tue, 3 Jun 2014 16:02:18 +0200
Message-ID: <CAKfTPtB2XC3hVN4LuRjvd3JB5GZ9=R5Tq6F52iYxO3nCJ04Cew@mail.gmail.com>
Subject: Re: [PATCH v2 04/11] sched: Allow all archs to set the power_orig
To: Morten Rasmussen <morten.rasmussen@arm.com>
Cc: "peterz@infradead.org" <peterz@infradead.org>,
        "mingo@kernel.org" <mingo@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux@arm.linux.org.uk" <linux@arm.linux.org.uk>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "preeti@linux.vnet.ibm.com" <preeti@linux.vnet.ibm.com>,
        "efault@gmx.de" <efault@gmx.de>,
        "nicolas.pitre@linaro.org" <nicolas.pitre@linaro.org>,
        "linaro-kernel@lists.linaro.org" <linaro-kernel@lists.linaro.org>,
        "daniel.lezcano@linaro.org" <daniel.lezcano@linaro.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 3 June 2014 15:22, Morten Rasmussen <morten.rasmussen@arm.com> wrote:
> On Fri, May 23, 2014 at 04:52:58PM +0100, Vincent Guittot wrote:
>> power_orig is only changed for system with a SMT sched_domain level in order to
>> reflect the lower capacity of CPUs. Heterogenous system also have to reflect an
>> original capacity that is different from the default value.
>>
>> Create a more generic function arch_scale_cpu_power that can be also used by
>> non SMT platform to set power_orig.
>
> I did a quick test of the patch set with adjusting cpu_power on
> big.LITTLE (ARM TC2) to reflect the different compute capacities of the
> A15s and A7s. I ran the sysbench cpu benchmark with 5 threads with and
> without the patches applied, but with non-default cpu_powers.
>
> I didn't see any difference in the load-balance. Three tasks ended up on
> the two A15s and two tasks ended up on two of the three A7s leaving one
> unused in both cases.
>
> Using default cpu_power I get one task on each of the five cpus (best
> throughput). Unless I messed something up, it seems that setting
> cpu_power doesn't give me the best throughput with these patches
> applied.

That's normal this patchset is necessary but not enough to solve the
issue you mention. We also need to fix the way the imbalance is
calculated for such situation. I have planned to push that in another
patchset in order to not mix too much thing together

Vincent

>
> Have you done any tests on big.LITTLE?
>
> Morten
