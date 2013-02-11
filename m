Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758814Ab3BKSXR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Feb 2013 13:23:17 -0500
Received: from mail-ob0-f170.google.com ([209.85.214.170]:53640 "EHLO
	mail-ob0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758780Ab3BKSXP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Feb 2013 13:23:15 -0500
MIME-Version: 1.0
In-Reply-To: <20130211183409.7519b73ca320baeac5ec886f@canb.auug.org.au>
References: <20130211183409.7519b73ca320baeac5ec886f@canb.auug.org.au>
From: Bjorn Helgaas <bhelgaas@google.com>
Date: Mon, 11 Feb 2013 11:22:55 -0700
Message-ID: <CAErSpo6R1LNg3PL3S_j_KudwR-n+0oY91KwJbRRTX0PORDTAbQ@mail.gmail.com>
Subject: Re: linux-next: build failure after merge of the final tree (acpi
 tree related)
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Len Brown <len.brown@intel.com>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
        sparclinux@vger.kernel.org, "Rafael J. Wysocki" <rjw@sisk.pl>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[+cc Rafael, since you mentioned the ACPI tree]

On Mon, Feb 11, 2013 at 12:34 AM, Stephen Rothwell <sfr@canb.auug.org.au> wrote:
> Hi all,
>
> After merging the final tree, today's linux-next build (sparc64 defconfig)
> failed like this:
>
> arch/sparc/include/asm/processor.h: Assembler messages:
> arch/sparc/include/asm/processor.h:10: Error: Unknown opcode: `extern'
>
> Caused by commit 3a242f58a5f4 ("sparc idle: rename pm_idle to
> sparc_idle") from the acpi tree.
>
> I have applied this patch for today:
>
> From: Stephen Rothwell <sfr@canb.auug.org.au>
> Date: Mon, 11 Feb 2013 18:30:19 +1100
> Subject: [PATCH] sparc idle: protect variable declarations against the assembler
>
> Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>
> ---
>  arch/sparc/include/asm/processor.h | 2 ++
>  1 file changed, 2 insertions(+)
>
> diff --git a/arch/sparc/include/asm/processor.h b/arch/sparc/include/asm/processor.h
> index 34baa35..622cfa5 100644
> --- a/arch/sparc/include/asm/processor.h
> +++ b/arch/sparc/include/asm/processor.h
> @@ -7,6 +7,8 @@
>  #endif
>
>  #define nop()          __asm__ __volatile__ ("nop")
> +#ifndef __ASSEMBLY__
>  extern void (*sparc_idle)(void);
> +#endif
>
>  #endif
> --
> 1.8.1
>
> --
> Cheers,
> Stephen Rothwell                    sfr@canb.auug.org.au
