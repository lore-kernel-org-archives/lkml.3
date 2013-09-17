Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751608Ab3IQFZR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Sep 2013 01:25:17 -0400
Received: from us02smtp1.synopsys.com ([198.182.60.75]:56819 "EHLO
	vaxjo.synopsys.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751338Ab3IQFZO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Sep 2013 01:25:14 -0400
Message-ID: <5237E7A9.5070703@synopsys.com>
Date: Tue, 17 Sep 2013 10:54:57 +0530
From: Vineet Gupta <Vineet.Gupta1@synopsys.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130803 Thunderbird/17.0.8
MIME-Version: 1.0
To: Rob Herring <rob.herring@calxeda.com>
CC: lkml <linux-kernel@vger.kernel.org>,
        "devicetree-discuss@lists.ozlabs.org" 
	<devicetree-discuss@lists.ozlabs.org>,
        grant Likely <grant.likely@secretlab.ca>
Subject: Re: [PATCH 03/28] of: create unflatten_and_copy_device_tree
References: <1379372965-22359-1-git-send-email-robherring2@gmail.com> <1379372965-22359-4-git-send-email-robherring2@gmail.com>
In-Reply-To: <1379372965-22359-4-git-send-email-robherring2@gmail.com>
X-Enigmail-Version: 1.5.2
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.12.197.111]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/17/2013 04:38 AM, Rob Herring wrote:
> From: Rob Herring <rob.herring-bsGFqQB8/DxBDgjK7y7TUQ@public.gmane.org>
> 
> Several architectures using DT support built-in dtb's in the init
> section. These platforms need to copy the dtb from init since the
> strings are referenced after unflattening. Every arch has their own
> copying routine which do the same thing. Create a common function,
> unflatten_and_copy_device_tree, to copy the dtb when unflattening the
> dtb.
> 
> Signed-off-by: Rob Herring <rob.herring-bsGFqQB8/DxBDgjK7y7TUQ@public.gmane.org>
> Cc: Grant Likely <grant.likely-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
> ---
>  drivers/of/fdt.c       | 13 +++++++++++++
>  include/linux/of_fdt.h |  2 ++
>  2 files changed, 15 insertions(+)
> 
> diff --git a/drivers/of/fdt.c b/drivers/of/fdt.c
> index 229dd9d..eca1810 100644
> --- a/drivers/of/fdt.c
> +++ b/drivers/of/fdt.c
> @@ -802,6 +802,19 @@ void __init unflatten_device_tree(void)
>  	of_alias_scan(early_init_dt_alloc_memory_arch);
>  }
>  
> +void __init unflatten_and_copy_device_tree(void)
> +{

Can we add a comment here why exactly is the copy needed (unflattening doesn't
copy strings which are referenced to by the DT APIs). Will help first time readers.


> +	int size = __be32_to_cpu(initial_boot_params->totalsize);
> +	void *dt = early_init_dt_alloc_memory_arch(size,
> +		__alignof__(struct boot_param_header));
> +
> +	if (dt) {
> +		memcpy(dt, initial_boot_params, size);
> +		initial_boot_params = dt;
> +	}
> +	unflatten_device_tree();
> +}
> +
>  #endif /* CONFIG_OF_EARLY_FLATTREE */
>  

