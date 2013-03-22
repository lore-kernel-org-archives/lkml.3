Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422946Ab3CVUgE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Mar 2013 16:36:04 -0400
Received: from g5t0007.atlanta.hp.com ([15.192.0.44]:16732 "EHLO
	g5t0007.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1422855Ab3CVUgD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Mar 2013 16:36:03 -0400
Message-ID: <1363983884.11659.14.camel@misato.fc.hp.com>
Subject: Re: [PATCH v3 2/2] ACPI,acpi_memhotplug: Remove
 acpi_memory_info->failed bit
From: Toshi Kani <toshi.kani@hp.com>
To: Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>
Cc: rjw@sisk.pl, linux-acpi@vger.kernel.org, tangchen@cn.fujitsu.com,
        wency@cn.fujitsu.com, laijs@cn.fujitsu.com,
        linux-kernel@vger.kernel.org
Date: Fri, 22 Mar 2013 14:24:44 -0600
In-Reply-To: <514BB9AD.3010704@jp.fujitsu.com>
References: <514022BF.3080303@jp.fujitsu.com>
	   <1363186213.12845.174.camel@misato.fc.hp.com>
	   <514679BC.5020700@jp.fujitsu.com>
	  <1363705437.11659.5.camel@misato.fc.hp.com>
	  <514A4CCD.6000608@jp.fujitsu.com> <514A8E3C.1050902@jp.fujitsu.com>
	  <514A8EF3.90203@jp.fujitsu.com>
	 <1363912171.11659.12.camel@misato.fc.hp.com>
	 <514BB9AD.3010704@jp.fujitsu.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4 (3.4.4-2.fc17) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2013-03-22 at 10:53 +0900, Yasuaki Ishimatsu wrote:
> acpi_memory_info has enabled bit and failed bit for controlling memory
> hotplug. But we don't need to keep both bits.
> 
> The patch removes acpi_memory_info->failed bit.
> 
> Signed-off-by: yasuaki ishimatsu <isimatu.yasuaki@jp.fujitsu.com>

Thanks for the update.  It looks good.  For the series:

Acked-by: Toshi Kani <toshi.kani@hp.com>

-Toshi


> ---
> 
> v3 : Continue to memory hot remove when (!info->enabled) case.
> v2 : Changed a based kernel from linux-3.9-rc2 to linux-pm.git/bleeding-edge.
> 
> ---
>   drivers/acpi/acpi_memhotplug.c |   15 ++-------------
>   1 files changed, 2 insertions(+), 13 deletions(-)
> 
> diff --git a/drivers/acpi/acpi_memhotplug.c b/drivers/acpi/acpi_memhotplug.c
> index ea78988..5e6301e 100644
> --- a/drivers/acpi/acpi_memhotplug.c
> +++ b/drivers/acpi/acpi_memhotplug.c
> @@ -73,7 +73,6 @@ struct acpi_memory_info {
>   	unsigned short caching;	/* memory cache attribute */
>   	unsigned short write_protect;	/* memory read/write attribute */
>   	unsigned int enabled:1;
> -	unsigned int failed:1;
>   };
>   
>   struct acpi_memory_device {
> @@ -201,10 +200,8 @@ static int acpi_memory_enable_device(struct acpi_memory_device *mem_device)
>   		 * returns -EEXIST. If add_memory() returns the other error, it
>   		 * means that this memory block is not used by the kernel.
>   		 */
> -		if (result && result != -EEXIST) {
> -			info->failed = 1;
> +		if (result && result != -EEXIST)
>   			continue;
> -		}
>   
>   		info->enabled = 1;
>   
> @@ -238,16 +235,8 @@ static int acpi_memory_remove_memory(struct acpi_memory_device *mem_device)
>   	nid = acpi_get_node(mem_device->device->handle);
>   
>   	list_for_each_entry_safe(info, n, &mem_device->res_list, list) {
> -		if (info->failed)
> -			/* The kernel does not use this memory block */
> -			continue;
> -
>   		if (!info->enabled)
> -			/*
> -			 * The kernel uses this memory block, but it may be not
> -			 * managed by us.
> -			 */
> -			return -EBUSY;
> +			continue;
>   
>   		if (nid < 0)
>   			nid = memory_add_physaddr_to_nid(info->start_addr);
> 


