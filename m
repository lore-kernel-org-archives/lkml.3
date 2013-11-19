Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751913Ab3KSI1L (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Nov 2013 03:27:11 -0500
Received: from mail-ee0-f53.google.com ([74.125.83.53]:64125 "EHLO
	mail-ee0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751848Ab3KSI1I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Nov 2013 03:27:08 -0500
Date: Tue, 19 Nov 2013 09:27:04 +0100
From: Ingo Molnar <mingo@kernel.org>
To: akpm@linux-foundation.org
Cc: mingo@elte.hu, hpa@zytor.com, tglx@linutronix.de, wujianguo@huawei.com,
        mingo@redhat.com, rientjes@google.com, linux-kernel@vger.kernel.org
Subject: Re: [patch 2/3] x86/srat: use NUMA_NO_NODE
Message-ID: <20131119082704.GA1243@gmail.com>
References: <20131115221403.74AF31CA2E5@corp2gmr1-1.eem.corp.google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131115221403.74AF31CA2E5@corp2gmr1-1.eem.corp.google.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* akpm@linux-foundation.org <akpm@linux-foundation.org> wrote:

> From: Jianguo Wu <wujianguo@huawei.com>
> Subject: x86/srat: use NUMA_NO_NODE
> 
> setup_node() return NUMA_NO_NODE or valid node id(>=0), So use more
> appropriate "if (node == NUMA_NO_NODE)" instead of "if (node < 0)"
> 
> Signed-off-by: Jianguo Wu <wujianguo@huawei.com>
> Acked-by: David Rientjes <rientjes@google.com>
> Cc: Thomas Gleixner <tglx@linutronix.de>
> Cc: Ingo Molnar <mingo@redhat.com>
> Cc: "H. Peter Anvin" <hpa@zytor.com>
> Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
> ---
> 
>  arch/x86/mm/srat.c |    6 +++---
>  1 file changed, 3 insertions(+), 3 deletions(-)
> 
> diff -puN arch/x86/mm/srat.c~x86-srat-use-numa_no_node arch/x86/mm/srat.c
> --- a/arch/x86/mm/srat.c~x86-srat-use-numa_no_node
> +++ a/arch/x86/mm/srat.c
> @@ -76,7 +76,7 @@ acpi_numa_x2apic_affinity_init(struct ac
>  		return;
>  	}
>  	node = setup_node(pxm);
> -	if (node < 0) {
> +	if (node == NUMA_NO_NODE) {
>  		printk(KERN_ERR "SRAT: Too many proximity domains %x\n", pxm);
>  		bad_srat();
>  		return;
> @@ -112,7 +112,7 @@ acpi_numa_processor_affinity_init(struct
>  	if (acpi_srat_revision >= 2)
>  		pxm |= *((unsigned int*)pa->proximity_domain_hi) << 8;
>  	node = setup_node(pxm);
> -	if (node < 0) {
> +	if (node == NUMA_NO_NODE) {
>  		printk(KERN_ERR "SRAT: Too many proximity domains %x\n", pxm);
>  		bad_srat();
>  		return;
> @@ -166,7 +166,7 @@ acpi_numa_memory_affinity_init(struct ac
>  		pxm &= 0xff;
>  
>  	node = setup_node(pxm);
> -	if (node < 0) {
> +	if (node == NUMA_NO_NODE) {
>  		printk(KERN_ERR "SRAT: Too many proximity domains.\n");
>  		goto out_err_bad_srat;
>  	}

Dunno, I think the 'node < 0' pattern is more readable and is in 
general more robust than explicit NUMA_NO_NODE use - as it would 
handle other errors as well, not just -1.

Thanks,

	Ingo
