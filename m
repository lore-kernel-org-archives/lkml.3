Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756796AbaLIMms (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Dec 2014 07:42:48 -0500
Received: from mail-lb0-f173.google.com ([209.85.217.173]:60436 "EHLO
	mail-lb0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756575AbaLIMmq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Dec 2014 07:42:46 -0500
MIME-Version: 1.0
In-Reply-To: <20141209095843.GA3990@pd.tnic>
References: <20141209095843.GA3990@pd.tnic>
Date: Tue, 9 Dec 2014 13:42:44 +0100
Message-ID: <CAKv+Gu_F+o6NKb5JJ8ZQ7AJbjvASeQF1YcuUXv8seOMa5oaxgg@mail.gmail.com>
Subject: Re: Shorten efi regions output
From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
To: Borislav Petkov <bp@alien8.de>
Cc: linux-efi <linux-efi@vger.kernel.org>, Laszlo Ersek <lersek@redhat.com>,
        Matt Fleming <matt.fleming@intel.com>,
        Ricardo Neri <ricardo.neri-calderon@linux.intel.com>,
        lkml <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 9 December 2014 at 10:58, Borislav Petkov <bp@alien8.de> wrote:
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
> The vertical bar after "UC" is missing on purpose although this is not
> that totally correct if the region we're printing doesn't have the UC
> bit set. Then it would issue "|]" at the end but who cares - I'd like to
> not complicate this function unnecessarily.
>

I am fine with this change, but I have no strong opinion either way,
to be honest.

The |] thing is easily fixed, though.

[...]
> diff --git a/drivers/firmware/efi/efi.c b/drivers/firmware/efi/efi.c
> index 8590099ac148..6734072980ee 100644
> --- a/drivers/firmware/efi/efi.c
> +++ b/drivers/firmware/efi/efi.c
[...]
> @@ -490,15 +490,15 @@ char * __init efi_md_typeattr_format(char *buf, size_t size,
>                 snprintf(pos, size, "|attr=0x%016llx]",
>                          (unsigned long long)attr);
>         else
> -               snprintf(pos, size, "|%3s|%2s|%2s|%2s|%3s|%2s|%2s|%2s|%2s]",
> -                        attr & EFI_MEMORY_RUNTIME ? "RUN" : "",
> -                        attr & EFI_MEMORY_XP      ? "XP"  : "",
> -                        attr & EFI_MEMORY_RP      ? "RP"  : "",
> -                        attr & EFI_MEMORY_WP      ? "WP"  : "",
> -                        attr & EFI_MEMORY_UCE     ? "UCE" : "",
> -                        attr & EFI_MEMORY_WB      ? "WB"  : "",
> -                        attr & EFI_MEMORY_WT      ? "WT"  : "",
> -                        attr & EFI_MEMORY_WC      ? "WC"  : "",
> -                        attr & EFI_MEMORY_UC      ? "UC"  : "");
> +               snprintf(pos, size, "|%s%s%s%s%s%s%s%s%s]",

Drop the leading | here

> +                        attr & EFI_MEMORY_RUNTIME ? "RT|"  : "",
> +                        attr & EFI_MEMORY_XP      ? "XP|"  : "",
> +                        attr & EFI_MEMORY_RP      ? "RP|"  : "",
> +                        attr & EFI_MEMORY_WP      ? "WP|"  : "",
> +                        attr & EFI_MEMORY_UCE     ? "UCE|" : "",
> +                        attr & EFI_MEMORY_WB      ? "WB|"  : "",
> +                        attr & EFI_MEMORY_WT      ? "WT|"  : "",
> +                        attr & EFI_MEMORY_WC      ? "WC|"  : "",
> +                        attr & EFI_MEMORY_UC      ? "UC"   : "");

and move all the | to the beginning of the string here, including "UC"


>         return buf;
>  }
> --
> 2.0.0
>
>
> --
> Regards/Gruss,
>     Boris.
>
> Sent from a fat crate under my desk. Formatting is fine.
> --
