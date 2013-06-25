Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753585Ab3FYSqn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Jun 2013 14:46:43 -0400
Received: from smtp.codeaurora.org ([198.145.11.231]:60971 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753195Ab3FYSqk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Jun 2013 14:46:40 -0400
Message-ID: <51C9E58E.5050004@codeaurora.org>
Date: Tue, 25 Jun 2013 14:46:38 -0400
From: Christopher Covington <cov@codeaurora.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130106 Thunderbird/17.0.2
MIME-Version: 1.0
To: Leif Lindholm <leif.lindholm@linaro.org>
CC: linux-arm-kernel@lists.infradead.org, linux-efi@vger.kernel.org,
        patches@linaro.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, matt.fleming@intel.com,
        tglx@linutronix.de, hpa@linux.intel.com
Subject: Re: [PATCH 1/4] Documentation: arm: [U]EFI runtime services
References: <1372183863-11333-1-git-send-email-leif.lindholm@linaro.org> <1372183863-11333-2-git-send-email-leif.lindholm@linaro.org>
In-Reply-To: <1372183863-11333-2-git-send-email-leif.lindholm@linaro.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/25/2013 02:11 PM, Leif Lindholm wrote:
> This patch provides documentation of the [U]EFI runtime services and
> configuration features.
> 
> Signed-off-by: Leif Lindholm <leif.lindholm@linaro.org>
> ---
>  Documentation/arm/00-INDEX |    3 +++
>  Documentation/arm/uefi.txt |   39 +++++++++++++++++++++++++++++++++++++++
>  2 files changed, 42 insertions(+)
>  create mode 100644 Documentation/arm/uefi.txt
> 
> diff --git a/Documentation/arm/00-INDEX b/Documentation/arm/00-INDEX
> index 4978456..87e01d1 100644
> --- a/Documentation/arm/00-INDEX
> +++ b/Documentation/arm/00-INDEX
> @@ -36,3 +36,6 @@ nwfpe/
>  	- NWFPE floating point emulator documentation
>  swp_emulation
>  	- SWP/SWPB emulation handler/logging description
> +
> +uefi.txt
> +	- [U]EFI configuration and runtime services documentation
> diff --git a/Documentation/arm/uefi.txt b/Documentation/arm/uefi.txt
> new file mode 100644
> index 0000000..5c48271
> --- /dev/null
> +++ b/Documentation/arm/uefi.txt
> @@ -0,0 +1,39 @@
> +The nomenclature EFI and UEFI are used interchangeably in this document.
> +
> +The implementation depends on receiving pointers to the UEFI memory map
> +and System Table in a Flattened Device Tree - so is only available with
> +CONFIG_OF.
> +
> +It (early) parses the FDT for the following parameters:
> +- 'efi-system-table':
> +  Physical address of the system table. (required)
> +- 'efi-runtime-mmap':
> +  Physical address of an EFI memory map, containing at least
> +  the regions to be preserved. (required)
> +- 'efi-runtime-mmap-size':
> +  Size in bytes of the provided memory map. (required)
> +- 'efi-mmap-desc-size':
> +  Size of each descriptor in the memory map. (override default)
> +- 'efi-mmap-desc-ver':
> +  Memory descriptor format version. (override default)
> +
> +Since UEFI firmware on ARM systems are required to use a 1:1 memory map
> +even on LPAE-capable systems, the above fields are 32-bit regardless.
> +
> +It also depends on early_ioremap to parse the memory map and preserve
> +the regions required for runtime services.
> +
> +For actually enabling [U]EFI support, enable:
> +- CONFIG_EFI=y
> +- CONFIG_EFI_VARS=y or m
> +
> +After the kernel has mapped the required regions into its address space,
> +a SetVirtualAddressMap() call is made into UEFI in order to update
> +relocations. This call must be performed with all the code in a 1:1
> +mapping. This implementation achieves this by temporarily disabling the
> +MMU for the duration of this call. This can only be done safely:
> +- before secondary CPUs are brought online.
> +- after early_initcalls have completed, sinze it uses setup_mm_for_reboot().

since

> +
> +For verbose debug messages, specify 'uefi_debug' on the kernel command
> +line.
> 

Christopher

-- 
Employee of Qualcomm Innovation Center, Inc.
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum,
hosted by the Linux Foundation.
