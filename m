Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755893Ab3BDTmF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Feb 2013 14:42:05 -0500
Received: from mail-pa0-f45.google.com ([209.85.220.45]:33529 "EHLO
	mail-pa0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755733Ab3BDTmA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Feb 2013 14:42:00 -0500
Date: Mon, 4 Feb 2013 11:41:57 -0800 (PST)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: liguang <lig.fnst@cn.fujitsu.com>
cc: linux-kernel@vger.kernel.org, linux-acpi@vger.kernel.org, x86@kernel.org
Subject: Re: [PATCH 2/5] acpi/numa: check if parsing acpi numa info disabled
 earlier
In-Reply-To: <1359967426-32629-3-git-send-email-lig.fnst@cn.fujitsu.com>
Message-ID: <alpine.DEB.2.02.1302041133520.10378@chino.kir.corp.google.com>
References: <1359967426-32629-1-git-send-email-lig.fnst@cn.fujitsu.com> <1359967426-32629-3-git-send-email-lig.fnst@cn.fujitsu.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 4 Feb 2013, liguang wrote:

> Signed-off-by: liguang <lig.fnst@cn.fujitsu.com>

Because there's no changelog, I have to read the patch to figure out what 
it's doing since the title isn't that helpful either.  Please provide a 
description of what problem you're trying to fix or what improvement 
you're trying to make so it's clear.

> ---
>  arch/x86/mm/srat.c  |    6 ------
>  drivers/acpi/numa.c |    2 ++
>  2 files changed, 2 insertions(+), 6 deletions(-)
> 
> diff --git a/arch/x86/mm/srat.c b/arch/x86/mm/srat.c
> index a837c95..78c67bd 100644
> --- a/arch/x86/mm/srat.c
> +++ b/arch/x86/mm/srat.c
> @@ -60,8 +60,6 @@ acpi_numa_x2apic_affinity_init(struct acpi_srat_x2apic_cpu_affinity *pa)
>  	int pxm, node;
>  	int apic_id;
>  
> -	if (srat_disabled())
> -		return;
>  	if (pa->header.length < sizeof(struct acpi_srat_x2apic_cpu_affinity)) {
>  		bad_srat();
>  		return;
> @@ -100,8 +98,6 @@ acpi_numa_processor_affinity_init(struct acpi_srat_cpu_affinity *pa)
>  	int pxm, node;
>  	int apic_id;
>  
> -	if (srat_disabled())
> -		return;
>  	if (pa->header.length != sizeof(struct acpi_srat_cpu_affinity)) {
>  		bad_srat();
>  		return;
> @@ -148,8 +144,6 @@ acpi_numa_memory_affinity_init(struct acpi_srat_mem_affinity *ma)
>  	u64 start, end;
>  	int node, pxm;
>  
> -	if (srat_disabled())
> -		return -1;
>  	if (ma->header.length != sizeof(struct acpi_srat_mem_affinity)) {
>  		bad_srat();
>  		return -1;
> diff --git a/drivers/acpi/numa.c b/drivers/acpi/numa.c
> index cb31298..1f51222 100644
> --- a/drivers/acpi/numa.c
> +++ b/drivers/acpi/numa.c
> @@ -262,6 +262,8 @@ static int __init acpi_parse_srat(struct acpi_table_header *table)
>  	struct acpi_table_srat *srat;
>  	if (!table)
>  		return -EINVAL;
> +	if (srat_disabled())
> +		return -EACCES;
>  
>  	srat = (struct acpi_table_srat *)table;
>  	acpi_srat_revision = srat->header.revision;

Nack, this isn't helpful since SRAT is only for x86 and other 
architectures use this code.  It would break the build on ia64 since it's 
obviously not going to have a function called srat_disabled().

And -EACCES would not be the appropriate return value, this has nothing to 
do with permissions.
