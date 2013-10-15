Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759449Ab3JOTTS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Oct 2013 15:19:18 -0400
Received: from e23smtp03.au.ibm.com ([202.81.31.145]:51895 "EHLO
	e23smtp03.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757102Ab3JOTTQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Oct 2013 15:19:16 -0400
Date: Wed, 16 Oct 2013 00:48:46 +0530
From: "Naveen N. Rao" <naveen.n.rao@linux.vnet.ibm.com>
To: "Chen, Gong" <gong.chen@linux.intel.com>
Cc: tony.luck@intel.com, bp@alien8.de, linux-kernel@vger.kernel.org,
        linux-acpi@vger.kernel.org
Subject: Re: [PATCH 6/8] ACPI, APEI, CPER: Enhance memory reporting capability
Message-ID: <20131015191846.GB4347@naverao1-tp.ibm.com>
References: <1381473166-29303-1-git-send-email-gong.chen@linux.intel.com>
 <1381473166-29303-7-git-send-email-gong.chen@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1381473166-29303-7-git-send-email-gong.chen@linux.intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13101519-6102-0000-0000-00000455DB77
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2013/10/11 02:32AM, Chen Gong wrote:
> After H/W error happens under FFM enabled mode, lots of information
> are shown but some important parts like DIMM location missed. This
> patch is used to show these extra fileds.
> 
> Original-author: Tony Luck <tony.luck@intel.com>
> Signed-off-by: Chen, Gong <gong.chen@linux.intel.com>
> ---
>  drivers/acpi/apei/cper.c | 12 ++++++++++++
>  1 file changed, 12 insertions(+)
> 

Acked-by: Naveen N. Rao <naveen.n.rao@linux.vnet.ibm.com>

> diff --git a/drivers/acpi/apei/cper.c b/drivers/acpi/apei/cper.c
> index 680230c..2a4389f 100644
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
> +			printk("%s""DIMM DMI handle: 0x%.4x", pfx,
> +					mem->mem_dev_handle);
> +	}
>  }
>  
>  static const char *cper_pcie_port_type_strs[] = {
> -- 
> 1.8.4.rc3
> 

