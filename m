Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754872Ab3KUQtj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Nov 2013 11:49:39 -0500
Received: from mail.skyhub.de ([78.46.96.112]:39654 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753575Ab3KUQth (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Nov 2013 11:49:37 -0500
Date: Thu, 21 Nov 2013 17:49:29 +0100
From: Borislav Petkov <bp@alien8.de>
To: dyoung@redhat.com
Cc: linux-kernel@vger.kernel.org, linux-efi@vger.kernel.org, x86@kernel.org,
        mjg59@srcf.ucam.org, hpa@zytor.com,
        James.Bottomley@HansenPartnership.com, vgoyal@redhat.com,
        ebiederm@xmission.com, horms@verge.net.au, kexec@lists.infradead.org,
        greg@kroah.com, matt@console-pimps.org, toshi.kani@hp.com
Subject: Re: [patch 4/9 v3] efi: cleanup efi_enter_virtual_mode function
Message-ID: <20131121164929.GM26009@pd.tnic>
References: <20131121061704.363730447@dhcp-16-126.nay.redhat.com>
 <20131121061754.304016344@dhcp-16-126.nay.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20131121061754.304016344@dhcp-16-126.nay.redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 21, 2013 at 02:17:08PM +0800, dyoung@redhat.com wrote:
> Add two small functions:
> efi_merge_regions and efi_map_regions, efi_enter_virtual_mode
> calls them instead of embedding two long for loop.
> 
> v1->v2:
> refresh; coding style fixes.
> 
> v2->v3:
> Toshi Kani:
> remove unused variable
> Matt: check return value of krealloc.
> 
> Signed-off-by: Dave Young <dyoung@redhat.com>

Same short comment nitpick as earlier :)

Otherwise:

Acked-by: Borislav Petkov <bp@suse.de>

> ---
>  arch/x86/platform/efi/efi.c |  109 ++++++++++++++++++++++++++------------------
>  1 file changed, 66 insertions(+), 43 deletions(-)
> 
> --- efi.orig/arch/x86/platform/efi/efi.c
> +++ efi/arch/x86/platform/efi/efi.c

[ … ]

> @@ -837,6 +805,18 @@ void __init efi_enter_virtual_mode(void)
>  		prev_md = md;
>  
>  	}
> +}
> +
> +/*
> + * Map efi memory ranges for runtime serivce and
> + * update new_memmap with virtual addresses.
> + */

Stretch comment to 80 cols:

/*
 * Map efi memory ranges for runtime serivce and update new_memmap with virtual
 * addresses.
 */

like it is customary for the rest of the file.

> +static void * __init efi_map_regions(int *count)
> +{
> +	efi_memory_desc_t *md;
> +	void *p, *new_memmap = NULL;
> +	unsigned long size;
> +	u64 end, systab;
>  
>  	for (p = memmap.map; p < memmap.map_end; p += memmap.desc_size) {
>  		md = p;

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
