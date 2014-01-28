Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932130AbaA1RM7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Jan 2014 12:12:59 -0500
Received: from mail-vc0-f177.google.com ([209.85.220.177]:58630 "EHLO
	mail-vc0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932113AbaA1RM5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Jan 2014 12:12:57 -0500
MIME-Version: 1.0
In-Reply-To: <20140128170507.GA16279@gmail.com>
References: <CAFLxGvxJ0A6hZ52RWffkg_zXXScyPn10P4HcKvdAXfE43h32Eg@mail.gmail.com>
	<CAGXu5jLcy9R_N_FQHMFheVTYSB9uobd-Orh7spEmpMaMXDtwEQ@mail.gmail.com>
	<52E6954F.2060303@nod.at>
	<CAGXu5jKXqUhTdhX_n8xSe+d3sPmZ0SK-aTQh2jCXWL6TgA5o=w@mail.gmail.com>
	<20140128062806.GA20750@gmail.com>
	<52E76997.40303@nod.at>
	<52E7D2E5.8090208@linux.intel.com>
	<52E7D9FF.1080506@nod.at>
	<52E7DB15.3090808@zytor.com>
	<CA+55aFzRJNEt-tOGgj-6OPB0cMW9ReM6y6kzCyR5bfts1de-Jg@mail.gmail.com>
	<20140128170507.GA16279@gmail.com>
Date: Tue, 28 Jan 2014 09:12:56 -0800
X-Google-Sender-Auth: JkFCcVApvZnJjdVx1hdCa8n4mh8
Message-ID: <CA+55aFw_xs1tUteDrXz21QZB7BFk5p+F5NZ-SpV=CUVjeFwapA@mail.gmail.com>
Subject: Re: [GIT PULL] x86/kaslr for v3.14
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Richard Weinberger <richard@nod.at>,
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

On Tue, Jan 28, 2014 at 9:05 AM, Ingo Molnar <mingo@kernel.org> wrote:
>
> Well, I often use the hex numbers to look them up and disassemble them
> in a vmlinux via gdb and 'list *0x1234123412341234' - where the
> vmlinux has no debuginfo. (Debuginfo takes longer to build so I
> generally build without it.)

Why the heck wouldn't you do that? Just do

   list schedule+0x45

instead.

> AFAICS this won't work in a symbol-less vmlinux. Is there some trick
> to do it with gdb?

Why would you have a symbol-less vmlinux? The only reason to strip
vmlinux is because you were crazy enough to build with
CONFIG_DEBUG_INFO and the damn debug info is so large that it won't
fit on your root partition. But dammit, if you build with debug_info
and then strip the end result, you're just insane. You made your build
take ten times longer, use ten times more diskspace, and then you
throw it all away. Crazy.

So I don't think the symbol-less version is worth even worrying about.
You do want to build with KALLSYMS (or whatever the config option is
called), so that the symbolic name is worth something, but once you
have the symbolc name, you're good unless you did something terminally
stupid.

Btw, we should make it harder to enable CONFIG_DEBUG_INFO. It's a
f*cking pain. It's particularly nasty when you do "make allmodconfig"
and it enables debug-info and makes the build take forever and waste
diskspace - but nobody sane actually *boots* the end result, so that
debug info is all pointless.

                  Linus
