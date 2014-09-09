Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757367AbaIIREI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Sep 2014 13:04:08 -0400
Received: from mx1.redhat.com ([209.132.183.28]:4609 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753909AbaIIREF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Sep 2014 13:04:05 -0400
Message-ID: <540F32BF.3000308@redhat.com>
Date: Tue, 09 Sep 2014 13:02:55 -0400
From: Jon Masters <jcm@redhat.com>
Organization: Red Hat, Inc.
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>,
        Hanjun Guo <hanjun.guo@linaro.org>
CC: Catalin Marinas <Catalin.Marinas@arm.com>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Mark Rutland <Mark.Rutland@arm.com>, Olof Johansson <olof@lixom.net>,
        "grant.likely@linaro.org" <grant.likely@linaro.org>,
        "graeme.gregory@linaro.org" <graeme.gregory@linaro.org>,
        Arnd Bergmann <arnd@arndb.de>, Sudeep Holla <Sudeep.Holla@arm.com>,
        Will Deacon <Will.Deacon@arm.com>, Jason Cooper <jason@lakedaemon.net>,
        Marc Zyngier <Marc.Zyngier@arm.com>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Mark Brown <broonie@kernel.org>, Rob Herring <robh@kernel.org>,
        Robert Richter <rric@kernel.org>, Lv Zheng <lv.zheng@intel.com>,
        Robert Moore <robert.moore@intel.com>,
        Liviu Dudau <Liviu.Dudau@arm.com>,
        Randy Dunlap <rdunlap@infradead.org>,
        Charles Garcia-Tobin <Charles.Garcia-Tobin@arm.com>,
        "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v3 09/17] ARM64 / ACPI: Parse MADT for SMP initialization
References: <1409583475-6978-1-git-send-email-hanjun.guo@linaro.org> <1409583475-6978-10-git-send-email-hanjun.guo@linaro.org> <20140903172138.GG1824@e102568-lin.cambridge.arm.com> <5408854B.9010703@linaro.org> <20140909165226.GD4948@e102568-lin.cambridge.arm.com>
In-Reply-To: <20140909165226.GD4948@e102568-lin.cambridge.arm.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/09/2014 12:52 PM, Lorenzo Pieralisi wrote:
> On Thu, Sep 04, 2014 at 04:29:15PM +0100, Hanjun Guo wrote:

>>>> +
>>>> +	/* Get cpu_ops include the boot CPU */
>>>> +	cpu_ops[cpu] = cpu_get_ops("psci");
>>>> +	if (!cpu_ops[cpu])
>>>> +		return -EINVAL;
>>>> +
>>>> +	/* CPU 0 was already initialized */
>>>> +	if (cpu) {
>>>> +		if (cpu_ops[cpu]->cpu_init(NULL, cpu))
>>>> +			return -EOPNOTSUPP;
>>>> +
>>>> +		/* map the logical cpu id to cpu MPIDR */
>>>> +		cpu_logical_map(cpu) = mpidr;
>>>> +
>>>> +		set_cpu_possible(cpu, true);
>>>> +	}
>>>> +
>>>> +	enabled_cpus++;
>>> See above to me enabled_cpus and (num_possible_cpus() - 1)  are identical.
>>
>> I think I need to remove all the CPU hotplug related code and make this function
>> as simple as possible and introduce them when needed.
> 
> Yes that makes sense, even though a bit of foresight is always appreciated;
> I certainly do not want you to completely rewrite this code to support CPU
> hotplug to be 100% clear. "Disabled" CPUs is a concept that is not
> managed at the moment with DT (on ARM and ARM64), and we need to introduce it
> properly. Again, I was asking questions, to understand why you would need
> those variables.
> 
> Have a look at this discussion:
> 
> https://lkml.org/lkml/2013/6/6/470

There could also be other reasons to disable "CPUs". For example, in an
SMT system configured not to use SMT threads, you might (in one
instantiation) decide to simply mark such GICCs as not enabled.

Jon.


