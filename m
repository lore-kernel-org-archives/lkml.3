Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754727Ab3LTQOG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Dec 2013 11:14:06 -0500
Received: from mail-ig0-f174.google.com ([209.85.213.174]:39200 "EHLO
	mail-ig0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752575Ab3LTQOE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Dec 2013 11:14:04 -0500
X-Greylist: delayed 82645 seconds by postgrey-1.27 at vger.kernel.org; Fri, 20 Dec 2013 11:14:04 EST
Message-ID: <52B46CC7.7060903@gmail.com>
Date: Fri, 20 Dec 2013 08:13:59 -0800
From: David Daney <ddaney.cavm@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130625 Thunderbird/17.0.7
MIME-Version: 1.0
To: Michal Simek <michal.simek@xilinx.com>
CC: linux-kernel@vger.kernel.org, monstr@monstr.eu,
        David Daney <david.daney@cavium.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will.deacon@arm.com>, microblaze-uclinux@itee.uq.edu.au
Subject: Re: [PATCH] microblaze: extable: Sort the exception table at build
 time
References: <3e05730caf4d945ac510b4657c4c4cf6f2e1b6f4.1387531751.git.michal.simek@xilinx.com>
In-Reply-To: <3e05730caf4d945ac510b4657c4c4cf6f2e1b6f4.1387531751.git.michal.simek@xilinx.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/20/2013 01:29 AM, Michal Simek wrote:
> Sort the exception table at build-time rather than during boot.
>
> Microblaze is the same case as AARCH64 that's why
> EM_MICROBLAZE conditional check was added to allow
> cross-compilation on machines which are not running
> the latest libc-dev.
>
> Inspired by AARCH64 commit:
> "arm64: extable: sort the exception table at build time"
> (sha1: adace89562c7a9645b8dc84f6e1ac7ba8756094e)
>
> Signed-off-by: Michal Simek <michal.simek@xilinx.com>

This seems plausible, I didn't test it, but this is how it is supposed 
to work, so...

Acked-by: David Daney <david.daney@cavium.com>


> ---
>
>   arch/microblaze/Kconfig | 1 +
>   scripts/sortextable.c   | 5 +++++
>   2 files changed, 6 insertions(+)
>
> diff --git a/arch/microblaze/Kconfig b/arch/microblaze/Kconfig
> index e23cccd..8d581ab 100644
> --- a/arch/microblaze/Kconfig
> +++ b/arch/microblaze/Kconfig
> @@ -30,6 +30,7 @@ config MICROBLAZE
>   	select MODULES_USE_ELF_RELA
>   	select CLONE_BACKWARDS3
>   	select CLKSRC_OF
> +	select BUILDTIME_EXTABLE_SORT
>
>   config SWAP
>   	def_bool n
> diff --git a/scripts/sortextable.c b/scripts/sortextable.c
> index 7941fbd..cc49062 100644
> --- a/scripts/sortextable.c
> +++ b/scripts/sortextable.c
> @@ -39,6 +39,10 @@
>   #define EM_AARCH64	183
>   #endif
>
> +#ifndef EM_MICROBLAZE
> +#define EM_MICROBLAZE	189
> +#endif
> +
>   static int fd_map;	/* File descriptor for file being modified. */
>   static int mmap_failed; /* Boolean flag. */
>   static void *ehdr_curr; /* current ElfXX_Ehdr *  for resource cleanup */
> @@ -275,6 +279,7 @@ do_file(char const *const fname)
>   	case EM_ARCOMPACT:
>   	case EM_ARM:
>   	case EM_AARCH64:
> +	case EM_MICROBLAZE:
>   	case EM_MIPS:
>   		break;
>   	}  /* end switch */
> --
> 1.8.2.3
>

