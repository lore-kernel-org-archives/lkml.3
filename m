Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751523AbaBIKm6 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Feb 2014 05:42:58 -0500
Received: from www84.your-server.de ([213.133.104.84]:58996 "EHLO
	www84.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751232AbaBIKm5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Feb 2014 05:42:57 -0500
Message-ID: <1391942615.30431.1.camel@wall-e.seibold.net>
Subject: Re: [PATCH v13 8/9] Add 32 bit VDSO time support for 32 bit kernel
From: Stefani Seibold <stefani@seibold.net>
To: Andi Kleen <ak@linux.intel.com>
Cc: gregkh@linuxfoundation.org, linux-kernel@vger.kernel.org, x86@kernel.org,
        tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com,
        aarcange@redhat.com, john.stultz@linaro.org, luto@amacapital.net,
        xemul@parallels.com, gorcunov@openvz.org,
        andriy.shevchenko@linux.intel.com, Martin.Runge@rohde-schwarz.com,
        Andreas.Brief@rohde-schwarz.com
Date: Sun, 09 Feb 2014 11:43:35 +0100
In-Reply-To: <20140209100536.GM12219@tassilo.jf.intel.com>
References: <1391894951-6381-1-git-send-email-stefani@seibold.net>
	 <1391894951-6381-9-git-send-email-stefani@seibold.net>
	 <20140209052230.GL12219@tassilo.jf.intel.com>
	 <1391933453.1014.20.camel@wall-e.seibold.net>
	 <20140209100536.GM12219@tassilo.jf.intel.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.3 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: stefani@seibold.net
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Sonntag, den 09.02.2014, 02:05 -0800 schrieb Andi Kleen:
> > EBX is a reserved as the base register when compiling with -fPIC.
> > Otherwise it get a "error: can't find a register in class 'BREG' while
> > reloading 'asm'".
> 
> In this case you have to dwarf annotate the push/pop
> 

Okay, but i have no idea why and how to supply dwarf2 unwind
annotations. Can you give my some hints?

> >  
> > > Also I if this calls syscall.S:__kernel_vsyscall it clobbers more registers
> > > (ecx at least?) and you need to describe that to gcc with a + 
> > 
> > Sine ECX is in use as the second parameter it is still marked as
> > clobbered. 
> 
> No input parameters are not clobbered.
> 

I will fix this.

> > I think it should word... As i know a system call will preserve all
> > register expect the EAX, which is marked as in and out for this asm()
> > directive. 
> 
> Yes the syscall does, but the vsyscall stub does not (for the !0x80 case)
> 
> > This is due the -m32 compilation, i will get a log of 
> > "warning: integer constant is too large for 'unsigned long' type",
> > because a unsigned long is only 32 bit.
> 
> Don't explain it to me, put it into a comment.
> 

I will place some comments in the source.

- Stefani


