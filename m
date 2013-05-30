Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933644Ab3E3P23 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 May 2013 11:28:29 -0400
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:42805 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932445Ab3E3P2W (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 May 2013 11:28:22 -0400
Date: Thu, 30 May 2013 16:27:47 +0100
From: Will Deacon <will.deacon@arm.com>
To: Catalin Marinas <Catalin.Marinas@arm.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "david.daney@cavium.com" <david.daney@cavium.com>,
        "sam@ravnborg.org" <sam@ravnborg.org>, heiko.carstens@de.ibm.com
Subject: Re: [PATCH v2] arm64: extable: sort the exception table at build time
Message-ID: <20130530152746.GV7483@mudshark.cambridge.arm.com>
References: <1369245812-27231-1-git-send-email-will.deacon@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1369245812-27231-1-git-send-email-will.deacon@arm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 22, 2013 at 07:03:32PM +0100, Will Deacon wrote:
> As is done for other architectures, sort the exception table at
> build-time rather than during boot.
> 
> Since sortextable appears to be a standalone C program relying on the
> host elf.h to provide EM_AARCH64, I've had to add a conditional check in
> order to allow cross-compilation on machines that aren't running a
> bleeding-edge libc-dev.
> 
> Signed-off-by: Will Deacon <will.deacon@arm.com>
> ---
>  arch/arm64/Kconfig              |  1 +
>  arch/arm64/kernel/vmlinux.lds.S | 10 +---------
>  scripts/sortextable.c           |  5 +++++
>  3 files changed, 7 insertions(+), 9 deletions(-)

[...]

> diff --git a/scripts/sortextable.c b/scripts/sortextable.c
> index 1f10e89..f9ce116 100644
> --- a/scripts/sortextable.c
> +++ b/scripts/sortextable.c
> @@ -31,6 +31,10 @@
>  #include <tools/be_byteshift.h>
>  #include <tools/le_byteshift.h>
>  
> +#ifndef EM_AARCH64
> +#define EM_AARCH64	183
> +#endif
> +
>  static int fd_map;	/* File descriptor for file being modified. */
>  static int mmap_failed; /* Boolean flag. */
>  static void *ehdr_curr; /* current ElfXX_Ehdr *  for resource cleanup */
> @@ -249,6 +253,7 @@ do_file(char const *const fname)
>  		custom_sort = sort_relative_table;
>  		break;
>  	case EM_ARM:
> +	case EM_AARCH64:
>  	case EM_MIPS:
>  		break;
>  	}  /* end switch */

Any chance I can have an ack for this part of the patch please? Then we can
take it through the arm64 tree.

Cheers,

Will
