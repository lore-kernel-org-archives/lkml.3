Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752835AbaBPEQR (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Feb 2014 23:16:17 -0500
Received: from terminus.zytor.com ([198.137.202.10]:43673 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752587AbaBPEQQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Feb 2014 23:16:16 -0500
Message-ID: <53003B43.4080909@zytor.com>
Date: Sat, 15 Feb 2014 20:14:59 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Stefani Seibold <stefani@seibold.net>, gregkh@linuxfoundation.org,
        linux-kernel@vger.kernel.org, x86@kernel.org, tglx@linutronix.de,
        mingo@redhat.com, ak@linux.intel.com, aarcange@redhat.com,
        john.stultz@linaro.org, luto@amacapital.net, xemul@parallels.com,
        gorcunov@openvz.org, andriy.shevchenko@linux.intel.com
CC: Martin.Runge@rohde-schwarz.com, Andreas.Brief@rohde-schwarz.com
Subject: Re: [PATCH v17 0/10] Add 32 bit VDSO time function support
References: <1392481976-6370-1-git-send-email-stefani@seibold.net>
In-Reply-To: <1392481976-6370-1-git-send-email-stefani@seibold.net>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/15/2014 08:32 AM, Stefani Seibold wrote:
> This patch add the functions vdso_gettimeofday(), vdso_clock_gettime()
> and vdso_time() to the 32 bit VDSO.

x86-64 allyesconfig:

  AS      arch/x86/vdso/vdso32/int80.o
/home/hpa/kernel/distwork/arch/x86/vdso/vdso32/../vclock_gettime.c:128:4: warning:
symbol 'hpet_page' was not declared
. Should it be static?
/home/hpa/kernel/distwork/arch/x86/vdso/vdso32/../vclock_gettime.c:134:33:
warning: incorrect type in argument 1 (diff
erent address spaces)
/home/hpa/kernel/distwork/arch/x86/vdso/vdso32/../vclock_gettime.c:134:33:
   expected void const volatile [noderef] <
asn:2>*addr
/home/hpa/kernel/distwork/arch/x86/vdso/vdso32/../vclock_gettime.c:134:33:
   got unsigned char [toplevel] *
/home/hpa/kernel/distwork/arch/x86/vdso/vdso32/../vclock_gettime.c:294:13:
warning: symbol '__vdso_clock_gettime' was
not declared. Should it be static?
/home/hpa/kernel/distwork/arch/x86/vdso/vdso32/../vclock_gettime.c:322:13:
warning: symbol '__vdso_gettimeofday' was n
ot declared. Should it be static?
/home/hpa/kernel/distwork/arch/x86/vdso/vdso32/../vclock_gettime.c:343:16:
warning: symbol '__vdso_time' was not decla
red. Should it be static?
  CC      arch/x86/vdso/vdso32/vclock_gettime.o
/home/hpa/kernel/distwork/arch/x86/vdso/vdso32/vclock_gettime.c:1:0:
sorry, unimplemented: -mfentry isn’t supported fo
r 32-bit in combination with -fpic
 #define BUILD_VDSO32
 ^
make[4]: *** [arch/x86/vdso/vdso32/vclock_gettime.o] Error 1


My patience is wearing really thin.  If I get another patchset that
doesn't compile in allyesconfig, allmodconfig, allnoconfig and defconfig
on both i386 and x86-64, I will put this patchset at the very bottom of
my priority list.

I strongly suggest also installing sparse and compiling with C=1 and
fixing all *those* warnings.

Sorry.

	-hpa

