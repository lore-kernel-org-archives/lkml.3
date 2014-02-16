Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752929AbaBPQaU (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Feb 2014 11:30:20 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:58826 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752474AbaBPQaT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Feb 2014 11:30:19 -0500
Date: Sun, 16 Feb 2014 08:32:41 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: Stefani Seibold <stefani@seibold.net>
Cc: "H. Peter Anvin" <hpa@zytor.com>, linux-kernel@vger.kernel.org,
        x86@kernel.org, tglx@linutronix.de, mingo@redhat.com,
        ak@linux.intel.com, aarcange@redhat.com, john.stultz@linaro.org,
        luto@amacapital.net, xemul@parallels.com, gorcunov@openvz.org,
        andriy.shevchenko@linux.intel.com, Martin.Runge@rohde-schwarz.com,
        Andreas.Brief@rohde-schwarz.com
Subject: Re: [PATCH v17 0/10] Add 32 bit VDSO time function support
Message-ID: <20140216163241.GA28616@kroah.com>
References: <1392481976-6370-1-git-send-email-stefani@seibold.net>
 <53003B43.4080909@zytor.com>
 <1392539375.6513.20.camel@wall-e.seibold.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1392539375.6513.20.camel@wall-e.seibold.net>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Feb 16, 2014 at 09:29:35AM +0100, Stefani Seibold wrote:
> Am Samstag, den 15.02.2014, 20:14 -0800 schrieb H. Peter Anvin:
> > On 02/15/2014 08:32 AM, Stefani Seibold wrote:
> > > This patch add the functions vdso_gettimeofday(), vdso_clock_gettime()
> > > and vdso_time() to the 32 bit VDSO.
> > 
> > x86-64 allyesconfig:
> > 
> >   AS      arch/x86/vdso/vdso32/int80.o
> > /home/hpa/kernel/distwork/arch/x86/vdso/vdso32/../vclock_gettime.c:128:4: warning:
> > symbol 'hpet_page' was not declared
> > . Should it be static?
> > /home/hpa/kernel/distwork/arch/x86/vdso/vdso32/../vclock_gettime.c:134:33:
> > warning: incorrect type in argument 1 (diff
> > erent address spaces)
> > /home/hpa/kernel/distwork/arch/x86/vdso/vdso32/../vclock_gettime.c:134:33:
> >    expected void const volatile [noderef] <
> > asn:2>*addr
> > /home/hpa/kernel/distwork/arch/x86/vdso/vdso32/../vclock_gettime.c:134:33:
> >    got unsigned char [toplevel] *
> > /home/hpa/kernel/distwork/arch/x86/vdso/vdso32/../vclock_gettime.c:294:13:
> > warning: symbol '__vdso_clock_gettime' was
> > not declared. Should it be static?
> > /home/hpa/kernel/distwork/arch/x86/vdso/vdso32/../vclock_gettime.c:322:13:
> > warning: symbol '__vdso_gettimeofday' was n
> > ot declared. Should it be static?
> > /home/hpa/kernel/distwork/arch/x86/vdso/vdso32/../vclock_gettime.c:343:16:
> > warning: symbol '__vdso_time' was not decla
> > red. Should it be static?
> >   CC      arch/x86/vdso/vdso32/vclock_gettime.o
> > /home/hpa/kernel/distwork/arch/x86/vdso/vdso32/vclock_gettime.c:1:0:
> > sorry, unimplemented: -mfentry isn’t supported fo
> > r 32-bit in combination with -fpic
> >  #define BUILD_VDSO32
> >  ^
> > make[4]: *** [arch/x86/vdso/vdso32/vclock_gettime.o] Error 1
> > 
> > 
> > My patience is wearing really thin.  If I get another patchset that
> > doesn't compile in allyesconfig, allmodconfig, allnoconfig and defconfig
> > on both i386 and x86-64, I will put this patchset at the very bottom of
> > my priority list.
> > 
> > I strongly suggest also installing sparse and compiling with C=1 and
> > fixing all *those* warnings.
> > 
> 
> All of the "__vdso__... was not declared" warnings was not introduced by
> me. But i can fix if you like.
> 
> The "sorry, unimplemented: -mfentry isn’t supported for 32-bit in
> combination with -fpic" did not occur on my system. I think it is a
> compiler issues, i am using for x86_64 the gcc 4.3.4.
> 
> I will add a
> 
> KBUILD_CFLAGS_32 := $(filter-out -mfentry,$(KBUILD_CFLAGS_32))
> 
> to the arch/x86/vdso/Makefile.
> 
> Hope this solve your problem.
> 
> Since i have only a 7 year old system with am intel quad "Core 2" 2.54
> GHz and a SATA II interface i am not able to run the suggested ktest
> tool. This would take days! A simple allyesconfig for a X86_64 takes
> about 2 hours.
> 
> What i will do now is run again a allyesconfig for i386 and X86_64 and
> next a allnoconfig and defconfig. I see no reason to a allmodconfig
> since there is no module dependency in this patch set.
> 
> I will not test the X86_X32 since i have no environment for this. Nor
> the CONFIG_CRYPTO_AES_NI_INTEL since my compiler does not support this.
> 
> That is the best effort i currently can do in my spare time. If this is
> not enough i have no idea how to continue.

If you do that, and there are still problems, I have access to faster
machines that can do the other builds for testing and fixing up, just
let me know.

thanks,

greg k-h
