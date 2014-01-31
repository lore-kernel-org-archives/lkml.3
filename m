Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753931AbaAaAK4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Jan 2014 19:10:56 -0500
Received: from mga02.intel.com ([134.134.136.20]:51725 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753097AbaAaAKz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Jan 2014 19:10:55 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.95,753,1384329600"; 
   d="scan'208";a="447386687"
Date: Thu, 30 Jan 2014 16:10:34 -0800
From: Andi Kleen <ak@linux.intel.com>
To: stefani@seibold.net
Cc: gregkh@linuxfoundation.org, linux-kernel@vger.kernel.org, x86@kernel.org,
        tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com,
        aarcange@redhat.com, john.stultz@linaro.org, luto@amacapital.net,
        xemul@parallels.com, gorcunov@openvz.org,
        andriy.shevchenko@linux.intel.com, Martin.Runge@rohde-schwarz.com,
        Andreas.Brief@rohde-schwarz.com
Subject: Re: [PATCH 1/4] Make vsyscall_gtod_data handling x86 generic
Message-ID: <20140131001034.GB2350@tassilo.jf.intel.com>
References: <1391078953-1575-1-git-send-email-stefani@seibold.net>
 <1391078953-1575-2-git-send-email-stefani@seibold.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1391078953-1575-2-git-send-email-stefani@seibold.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> @@ -1335,7 +1335,6 @@ config ARCH_SPARSEMEM_ENABLE
>  
>  config ARCH_SPARSEMEM_DEFAULT
>  	def_bool y
> -	depends on X86_64

Is that really needed? Why does the vdso need sparsemem?

>  
>  static inline void __user *arch_compat_alloc_user_space(long len)
>  {
> +#ifdef CONFIG_X86_32
> +	struct pt_regs *regs = task_pt_regs(current);
> +	return (void __user *)regs->sp - len;
> +#else
>  	compat_uptr_t sp;

and that? why does a vdso need to allocate things on the user page?

-Andi
