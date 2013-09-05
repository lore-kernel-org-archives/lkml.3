Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762624Ab3IEAeL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Sep 2013 20:34:11 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:52157 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758175Ab3IEAeI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Sep 2013 20:34:08 -0400
X-SecurityPolicyCheck: OK by SHieldMailChecker v2.0.1
X-SHieldMailCheckerPolicyVersion: FJ-ISEC-20120718-3
Message-ID: <5227D150.1060502@jp.fujitsu.com>
Date: Thu, 5 Sep 2013 09:33:20 +0900
From: Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:17.0) Gecko/20130801 Thunderbird/17.0.8
MIME-Version: 1.0
To: Tang Chen <tangchen@cn.fujitsu.com>
CC: <tglx@linutronix.de>, <mingo@redhat.com>, <hpa@zytor.com>,
        <lenb@kernel.org>, <rjw@sisk.pl>, <liwanp@linux.vnet.ibm.com>,
        <tj@kernel.org>, <akpm@linux-foundation.org>, <joe@perches.com>,
        <toshi.kani@hp.com>, <x86@kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-acpi@vger.kernel.org>
Subject: Re: [PATCH v2 2/4] acpi cleanup: Use pr_{info|err}() instead of printk()
 in arch/x86/mm/srat.c
References: <1378197941-26479-1-git-send-email-tangchen@cn.fujitsu.com> <1378197941-26479-3-git-send-email-tangchen@cn.fujitsu.com>
In-Reply-To: <1378197941-26479-3-git-send-email-tangchen@cn.fujitsu.com>
Content-Type: text/plain; charset="ISO-2022-JP"
Content-Transfer-Encoding: 7bit
X-SecurityPolicyCheck-GC: OK by FENCE-Mail
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2013/09/03 17:45), Tang Chen wrote:
> Use pr_{info|err}() instead of printk() in arch/x86/mm/srat.c.
> 
> As suggested by Joe Perches <joe@perches.com>, use pr_fmt(fmt) to simplify
> the output format.
> 
> Signed-off-by: Tang Chen <tangchen@cn.fujitsu.com>
> Acked-by: Toshi Kani <toshi.kani@hp.com>
> ---
>   arch/x86/mm/srat.c |   32 +++++++++++++++++---------------
>   1 files changed, 17 insertions(+), 15 deletions(-)
> 
> diff --git a/arch/x86/mm/srat.c b/arch/x86/mm/srat.c
> index 1613c02..5adfcfb 100644
> --- a/arch/x86/mm/srat.c
> +++ b/arch/x86/mm/srat.c
> @@ -24,6 +24,8 @@
>   #include <asm/apic.h>
>   #include <asm/uv/uv.h>
>   
> +#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
> +
>   int acpi_numa __initdata;
>   
>   static __init int setup_node(int pxm)
> @@ -33,7 +35,7 @@ static __init int setup_node(int pxm)
>   
>   static __init void bad_srat(void)
>   {
> -	printk(KERN_ERR "SRAT: SRAT not used.\n");
> +	pr_err("SRAT not used.\n");
>   	acpi_numa = -1;
>   }
>   
> @@ -71,26 +73,26 @@ acpi_numa_x2apic_affinity_init(struct acpi_srat_x2apic_cpu_affinity *pa)
>   	pxm = pa->proximity_domain;
>   	apic_id = pa->apic_id;
>   	if (!apic->apic_id_valid(apic_id)) {

> -		printk(KERN_INFO "SRAT: PXM %u -> X2APIC 0x%04x ignored\n",
> -			 pxm, apic_id);
> +		pr_info("PXM %u -> X2APIC 0x%04x ignored\n",
> +			pxm, apic_id);

It should be one line.

>   		return;
>   	}
>   	node = setup_node(pxm);
>   	if (node < 0) {
> -		printk(KERN_ERR "SRAT: Too many proximity domains %x\n", pxm);
> +		pr_err("Too many proximity domains %x\n", pxm);
>   		bad_srat();
>   		return;
>   	}
>   
>   	if (apic_id >= MAX_LOCAL_APIC) {
> -		printk(KERN_INFO "SRAT: PXM %u -> APIC 0x%04x -> Node %u skipped apicid that is too big\n", pxm, apic_id, node);
> +		pr_info("PXM %u -> APIC 0x%04x -> Node %u skipped apicid that is too big\n", pxm, apic_id, node);
>   		return;
>   	}
>   	set_apicid_to_node(apic_id, node);
>   	node_set(node, numa_nodes_parsed);
>   	acpi_numa = 1;

> -	printk(KERN_INFO "SRAT: PXM %u -> APIC 0x%04x -> Node %u\n",
> -	       pxm, apic_id, node);
> +	pr_info("PXM %u -> APIC 0x%04x -> Node %u\n",
> +	        pxm, apic_id, node);

ditto.

>   }
>   
>   /* Callback for Proximity Domain -> LAPIC mapping */
> @@ -113,7 +115,7 @@ acpi_numa_processor_affinity_init(struct acpi_srat_cpu_affinity *pa)
>   		pxm |= *((unsigned int*)pa->proximity_domain_hi) << 8;
>   	node = setup_node(pxm);
>   	if (node < 0) {
> -		printk(KERN_ERR "SRAT: Too many proximity domains %x\n", pxm);
> +		pr_err("Too many proximity domains %x\n", pxm);
>   		bad_srat();
>   		return;
>   	}
> @@ -124,15 +126,15 @@ acpi_numa_processor_affinity_init(struct acpi_srat_cpu_affinity *pa)
>   		apic_id = pa->apic_id;
>   
>   	if (apic_id >= MAX_LOCAL_APIC) {
> -		printk(KERN_INFO "SRAT: PXM %u -> APIC 0x%02x -> Node %u skipped apicid that is too big\n", pxm, apic_id, node);
> +		pr_info("PXM %u -> APIC 0x%02x -> Node %u skipped apicid that is too big\n", pxm, apic_id, node);
>   		return;
>   	}
>   
>   	set_apicid_to_node(apic_id, node);
>   	node_set(node, numa_nodes_parsed);
>   	acpi_numa = 1;

> -	printk(KERN_INFO "SRAT: PXM %u -> APIC 0x%02x -> Node %u\n",
> -	       pxm, apic_id, node);
> +	pr_info("PXM %u -> APIC 0x%02x -> Node %u\n",
> +	        pxm, apic_id, node);

ditto.

>   }
>   
>   /* Callback for parsing of the Proximity Domain <-> Memory Area mappings */
> @@ -157,7 +159,7 @@ acpi_numa_memory_affinity_init(struct acpi_srat_mem_affinity *ma)
>   
>   	node = setup_node(pxm);
>   	if (node < 0) {
> -		printk(KERN_ERR "SRAT: Too many proximity domains.\n");
> +		pr_err("Too many proximity domains.\n");
>   		goto out_err_bad_srat;
>   	}
>   
> @@ -166,9 +168,9 @@ acpi_numa_memory_affinity_init(struct acpi_srat_mem_affinity *ma)
>   
>   	node_set(node, numa_nodes_parsed);
>   

> -	printk(KERN_INFO "SRAT: Node %u PXM %u [mem %#010Lx-%#010Lx]\n",
> -	       node, pxm,
> -	       (unsigned long long) start, (unsigned long long) end - 1);
> +	pr_info("Node %u PXM %u [mem %#010Lx-%#010Lx]\n",
> +	        node, pxm,
> +	        (unsigned long long) start, (unsigned long long) end - 1);

It should be two lines.

Thanks,
Yasuaki Ishimatsu

>   
>   	return 0;
>   out_err_bad_srat:
> 


