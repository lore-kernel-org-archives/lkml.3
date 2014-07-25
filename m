Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760185AbaGYKda (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jul 2014 06:33:30 -0400
Received: from mail-pd0-f174.google.com ([209.85.192.174]:65115 "EHLO
	mail-pd0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751318AbaGYKd0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jul 2014 06:33:26 -0400
Message-ID: <53D2322E.9010802@linaro.org>
Date: Fri, 25 Jul 2014 18:32:14 +0800
From: Hanjun Guo <hanjun.guo@linaro.org>
User-Agent: Mozilla/5.0 (Windows NT 5.1; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Mark Brown <broonie@kernel.org>
CC: Catalin Marinas <catalin.marinas@arm.com>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Mark Rutland <mark.rutland@arm.com>,
        Graeme Gregory <graeme.gregory@linaro.org>,
        Arnd Bergmann <arnd@arndb.de>, Grant Likely <grant.likely@linaro.org>,
        Sudeep Holla <Sudeep.Holla@arm.com>, Will Deacon <will.deacon@arm.com>,
        Jason Cooper <jason@lakedaemon.net>,
        Marc Zyngier <marc.zyngier@arm.com>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Robert Richter <rric@kernel.org>, Lv Zheng <lv.zheng@intel.com>,
        Robert Moore <robert.moore@intel.com>,
        Lorenzo Pieralisi <Lorenzo.Pieralisi@arm.com>,
        Liviu Dudau <Liviu.Dudau@arm.com>,
        Randy Dunlap <rdunlap@infradead.org>, Charles.Garcia-Tobin@arm.com,
        linux-acpi@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, linaro-acpi-private@linaro.org
Subject: Re: [PATCH 04/19] ARM64 / ACPI: Introduce arch_fix_phys_package_id()
 for cpu topology
References: <1406206825-15590-1-git-send-email-hanjun.guo@linaro.org> <1406206825-15590-5-git-send-email-hanjun.guo@linaro.org> <20140724144327.GJ17528@sirena.org.uk>
In-Reply-To: <20140724144327.GJ17528@sirena.org.uk>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2014-7-24 22:43, Mark Brown wrote:
> On Thu, Jul 24, 2014 at 09:00:10PM +0800, Hanjun Guo wrote:
> 
>> +/*
>> + * Use the CPU slot number provided by ACPI to update the physical
>> + * package id when cpuid_topo->cluster_id is not available, then we
>> + * can get the right value in the "physical id" field of /proc/cpuinfo.
>> + */
>> +void arch_fix_phys_package_id(int num, u32 slot)
>> +{
>> +	struct cpu_topology *cpuid_topo = &cpu_topology[num];
>> +
>> +	if (cpuid_topo->cluster_id == -1)
>> +		cpuid_topo->cluster_id = slot;
>> +}
>> +EXPORT_SYMBOL_GPL(arch_fix_phys_package_id);
> 
> As I said on the previous version of this patch are you sure this runs
> at a point between the cluster ID getting initialized to -1 and the slot
> being initialized (bear in mind that we now use MPIDR information if
> availabe).  I don't understand why we don't just unconditionally use the
> value given.

Ah, sorry, it should be unconditionally used as you said, and I remember
the comments in last version, but the patch shows not, must be something
wrong, will update it in next version.

Thanks
Hanjun

