Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752347Ab3KLEHL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Nov 2013 23:07:11 -0500
Received: from mail-ea0-f180.google.com ([209.85.215.180]:56756 "EHLO
	mail-ea0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751571Ab3KLEHG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Nov 2013 23:07:06 -0500
Date: Tue, 12 Nov 2013 05:07:03 +0100
From: Ingo Molnar <mingo@kernel.org>
To: "H. Peter Anvin" <hpa@linux.intel.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>, Olof Johansson <olof@lixom.net>
Subject: Re: [RFC PATCH 3/3] x86, boot: Change the BIOS corruption checker to
 scan 640K
Message-ID: <20131112040703.GA28410@gmail.com>
References: <1384215407-22288-1-git-send-email-hpa@linux.intel.com>
 <1384215407-22288-4-git-send-email-hpa@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1384215407-22288-4-git-send-email-hpa@linux.intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* H. Peter Anvin <hpa@linux.intel.com> wrote:

> From: "H. Peter Anvin" <hpa@linux.intel.com>
> 
> Change the BIOS corruption checker to scan 640K if enabled.  This is
> the normal amount that we otherwise would reserve with the new default
> settings; change the Kconfig help message to indicate that this is now
> intended as a diagnostic tool when one is considering enabling any
> chunk of low memory.
> 
> Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
> Cc: Olof Johansson <olof@lixom.net>
> Link: http://lkml.kernel.org/r/528168CB.7070602@linux.intel.com
> ---
>  arch/x86/Kconfig        | 25 +++++++++++--------------
>  arch/x86/kernel/check.c | 10 +++++-----
>  2 files changed, 16 insertions(+), 19 deletions(-)
> 
> diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
> index 7631122..554aedd 100644
> --- a/arch/x86/Kconfig
> +++ b/arch/x86/Kconfig
> @@ -1384,24 +1384,21 @@ config HIGHPTE
>  config X86_CHECK_BIOS_CORRUPTION
>  	bool "Check for low memory corruption"
>  	---help---
> +	  Periodically check for memory corruption in low memory,
> +	  which is suspected to be caused by BIOS.  Even when enabled
> +	  in the configuration, it is disabled at runtime.  Enable it
> +	  by setting "memory_corruption_check=1" on the kernel command
> +	  line.  By default it reserves and scans the low 640K of
> +	  memory every 60 seconds; see the
> +	  memory_corruption_check_size and
>  	  memory_corruption_check_period parameters in
>  	  Documentation/kernel-parameters.txt to adjust this.

I agree with your patches so far, and I'd suggest we go even further: I'd 
say the config option is now a misnomer, it should probably be renamed to 
CONFIG_X86_FORCE_RESERVE_BIOS_LOW_1MB=y or so.

Btw., should we also force-reserve the remaining bits over 640K..1MB, if 
they are not marked as reserved in the memory maps, or do we already 
force-reserve them somewhere?

The CONFIG_X86_BOOTPARAM_MEMORY_CORRUPTION_CHECK=y option and the 
memory_corruption_check=1 boot option then allow the activation of the low 
memory corrupion checker - which debug facility can be used on systems 
where someone wants to live dangerously and not reserve the low 1MB of RAM 
to the firmware.

Thanks,

	Ingo
