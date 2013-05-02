Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751065Ab3EBHeK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 May 2013 03:34:10 -0400
Received: from mail-ee0-f53.google.com ([74.125.83.53]:57954 "EHLO
	mail-ee0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750769Ab3EBHeF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 May 2013 03:34:05 -0400
Date: Thu, 2 May 2013 09:34:00 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Robin Holt <holt@sgi.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Russell King <linux@arm.linux.org.uk>,
        Guan Xuetao <gxt@mprc.pku.edu.cn>,
        Miguel Boton <mboton.lkml@gmail.com>, Russ Anderson <rja@sgi.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        the arch/x86 maintainers <x86@kernel.org>,
        Arm Mailing List <linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH -v7 11/11] Move arch/x86 reboot= handling to generic
 kernel.
Message-ID: <20130502073400.GD26361@gmail.com>
References: <1367428011-17123-1-git-send-email-holt@sgi.com>
 <1367428011-17123-12-git-send-email-holt@sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1367428011-17123-12-git-send-email-holt@sgi.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Robin Holt <holt@sgi.com> wrote:

> Merge together the unicore32, arm, and x86 reboot= command line
> parameter handling.

Nice!

> +		switch (*str) {
> +#if defined(CONFIG_X86) || defined(CONFIG_X86_64)
> +		case 'w':
> +			reboot_mode = REBOOT_WARM;
> +			break;
> +
> +		case 'c':
> +			reboot_mode = REBOOT_COLD;
> +			break;
> +
> +#ifdef CONFIG_SMP
> +		case 's':
> +			if (isdigit(*(str+1))) {
> +				reboot_cpu = (int) (*(str+1) - '0');
> +				if (isdigit(*(str+2)))
> +					reboot_cpu = reboot_cpu*10 + (int)(*(str+2) - '0');
> +			}
> +			/*
> +			 * We will leave sorting out the final value
> +			 * when we are ready to reboot, since we might not
> +			 * have detected BSP APIC ID or smp_num_cpu
> +			 */
> +			break;
> +#endif /* CONFIG_SMP */
> +
> +#else
> +		case 's':
> +			reboot_mode = REBOOT_WARM;
> +		case 'h':
> +			reboot_mode = REBOOT_COLD;
> +#endif

This architecture dependent bit is not so nice.

I doubt the 's' parameter is used widely at all on x86 [it's more like a 
debug/hack parameter], so might as well just pick up a new character (for 
example capital 'S'?) and have the same parameters on every architecture.

Thanks,

	Ingo
