Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752551AbaFAHyZ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Jun 2014 03:54:25 -0400
Received: from a.ns.miles-group.at ([95.130.255.143]:47834 "EHLO radon.swed.at"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750939AbaFAHyY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Jun 2014 03:54:24 -0400
Message-ID: <538ADC2C.6060902@nod.at>
Date: Sun, 01 Jun 2014 09:54:20 +0200
From: Richard Weinberger <richard@nod.at>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.1.0
MIME-Version: 1.0
To: Real Name <enjoymindful@gmail.com>,
        user-mode-linux-devel@lists.sourceforge.net
CC: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] delete unnecessary bootmem struct page array
References: <1401582246-30025-1-git-send-email-enjoymindful@gmail.com>
In-Reply-To: <1401582246-30025-1-git-send-email-enjoymindful@gmail.com>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

Am 01.06.2014 02:24, schrieb Real Name:
> 1) uml kernel bootmem managed through bootmem_data->node_bootmem_map,
> not struct page array, so it is unnecessary.
> 
> 2) the struct page array allocate has been pointer by a *loacl* pointer
> struct page *map in init_maps function. The array can't be access after
> the init_maps exit. As a result, there is about 1% of total memory leak.

Please add a Signed-off-by tag using your real name.

Thanks,
//richard

> ---
>  arch/um/kernel/um_arch.c | 6 ------
>  1 file changed, 6 deletions(-)
> 
> diff --git a/arch/um/kernel/um_arch.c b/arch/um/kernel/um_arch.c
> index 016adf0..d4c98d1 100644
> --- a/arch/um/kernel/um_arch.c
> +++ b/arch/um/kernel/um_arch.c
> @@ -348,12 +348,6 @@ int __init linux_main(int argc, char **argv)
>  	start_vm = VMALLOC_START;
>  
>  	setup_physmem(uml_physmem, uml_reserved, physmem_size, highmem);
> -	if (init_maps(physmem_size, iomem_size, highmem)) {
> -		printf("Failed to allocate mem_map for %Lu bytes of physical "
> -		       "memory and %Lu bytes of highmem\n", physmem_size,
> -		       highmem);
> -		exit(1);
> -	}
>  
>  	virtmem_size = physmem_size;
>  	stack = (unsigned long) argv;
> 
