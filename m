Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932890AbbAIPte (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Jan 2015 10:49:34 -0500
Received: from foss-mx-na.foss.arm.com ([217.140.108.86]:58909 "EHLO
	foss-mx-na.foss.arm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757246AbbAIPtc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Jan 2015 10:49:32 -0500
Date: Fri, 9 Jan 2015 15:49:24 +0000
From: Will Deacon <will.deacon@arm.com>
To: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Cc: "leif.lindholm@linaro.org" <leif.lindholm@linaro.org>,
        "roy.franz@linaro.org" <roy.franz@linaro.org>,
        "matt.fleming@intel.com" <matt.fleming@intel.com>,
        Catalin Marinas <Catalin.Marinas@arm.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-efi@vger.kernel.org" <linux-efi@vger.kernel.org>,
        "bp@alien8.de" <bp@alien8.de>,
        "msalter@redhat.com" <msalter@redhat.com>,
        "geoff.levand@linaro.org" <geoff.levand@linaro.org>,
        "dyoung@redhat.com" <dyoung@redhat.com>,
        Mark Rutland <Mark.Rutland@arm.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v5 7/8] arm64/efi: remove free_boot_services() and friends
Message-ID: <20150109154924.GH11258@arm.com>
References: <1420742914-2404-1-git-send-email-ard.biesheuvel@linaro.org>
 <1420742914-2404-8-git-send-email-ard.biesheuvel@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1420742914-2404-8-git-send-email-ard.biesheuvel@linaro.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 08, 2015 at 06:48:33PM +0000, Ard Biesheuvel wrote:
> Now that we are calling SetVirtualAddressMap() from the stub, there is no
> need to reserve boot-only memory regions, which implies that there is also
> no reason to free them again later.
> 
> Acked-by: Leif Lindholm <leif.lindholm@linaro.org>
> Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
> ---
>  arch/arm64/kernel/efi.c | 123 +-----------------------------------------------
>  1 file changed, 1 insertion(+), 122 deletions(-)

[...]

> -static void __init free_boot_services(void)
> -{
> -	u64 total_freed = 0;
> -	u64 keep_end, free_start, free_end;
> -	efi_memory_desc_t *md;
> -
> -	/*
> -	 * If kernel uses larger pages than UEFI, we have to be careful
> -	 * not to inadvertantly free memory we want to keep if there is
> -	 * overlap at the kernel page size alignment. We do not want to
> -	 * free is_reserve_region() memory nor the UEFI memmap itself.
> -	 *
> -	 * The memory map is sorted, so we keep track of the end of
> -	 * any previous region we want to keep, remember any region
> -	 * we want to free and defer freeing it until we encounter
> -	 * the next region we want to keep. This way, before freeing
> -	 * it, we can clip it as needed to avoid freeing memory we
> -	 * want to keep for UEFI.
> -	 */
> -
> -	keep_end = 0;
> -	free_start = 0;
> -
> -	for_each_efi_memory_desc(&memmap, md) {
> -		u64 paddr, npages, size;

I'm glad to see the back of this function, thanks.

Acked-by: Will Deacon <will.deacon@arm.com>

Will
