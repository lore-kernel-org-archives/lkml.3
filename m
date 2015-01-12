Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752753AbbALLqI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jan 2015 06:46:08 -0500
Received: from mail-wi0-f179.google.com ([209.85.212.179]:41281 "EHLO
	mail-wi0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751175AbbALLqE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jan 2015 06:46:04 -0500
Date: Mon, 12 Jan 2015 11:46:00 +0000
From: Matt Fleming <matt@codeblueprint.co.uk>
To: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Cc: leif.lindholm@linaro.org, roy.franz@linaro.org, matt.fleming@intel.com,
        will.deacon@arm.com, catalin.marinas@arm.com,
        linux-arm-kernel@lists.infradead.org, linux-efi@vger.kernel.org,
        bp@alien8.de, msalter@redhat.com, geoff.levand@linaro.org,
        dyoung@redhat.com, mark.rutland@arm.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v5 6/8] arm64/efi: move SetVirtualAddressMap() to UEFI
 stub
Message-ID: <20150112114600.GE26589@codeblueprint.co.uk>
References: <1420742914-2404-1-git-send-email-ard.biesheuvel@linaro.org>
 <1420742914-2404-7-git-send-email-ard.biesheuvel@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1420742914-2404-7-git-send-email-ard.biesheuvel@linaro.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 08 Jan, at 06:48:32PM, Ard Biesheuvel wrote:
> @@ -46,4 +54,26 @@ extern void efi_idmap_init(void);
>  
>  #define EFI_ALLOC_ALIGN		SZ_64K
>  
> +/*
> + * On ARM systems, virtually remapped UEFI runtime services are set up in three
> + * distinct stages:
> + * - The stub retrieves the final version of the memory map from UEFI, populates
> + *   the virt_addr fields and calls the SetVirtualAddressMap() [SVAM] runtime
> + *   service to communicate the new mapping to the firmware (Note that the new
> + *   mapping is not live at this time)
> + * - During early boot, the page tables are allocated and populated based on the
> + *   virt_addr fields in the memory map, but only if all descriptors with the
> + *   EFI_MEMORY_RUNTIME attribute have a non-zero value for virt_addr. If this
> + *   succeeds, the EFI_VIRTMAP flag is set to indicate that the virtual mappings
> + *   have been installed successfully.
> + * - During an early initcall(), the UEFI Runtime Services are enabled and the
> + *   EFI_RUNTIME_SERVICES bit set if some conditions are met, i.e., we need a
> + *   non-early mapping of the UEFI system table, and we need to have the virtmap
> + *   installed.
> + */
> +#define EFI_VIRTMAP		EFI_ARCH_1

Lucid. Thanks, Ard!

-- 
Matt Fleming, Intel Open Source Technology Center
