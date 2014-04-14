Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753773AbaDNH3Z (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Apr 2014 03:29:25 -0400
Received: from mail-ob0-f178.google.com ([209.85.214.178]:57448 "EHLO
	mail-ob0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752298AbaDNH3Y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Apr 2014 03:29:24 -0400
MIME-Version: 1.0
In-Reply-To: <534937F0.3020702@arm.com>
References: <1397209481-28542-1-git-send-email-vincent.guittot@linaro.org> <534937F0.3020702@arm.com>
From: Vincent Guittot <vincent.guittot@linaro.org>
Date: Mon, 14 Apr 2014 09:29:02 +0200
Message-ID: <CAKfTPtC02QMyA55zVr_MmVMi8h7UzB5SDmZvU2GUNx-VXj+hkg@mail.gmail.com>
Subject: Re: [PATCH v4 0/5] rework sched_domain topology description
To: Dietmar Eggemann <dietmar.eggemann@arm.com>
Cc: "peterz@infradead.org" <peterz@infradead.org>,
        "mingo@kernel.org" <mingo@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "tony.luck@intel.com" <tony.luck@intel.com>,
        "fenghua.yu@intel.com" <fenghua.yu@intel.com>,
        "schwidefsky@de.ibm.com" <schwidefsky@de.ibm.com>,
        "cmetcalf@tilera.com" <cmetcalf@tilera.com>,
        "benh@kernel.crashing.org" <benh@kernel.crashing.org>,
        "linux@arm.linux.org.uk" <linux@arm.linux.org.uk>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "preeti@linux.vnet.ibm.com" <preeti@linux.vnet.ibm.com>,
        "linaro-kernel@lists.linaro.org" <linaro-kernel@lists.linaro.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12 April 2014 14:56, Dietmar Eggemann <dietmar.eggemann@arm.com> wrote:
> On 11/04/14 10:44, Vincent Guittot wrote:
>>
>> This patchset was previously part of the larger tasks packing patchset
>> [1].
>> I have splitted the latter in 3 different patchsets (at least) to make the
>> thing easier.
>> -configuration of sched_domain topology (this patchset)
>> -update and consolidation of cpu_power
>> -tasks packing algorithm
>>
>> Based on Peter Z's proposal [2][3], this patchset modifies the way to
>> configure
>> the sched_domain level in order to let architectures to add specific level
>> like
>> the current BOOK level or the proposed power gating level for ARM
>> architecture.
>>
>> [1] https://lkml.org/lkml/2013/10/18/121
>> [2] https://lkml.org/lkml/2013/11/5/239
>> [3] https://lkml.org/lkml/2013/11/5/449
>
>
> Hi Vincent,
>
> given the discussion we had for v1-v3 and a short boot test of v4:
>
> For patch 1/5, 4/5, 5/5 on ARM TC2 (heterogeneous dual socket w/o SMT
> machine):
>
> Reviewed-by: Dietmar Eggemann <dietmar.eggemann@arm.com>
> Tested-by: Dietmar Eggemann <dietmar.eggemann@arm.com>
>

Thanks

> Cheers,
>
> -- Dietmar
>
>
>>
>> Change since v3:
>> - remove last patch which was adding SD_SHARE_POWER_DOMAIN for powerpc's
>> SMT
>>    level
>>
>> Change since v2:
>> - remove patch 1 as it has been already applied to metag tree for v3.15
>> - updates some commit messages
>> - add new flag description in TOPOLOGY_SD_FLAGS description
>>
>> Change since v1:
>> - move sched_domains_curr_level back under #ifdef CONFIG_NUMA
>> - use function pointer to set flag instead of a plain value.
>> - add list of tunable flags in the commit message of patch 2
>> - add SD_SHARE_POWER_DOMAIN flag for powerpc's SMT level
>>
>> Vincent Guittot (5):
>>    sched: rework of sched_domain topology definition
>>    sched: s390: create a dedicated topology table
>>    sched: powerpc: create a dedicated topology table
>>    sched: add a new SD_SHARE_POWERDOMAIN for sched_domain
>>    sched: ARM: create a dedicated scheduler topology table
>>
>>   arch/arm/kernel/topology.c       |  26 +++++
>>   arch/ia64/include/asm/topology.h |  24 ----
>>   arch/powerpc/kernel/smp.c        |  31 +++--
>>   arch/s390/include/asm/topology.h |  13 +--
>>   arch/s390/kernel/topology.c      |  20 ++++
>>   arch/tile/include/asm/topology.h |  33 ------
>>   include/linux/sched.h            |  49 +++++++-
>>   include/linux/topology.h         | 128 +++-----------------
>>   kernel/sched/core.c              | 244
>> ++++++++++++++++++++-------------------
>>   9 files changed, 255 insertions(+), 313 deletions(-)
>>
>
>
