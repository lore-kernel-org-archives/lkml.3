Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751486AbaJIHrl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Oct 2014 03:47:41 -0400
Received: from sym2.noone.org ([178.63.92.236]:60190 "EHLO sym2.noone.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750839AbaJIHrc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Oct 2014 03:47:32 -0400
Date: Thu, 9 Oct 2014 09:47:29 +0200
From: Tobias Klauser <tklauser@distanz.ch>
To: Ley Foon Tan <lftan@altera.com>
Cc: linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-doc@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>,
        lftan.linux@gmail.com, cltang@codesourcery.com
Subject: Re: [PATCH v4 17/29] nios2: System calls handling
Message-ID: <20141009074729.GN3279@distanz.ch>
References: <1412760595-3935-1-git-send-email-lftan@altera.com>
 <1412760595-3935-18-git-send-email-lftan@altera.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1412760595-3935-18-git-send-email-lftan@altera.com>
X-Editor: Vi IMproved 7.3
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2014-10-08 at 11:29:43 +0200, Ley Foon Tan <lftan@altera.com> wrote:
> This patch adds support for system calls from userspaces. It uses the
> asm-generic/unistd.h definitions with architecture spcific syscall. The sys_call_table
> is just an array defined in a C file and it contains pointers to the syscall functions.
> 
> Signed-off-by: Ley Foon Tan <lftan@altera.com>
> ---
>  arch/nios2/include/asm/syscall.h     |  138 ++++++++++++++++++++++++++++++++++
>  arch/nios2/include/asm/syscalls.h    |   25 ++++++
>  arch/nios2/include/uapi/asm/unistd.h |   25 ++++++
>  arch/nios2/kernel/sys_nios2.c        |   66 ++++++++++++++++
>  arch/nios2/kernel/syscall_table.c    |   29 +++++++
>  5 files changed, 283 insertions(+), 0 deletions(-)
>  create mode 100644 arch/nios2/include/asm/syscall.h
>  create mode 100644 arch/nios2/include/asm/syscalls.h
>  create mode 100644 arch/nios2/include/uapi/asm/unistd.h
>  create mode 100644 arch/nios2/kernel/sys_nios2.c
>  create mode 100644 arch/nios2/kernel/syscall_table.c
[...]
> diff --git a/arch/nios2/kernel/sys_nios2.c b/arch/nios2/kernel/sys_nios2.c
> new file mode 100644
> index 0000000..a32d7f3
> --- /dev/null
> +++ b/arch/nios2/kernel/sys_nios2.c
[...]
> +#if defined(CONFIG_FB) || defined(CONFIG_FB_MODULE)
> +#include <linux/fb.h>
> +unsigned long get_fb_unmapped_area(struct file *filp, unsigned long orig_addr,
> +		unsigned long len, unsigned long pgoff, unsigned long flags)
> +{
> +
> +	struct fb_info *info = filp->private_data;
> +
> +	return (unsigned long)info->screen_base;
> +}
> +EXPORT_SYMBOL(get_fb_unmapped_area);

get_fb_unmapped_area only used if HAVE_ARCH_FB_UNMAPPED_AREA is defined,
but this isn't the case for nios2. AFAICS the altfb driver has been
broken on nios2 for a long time anyway, so I'd suggest to just remove
this function for now.
