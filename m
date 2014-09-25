Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751755AbaIYBNo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Sep 2014 21:13:44 -0400
Received: from hub027-ca-8.exch027.serverdata.net ([64.78.52.15]:23766 "EHLO
	hub027-ca-8.exch027.serverdata.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751175AbaIYBNl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Sep 2014 21:13:41 -0400
X-Greylist: delayed 482 seconds by postgrey-1.27 at vger.kernel.org; Wed, 24 Sep 2014 21:13:41 EDT
Message-ID: <54236A67.90001@uclinux.org>
Date: Thu, 25 Sep 2014 11:05:43 +1000
From: Greg Ungerer <gerg@uclinux.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.1.2
MIME-Version: 1.0
To: Will Deacon <will.deacon@arm.com>, <linux-arch@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
CC: <arnd@arndb.de>, <benh@kernel.crashing.org>, <chris@zankel.net>,
        <cmetcalf@tilera.com>, <davem@davemloft.net>, <deller@gmx.de>,
        <dhowells@redhat.com>, <geert@linux-m68k.org>,
        <heiko.carstens@de.ibm.com>, <hpa@zytor.com>, <jcmvbkbc@gmail.com>,
        <jesper.nilsson@axis.com>, <mingo@redhat.com>, <monstr@monstr.eu>,
        <paulmck@linux.vnet.ibm.com>, <rdunlap@infradead.org>,
        <sam@ravnborg.org>, <schwidefsky@de.ibm.com>, <starvik@axis.com>,
        <takata@linux-m32r.org>, <tglx@linutronix.de>, <tony.luck@intel.com>,
        <daniel.thompson@linaro.org>, <broonie@linaro.org>,
        <linux@arm.linux.org.uk>
Subject: Re: [PATCH v3 09/17] m68k: io: implement dummy relaxed accessor macros
 for writes
References: <1411579056-16966-1-git-send-email-will.deacon@arm.com> <1411579056-16966-10-git-send-email-will.deacon@arm.com>
In-Reply-To: <1411579056-16966-10-git-send-email-will.deacon@arm.com>
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Will

On 25/09/14 03:17, Will Deacon wrote:
> write{b,w,l}_relaxed are implemented by some architectures in order to
> permit memory-mapped I/O accesses with weaker barrier semantics than the
> non-relaxed variants.
> 
> This patch adds dummy macros for the write accessors to m68k, in the
> same vein as the dummy definitions for the relaxed read accessors.
> Additionally, the existing relaxed read accessors are moved into
> asm/io.h, so that they can be used by m68k targets with an MMU.
> 
> Acked-by: Geert Uytterhoeven <geert@linux-m68k.org>
> Signed-off-by: Will Deacon <will.deacon@arm.com>
> ---
>  arch/m68k/include/asm/io.h    | 8 ++++++++
>  arch/m68k/include/asm/io_no.h | 4 ----
>  2 files changed, 8 insertions(+), 4 deletions(-)
> 
> diff --git a/arch/m68k/include/asm/io.h b/arch/m68k/include/asm/io.h
> index c70cc9155003..bccd5a914eb6 100644
> --- a/arch/m68k/include/asm/io.h
> +++ b/arch/m68k/include/asm/io.h
> @@ -3,3 +3,11 @@
>  #else
>  #include <asm/io_mm.h>
>  #endif
> +
> +#define readb_relaxed(addr)	readb(addr)
> +#define readw_relaxed(addr)	readw(addr)
> +#define readl_relaxed(addr)	readl(addr)
> +
> +#define writeb_relaxed(b, addr)	writeb(b, addr)
> +#define writew_relaxed(b, addr)	writew(b, addr)
> +#define writel_relaxed(b, addr)	writel(b, addr)

Putting them here means they won't have any multiple include protection
(there is no "#ifndef _IO_H" around them). Doesn't seem to lead to
any problems in practice. Just flagging it...

Regards
Greg



> diff --git a/arch/m68k/include/asm/io_no.h b/arch/m68k/include/asm/io_no.h
> index 52f7e8499172..19c237c63dc2 100644
> --- a/arch/m68k/include/asm/io_no.h
> +++ b/arch/m68k/include/asm/io_no.h
> @@ -40,10 +40,6 @@ static inline unsigned int _swapl(volatile unsigned long v)
>  #define readl(addr) \
>      ({ unsigned int __v = (*(volatile unsigned int *) (addr)); __v; })
>  
> -#define readb_relaxed(addr) readb(addr)
> -#define readw_relaxed(addr) readw(addr)
> -#define readl_relaxed(addr) readl(addr)
> -
>  #define writeb(b,addr) (void)((*(volatile unsigned char *) (addr)) = (b))
>  #define writew(b,addr) (void)((*(volatile unsigned short *) (addr)) = (b))
>  #define writel(b,addr) (void)((*(volatile unsigned int *) (addr)) = (b))
> 

