Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754796Ab3JQKY1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Oct 2013 06:24:27 -0400
Received: from mailout3.w2.samsung.com ([211.189.100.13]:36243 "EHLO
	usmailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754577Ab3JQKYY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Oct 2013 06:24:24 -0400
X-AuditID: cbfec373-b7f6d6d00000330d-72-525fbad7131a
Date: Thu, 17 Oct 2013 07:24:17 -0300
From: Mauro Carvalho Chehab <m.chehab@samsung.com>
To: "Chen, Gong" <gong.chen@linux.intel.com>
Cc: tony.luck@intel.com, bp@alien8.de, joe@perches.com,
        naveen.n.rao@linux.vnet.ibm.com, arozansk@redhat.com,
        linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 7/9] ACPI, APEI,
 CPER: Enhance memory reporting capability
Message-id: <20131017072417.2f98d2ec@samsung.com>
In-reply-to: <1381935366-11731-8-git-send-email-gong.chen@linux.intel.com>
References: <1381935366-11731-1-git-send-email-gong.chen@linux.intel.com>
 <1381935366-11731-8-git-send-email-gong.chen@linux.intel.com>
X-Mailer: Claws Mail 3.9.2 (GTK+ 2.24.19; x86_64-redhat-linux-gnu)
MIME-version: 1.0
Content-type: text/plain; charset=US-ASCII
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrDLMWRmVeSWpSXmKPExsVy+t/hEN3ru+KDDG4eEbZoO/GbzeLzhn9s
	Frfe2VrMvv+YxWL5vn5Gi8u75rBZ3G95ym7x5sI9FgcOj++tfSwei/e8ZPKYdzLQ48GhzSwe
	X1ZdY/Z4v+8qm8fnTXIB7FFcNimpOZllqUX6dglcGb+uz2YsWCJYsfjuItYGxh6+LkZODgkB
	E4lNG6axQ9hiEhfurWfrYuTiEBJYwihxbvoNRginh0li+q1lrCBVLAKqEmfX3gbrYBMwknjV
	2AIWFxHQkXiwaTVYA7PAKkaJN2+2gyWEBYIl7r2fD9bAK2AocaRpNlicU8BLYuvqmcwQGzoZ
	Jf6t2gHkcADd4SSxdaovRL2gxI/J91hAbGYBLYnN25pYIWx5ic1r3jJPYBSYhaRsFpKyWUjK
	FjAyr2IULS1OLihOSs810itOzC0uzUvXS87P3cQIiYHiHYwvNlgdYhTgYFTi4Z2xPC5IiDWx
	rLgy9xCjBAezkgjvlu3xQUK8KYmVValF+fFFpTmpxYcYmTg4pRoYuXc95/pWFXht1UU9N9Uf
	X2x2H+Aqr715We+df16XxP/1jg88p7+7MY/x+d2E9Mz/lVPV7/aJfHb/WWQcFZPzNfOejrV0
	VeGq/1tqt+5IXcxidXLrNvGLnzyzinhm2Cova2N0nOukoLbMeKZ1ZdcfqcrD/f//Tz7LyDrp
	SdC/9Vxr+prW/d8RpsRSnJFoqMVcVJwIAEPUr0BfAgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Wed, 16 Oct 2013 10:56:04 -0400
"Chen, Gong" <gong.chen@linux.intel.com> escreveu:

> After H/W error happens under FFM enabled mode, lots of information
> are shown but some important parts like DIMM location missed. This
> patch is used to show these extra fileds.
> 
> Original-author: Tony Luck <tony.luck@intel.com>
> Signed-off-by: Chen, Gong <gong.chen@linux.intel.com>
> Acked-by: Naveen N. Rao <naveen.n.rao@linux.vnet.ibm.com>

Reviewed-by: Mauro Carvalho Chehab <m.chehab@samsung.com>

> ---
>  drivers/acpi/apei/cper.c | 12 ++++++++++++
>  1 file changed, 12 insertions(+)
> 
> diff --git a/drivers/acpi/apei/cper.c b/drivers/acpi/apei/cper.c
> index 946ef52..b1a8a55 100644
> --- a/drivers/acpi/apei/cper.c
> +++ b/drivers/acpi/apei/cper.c
> @@ -28,6 +28,7 @@
>  #include <linux/module.h>
>  #include <linux/time.h>
>  #include <linux/cper.h>
> +#include <linux/dmi.h>
>  #include <linux/acpi.h>
>  #include <linux/pci.h>
>  #include <linux/aer.h>
> @@ -210,6 +211,8 @@ static void cper_print_mem(const char *pfx, const struct cper_sec_mem_err *mem)
>  		printk("%s""card: %d\n", pfx, mem->card);
>  	if (mem->validation_bits & CPER_MEM_VALID_MODULE)
>  		printk("%s""module: %d\n", pfx, mem->module);
> +	if (mem->validation_bits & CPER_MEM_VALID_RANK_NUMBER)
> +		printk("%s""rank: %d\n", pfx, mem->rank);
>  	if (mem->validation_bits & CPER_MEM_VALID_BANK)
>  		printk("%s""bank: %d\n", pfx, mem->bank);
>  	if (mem->validation_bits & CPER_MEM_VALID_DEVICE)
> @@ -232,6 +235,15 @@ static void cper_print_mem(const char *pfx, const struct cper_sec_mem_err *mem)
>  		       etype < ARRAY_SIZE(cper_mem_err_type_strs) ?
>  		       cper_mem_err_type_strs[etype] : "unknown");
>  	}
> +	if (mem->validation_bits & CPER_MEM_VALID_MODULE_HANDLE) {
> +		const char *bank = NULL, *device = NULL;
> +		dmi_memdev_name(mem->mem_dev_handle, &bank, &device);
> +		if (bank != NULL && device != NULL)
> +			printk("%s""DIMM location: %s %s", pfx, bank, device);
> +		else
> +			printk("%s""DIMM DMI handle: 0x%.4x",
> +			       pfx, mem->mem_dev_handle);
> +	}
>  }
>  
>  static const char *cper_pcie_port_type_strs[] = {


-- 

Cheers,
Mauro
