Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751973AbaBIKFi (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Feb 2014 05:05:38 -0500
Received: from mga09.intel.com ([134.134.136.24]:57258 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751457AbaBIKFh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Feb 2014 05:05:37 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.95,811,1384329600"; 
   d="scan'208";a="480411886"
Date: Sun, 9 Feb 2014 02:05:36 -0800
From: Andi Kleen <ak@linux.intel.com>
To: Stefani Seibold <stefani@seibold.net>
Cc: gregkh@linuxfoundation.org, linux-kernel@vger.kernel.org, x86@kernel.org,
        tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com,
        aarcange@redhat.com, john.stultz@linaro.org, luto@amacapital.net,
        xemul@parallels.com, gorcunov@openvz.org,
        andriy.shevchenko@linux.intel.com, Martin.Runge@rohde-schwarz.com,
        Andreas.Brief@rohde-schwarz.com
Subject: Re: [PATCH v13 8/9] Add 32 bit VDSO time support for 32 bit kernel
Message-ID: <20140209100536.GM12219@tassilo.jf.intel.com>
References: <1391894951-6381-1-git-send-email-stefani@seibold.net>
 <1391894951-6381-9-git-send-email-stefani@seibold.net>
 <20140209052230.GL12219@tassilo.jf.intel.com>
 <1391933453.1014.20.camel@wall-e.seibold.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1391933453.1014.20.camel@wall-e.seibold.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> EBX is a reserved as the base register when compiling with -fPIC.
> Otherwise it get a "error: can't find a register in class 'BREG' while
> reloading 'asm'".

In this case you have to dwarf annotate the push/pop

>  
> > Also I if this calls syscall.S:__kernel_vsyscall it clobbers more registers
> > (ecx at least?) and you need to describe that to gcc with a + 
> 
> Sine ECX is in use as the second parameter it is still marked as
> clobbered. 

No input parameters are not clobbered.

> I think it should word... As i know a system call will preserve all
> register expect the EAX, which is marked as in and out for this asm()
> directive. 

Yes the syscall does, but the vsyscall stub does not (for the !0x80 case)

> This is due the -m32 compilation, i will get a log of 
> "warning: integer constant is too large for 'unsigned long' type",
> because a unsigned long is only 32 bit.

Don't explain it to me, put it into a comment.

-Andi

-- 
ak@linux.intel.com -- Speaking for myself only
