Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754297AbaFCNWg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jun 2014 09:22:36 -0400
Received: from fw-tnat.austin.arm.com ([217.140.110.23]:43525 "EHLO
	collaborate-mta1.arm.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753881AbaFCNWX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jun 2014 09:22:23 -0400
Date: Tue, 3 Jun 2014 14:22:18 +0100
From: Morten Rasmussen <morten.rasmussen@arm.com>
To: Vincent Guittot <vincent.guittot@linaro.org>
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
Subject: Re: [PATCH v2 04/11] sched: Allow all archs to set the power_orig
Message-ID: <20140603132217.GD29593@e103034-lin>
References: <1400860385-14555-1-git-send-email-vincent.guittot@linaro.org>
 <1400860385-14555-5-git-send-email-vincent.guittot@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1400860385-14555-5-git-send-email-vincent.guittot@linaro.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 23, 2014 at 04:52:58PM +0100, Vincent Guittot wrote:
> power_orig is only changed for system with a SMT sched_domain level in order to
> reflect the lower capacity of CPUs. Heterogenous system also have to reflect an
> original capacity that is different from the default value.
> 
> Create a more generic function arch_scale_cpu_power that can be also used by
> non SMT platform to set power_orig.

I did a quick test of the patch set with adjusting cpu_power on
big.LITTLE (ARM TC2) to reflect the different compute capacities of the
A15s and A7s. I ran the sysbench cpu benchmark with 5 threads with and
without the patches applied, but with non-default cpu_powers.

I didn't see any difference in the load-balance. Three tasks ended up on
the two A15s and two tasks ended up on two of the three A7s leaving one
unused in both cases.

Using default cpu_power I get one task on each of the five cpus (best
throughput). Unless I messed something up, it seems that setting
cpu_power doesn't give me the best throughput with these patches
applied.

Have you done any tests on big.LITTLE?

Morten
