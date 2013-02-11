Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760540Ab3BKXYB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Feb 2013 18:24:01 -0500
Received: from mail-vb0-f48.google.com ([209.85.212.48]:53003 "EHLO
	mail-vb0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760000Ab3BKXX6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Feb 2013 18:23:58 -0500
Message-ID: <51197D8B.6010407@kernel.org>
Date: Mon, 11 Feb 2013 18:23:55 -0500
From: Len Brown <lenb@kernel.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130110 Thunderbird/17.0.2
MIME-Version: 1.0
To: Stephen Rothwell <sfr@canb.auug.org.au>
CC: Len Brown <len.brown@intel.com>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
        sparclinux@vger.kernel.org
Subject: Re: linux-next: build failure after merge of the final tree (acpi
 tree related)
References: <20130211183409.7519b73ca320baeac5ec886f@canb.auug.org.au>
In-Reply-To: <20130211183409.7519b73ca320baeac5ec886f@canb.auug.org.au>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/11/2013 02:34 AM, Stephen Rothwell wrote:
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
>  #define nop() 		__asm__ __volatile__ ("nop")
> +#ifndef __ASSEMBLY__
>  extern void (*sparc_idle)(void);
> +#endif
>  
>  #endif
> 

Thank you Stephen!

The last time I compiled a sparc kernel was in 1993:-)

I've added your fix and Dave's Ack to this patch,
and updated it in my next branch.

Len Brown, Intel Open Source Technology Center


