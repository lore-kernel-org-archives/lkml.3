Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752902Ab3GWAZh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Jul 2013 20:25:37 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:56760 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751589Ab3GWAZg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Jul 2013 20:25:36 -0400
X-SecurityPolicyCheck: OK by SHieldMailChecker v2.0.1
X-SHieldMailCheckerPolicyVersion: FJ-ISEC-20120718-3
Message-ID: <51EDCD46.5040502@jp.fujitsu.com>
Date: Tue, 23 Jul 2013 09:24:38 +0900
From: Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:17.0) Gecko/20130620 Thunderbird/17.0.7
MIME-Version: 1.0
To: Toshi Kani <toshi.kani@hp.com>
CC: <akpm@linux-foundation.org>, <linux-mm@kvack.org>,
        <linux-kernel@vger.kernel.org>, <x86@kernel.org>, <dave@sr71.net>,
        <kosaki.motohiro@gmail.com>, <tangchen@cn.fujitsu.com>,
        <vasilis.liaskovitis@profitbricks.com>
Subject: Re: [PATCH v2] mm/hotplug, x86: Disable ARCH_MEMORY_PROBE by default
References: <1374256068-26016-1-git-send-email-toshi.kani@hp.com>
In-Reply-To: <1374256068-26016-1-git-send-email-toshi.kani@hp.com>
Content-Type: text/plain; charset="ISO-2022-JP"
Content-Transfer-Encoding: 7bit
X-SecurityPolicyCheck-GC: OK by FENCE-Mail
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2013/07/20 2:47), Toshi Kani wrote:
> CONFIG_ARCH_MEMORY_PROBE enables /sys/devices/system/memory/probe
> interface, which allows a given memory address to be hot-added as
> follows. (See Documentation/memory-hotplug.txt for more detail.)
> 
> # echo start_address_of_new_memory > /sys/devices/system/memory/probe
> 
> This probe interface is required on powerpc. On x86, however, ACPI
> notifies a memory hotplug event to the kernel, which performs its
> hotplug operation as the result. Therefore, regular users do not need
> this interface on x86. This probe interface is also error-prone and
> misleading that the kernel blindly adds a given memory address without
> checking if the memory is present on the system; no probing is done
> despite of its name. The kernel crashes when a user requests to online
> a memory block that is not present on the system. This interface is
> currently used for testing as it can fake a hotplug event.
> 
> This patch disables CONFIG_ARCH_MEMORY_PROBE by default on x86, adds
> its Kconfig menu entry on x86, and clarifies its use in Documentation/
> memory-hotplug.txt.
> 
> Signed-off-by: Toshi Kani <toshi.kani@hp.com>

Reviewed-by: Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>

Thanks,
Yasuaki Ishimatsu

> ---
>   Documentation/memory-hotplug.txt |   16 +++++++++-------
>   arch/x86/Kconfig                 |    7 ++++++-
>   2 files changed, 15 insertions(+), 8 deletions(-)
> 
> diff --git a/Documentation/memory-hotplug.txt b/Documentation/memory-hotplug.txt
> index 8e5eacb..8fd254c 100644
> --- a/Documentation/memory-hotplug.txt
> +++ b/Documentation/memory-hotplug.txt
> @@ -210,13 +210,15 @@ If memory device is found, memory hotplug code will be called.
>   
>   4.2 Notify memory hot-add event by hand
>   ------------
> -In some environments, especially virtualized environment, firmware will not
> -notify memory hotplug event to the kernel. For such environment, "probe"
> -interface is supported. This interface depends on CONFIG_ARCH_MEMORY_PROBE.
> -
> -Now, CONFIG_ARCH_MEMORY_PROBE is supported only by powerpc but it does not
> -contain highly architecture codes. Please add config if you need "probe"
> -interface.
> +On powerpc, the firmware does not notify a memory hotplug event to the kernel.
> +Therefore, "probe" interface is supported to notify the event to the kernel.
> +This interface depends on CONFIG_ARCH_MEMORY_PROBE.
> +
> +CONFIG_ARCH_MEMORY_PROBE is supported on powerpc only. On x86, this config
> +option is disabled by default since ACPI notifies a memory hotplug event to
> +the kernel, which performs its hotplug operation as the result. Please
> +enable this option if you need the "probe" interface for testing purposes
> +on x86.
>   
>   Probe interface is located at
>   /sys/devices/system/memory/probe
> diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
> index b32ebf9..408ef68 100644
> --- a/arch/x86/Kconfig
> +++ b/arch/x86/Kconfig
> @@ -1344,8 +1344,13 @@ config ARCH_SELECT_MEMORY_MODEL
>   	depends on ARCH_SPARSEMEM_ENABLE
>   
>   config ARCH_MEMORY_PROBE
> -	def_bool y
> +	bool "Enable sysfs memory/probe interface"
> +	default n
>   	depends on X86_64 && MEMORY_HOTPLUG
> +	help
> +	  This option enables a sysfs memory/probe interface for testing.
> +	  See Documentation/memory-hotplug.txt for more information.
> +	  If you are unsure how to answer this question, answer N.
>   
>   config ARCH_PROC_KCORE_TEXT
>   	def_bool y
> 


