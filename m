Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758339Ab3HMPj7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Aug 2013 11:39:59 -0400
Received: from service87.mimecast.com ([91.220.42.44]:33018 "EHLO
	service87.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758298Ab3HMPjy convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Aug 2013 11:39:54 -0400
Message-ID: <520A536C.3030600@arm.com>
Date: Tue, 13 Aug 2013 16:40:28 +0100
From: Sudeep KarkadaNagesha <Sudeep.KarkadaNagesha@arm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130803 Thunderbird/17.0.8
MIME-Version: 1.0
To: "Rafael J. Wysocki" <rjw@sisk.pl>,
        "rob.herring@calxeda.com" <rob.herring@calxeda.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        linuxppc-dev@lists.ozlabs.org
CC: Sudeep KarkadaNagesha <Sudeep.KarkadaNagesha@arm.com>,
        Viresh Kumar <viresh.kumar@linaro.org>,
        Olof Johansson <olof@lixom.net>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>
Subject: Re: [GIT PULL] DT/core: cpu_ofnode updates for v3.12
References: <5208E2D3.7060005@arm.com> <3356439.a21MloFP7n@vostro.rjw.lan>
In-Reply-To: <3356439.a21MloFP7n@vostro.rjw.lan>
X-OriginalArrivalTime: 13 Aug 2013 15:39:50.0470 (UTC) FILETIME=[590ADE60:01CE983B]
X-MC-Unique: 113081316395200301
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Adding PowerPC list

On 13/08/13 14:00, Rafael J. Wysocki wrote:
> On Monday, August 12, 2013 02:27:47 PM Sudeep KarkadaNagesha wrote:
>> The following changes since commit
>> d4e4ab86bcba5a72779c43dc1459f71fea3d89c8:
>> 
>> Linux 3.11-rc5 (2013-08-11 18:04:20 -0700)
>> 
>> are available in the git repository at:
>> 
>> git://linux-arm.org/linux-skn.git cpu_of_node
>> 
>> for you to fetch changes up to
>> 9e9e26dde91f22635c87d0e45f3938b5ded96f0d:
>> 
>> cpufreq: pmac32-cpufreq: remove device tree parsing for cpu nodes 
>> (2013-08-12 10:22:29 +0100)
>> 
>> ---------------------------------------------------------------- 
>> Sudeep KarkadaNagesha (16): of: add support for retrieving cpu node
>> for a given logical cpu index ARM: DT/kernel: define ARM specific
>> arch_match_cpu_phys_id driver/core: cpu: initialize of_node in
>> cpu's device struture of/device: add helper to get cpu device node
>> from logical cpu index ARM: topology: remove hwid/MPIDR dependency
>> from cpu_capacity ARM: mvebu: remove device tree parsing for cpu
>> nodes drivers/bus: arm-cci: avoid parsing DT for cpu device nodes 
>> cpufreq: imx6q-cpufreq: remove device tree parsing for cpu nodes 
>> cpufreq: cpufreq-cpu0: remove device tree parsing for cpu nodes 
>> cpufreq: highbank-cpufreq: remove device tree parsing for cpu
>> nodes cpufreq: spear-cpufreq: remove device tree parsing for cpu
>> nodes cpufreq: kirkwood-cpufreq: remove device tree parsing for cpu
>> nodes cpufreq: arm_big_little: remove device tree parsing for cpu
>> nodes cpufreq: maple-cpufreq: remove device tree parsing for cpu
>> nodes cpufreq: pmac64-cpufreq: remove device tree parsing for cpu
>> nodes cpufreq: pmac32-cpufreq: remove device tree parsing for cpu
>> nodes
>> 
>> arch/arm/kernel/devtree.c           |  5 +++++ 
>> arch/arm/kernel/topology.c          | 61 
>> +++++++++++++++++++------------------------------------------ 
>> arch/arm/mach-imx/mach-imx6q.c      |  3 +-- 
>> arch/arm/mach-mvebu/platsmp.c       | 52 
>> ++++++++++++++++++++++++---------------------------- 
>> drivers/base/cpu.c                  |  2 ++ drivers/bus/arm-cci.c
>> | 28 +++++++--------------------- 
>> drivers/cpufreq/arm_big_little_dt.c | 40 
>> ++++++++++++++-------------------------- 
>> drivers/cpufreq/cpufreq-cpu0.c      | 23 ++++------------------- 
>> drivers/cpufreq/highbank-cpufreq.c  | 18 ++++++------------ 
>> drivers/cpufreq/imx6q-cpufreq.c     |  4 +--- 
>> drivers/cpufreq/kirkwood-cpufreq.c  |  8 +++++--- 
>> drivers/cpufreq/maple-cpufreq.c     | 23 +++-------------------- 
>> drivers/cpufreq/pmac32-cpufreq.c    |  5 +++-- 
>> drivers/cpufreq/pmac64-cpufreq.c    | 47 
>> +++++++++++------------------------------------ 
>> drivers/cpufreq/spear-cpufreq.c     |  4 ++-- drivers/of/base.c
>> | 73 
>> +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
>>
>> 
include/linux/cpu.h                 |  1 +
>> include/linux/of.h                  |  6 ++++++ 
>> include/linux/of_device.h           | 15 +++++++++++++++ 19 files
>> changed, 202 insertions(+), 216 deletions(-)
>> 
>> 
>> PS: This patch series is reviewed and acknowledged @
>> 
>> v1: https://lkml.org/lkml/2013/7/15/128 v2:
>> https://lkml.org/lkml/2013/7/17/341 v3:
>> https://lkml.org/lkml/2013/7/22/219
> 
> Pulled, thanks!
> 
Hi Rob, Rafael,

On 13/08/13 15:16, kbuild test robot wrote:> tree:
git://git.kernel.org/pub/scm/linux/kernel/git/rafael/linux-pm.git
bleeding-edge
> head:   0d4bcb5dc7d3040c0ce7572ea30ab9e5d9455bfa commit:
> 7939ff8d991de2c0b15064e76ee549a6df5ae67f [151/204] of: add
> support for retrieving cpu node for a given logical cpu index
> config: make ARCH=powerpc allmodconfig
> 
> All error/warnings:
> 
> warning: (MPC836x_RDK && MTD_NAND_FSL_ELBC && MTD_NAND_FSL_UPM)
> selects FSL_LBC which has unmet direct dependencies (FSL_SOC)
> warning: (MPC836x_RDK && MTD_NAND_FSL_ELBC && MTD_NAND_FSL_UPM)
> selects FSL_LBC which has unmet direct dependencies (FSL_SOC)
> In file included from arch/powerpc/include/asm/kvm_para.h:26:0, from
> include/uapi/linux/kvm_para.h:26, from include/linux/kvm_para.h:4, 
> from include/linux/kvm_host.h:30, from
> arch/powerpc/kernel/asm-offsets.c:53:
> include/linux/of.h:269:28: error: conflicting types for
>'of_get_cpu_node'
> extern struct device_node *of_get_cpu_node(int cpu); ^ In file
> included from include/linux/of.h:139:0, from
> arch/powerpc/include/asm/kvm_para.h:26, from
> include/uapi/linux/kvm_para.h:26, from include/linux/kvm_para.h:4, 
> from include/linux/kvm_host.h:30, from
> arch/powerpc/kernel/asm-offsets.c:53: 
> arch/powerpc/include/asm/prom.h:47:21: note: previous declaration
> of 'of_get_cpu_node' was here
> struct device_node *of_get_cpu_node(int cpu, unsigned int *thread); 
> ^ make[2]: *** [arch/powerpc/kernel/asm-offsets.s] Error 1 make[2]:
> Target `__build' not remade because of errors. make[1]: ***
> [prepare0] Error 2 make[1]: Target `prepare' not remade because of
> errors. make: *** [sub-make] Error 2
> 

There seems to be conflict in the new function "of_get_cpu_node" added.
PowerPC also defines the same function name. Further microblaze and
openrisc declares it(can be removed) but doesn't define it.
To fix this:
1. I can rename the newly added function to something different like
   `of_get_cpunode` or
2. If of_* namespace should be used by only OF/FDT and not by any
   architecture specific code, then the arch specific version can be
   renamed to some thing like arch_of_get_cpu_node.
   Also most of the calls to arch specific function can be moved to
   generic code.

Let me know your thoughts.

Regards,
Sudeep

