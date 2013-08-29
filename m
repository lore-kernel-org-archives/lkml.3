Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754324Ab3H2PSW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Aug 2013 11:18:22 -0400
Received: from mga01.intel.com ([192.55.52.88]:51145 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752945Ab3H2PSV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Aug 2013 11:18:21 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.89,984,1367996400"; 
   d="scan'208";a="393998091"
Message-ID: <521F662F.4050003@intel.com>
Date: Thu, 29 Aug 2013 08:18:07 -0700
From: Dave Hansen <dave.hansen@intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130803 Thunderbird/17.0.8
MIME-Version: 1.0
To: Vineet Gupta <Vineet.Gupta1@synopsys.com>
CC: linux-kernel@vger.kernel.org, Dave Hansen <dave.hansen@linux.intel.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        "Paul E. McKenney" <paul.mckenney@linaro.org>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Michel Lespinasse <walken@google.com>
Subject: Re: [PATCH] Kconfig.debug: Add FRAME_POINTER anti-dependency for
 ARC
References: <1377592285-21148-1-git-send-email-vgupta@synopsys.com>
In-Reply-To: <1377592285-21148-1-git-send-email-vgupta@synopsys.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/27/2013 01:31 AM, Vineet Gupta wrote:
> Frame pointer on ARC doesn't serve the conventional purpose of stack
> unwinding due to the typical way ABI designates it's usage.
> Thus it's explicit usage on ARC is discouraged (gcc is free to use it,
> for some tricky stack frames even if -fomit-frame-pointer)
...
> diff --git a/lib/Kconfig.debug b/lib/Kconfig.debug
> index 1501aa5..c971f3a 100644
> --- a/lib/Kconfig.debug
> +++ b/lib/Kconfig.debug
> @@ -908,7 +908,7 @@ config LOCKDEP
>  	bool
>  	depends on DEBUG_KERNEL && TRACE_IRQFLAGS_SUPPORT && STACKTRACE_SUPPORT && LOCKDEP_SUPPORT
>  	select STACKTRACE
> -	select FRAME_POINTER if !MIPS && !PPC && !ARM_UNWIND && !S390 && !MICROBLAZE
> +	select FRAME_POINTER if !MIPS && !PPC && !ARM_UNWIND && !S390 && !MICROBLAZE && !ARC
>  	select KALLSYMS
>  	select KALLSYMS_ALL

I assume you're sending this my way since getmaintainer.pl has me tagged
I moved a bunch of code in there. :)

The Kconfig.debug stuff has no real maintainer.  It would probably be OK
if you just stick this in your architecture's next git pull request.

Although, it would be nice if someone, at some point, actually
abstracted that out so that the individual architectures could take care
of this without editing the main files:

# Kconfig.debug:

config ARCH_FRAME_POINTER_UNAVAILABLE
	def_bool y
...
select FRAME_POINTER if !ARCH_FRAME_POINTER_UNAVAILABLE

# arch/.../Kconfig

select ARCH_FRAME_POINTER_UNAVAILABLE


