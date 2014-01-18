Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753249AbaARDqS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Jan 2014 22:46:18 -0500
Received: from mail-pb0-f42.google.com ([209.85.160.42]:37653 "EHLO
	mail-pb0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752100AbaARDqN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Jan 2014 22:46:13 -0500
Message-ID: <52D9F8E8.8030602@linaro.org>
Date: Sat, 18 Jan 2014 11:45:44 +0800
From: Hanjun Guo <hanjun.guo@linaro.org>
User-Agent: Mozilla/5.0 (Windows NT 5.1; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Sudeep Holla <Sudeep.Holla@arm.com>
CC: "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Catalin Marinas <Catalin.Marinas@arm.com>,
        Will Deacon <Will.Deacon@arm.com>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "grant.likely@linaro.org" <grant.likely@linaro.org>,
        Matthew Garrett <mjg59@srcf.ucam.org>, Olof Johansson <olof@lixom.net>,
        Linus Walleij <linus.walleij@linaro.org>,
        Bjorn Helgaas <bhelgaas@google.com>,
        "rob.herring@calxeda.com" <rob.herring@calxeda.com>,
        Mark Rutland <Mark.Rutland@arm.com>,
        Jon Masters <jonathan@jonmasters.org>,
        "patches@linaro.org" <patches@linaro.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linaro-kernel@lists.linaro.org" <linaro-kernel@lists.linaro.org>,
        "linaro-acpi@lists.linaro.org" <linaro-acpi@lists.linaro.org>
Subject: Re: [PATCH 1/3] ACPI / idle: Move idle_boot_override out of the arch
 directory
References: <1389924207-7360-1-git-send-email-hanjun.guo@linaro.org> <1389924207-7360-2-git-send-email-hanjun.guo@linaro.org> <52D91CE2.3050704@arm.com>
In-Reply-To: <52D91CE2.3050704@arm.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2014-1-17 20:06, Sudeep Holla wrote:
> On 17/01/14 02:03, Hanjun Guo wrote:
>> Move idle_boot_override out of the arch directory to be a single enum
>> including both platforms values, this will make it rather easier to
>> avoid ifdefs around which definitions are for which processor in
>> generally used ACPI code.
>>
>> IDLE_FORCE_MWAIT for IA64 is not used anywhere, so romove it.
>>
>> No functional change in this patch.
>>
>> Suggested-by: Alan <gnomes@lxorguk.ukuu.org.uk>
>> Signed-off-by: Hanjun Guo <hanjun.guo@linaro.org>
>> ---
>>  arch/ia64/include/asm/processor.h    | 3 ---
>>  arch/powerpc/include/asm/processor.h | 1 -
>>  arch/x86/include/asm/processor.h     | 3 ---
>>  arch/x86/kernel/process.c            | 1 +
>>  include/linux/cpu.h                  | 8 ++++++++
>>  5 files changed, 9 insertions(+), 7 deletions(-)
>>
>> diff --git a/arch/ia64/include/asm/processor.h b/arch/ia64/include/asm/processor.h
>> index 5a84b3a..ccd63a0 100644
>> --- a/arch/ia64/include/asm/processor.h
>> +++ b/arch/ia64/include/asm/processor.h
>> @@ -698,9 +698,6 @@ prefetchw (const void *x)
>>  
>>  extern unsigned long boot_option_idle_override;
>>  
>> -enum idle_boot_override {IDLE_NO_OVERRIDE=0, IDLE_HALT, IDLE_FORCE_MWAIT,
>> -			 IDLE_NOMWAIT, IDLE_POLL};
>> -
>>  void default_idle(void);
>>  
>>  #define ia64_platform_is(x) (strcmp(x, ia64_platform_name) == 0)
>> diff --git a/arch/powerpc/include/asm/processor.h b/arch/powerpc/include/asm/processor.h
>> index fc14a38..06689c0 100644
>> --- a/arch/powerpc/include/asm/processor.h
>> +++ b/arch/powerpc/include/asm/processor.h
>> @@ -440,7 +440,6 @@ static inline unsigned long get_clean_sp(unsigned long sp, int is_32)
>>  #endif
>>  
>>  extern unsigned long cpuidle_disable;
>> -enum idle_boot_override {IDLE_NO_OVERRIDE = 0, IDLE_POWERSAVE_OFF};
>>  
> 
> I don't think it is used in the context of ACPI. Though it's same variable name,
> it looks like it just used as boot to override the cpuidle option.
> Does it still make any sense to combine this ?

Yes, it is not related to ACPI on powerpc, I will investigate it will cause
compile warning or not if I don't combine this.

> 
>>  extern int powersave_nap;	/* set if nap mode can be used in idle loop */
>>  extern void power7_nap(void);
>> diff --git a/arch/x86/include/asm/processor.h b/arch/x86/include/asm/processor.h
>> index 7b034a4..4bee51a 100644
>> --- a/arch/x86/include/asm/processor.h
>> +++ b/arch/x86/include/asm/processor.h
>> @@ -729,9 +729,6 @@ extern void init_amd_e400_c1e_mask(void);
>>  extern unsigned long		boot_option_idle_override;
>>  extern bool			amd_e400_c1e_detected;
>>  
>> -enum idle_boot_override {IDLE_NO_OVERRIDE=0, IDLE_HALT, IDLE_NOMWAIT,
>> -			 IDLE_POLL};
>> -
>>  extern void enable_sep_cpu(void);
>>  extern int sysenter_setup(void);
>>  
>> diff --git a/arch/x86/kernel/process.c b/arch/x86/kernel/process.c
>> index 3fb8d95..62764ff 100644
>> --- a/arch/x86/kernel/process.c
>> +++ b/arch/x86/kernel/process.c
>> @@ -17,6 +17,7 @@
>>  #include <linux/stackprotector.h>
>>  #include <linux/tick.h>
>>  #include <linux/cpuidle.h>
>> +#include <linux/cpu.h>
>>  #include <trace/events/power.h>
>>  #include <linux/hw_breakpoint.h>
>>  #include <asm/cpu.h>
>> diff --git a/include/linux/cpu.h b/include/linux/cpu.h
>> index 03e235ad..e324561 100644
>> --- a/include/linux/cpu.h
>> +++ b/include/linux/cpu.h
>> @@ -220,6 +220,14 @@ void cpu_idle(void);
>>  
>>  void cpu_idle_poll_ctrl(bool enable);
>>  
>> +enum idle_boot_override {
>> +	IDLE_NO_OVERRIDE = 0,
>> +	IDLE_HALT,
>> +	IDLE_NOMWAIT,
>> +	IDLE_POLL,
>> +	IDLE_POWERSAVE_OFF
>> +};
>> +
> 
> I do understand the idea behind this change, but IMO HALT and MWAIT are x86
> specific and may not make sense for other architectures.

yes, this is the strange part, the value is arch-dependent.

> 
> It will also require every architecture using ACPI to export
> boot_option_idle_override which may not be really required.

so, how about forget this patch and move boot_option_idle_override
related code into arch directory such as arch/x86/acpi/boot.c for
x86?

> 
> Further the only users of boot_option_idle_override(outside x86) are:
> 
> 1. drivers/acpi/processor_core.c
>    Your second patch is moving this to x86 specific code anyway
> 
> 2. drivers/acpi/processor_idle.c
>    Currently idle driver is bit x86 specific and needs modifications to get it
>    working on ARM

Yes, That's why I did not enable acpi idle driver on ARM64 for now.

Thanks
Hanjun

