Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756018Ab3HFNTt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Aug 2013 09:19:49 -0400
Received: from arkanian.console-pimps.org ([212.110.184.194]:56273 "EHLO
	arkanian.console-pimps.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755099Ab3HFNTr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Aug 2013 09:19:47 -0400
Date: Tue, 6 Aug 2013 14:19:42 +0100
From: Matt Fleming <matt@console-pimps.org>
To: Roy Franz <roy.franz@linaro.org>
Cc: linux-kernel@vger.kernel.org, linux-efi@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, matt.fleming@intel.com,
        linux@arm.linux.org.uk, leif.lindholm@linaro.org
Subject: Re: [PATCH 4/7] Add proper definitions for some EFI function
 pointers.
Message-ID: <20130806131942.GW2515@console-pimps.org>
References: <1375478948-22562-1-git-send-email-roy.franz@linaro.org>
 <1375478948-22562-5-git-send-email-roy.franz@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1375478948-22562-5-git-send-email-roy.franz@linaro.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 02 Aug, at 02:29:05PM, Roy Franz wrote:
> The x86/AMD64 EFI stubs must us a call wrapper to convert between
> the Linux and EFI ABIs, so void pointers are sufficient.  For ARM,
> the ABIs are compatible, so we can directly invoke the function
> pointers.  The functions that are used by the ARM stub are updated
> to match the EFI definitions.
> 
> Signed-off-by: Roy Franz <roy.franz@linaro.org>
> ---
>  include/linux/efi.h |   61 +++++++++++++++++++++++++++++++++++++--------------
>  1 file changed, 44 insertions(+), 17 deletions(-)

[...]

> @@ -96,6 +98,26 @@ typedef	struct {
>  #define EFI_MEMORY_DESCRIPTOR_VERSION	1
>  
>  #define EFI_PAGE_SHIFT		12
> +#define EFI_PAGE_SIZE		(1UL << EFI_PAGE_SHIFT)
> +
> +typedef enum {
> +	EfiReservedMemoryType,
> +	EfiLoaderCode,
> +	EfiLoaderData,
> +	EfiBootServicesCode,
> +	EfiBootServicesData,
> +	EfiRuntimeServicesCode,
> +	EfiRuntimeServicesData,
> +	EfiConventionalMemory,
> +	EfiUnusableMemory,
> +	EfiACPIReclaimMemory,
> +	EfiACPIMemoryNVS,
> +	EfiMemoryMappedIO,
> +	EfiMemoryMappedIOPortSpace,
> +	EfiPalCode,
> +	EfiMaxMemoryType
> +} EFI_MEMORY_TYPE;
> +

These enums aren't used anywhere in your patches from what I can see and
we already have #define's for all these values, e.g. EFI_RESERVED_TYPE.

-- 
Matt Fleming, Intel Open Source Technology Center
