Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754745AbaA2I1O (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Jan 2014 03:27:14 -0500
Received: from mail-lb0-f180.google.com ([209.85.217.180]:33121 "EHLO
	mail-lb0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753860AbaA2I1N (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Jan 2014 03:27:13 -0500
MIME-Version: 1.0
In-Reply-To: <20140129081128.GA31489@gmail.com>
References: <20140128062806.GA20750@gmail.com>
	<52E76997.40303@nod.at>
	<52E7D2E5.8090208@linux.intel.com>
	<52E7D9FF.1080506@nod.at>
	<52E7DB15.3090808@zytor.com>
	<CA+55aFzRJNEt-tOGgj-6OPB0cMW9ReM6y6kzCyR5bfts1de-Jg@mail.gmail.com>
	<20140128170507.GA16279@gmail.com>
	<CA+55aFw_xs1tUteDrXz21QZB7BFk5p+F5NZ-SpV=CUVjeFwapA@mail.gmail.com>
	<20140128194823.GA18702@gmail.com>
	<CA+55aFzqJe2XFCTu3Wb4hvZULuR97OOeEhQLYvFMF2bYTLb5Vw@mail.gmail.com>
	<20140129081128.GA31489@gmail.com>
Date: Wed, 29 Jan 2014 09:27:08 +0100
Message-ID: <CA+rthh93phituM24W8KrGygvKtUmByJUtOCS-sELj4QgLqS3cw@mail.gmail.com>
Subject: Re: [GIT PULL] x86/kaslr for v3.14
From: Mathias Krause <minipli@googlemail.com>
To: Ingo Molnar <mingo@kernel.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        "H. Peter Anvin" <hpa@zytor.com>, Richard Weinberger <richard@nod.at>,
        "H. Peter Anvin" <hpa@linux.intel.com>,
        Kees Cook <keescook@chromium.org>, Cong Ding <dinggnu@gmail.com>,
        Ingo Molnar <mingo@elte.hu>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Michael Davidson <md@google.com>, Thomas Gleixner <tglx@linutronix.de>,
        Wei Yongjun <yongjun_wei@trendmicro.com.cn>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 29 January 2014 09:11, Ingo Molnar <mingo@kernel.org> wrote:
>> But you can see that the symbol is perfectly fine:
>>
>>   (gdb) list *(schedule+0x45)
>
> Oh, cool. Thanks for that trick - this will save me quite some time in
> the future.
>
> So we can strip absolute addresses just fine from oopses - cool.
>
> I'd even argue to strip the hex on non-randomized kernels as long as
> there's kallsyms around, and only print hex if we don't have any
> symbols.

Please, don't do so! I do find the hex values in the backtrace *very*
useful as I'm using 'objdump -wdr vmlinux | less' quite often to
"browse around" in the kernel binary. Grepping for addresses from a
backtrace works quite nicely this way. Having to lookup symbols and do
base-16 arithmetics in the head (or a shell, for that matter) would
only slow down this process. So, please leave the hex values in place.
They do help a lot -- at least in the non-kASLR case.

Regards,
Mathias
