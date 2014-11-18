Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754010AbaKRNqD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Nov 2014 08:46:03 -0500
Received: from mail-pa0-f41.google.com ([209.85.220.41]:57079 "EHLO
	mail-pa0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752212AbaKRNqA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Nov 2014 08:46:00 -0500
Message-ID: <546B4D8D.2020605@linaro.org>
Date: Tue, 18 Nov 2014 21:45:49 +0800
From: Hanjun Guo <hanjun.guo@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will.deacon@arm.com>
CC: "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Mark Rutland <mark.rutland@arm.com>, Olof Johansson <olof@lixom.net>,
        Grant Likely <grant.likely@linaro.org>,
        Graeme Gregory <graeme.gregory@linaro.org>,
        Arnd Bergmann <arnd@arndb.de>, Sudeep Holla <Sudeep.Holla@arm.com>,
        Jon Masters <jcm@redhat.com>, Jason Cooper <jason@lakedaemon.net>,
        Marc Zyngier <marc.zyngier@arm.com>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Mark Brown <broonie@kernel.org>, Rob Herring <robh@kernel.org>,
        Robert Richter <rric@kernel.org>, Lv Zheng <lv.zheng@intel.com>,
        Robert Moore <robert.moore@intel.com>,
        Lorenzo Pieralisi <Lorenzo.Pieralisi@arm.com>,
        Liviu Dudau <Liviu.Dudau@arm.com>,
        Randy Dunlap <rdunlap@infradead.org>, Charles.Garcia-Tobin@arm.com,
        Kangkang.Shen@huawei.com, linux-acpi@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linaro-acpi@lists.linaro.org
Subject: Re: [PATCH v5 01/18] ARM64: Move the init of cpu_logical_map(0) before
 unflatten_device_tree()
References: <1413553034-20956-1-git-send-email-hanjun.guo@linaro.org> <1413553034-20956-2-git-send-email-hanjun.guo@linaro.org>
In-Reply-To: <1413553034-20956-2-git-send-email-hanjun.guo@linaro.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Catalin,

On 2014年10月17日 21:36, Hanjun Guo wrote:
> It always make sense to initialize CPU0's logical map entry from the
> hardware values, so move the initialization of cpu_logical_map(0)
> before unflatten_device_tree() which is needed by ACPI code later.
>
> Acked-by: Olof Johansson <olof@lixom.net>
> Acked-by: Mark Rutland <mark.rutland@arm.com>
> Signed-off-by: Hanjun Guo <hanjun.guo@linaro.org>

Could you merge this patch first in 3.19? It was acked by Olof and
Mark, and it will make sense without ACPI too.

Thanks
Hanjun

> ---
>   arch/arm64/kernel/setup.c |    2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/arch/arm64/kernel/setup.c b/arch/arm64/kernel/setup.c
> index edb146d..8f33f72 100644
> --- a/arch/arm64/kernel/setup.c
> +++ b/arch/arm64/kernel/setup.c
> @@ -393,11 +393,11 @@ void __init setup_arch(char **cmdline_p)
>
>   	efi_idmap_init();
>
> +	cpu_logical_map(0) = read_cpuid_mpidr() & MPIDR_HWID_BITMASK;
>   	unflatten_device_tree();
>
>   	psci_init();
>
> -	cpu_logical_map(0) = read_cpuid_mpidr() & MPIDR_HWID_BITMASK;
>   	cpu_read_bootcpu_ops();
>   #ifdef CONFIG_SMP
>   	smp_init_cpus();
>
