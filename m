Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752153AbaA2GiT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Jan 2014 01:38:19 -0500
Received: from moutng.kundenserver.de ([212.227.126.187]:49822 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750848AbaA2GiS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Jan 2014 01:38:18 -0500
Message-ID: <1390977361.8072.29.camel@marge.simpson.net>
Subject: Re: [GIT PULL] x86/kaslr for v3.14
From: Mike Galbraith <bitbucket@online.de>
To: Dave Jones <davej@redhat.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Borislav Petkov <bp@alien8.de>, Ingo Molnar <mingo@kernel.org>,
        "H. Peter Anvin" <hpa@zytor.com>, Richard Weinberger <richard@nod.at>,
        "H. Peter Anvin" <hpa@linux.intel.com>,
        Kees Cook <keescook@chromium.org>, Cong Ding <dinggnu@gmail.com>,
        Ingo Molnar <mingo@elte.hu>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Mathias Krause <minipli@googlemail.com>,
        Michael Davidson <md@google.com>, Thomas Gleixner <tglx@linutronix.de>,
        Wei Yongjun <yongjun_wei@trendmicro.com.cn>
Date: Wed, 29 Jan 2014 07:36:01 +0100
In-Reply-To: <20140128210857.GA1377@redhat.com>
References: <52E7D2E5.8090208@linux.intel.com> <52E7D9FF.1080506@nod.at>
	 <52E7DB15.3090808@zytor.com>
	 <CA+55aFzRJNEt-tOGgj-6OPB0cMW9ReM6y6kzCyR5bfts1de-Jg@mail.gmail.com>
	 <20140128170507.GA16279@gmail.com>
	 <CA+55aFw_xs1tUteDrXz21QZB7BFk5p+F5NZ-SpV=CUVjeFwapA@mail.gmail.com>
	 <20140128194823.GA18702@gmail.com>
	 <CA+55aFzqJe2XFCTu3Wb4hvZULuR97OOeEhQLYvFMF2bYTLb5Vw@mail.gmail.com>
	 <20140128201536.GB5178@pd.tnic>
	 <CA+55aFwpsAatO7dy_jQM1NdM5VfJy33RaQ0tJzx+KN_oJsHcBQ@mail.gmail.com>
	 <20140128210857.GA1377@redhat.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
X-Provags-ID: V02:K0:qSRCx4Tc9UI6zxZS2wJAeBybw3Jd9UbYTY6ZfQVpNQH
 742e29tBbt0JrsLr5BWDwlVgHjyxYqb71L0naCSK54/ZOtMIzf
 odqVihl1WudFKdv7Mgb3xXyrf8A98HINWvYAkqbsgG9kguvIWk
 3JP2Ka63AaL/MvkxRFb8GYodWfOFA5nOFiwtfXe0xt2piciwg/
 EZMJe3BYmxR9QfSIcWn0LVB1RPdHUDP4VEXlnN+LM6qG4qhgmE
 Oresbcmik5at19rGBk+Fz7zbeNnfbAJg9ynRcmPIksWrPKElLs
 M2rVAZ12xedYjTXcFiqr5rLe94pgQ3Xs8+imGhsdi3yZY9BuTY
 vSFKEmxVSlkDcpO1NfU7kwk3HDOQbOkgR8RpfF8ppJ+/dYRuTu
 cjHxCcRO2ev9A==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2014-01-28 at 16:08 -0500, Dave Jones wrote: 
> On Tue, Jan 28, 2014 at 12:25:15PM -0800, Linus Torvalds wrote:
>  > On Tue, Jan 28, 2014 at 12:15 PM, Borislav Petkov <bp@alien8.de> wrote:
>  > >
>  > > Shouldn't we hold that down in the Kconfig help text of DEBUG_INFO?
>  > > Something like:
>  > >
>  > > "You don't need to enable this if you want symbolic names for kernel
>  > > objects. Enable CONFIG_KALLSYMS instead."
>  > 
>  > Probably. And then we should make sure that allyesconfig/allmodconfig
>  > don't pick it.
>  > 
>  > There *are* reasonable uses for DEBUG_INFO:
>  > 
>  >  - if you very actively and extensively use kgdb, DEBUG_INFO is very useful.
>  > 
>  >  - distros might want to build distro kernels with DEBUG_INFO for the
>  > kernel debug package
> 
> - objdump -S is kind of useful. I find myself using that quite often.
>   (like at least a dozen times each merge window)

For those with wimpy asm muscles (/me), it's very useful indeed, as are
gdb list *foo()+0x10 or *0xfeedbabedeadbeef.  I always build with full
DEBUG_INFO, just keep configs lean enough that lots of kernels fit in a
2G /boot, and _never ever_ set a box up with a microscopic root.

> pretty sure it works with DEBUG_INFO_REDUCED though, which is somewhat
> faster than full DEBUG_INFO

Yeah, it does.

-Mike

