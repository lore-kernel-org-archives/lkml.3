Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758160Ab3HMSo1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Aug 2013 14:44:27 -0400
Received: from mail-qe0-f51.google.com ([209.85.128.51]:49074 "EHLO
	mail-qe0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756803Ab3HMSoY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Aug 2013 14:44:24 -0400
MIME-Version: 1.0
In-Reply-To: <520A536C.3030600@arm.com>
References: <5208E2D3.7060005@arm.com>
	<3356439.a21MloFP7n@vostro.rjw.lan>
	<520A536C.3030600@arm.com>
Date: Tue, 13 Aug 2013 13:44:23 -0500
Message-ID: <CAL_JsqJdGXuTmb2kgBwgmRYGs9f92-dsawDXSXjmJW8cwjFVQQ@mail.gmail.com>
Subject: Re: [GIT PULL] DT/core: cpu_ofnode updates for v3.12
From: Rob Herring <robherring2@gmail.com>
To: Sudeep KarkadaNagesha <Sudeep.KarkadaNagesha@arm.com>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
        "rob.herring@calxeda.com" <rob.herring@calxeda.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        linuxppc-dev <linuxppc-dev@lists.ozlabs.org>,
        Viresh Kumar <viresh.kumar@linaro.org>,
        Olof Johansson <olof@lixom.net>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 13, 2013 at 10:40 AM, Sudeep KarkadaNagesha
<Sudeep.KarkadaNagesha@arm.com> wrote:
> Adding PowerPC list
>
> On 13/08/13 14:00, Rafael J. Wysocki wrote:
>> On Monday, August 12, 2013 02:27:47 PM Sudeep KarkadaNagesha wrote:
>>> The following changes since commit
>>> d4e4ab86bcba5a72779c43dc1459f71fea3d89c8:
>>>
>>> Linux 3.11-rc5 (2013-08-11 18:04:20 -0700)
>>>
>>> are available in the git repository at:
>>>
>>> git://linux-arm.org/linux-skn.git cpu_of_node

[snip]

>> All error/warnings:
>>
>> warning: (MPC836x_RDK && MTD_NAND_FSL_ELBC && MTD_NAND_FSL_UPM)
>> selects FSL_LBC which has unmet direct dependencies (FSL_SOC)
>> warning: (MPC836x_RDK && MTD_NAND_FSL_ELBC && MTD_NAND_FSL_UPM)
>> selects FSL_LBC which has unmet direct dependencies (FSL_SOC)
>> In file included from arch/powerpc/include/asm/kvm_para.h:26:0, from
>> include/uapi/linux/kvm_para.h:26, from include/linux/kvm_para.h:4,
>> from include/linux/kvm_host.h:30, from
>> arch/powerpc/kernel/asm-offsets.c:53:
>> include/linux/of.h:269:28: error: conflicting types for
>>'of_get_cpu_node'
>> extern struct device_node *of_get_cpu_node(int cpu); ^ In file
>> included from include/linux/of.h:139:0, from
>> arch/powerpc/include/asm/kvm_para.h:26, from
>> include/uapi/linux/kvm_para.h:26, from include/linux/kvm_para.h:4,
>> from include/linux/kvm_host.h:30, from
>> arch/powerpc/kernel/asm-offsets.c:53:
>> arch/powerpc/include/asm/prom.h:47:21: note: previous declaration
>> of 'of_get_cpu_node' was here
>> struct device_node *of_get_cpu_node(int cpu, unsigned int *thread);
>> ^ make[2]: *** [arch/powerpc/kernel/asm-offsets.s] Error 1 make[2]:
>> Target `__build' not remade because of errors. make[1]: ***
>> [prepare0] Error 2 make[1]: Target `prepare' not remade because of
>> errors. make: *** [sub-make] Error 2
>>
>
> There seems to be conflict in the new function "of_get_cpu_node" added.
> PowerPC also defines the same function name. Further microblaze and
> openrisc declares it(can be removed) but doesn't define it.
> To fix this:
> 1. I can rename the newly added function to something different like
>    `of_get_cpunode` or
> 2. If of_* namespace should be used by only OF/FDT and not by any
>    architecture specific code, then the arch specific version can be
>    renamed to some thing like arch_of_get_cpu_node.
>    Also most of the calls to arch specific function can be moved to
>    generic code.
>
> Let me know your thoughts.

It is up to Rafael if he is willing/able to rebase his tree, but I
would drop this series until this is sorted out. I think the new
common function should be and can be generalized to work for powerpc.
It would need to make reg property optional and pass in the device
node to the arch specific function.

A short term solution would be just to make the function "#ifndef CONFIG_PPC".

Rob
