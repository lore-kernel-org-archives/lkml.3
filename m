Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933266AbaBAOu4 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Feb 2014 09:50:56 -0500
Received: from www84.your-server.de ([213.133.104.84]:55496 "EHLO
	www84.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751640AbaBAOuz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Feb 2014 09:50:55 -0500
Message-ID: <1391266284.964.1.camel@wall-e.seibold.net>
Subject: Re: [PATCH 1/4] Make vsyscall_gtod_data handling x86 generic
From: Stefani Seibold <stefani@seibold.net>
To: Andi Kleen <ak@linux.intel.com>
Cc: gregkh@linuxfoundation.org, linux-kernel@vger.kernel.org, x86@kernel.org,
        tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com,
        aarcange@redhat.com, john.stultz@linaro.org, luto@amacapital.net,
        xemul@parallels.com, gorcunov@openvz.org,
        andriy.shevchenko@linux.intel.com, Martin.Runge@rohde-schwarz.com,
        Andreas.Brief@rohde-schwarz.com
Date: Sat, 01 Feb 2014 15:51:24 +0100
In-Reply-To: <20140131001034.GB2350@tassilo.jf.intel.com>
References: <1391078953-1575-1-git-send-email-stefani@seibold.net>
	 <1391078953-1575-2-git-send-email-stefani@seibold.net>
	 <20140131001034.GB2350@tassilo.jf.intel.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.8.5 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: stefani@seibold.net
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Donnerstag, den 30.01.2014, 16:10 -0800 schrieb Andi Kleen:
> > @@ -1335,7 +1335,6 @@ config ARCH_SPARSEMEM_ENABLE
> >  
> >  config ARCH_SPARSEMEM_DEFAULT
> >  	def_bool y
> > -	depends on X86_64
> 
> Is that really needed? Why does the vdso need sparsemem?
> 

No, it is from the previous patch. I will fix it.

> >  
> >  static inline void __user *arch_compat_alloc_user_space(long len)
> >  {
> > +#ifdef CONFIG_X86_32
> > +	struct pt_regs *regs = task_pt_regs(current);
> > +	return (void __user *)regs->sp - len;
> > +#else
> >  	compat_uptr_t sp;
> 
> and that? why does a vdso need to allocate things on the user page?
> 

Will also fixed, compat.h will not longer include by vsyscall_gtod.c.


