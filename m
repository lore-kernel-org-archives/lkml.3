Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752839Ab3JLR4V (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Oct 2013 13:56:21 -0400
Received: from mail-ea0-f169.google.com ([209.85.215.169]:34199 "EHLO
	mail-ea0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752570Ab3JLR4T (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Oct 2013 13:56:19 -0400
Date: Sat, 12 Oct 2013 19:56:15 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Matt Fleming <matt@console-pimps.org>
Cc: linux-efi@vger.kernel.org, linux-kernel@vger.kernel.org,
        Matt Fleming <matt.fleming@intel.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
        Peter Jones <pjones@redhat.com>
Subject: Re: [PATCH v2 2/2] x86/efi: Add EFI framebuffer earlyprintk support
Message-ID: <20131012175615.GB18849@gmail.com>
References: <1381502037-22225-1-git-send-email-matt@console-pimps.org>
 <1381502037-22225-3-git-send-email-matt@console-pimps.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1381502037-22225-3-git-send-email-matt@console-pimps.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Matt Fleming <matt@console-pimps.org> wrote:

> From: Matt Fleming <matt.fleming@intel.com>
> 
> It's incredibly difficult to diagnose early EFI boot issues without
> special hardware because earlyprintk=vga doesn't work on EFI systems.
> 
> Add support for writing to the EFI framebuffer, via earlyprintk=efi,
> which will actually give users a chance of providing debug output.
> 
> Cc: H. Peter Anvin <hpa@zytor.com>
> Cc: Ingo Molnar <mingo@kernel.org>
> Cc: Thomas Gleixner <tglx@linutronix.de>
> Cc: Peter Jones <pjones@redhat.com>
> Signed-off-by: Matt Fleming <matt.fleming@intel.com>
> 
>  Documentation/kernel-parameters.txt  |   8 +-
>  arch/x86/Kconfig.debug               |   9 ++
>  arch/x86/include/asm/efi.h           |   2 +
>  arch/x86/kernel/early_printk.c       |   6 ++
>  arch/x86/platform/efi/Makefile       |   1 +
>  arch/x86/platform/efi/early_printk.c | 191 +++++++++++++++++++++++++++++++++++
>  6 files changed, 214 insertions(+), 3 deletions(-)
>  create mode 100644 arch/x86/platform/efi/early_printk.c

Looks really nice now!

Reviewed-by: Ingo Molnar <mingo@kernel.org>

One detail:

> +static void early_efi_write_char(u32 *dst, unsigned char c, unsigned int h)
> +{
> +	const u32 color_black = 0x00000000;
> +	const u32 color_grey = 0x00aaaaaa;

I still think this should be white - that should be more visible than 
grey, especially in brightly lit places. (And I'm really sorry about nerds 
in the basement getting eye damage.)

Also, what is the highest byte typically, can that ever be part of 
multiple framebuffers and can it mean an alpha channel? If yes then '0x00' 
(read: fully translucent) might not be the best of choices for console 
output. In that case -1 (0xffffffff) would work in a natural way.

(If it's reserved bits then it has to be all zeroes.)

Thanks,

	Ingo
