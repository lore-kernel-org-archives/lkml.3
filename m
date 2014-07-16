Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754676AbaGPXiq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jul 2014 19:38:46 -0400
Received: from terminus.zytor.com ([198.137.202.10]:47056 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752818AbaGPXim (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jul 2014 19:38:42 -0400
Message-ID: <53C70CCC.2080109@zytor.com>
Date: Wed, 16 Jul 2014 16:37:48 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Hanjun Guo <hanjun.guo@linaro.org>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>
CC: Catalin Marinas <catalin.marinas@arm.com>,
        Graeme Gregory <graeme.gregory@linaro.org>,
        Tony Luck <tony.luck@intel.com>, Thomas Gleixner <tglx@linutronix.de>,
        linux-acpi@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, linaro-acpi@lists.linaro.org
Subject: Re: [PATCH v2 1/3] ACPI: ARM64 does not have a BIOS add config for
 BIOS table scan.
References: <1404898746-6685-1-git-send-email-hanjun.guo@linaro.org> <1404898746-6685-2-git-send-email-hanjun.guo@linaro.org>
In-Reply-To: <1404898746-6685-2-git-send-email-hanjun.guo@linaro.org>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/09/2014 02:39 AM, Hanjun Guo wrote:
> From: Graeme Gregory <graeme.gregory@linaro.org>
> 
> With the addition of ARM64 that does not have a traditional BIOS to
> scan, add a config option which is selected on x86 and ia64 to do
> the traditional BIOS scanning for tables.
> 
> Signed-off-by: Graeme Gregory <graeme.gregory@linaro.org>
> Signed-off-by: Hanjun Guo <hanjun.guo@linaro.org>
> ---
>  arch/ia64/Kconfig    |    1 +
>  arch/x86/Kconfig     |    1 +
>  drivers/acpi/Kconfig |    3 +++
>  drivers/acpi/osl.c   |    4 +++-
>  4 files changed, 8 insertions(+), 1 deletion(-)
> 
> diff --git a/arch/ia64/Kconfig b/arch/ia64/Kconfig
> index 2f3abcf..c54bd7e 100644
> --- a/arch/ia64/Kconfig
> +++ b/arch/ia64/Kconfig
> @@ -47,6 +47,7 @@ config IA64
>  	select MODULES_USE_ELF_RELA
>  	select ARCH_USE_CMPXCHG_LOCKREF
>  	select HAVE_ARCH_AUDITSYSCALL
> +	select ACPI_LEGACY_TABLES_LOOKUP if ACPI
>  	default y
>  	help
>  	  The Itanium Processor Family is Intel's 64-bit successor to

This shouldn't actually be set on IA64, should it?  IA64 doesn't have
BIOS, either, it has EFI/UEFI, like ARM64...

	-hpa

