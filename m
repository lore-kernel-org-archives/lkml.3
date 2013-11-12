Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752701Ab3KLLFt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Nov 2013 06:05:49 -0500
Received: from mail-ob0-f181.google.com ([209.85.214.181]:41253 "EHLO
	mail-ob0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751214Ab3KLLFq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Nov 2013 06:05:46 -0500
MIME-Version: 1.0
In-Reply-To: <20131112103440.GF4971@laptop.programming.kicks-ass.net>
References: <1382097147-30088-1-git-send-email-vincent.guittot@linaro.org>
	<1382097147-30088-6-git-send-email-vincent.guittot@linaro.org>
	<20131112103440.GF4971@laptop.programming.kicks-ass.net>
Date: Tue, 12 Nov 2013 12:05:45 +0100
Message-ID: <CAKfTPtBToS=_6p-005LkHzmdkspKQj9Y4_LfEmV2SLFu88w8-w@mail.gmail.com>
Subject: Re: [RFC][PATCH v5 06/14] sched: create a new field with available capacity
From: Vincent Guittot <vincent.guittot@linaro.org>
To: Peter Zijlstra <peterz@infradead.org>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@kernel.org>, Paul Turner <pjt@google.com>,
        Morten Rasmussen <Morten.Rasmussen@arm.com>,
        "cmetcalf@tilera.com" <cmetcalf@tilera.com>,
        "tony.luck@intel.com" <tony.luck@intel.com>,
        Alex Shi <alex.shi@intel.com>,
        Preeti U Murthy <preeti@linux.vnet.ibm.com>,
        "linaro-kernel@lists.linaro.org" <linaro-kernel@lists.linaro.org>,
        "Rafael J. Wysocki" <rjw@sisk.pl>,
        Paul McKenney <paulmck@linux.vnet.ibm.com>,
        Jonathan Corbet <corbet@lwn.net>, Thomas Gleixner <tglx@linutronix.de>,
        Len Brown <len.brown@intel.com>,
        Arjan van de Ven <arjan@linux.intel.com>,
        Amit Kucheria <amit.kucheria@linaro.org>,
        Lukasz Majewski <l.majewski@samsung.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12 November 2013 11:34, Peter Zijlstra <peterz@infradead.org> wrote:
> On Fri, Oct 18, 2013 at 01:52:19PM +0200, Vincent Guittot wrote:
>> This new field power_available reflects the available capacity of a CPU
>> unlike the cpu_power which reflects the current capacity.
>
>> -     sdg->sgp->power_orig = sdg->sgp->power = power;
>> +     sdg->sgp->power_orig = sdg->sgp->power_available = available;
>> +     sdg->sgp->power = power;
>
> This patch leaves me confused as to power_available vs power_orig and
> the Changelog doesn't really clarify anything much at all.

Ok, i will add more details in the changelog
power_ori can only modified for SMT purpose otherwise it stays to 1024
whereas power_available take into account the modification that has
been done by the platform.

I can probably re-factor that and merge power_ori and power_available.
At now,  arch_scale_smt_power and arch_scale_freq_power are not used
simultaneously by an architecture so I can probably move the returned
value of arch_scale_freq_power into the power_ori. This would even
make more sense regarding the current use of it.
