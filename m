Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752535AbaA3Iz7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Jan 2014 03:55:59 -0500
Received: from mail-ee0-f41.google.com ([74.125.83.41]:33160 "EHLO
	mail-ee0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750982AbaA3Iz4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Jan 2014 03:55:56 -0500
Date: Thu, 30 Jan 2014 09:55:51 +0100
From: Ingo Molnar <mingo@kernel.org>
To: Dave Hansen <dave@sr71.net>
Cc: linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        linux-security-module@vger.kernel.org, linux-arch@vger.kernel.org,
        sfr@canb.auug.org.au, zohar@linux.vnet.ibm.com, linux@arm.linux.org.uk,
        monstr@monstr.eu, ralf@linux-mips.org, benh@kernel.crashing.org,
        paulus@samba.org, schwidefsky@de.ibm.com, heiko.carstens@de.ibm.com,
        lethal@linux-sh.org, x86@kernel.org, james.l.morris@oracle.com
Subject: Re: [PATCH] kconfig: consolidate arch-specific seccomp options
Message-ID: <20140130085551.GB2024@gmail.com>
References: <20140129191011.8FB63DFA@viggo.jf.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140129191011.8FB63DFA@viggo.jf.intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Dave Hansen <dave@sr71.net> wrote:

> 
> There are some minor updates here from last time:
>  * added a def_bool instead of separate lines in config
>  * clarified that the /proc interface is *GONE*
> 
> cc'ing a bunch of folks directly now instead of depending
> on linux-arch@ to awaken them.  I think it's most appropriate
> for this to go in via the security tree, but I guess it
> could also go directly to Linus.
> 
> --
> 
> From: Dave Hansen <dave.hansen@linux.intel.com>
> 
> There are 7 architecures with "config SECCOMP".  They all have
> virtually the same help text except for those referencing the
> /proc interface.  The /proc interface was removed in 2007.
> 
> There is *NOTHING* architecture-specific about SECCOMP except
> that the syscalls have per-architecture definitions, like every
> other syscall.  It is absurd to have the option in the
> arch-specific menus.
> 
> Move it to the security menu, consolidate the 7 down to one, and
> remove the embarassingly-ancient help text references and
> dependencies on /proc.
> 
> Signed-off-by: Dave Hansen <dave.hansen@linux.intel.com>
> Cc: linux-security-module@vger.kernel.org
> Cc: linux-arch@vger.kernel.org
> Cc: Stephen Rothwell <sfr@canb.auug.org.au>
> Cc: Mimi Zohar <zohar@linux.vnet.ibm.com>
> Cc: Russell King <linux@arm.linux.org.uk>
> Cc: Michal Simek <monstr@monstr.eu>
> Cc: Ralf Baechle <ralf@linux-mips.org> 
> Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
> Cc: Paul Mackerras <paulus@samba.org>
> Cc: Martin Schwidefsky <schwidefsky@de.ibm.com>
> Cc: Heiko Carstens <heiko.carstens@de.ibm.com>
> Cc: Paul Mundt <lethal@linux-sh.org> 
> Cc: x86@kernel.org
> Cc: James Morris <james.l.morris@oracle.com>
> 
> ---
> 
>  b/arch/arm/Kconfig        |   15 +--------------
>  b/arch/microblaze/Kconfig |   18 +-----------------
>  b/arch/mips/Kconfig       |   18 +-----------------
>  b/arch/powerpc/Kconfig    |   18 +-----------------
>  b/arch/s390/Kconfig       |   18 +-----------------
>  b/arch/sh/Kconfig         |   17 +----------------
>  b/arch/sparc/Kconfig      |   18 +-----------------
>  b/arch/x86/Kconfig        |   17 +----------------

> --- a/security/Kconfig~consolidate-seccomp-options	2014-01-29 11:02:31.607008738 -0800
> +++ b/security/Kconfig	2014-01-29 11:02:31.616009147 -0800
> @@ -167,5 +167,24 @@ config DEFAULT_SECURITY
>  	default "yama" if DEFAULT_SECURITY_YAMA
>  	default "" if DEFAULT_SECURITY_DAC
>  
> -endmenu
> +config HAVE_ARCH_SECCOMP
> +	bool
> +


> +config SECCOMP
> +	def_bool y
> +	depends on HAVE_ARCH_SECCOMP
> +	prompt "Enable seccomp to safely compute untrusted bytecode"
> +	---help---
> +	  This kernel feature is useful for number crunching applications
> +	  that may need to compute untrusted bytecode during their
> +	  execution. By using pipes or other transports made available to

I'd change and simplify the first sentence to:

> +	  This kernel feature is useful to sandbox runtimes that need
> +	  to execute untrusted machine code.

Seccomp isn't primarily about number crunching anymore, and it's 
definitely not about 'bytecode' in the classical sense either.

> +	  the process as file descriptors supporting the read/write
> +	  syscalls, it's possible to isolate those applications in
> +	  their own address space using seccomp. Once seccomp is
> +	  enabled via prctl(PR_SET_SECCOMP), it cannot be disabled
> +	  and the task is only allowed to execute a few safe syscalls
> +	  defined by each seccomp mode.
>  
> +	  If unsure, say Y. Only embedded should say N here.
> +
> +endmenu

Other than that:

Acked-by: Ingo Molnar <mingo@kernel.org>

Thanks,

	Ingo
