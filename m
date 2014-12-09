Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757480AbaLIPgG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Dec 2014 10:36:06 -0500
Received: from mx1.redhat.com ([209.132.183.28]:58466 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754232AbaLIPgD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Dec 2014 10:36:03 -0500
Message-ID: <548716C5.6000506@redhat.com>
Date: Tue, 09 Dec 2014 16:35:33 +0100
From: Laszlo Ersek <lersek@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.3.0
MIME-Version: 1.0
To: Borislav Petkov <bp@alien8.de>, linux-efi <linux-efi@vger.kernel.org>
CC: Ard Biesheuvel <ard.biesheuvel@linaro.org>,
        Matt Fleming <matt.fleming@intel.com>,
        Ricardo Neri <ricardo.neri-calderon@linux.intel.com>,
        lkml <linux-kernel@vger.kernel.org>
Subject: Re: Shorten efi regions output
References: <20141209095843.GA3990@pd.tnic>
In-Reply-To: <20141209095843.GA3990@pd.tnic>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/09/14 10:58, Borislav Petkov wrote:
> Hi guys,
> 
> so this decoded EFI regions output is nice but can we shorten it? It
> sticks too far out in the terminal more than anything else in dmesg and
> staring at it needs me to resize window and such. It probably is an even
> bigger problem if one's monitor hasn't switched to higher res early
> during boot.
> 
> So here's what I'm seeing with the latest EDKII:
> 
> [    0.000000] efi: EFI v2.40 by EDK II
> [    0.000000] efi:  ACPI=0x7ff2d000  ACPI 2.0=0x7ff2d014 
> [    0.000000] efi: mem00: [Conventional Memory|   |  |  |  |   |WB|WT|WC|UC] range=[0x0000000000000000-0x0000000000001000) (0MB)
> [    0.000000] efi: mem01: [Loader Data        |   |  |  |  |   |WB|WT|WC|UC] range=[0x0000000000001000-0x0000000000002000) (0MB)
> [    0.000000] efi: mem02: [Conventional Memory|   |  |  |  |   |WB|WT|WC|UC] range=[0x0000000000002000-0x000000000009f000) (0MB)
> [    0.000000] efi: mem03: [Loader Data        |   |  |  |  |   |WB|WT|WC|UC] range=[0x000000000009f000-0x00000000000a0000) (0MB)
> [    0.000000] efi: mem04: [Conventional Memory|   |  |  |  |   |WB|WT|WC|UC] range=[0x0000000000100000-0x0000000000820000) (7MB)
> [    0.000000] efi: mem05: [Boot Data          |   |  |  |  |   |WB|WT|WC|UC] range=[0x0000000000820000-0x0000000001000000) (7MB)
> [    0.000000] efi: mem06: [Loader Data        |   |  |  |  |   |WB|WT|WC|UC] range=[0x0000000001000000-0x0000000003cbc000) (44MB)
> [    0.000000] efi: mem07: [Conventional Memory|   |  |  |  |   |WB|WT|WC|UC] range=[0x0000000003cbc000-0x0000000004000000) (3MB)
> [    0.000000] efi: mem08: [Loader Data        |   |  |  |  |   |WB|WT|WC|UC] range=[0x0000000004000000-0x0000000005cbc000) (28MB)
> [    0.000000] efi: mem09: [Conventional Memory|   |  |  |  |   |WB|WT|WC|UC] range=[0x0000000005cbc000-0x000000003fffc000) (931MB)
> [    0.000000] efi: mem10: [Loader Data        |   |  |  |  |   |WB|WT|WC|UC] range=[0x000000003fffc000-0x0000000040000000) (0MB)
> [    0.000000] efi: mem11: [Conventional Memory|   |  |  |  |   |WB|WT|WC|UC] range=[0x0000000040000000-0x000000007c000000) (960MB)
> [    0.000000] efi: mem12: [Boot Data          |   |  |  |  |   |WB|WT|WC|UC] range=[0x000000007c000000-0x000000007c020000) (0MB)
> [    0.000000] efi: mem13: [Conventional Memory|   |  |  |  |   |WB|WT|WC|UC] range=[0x000000007c020000-0x000000007ebc5000) (43MB)
> [    0.000000] efi: mem14: [Loader Data        |   |  |  |  |   |WB|WT|WC|UC] range=[0x000000007ebc5000-0x000000007ebfe000) (0MB)
> [    0.000000] efi: mem15: [Boot Data          |   |  |  |  |   |WB|WT|WC|UC] range=[0x000000007ebfe000-0x000000007ebff000) (0MB)
> [    0.000000] efi: mem16: [Conventional Memory|   |  |  |  |   |WB|WT|WC|UC] range=[0x000000007ebff000-0x000000007ec03000) (0MB)
> [    0.000000] efi: mem17: [Boot Data          |   |  |  |  |   |WB|WT|WC|UC] range=[0x000000007ec03000-0x000000007ec05000) (0MB)
> [    0.000000] efi: mem18: [Loader Data        |   |  |  |  |   |WB|WT|WC|UC] range=[0x000000007ec05000-0x000000007ec06000) (0MB)
> [    0.000000] efi: mem19: [Boot Data          |   |  |  |  |   |WB|WT|WC|UC] range=[0x000000007ec06000-0x000000007ec07000) (0MB)
> [    0.000000] efi: mem20: [Loader Data        |   |  |  |  |   |WB|WT|WC|UC] range=[0x000000007ec07000-0x000000007ec08000) (0MB)
> [    0.000000] efi: mem21: [Boot Data          |   |  |  |  |   |WB|WT|WC|UC] range=[0x000000007ec08000-0x000000007ece7000) (0MB)
> [    0.000000] efi: mem22: [Boot Code          |   |  |  |  |   |WB|WT|WC|UC] range=[0x000000007ece7000-0x000000007ee3b000) (1MB)
> [    0.000000] efi: mem23: [Runtime Data       |RUN|  |  |  |   |WB|WT|WC|UC] range=[0x000000007ee3b000-0x000000007ee4e000) (0MB)
> [    0.000000] efi: mem24: [Boot Data          |   |  |  |  |   |WB|WT|WC|UC] range=[0x000000007ee4e000-0x000000007fd4e000) (15MB)
> [    0.000000] efi: mem25: [Boot Code          |   |  |  |  |   |WB|WT|WC|UC] range=[0x000000007fd4e000-0x000000007fece000) (1MB)
> [    0.000000] efi: mem26: [Runtime Code       |RUN|  |  |  |   |WB|WT|WC|UC] range=[0x000000007fece000-0x000000007fefe000) (0MB)
> [    0.000000] efi: mem27: [Runtime Data       |RUN|  |  |  |   |WB|WT|WC|UC] range=[0x000000007fefe000-0x000000007ff22000) (0MB)
> [    0.000000] efi: mem28: [Reserved           |   |  |  |  |   |WB|WT|WC|UC] range=[0x000000007ff22000-0x000000007ff26000) (0MB)
> [    0.000000] efi: mem29: [ACPI Reclaim Memory|   |  |  |  |   |WB|WT|WC|UC] range=[0x000000007ff26000-0x000000007ff2e000) (0MB)
> [    0.000000] efi: mem30: [ACPI Memory NVS    |   |  |  |  |   |WB|WT|WC|UC] range=[0x000000007ff2e000-0x000000007ff32000) (0MB)
> [    0.000000] efi: mem31: [Boot Data          |   |  |  |  |   |WB|WT|WC|UC] range=[0x000000007ff32000-0x000000007ffd0000) (0MB)
> [    0.000000] efi: mem32: [Runtime Data       |RUN|  |  |  |   |WB|WT|WC|UC] range=[0x000000007ffd0000-0x0000000080000000) (0MB)
> [    0.000000] efi: mem33: [Runtime Data       |RUN|  |  |  |   |  |  |  |UC] range=[0x00000000fff00000-0x0000000100000000) (1MB)
> 
> and here's with the proposed changes:
> 
> * regions get printed first so that vertical alignment gets preserved
> 
> * memory types come then, with shorter names but still readable (I hope :))
> 
> * efi mem attributes which are not set do not print the empty string.

