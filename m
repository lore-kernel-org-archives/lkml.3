Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755799AbaA1UZS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Jan 2014 15:25:18 -0500
Received: from mail-vc0-f177.google.com ([209.85.220.177]:53592 "EHLO
	mail-vc0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755765AbaA1UZQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Jan 2014 15:25:16 -0500
MIME-Version: 1.0
In-Reply-To: <20140128201536.GB5178@pd.tnic>
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
	<20140128201536.GB5178@pd.tnic>
Date: Tue, 28 Jan 2014 12:25:15 -0800
X-Google-Sender-Auth: zVLlHbo3R7xE6U7Fgr6wfUT-eSU
Message-ID: <CA+55aFwpsAatO7dy_jQM1NdM5VfJy33RaQ0tJzx+KN_oJsHcBQ@mail.gmail.com>
Subject: Re: [GIT PULL] x86/kaslr for v3.14
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Borislav Petkov <bp@alien8.de>
Cc: Ingo Molnar <mingo@kernel.org>, "H. Peter Anvin" <hpa@zytor.com>,
        Richard Weinberger <richard@nod.at>,
        "H. Peter Anvin" <hpa@linux.intel.com>,
        Kees Cook <keescook@chromium.org>, Cong Ding <dinggnu@gmail.com>,
        Ingo Molnar <mingo@elte.hu>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Mathias Krause <minipli@googlemail.com>,
        Michael Davidson <md@google.com>, Thomas Gleixner <tglx@linutronix.de>,
        Wei Yongjun <yongjun_wei@trendmicro.com.cn>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 28, 2014 at 12:15 PM, Borislav Petkov <bp@alien8.de> wrote:
>
> Shouldn't we hold that down in the Kconfig help text of DEBUG_INFO?
> Something like:
>
> "You don't need to enable this if you want symbolic names for kernel
> objects. Enable CONFIG_KALLSYMS instead."

Probably. And then we should make sure that allyesconfig/allmodconfig
don't pick it.

There *are* reasonable uses for DEBUG_INFO:

 - if you very actively and extensively use kgdb, DEBUG_INFO is very useful.

 - distros might want to build distro kernels with DEBUG_INFO for the
kernel debug package

but for most kernel developers, DEBUG_INFO really just bloats things
and makes the build much *much* slower, for very little gain. Sure,
you get line numbers, but let's face it, it's not that hard to just do
"x/20i <address>" and trying to match it up with the generated code
instead. And since "just match it up" model works with user-reported
oopses of random kernels, you had better be able and willing to do
that *anyway*.

If most of the oopses you decode are on your own machine with your own
kernel, you might want to try to learn to be more careful when writing
code. And I'm not even kidding.

                       Linus
