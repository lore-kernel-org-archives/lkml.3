Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752164AbaILT73 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Sep 2014 15:59:29 -0400
Received: from mx1.redhat.com ([209.132.183.28]:61761 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751208AbaILT71 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Sep 2014 15:59:27 -0400
Message-ID: <54134AAE.8090106@redhat.com>
Date: Fri, 12 Sep 2014 15:34:06 -0400
From: Jon Masters <jcm@redhat.com>
Organization: Red Hat, Inc.
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Hanjun Guo <hanjun.guo@linaro.org>,
        Catalin Marinas <catalin.marinas@arm.com>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Mark Rutland <mark.rutland@arm.com>, Olof Johansson <olof@lixom.net>,
        Grant Likely <grant.likely@linaro.org>,
        Will Deacon <will.deacon@arm.com>
CC: Graeme Gregory <graeme.gregory@linaro.org>, Arnd Bergmann <arnd@arndb.de>,
        Sudeep Holla <Sudeep.Holla@arm.com>,
        Jason Cooper <jason@lakedaemon.net>,
        Marc Zyngier <marc.zyngier@arm.com>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Mark Brown <broonie@kernel.org>, Rob Herring <robh@kernel.org>,
        Robert Richter <rric@kernel.org>, Lv Zheng <lv.zheng@intel.com>,
        Robert Moore <robert.moore@intel.com>,
        Lorenzo Pieralisi <Lorenzo.Pieralisi@arm.com>,
        Liviu Dudau <Liviu.Dudau@arm.com>,
        Randy Dunlap <rdunlap@infradead.org>, Charles.Garcia-Tobin@arm.com,
        linux-acpi@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, linaro-acpi@lists.linaro.org
Subject: Re: [PATCH v4 01/18] ARM64: Move the init of cpu_logical_map(0) before
 unflatten_device_tree()
References: <1410530416-30200-1-git-send-email-hanjun.guo@linaro.org> <1410530416-30200-2-git-send-email-hanjun.guo@linaro.org>
In-Reply-To: <1410530416-30200-2-git-send-email-hanjun.guo@linaro.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/12/2014 09:59 AM, Hanjun Guo wrote:
> It always make sense to initialize CPU0's logical map entry from the
> hardware values, so move the initialization of cpu_logical_map(0)
> before unflatten_device_tree() which is needed by ACPI code later.
> 
> Signed-off-by: Hanjun Guo <hanjun.guo@linaro.org>
> ---
>  arch/arm64/kernel/setup.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/arch/arm64/kernel/setup.c b/arch/arm64/kernel/setup.c
> index edb146d..8f33f72 100644
> --- a/arch/arm64/kernel/setup.c
> +++ b/arch/arm64/kernel/setup.c
> @@ -393,11 +393,11 @@ void __init setup_arch(char **cmdline_p)
>  
>  	efi_idmap_init();
>  
> +	cpu_logical_map(0) = read_cpuid_mpidr() & MPIDR_HWID_BITMASK;
>  	unflatten_device_tree();
>  
>  	psci_init();
>  
> -	cpu_logical_map(0) = read_cpuid_mpidr() & MPIDR_HWID_BITMASK;
>  	cpu_read_bootcpu_ops();
>  #ifdef CONFIG_SMP
>  	smp_init_cpus();

Thanks - this is a good fix to ensure we're always dealing with the
masked value of the MPIDR Aff bits that we care about.

Jon.


