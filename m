Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753823AbaDYXI5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Apr 2014 19:08:57 -0400
Received: from mail-ee0-f42.google.com ([74.125.83.42]:55795 "EHLO
	mail-ee0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753403AbaDYXHl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Apr 2014 19:07:41 -0400
Message-ID: <535AEAB9.6020707@gmail.com>
Date: Sat, 26 Apr 2014 01:07:37 +0200
From: Tomasz Figa <tomasz.figa@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: Kevin Hilman <khilman@linaro.org>, Tarek Dakhran <t.dakhran@samsung.com>
CC: linux-kernel@vger.kernel.org, Rob Herring <robh+dt@kernel.org>,
        Pawel Moll <pawel.moll@arm.com>, Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>, Rob Landley <rob@landley.net>,
        Kukjin Kim <kgene.kim@samsung.com>,
        Russell King <linux@arm.linux.org.uk>, Ben Dooks <ben-linux@fluff.org>,
        Tomasz Figa <t.figa@samsung.com>,
        Mike Turquette <mturquette@linaro.org>,
        Vyacheslav Tyrtov <v.tyrtov@samsung.com>,
        Thomas Abraham <thomas.abraham@linaro.org>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Heiko Stuebner <heiko@sntech.de>,
        Romain Naour <romain.naour@openwide.fr>,
        Chander Kashyap <chander.kashyap@linaro.org>,
        devicetree@vger.kernel.org, linux-doc@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org, Tarek Dakhran <t.dakhran@gmail.com>
Subject: Re: [PATCH v8 1/3] ARM: EXYNOS: Add support for EXYNOS5410 SoC
References: <1397459860-21869-1-git-send-email-t.dakhran@samsung.com>	<1397459860-21869-2-git-send-email-t.dakhran@samsung.com> <7hwqedf2d5.fsf@paris.lan>
In-Reply-To: <7hwqedf2d5.fsf@paris.lan>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Kevin,

On 26.04.2014 00:52, Kevin Hilman wrote:
> Tarek Dakhran <t.dakhran@samsung.com> writes:
>
>> EXYNOS5410 is SoC in Samsung's Exynos5 SoC series.
>> Add initial support for this SoC.
>>
>> Signed-off-by: Tarek Dakhran <t.dakhran@samsung.com>
>> Signed-off-by: Vyacheslav Tyrtov <v.tyrtov@samsung.com>
>> Reviewed-by: Tomasz Figa <t.figa@samsung.com>
>
> [...]
>
>> diff --git a/arch/arm/mach-exynos/hotplug.c b/arch/arm/mach-exynos/hotplug.c
>> index 5eead53..83ae5fb 100644
>> --- a/arch/arm/mach-exynos/hotplug.c
>> +++ b/arch/arm/mach-exynos/hotplug.c
>> @@ -95,8 +95,8 @@ static inline void platform_do_lowpower(unsigned int cpu, int *spurious)
>>   	for (;;) {
>>
>>   		/* make cpu1 to be turned off at next WFI command */
>> -		if (cpu == 1)
>> -			__raw_writel(0, S5P_ARM_CORE1_CONFIGURATION);
>> +		if (cpu > 0)
>> +			__raw_writel(0, S5P_ARM_CORE_CONFIGURATION(cpu));
>
> This looks like a fix that's probably not specific to the 5410 and maybe
> deserves it's own patch?
>
> [...]
>
>> @@ -107,14 +111,14 @@ static int exynos_boot_secondary(unsigned int cpu, struct task_struct *idle)
>>   	 */
>>   	write_pen_release(phys_cpu);
>>
>> -	if (!(__raw_readl(S5P_ARM_CORE1_STATUS) & S5P_CORE_LOCAL_PWR_EN)) {
>> +	if (!(__raw_readl(S5P_ARM_CORE_STATUS(cpu)) & S5P_CORE_LOCAL_PWR_EN)) {
>>   		__raw_writel(S5P_CORE_LOCAL_PWR_EN,
>> -			     S5P_ARM_CORE1_CONFIGURATION);
>> +			     S5P_ARM_CORE_CONFIGURATION(cpu));
>>
>>   		timeout = 10;
>>
>>   		/* wait max 10 ms until cpu1 is on */
>> -		while ((__raw_readl(S5P_ARM_CORE1_STATUS)
>> +		while ((__raw_readl(S5P_ARM_CORE_STATUS(cpu))
>>   			& S5P_CORE_LOCAL_PWR_EN) != S5P_CORE_LOCAL_PWR_EN) {
>>   			if (timeout-- == 0)
>>   				break;
>
> ...and this hunk too?

Yes, they do, but we are currently refactoring this code anyway.

Best regards,
Tomasz
