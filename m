Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933211AbaE3OEd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 May 2014 10:04:33 -0400
Received: from service87.mimecast.com ([91.220.42.44]:50085 "EHLO
	service87.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751529AbaE3OEc convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 May 2014 10:04:32 -0400
Message-ID: <53888FF0.4020403@arm.com>
Date: Fri, 30 May 2014 15:04:32 +0100
From: Dietmar Eggemann <dietmar.eggemann@arm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Vincent Guittot <vincent.guittot@linaro.org>,
        "peterz@infradead.org" <peterz@infradead.org>,
        "mingo@kernel.org" <mingo@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux@arm.linux.org.uk" <linux@arm.linux.org.uk>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
CC: "preeti@linux.vnet.ibm.com" <preeti@linux.vnet.ibm.com>,
        Morten Rasmussen <Morten.Rasmussen@arm.com>,
        "efault@gmx.de" <efault@gmx.de>,
        "nicolas.pitre@linaro.org" <nicolas.pitre@linaro.org>,
        "linaro-kernel@lists.linaro.org" <linaro-kernel@lists.linaro.org>,
        "daniel.lezcano@linaro.org" <daniel.lezcano@linaro.org>
Subject: Re: [PATCH v2 04/11] sched: Allow all archs to set the power_orig
References: <1400860385-14555-1-git-send-email-vincent.guittot@linaro.org> <1400860385-14555-5-git-send-email-vincent.guittot@linaro.org>
In-Reply-To: <1400860385-14555-5-git-send-email-vincent.guittot@linaro.org>
X-OriginalArrivalTime: 30 May 2014 14:04:27.0648 (UTC) FILETIME=[11C50800:01CF7C10]
X-MC-Unique: 114053015043010801
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 23/05/14 16:52, Vincent Guittot wrote:
> power_orig is only changed for system with a SMT sched_domain level in order to
> reflect the lower capacity of CPUs. Heterogenous system also have to reflect an
> original capacity that is different from the default value.
> 
> Create a more generic function arch_scale_cpu_power that can be also used by
> non SMT platform to set power_orig.
> 
> The weak behavior of arch_scale_cpu_power is the previous SMT one in order to
> keep backward compatibility in the use of power_orig.
> 
> Signed-off-by: Vincent Guittot <vincent.guittot@linaro.org>

As you know, besides uarch scaled cpu power for HMP, freq scaled cpu
power is important for energy-aware scheduling to achieve freq scale
invariance for task load.

I know that your patch-set is not about introducing freq scaled cpu
power, but we were discussing how this can be achieved w/ your patch-set
in place, so maybe you can share your opinion regarding the easiest way
to achieve freq scale invariance with us?

(1) We assume that the current way (update_cpu_power() calls
arch_scale_freq_power() to get the avg power(freq) over the time period
since the last call to arch_scale_freq_power()) is suitable
for us. Do you have another opinion here?

(2) Is the current layout of update_cpu_power() adequate for this, where
we scale power_orig related to freq and then related to rt/(irq):

  power_orig = scale_cpu(SCHED_POWER_SCALE)
  power = scale_rt(scale_freq(power_orig))

or do we need an extra power_freq data member on the rq and do:

  power_orig = scale_cpu(SCHED_POWER_SCALE)
  power_freq = scale_freq(power_orig))
  power = scale_rt(power_orig))

In other words, do we consider rt/(irq) pressure when calculating freq
scale invariant task load or not?

Thanks,

-- Dietmar
[...]