I disagree with the patch in general, and I strongly disagree with this
specific change in particular. This part:

- breaks the alignment for the right side of the table

- completely defeats another of my goals with the original patch, which
  was to be able to get an overview of memory attributes *at a glance*.
  That only works if each column is strictly associated with one bit,
  and your gaze can slide over empty stretches.

  Please compare how you visually execute a search for the next
  runtime region (or the next non-WB line) before and after.

Your patch shaves off 30 characters of the width if I measured it right
(goes from 131 to 101.) I don't believe that would justify breaking the
alignment of the columns. For example, you could remove 15 characters
from the right just with "dmesg -t" (timestamps are probably not overly
important for printing the memmap).

Also, how the table looks on the character console while booting is of
absolutely no consequence (for me at least).

Anyway it's a matter of taste. I know you work with this every day so if
it doesn't meet your needs then I won't insist preserving it. I won't
NACK the patch it but I certainly won't ACK it either.

Thanks
Laszlo

> The vertical bar after "UC" is missing on purpose although this is not
> that totally correct if the region we're printing doesn't have the UC
> bit set. Then it would issue "|]" at the end but who cares - I'd like to
> not complicate this function unnecessarily.
> 
> This way the output fits much better in dmesg and we shorten it by 30ish
> columns while preserving it. Diff below.
> 
> [    0.000000] efi: EFI v2.40 by EDK II
> [    0.000000] efi:  ACPI=0x7ff2d000  ACPI 2.0=0x7ff2d014 
> [    0.000000] efi: mem00: [0x0000000000000000-0x0000000000001000) [Mem        |WB|WT|WC|UC] (0MB)
> [    0.000000] efi: mem01: [0x0000000000001000-0x0000000000002000) [LdrData    |WB|WT|WC|UC] (0MB)
> [    0.000000] efi: mem02: [0x0000000000002000-0x000000000009f000) [Mem        |WB|WT|WC|UC] (0MB)
> [    0.000000] efi: mem03: [0x000000000009f000-0x00000000000a0000) [LdrData    |WB|WT|WC|UC] (0MB)
> [    0.000000] efi: mem04: [0x0000000000100000-0x0000000000820000) [Mem        |WB|WT|WC|UC] (7MB)
> [    0.000000] efi: mem05: [0x0000000000820000-0x0000000001000000) [BootData   |WB|WT|WC|UC] (7MB)
> [    0.000000] efi: mem06: [0x0000000001000000-0x0000000003cbc000) [LdrData    |WB|WT|WC|UC] (44MB)
> [    0.000000] efi: mem07: [0x0000000003cbc000-0x0000000004000000) [Mem        |WB|WT|WC|UC] (3MB)
> [    0.000000] efi: mem08: [0x0000000004000000-0x0000000005cbc000) [LdrData    |WB|WT|WC|UC] (28MB)
> [    0.000000] efi: mem09: [0x0000000005cbc000-0x000000003fffc000) [Mem        |WB|WT|WC|UC] (931MB)
> [    0.000000] efi: mem10: [0x000000003fffc000-0x0000000040000000) [LdrData    |WB|WT|WC|UC] (0MB)
> [    0.000000] efi: mem11: [0x0000000040000000-0x000000007c000000) [Mem        |WB|WT|WC|UC] (960MB)
> [    0.000000] efi: mem12: [0x000000007c000000-0x000000007c020000) [BootData   |WB|WT|WC|UC] (0MB)
> [    0.000000] efi: mem13: [0x000000007c020000-0x000000007ebc5000) [Mem        |WB|WT|WC|UC] (43MB)
> [    0.000000] efi: mem14: [0x000000007ebc5000-0x000000007ebfe000) [LdrData    |WB|WT|WC|UC] (0MB)
> [    0.000000] efi: mem15: [0x000000007ebfe000-0x000000007ebff000) [BootData   |WB|WT|WC|UC] (0MB)
> [    0.000000] efi: mem16: [0x000000007ebff000-0x000000007ec03000) [Mem        |WB|WT|WC|UC] (0MB)
> [    0.000000] efi: mem17: [0x000000007ec03000-0x000000007ec05000) [BootData   |WB|WT|WC|UC] (0MB)
> [    0.000000] efi: mem18: [0x000000007ec05000-0x000000007ec06000) [LdrData    |WB|WT|WC|UC] (0MB)
> [    0.000000] efi: mem19: [0x000000007ec06000-0x000000007ec07000) [BootData   |WB|WT|WC|UC] (0MB)
> [    0.000000] efi: mem20: [0x000000007ec07000-0x000000007ec08000) [LdrData    |WB|WT|WC|UC] (0MB)
> [    0.000000] efi: mem21: [0x000000007ec08000-0x000000007ece7000) [BootData   |WB|WT|WC|UC] (0MB)
> [    0.000000] efi: mem22: [0x000000007ece7000-0x000000007ee3b000) [BootCode   |WB|WT|WC|UC] (1MB)
> [    0.000000] efi: mem23: [0x000000007ee3b000-0x000000007ee4e000) [RtData     |RT|WB|WT|WC|UC] (0MB)
> [    0.000000] efi: mem24: [0x000000007ee4e000-0x000000007fd4e000) [BootData   |WB|WT|WC|UC] (15MB)
> [    0.000000] efi: mem25: [0x000000007fd4e000-0x000000007fece000) [BootCode   |WB|WT|WC|UC] (1MB)
> [    0.000000] efi: mem26: [0x000000007fece000-0x000000007fefe000) [RtCode     |RT|WB|WT|WC|UC] (0MB)
> [    0.000000] efi: mem27: [0x000000007fefe000-0x000000007ff22000) [RtData     |RT|WB|WT|WC|UC] (0MB)
> [    0.000000] efi: mem28: [0x000000007ff22000-0x000000007ff26000) [Reserved   |WB|WT|WC|UC] (0MB)
> [    0.000000] efi: mem29: [0x000000007ff26000-0x000000007ff2e000) [ACPIRclMem |WB|WT|WC|UC] (0MB)
> [    0.000000] efi: mem30: [0x000000007ff2e000-0x000000007ff32000) [ACPIMemNVS |WB|WT|WC|UC] (0MB)
> [    0.000000] efi: mem31: [0x000000007ff32000-0x000000007ffd0000) [BootData   |WB|WT|WC|UC] (0MB)
> [    0.000000] efi: mem32: [0x000000007ffd0000-0x0000000080000000) [RtData     |RT|WB|WT|WC|UC] (0MB)
> [    0.000000] efi: mem33: [0x00000000fff00000-0x0000000100000000) [RtData     |RT|UC] (1MB)
> 
> ---
>  arch/x86/platform/efi/efi.c |  5 +++--
>  drivers/firmware/efi/efi.c  | 52 ++++++++++++++++++++++-----------------------
>  2 files changed, 29 insertions(+), 28 deletions(-)
> 
> diff --git a/arch/x86/platform/efi/efi.c b/arch/x86/platform/efi/efi.c
> index 6a1ffd777db0..4b76256dcb31 100644
> --- a/arch/x86/platform/efi/efi.c
> +++ b/arch/x86/platform/efi/efi.c
> @@ -203,10 +203,11 @@ static void __init print_efi_memmap(void)
>  		char buf[64];
>  
>  		md = p;
> -		pr_info("mem%02u: %s range=[0x%016llx-0x%016llx) (%lluMB)\n",
> -			i, efi_md_typeattr_format(buf, sizeof(buf), md),
> +		pr_info("mem%02u: [0x%016llx-0x%016llx) %s (%lluMB)\n",
> +			i,
>  			md->phys_addr,
>  			md->phys_addr + (md->num_pages << EFI_PAGE_SHIFT),
> +			efi_md_typeattr_format(buf, sizeof(buf), md),
>  			(md->num_pages >> (20 - EFI_PAGE_SHIFT)));
>  	}
>  #endif  /*  EFI_DEBUG  */
> diff --git a/drivers/firmware/efi/efi.c b/drivers/firmware/efi/efi.c
> index 8590099ac148..6734072980ee 100644
> --- a/drivers/firmware/efi/efi.c
> +++ b/drivers/firmware/efi/efi.c
> @@ -446,21 +446,23 @@ int __init efi_get_fdt_params(struct efi_fdt_params *params, int verbose)
>  }
>  #endif /* CONFIG_EFI_PARAMS_FROM_FDT */
>  
> +/* Update this if you're adding a longer string */
> +#define MEM_TYPE_MAXLEN 11
>  static __initdata char memory_type_name[][20] = {
>  	"Reserved",
> -	"Loader Code",
> -	"Loader Data",
> -	"Boot Code",
> -	"Boot Data",
> -	"Runtime Code",
> -	"Runtime Data",
> -	"Conventional Memory",
> -	"Unusable Memory",
> -	"ACPI Reclaim Memory",
> -	"ACPI Memory NVS",
> -	"Memory Mapped I/O",
> -	"MMIO Port Space",
> -	"PAL Code"
> +	"LdrCode",
> +	"LdrData",
> +	"BootCode",
> +	"BootData",
> +	"RtCode",
> +	"RtData",
> +	"Mem",
> +	"UnusableMem",
> +	"ACPIRclMem",
> +	"ACPIMemNVS",
> +	"MMappedI/O",
> +	"MMIOPortSpc",
> +	"PALCode"
>  };
>  
>  char * __init efi_md_typeattr_format(char *buf, size_t size,
> @@ -474,9 +476,7 @@ char * __init efi_md_typeattr_format(char *buf, size_t size,
>  	if (md->type >= ARRAY_SIZE(memory_type_name))
>  		type_len = snprintf(pos, size, "[type=%u", md->type);
>  	else
> -		type_len = snprintf(pos, size, "[%-*s",
> -				    (int)(sizeof(memory_type_name[0]) - 1),
> -				    memory_type_name[md->type]);
> +		type_len = snprintf(pos, size, "[%-*s", MEM_TYPE_MAXLEN, memory_type_name[md->type]);
>  	if (type_len >= size)
>  		return buf;
>  
> @@ -490,15 +490,15 @@ char * __init efi_md_typeattr_format(char *buf, size_t size,
>  		snprintf(pos, size, "|attr=0x%016llx]",
>  			 (unsigned long long)attr);
>  	else
> -		snprintf(pos, size, "|%3s|%2s|%2s|%2s|%3s|%2s|%2s|%2s|%2s]",
> -			 attr & EFI_MEMORY_RUNTIME ? "RUN" : "",
> -			 attr & EFI_MEMORY_XP      ? "XP"  : "",
> -			 attr & EFI_MEMORY_RP      ? "RP"  : "",
> -			 attr & EFI_MEMORY_WP      ? "WP"  : "",
> -			 attr & EFI_MEMORY_UCE     ? "UCE" : "",
> -			 attr & EFI_MEMORY_WB      ? "WB"  : "",
> -			 attr & EFI_MEMORY_WT      ? "WT"  : "",
> -			 attr & EFI_MEMORY_WC      ? "WC"  : "",
> -			 attr & EFI_MEMORY_UC      ? "UC"  : "");
> +		snprintf(pos, size, "|%s%s%s%s%s%s%s%s%s]",
> +			 attr & EFI_MEMORY_RUNTIME ? "RT|"  : "",
> +			 attr & EFI_MEMORY_XP      ? "XP|"  : "",
> +			 attr & EFI_MEMORY_RP      ? "RP|"  : "",
> +			 attr & EFI_MEMORY_WP      ? "WP|"  : "",
> +			 attr & EFI_MEMORY_UCE     ? "UCE|" : "",
> +			 attr & EFI_MEMORY_WB      ? "WB|"  : "",
> +			 attr & EFI_MEMORY_WT      ? "WT|"  : "",
> +			 attr & EFI_MEMORY_WC      ? "WC|"  : "",
> +			 attr & EFI_MEMORY_UC      ? "UC"   : "");
>  	return buf;
>  }
> 

