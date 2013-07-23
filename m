Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756169Ab3GWJWU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Jul 2013 05:22:20 -0400
Received: from mail-ea0-f180.google.com ([209.85.215.180]:65295 "EHLO
	mail-ea0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752241Ab3GWJWT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Jul 2013 05:22:19 -0400
Date: Tue, 23 Jul 2013 11:22:14 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Zhang Yanfei <zhangyanfei.yes@gmail.com>
Cc: len.brown@intel.com, pavel@ucw.cz, rjw@sisk.pl,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] x86, acpi: Remove out-of-date comment of __acpi_map_table
Message-ID: <20130723092214.GB19786@gmail.com>
References: <51DDA677.9000102@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <51DDA677.9000102@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Zhang Yanfei <zhangyanfei.yes@gmail.com> wrote:

> From: Zhang Yanfei <zhangyanfei@cn.fujitsu.com>
> 
> The implementation of function __acpi_map_table() has been changed
> long time ago, and now it directly invokes early_ioremap() to setup
> the temporarily acpi table mappings. So remove its out-of-date
> comment.
> 
> Signed-off-by: Zhang Yanfei <zhangyanfei@cn.fujitsu.com>
> ---
>  arch/x86/kernel/acpi/boot.c |   13 +------------
>  1 files changed, 1 insertions(+), 12 deletions(-)
> 
> diff --git a/arch/x86/kernel/acpi/boot.c b/arch/x86/kernel/acpi/boot.c
> index d81a972..bac8b5b 100644
> --- a/arch/x86/kernel/acpi/boot.c
> +++ b/arch/x86/kernel/acpi/boot.c
> @@ -140,18 +140,6 @@ static u32 irq_to_gsi(int irq)
>  	return gsi;
>  }
>  
> -/*
> - * Temporarily use the virtual area starting from FIX_IO_APIC_BASE_END,
> - * to map the target physical address. The problem is that set_fixmap()
> - * provides a single page, and it is possible that the page is not
> - * sufficient.
> - * By using this area, we can map up to MAX_IO_APICS pages temporarily,
> - * i.e. until the next __va_range() call.
> - *
> - * Important Safety Note:  The fixed I/O APIC page numbers are *subtracted*
> - * from the fixed base.  That's why we start at FIX_IO_APIC_BASE_END and
> - * count idx down while incrementing the phys address.
> - */
>  char *__init __acpi_map_table(unsigned long phys, unsigned long size)

Good catch. Removing documentation makes me sad, so how about replacing it 
with a simple comment:

	/*
	 * This is just a simple wrapper around early_ioremap(),
	 * with sanity checks for phys == 0 and size == 0:
	 */

?

Thanks,

	Ingo
