Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753635AbaA3SPW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Jan 2014 13:15:22 -0500
Received: from mail-vb0-f52.google.com ([209.85.212.52]:59052 "EHLO
	mail-vb0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751148AbaA3SPV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Jan 2014 13:15:21 -0500
MIME-Version: 1.0
In-Reply-To: <20140130092301.GB2862@gmail.com>
References: <52E7D2E5.8090208@linux.intel.com>
	<52E7D9FF.1080506@nod.at>
	<52E7DB15.3090808@zytor.com>
	<CA+55aFzRJNEt-tOGgj-6OPB0cMW9ReM6y6kzCyR5bfts1de-Jg@mail.gmail.com>
	<20140128170507.GA16279@gmail.com>
	<CA+55aFw_xs1tUteDrXz21QZB7BFk5p+F5NZ-SpV=CUVjeFwapA@mail.gmail.com>
	<20140128194823.GA18702@gmail.com>
	<CA+55aFzqJe2XFCTu3Wb4hvZULuR97OOeEhQLYvFMF2bYTLb5Vw@mail.gmail.com>
	<20140129081128.GA31489@gmail.com>
	<CA+rthh93phituM24W8KrGygvKtUmByJUtOCS-sELj4QgLqS3cw@mail.gmail.com>
	<20140130092301.GB2862@gmail.com>
Date: Thu, 30 Jan 2014 10:15:20 -0800
X-Google-Sender-Auth: MQVmxHAzAkxk6cLoytbgZofUZm0
Message-ID: <CA+55aFyT1NHBihoZyH2HPrcRGhVSAbd0_xLDrjWrmVEJjW6_EQ@mail.gmail.com>
Subject: Re: [GIT PULL] x86/kaslr for v3.14
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: Mathias Krause <minipli@googlemail.com>, "H. Peter Anvin" <hpa@zytor.com>,
        Richard Weinberger <richard@nod.at>,
        "H. Peter Anvin" <hpa@linux.intel.com>,
        Kees Cook <keescook@chromium.org>, Cong Ding <dinggnu@gmail.com>,
        Ingo Molnar <mingo@elte.hu>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Michael Davidson <md@google.com>, Thomas Gleixner <tglx@linutronix.de>,
        Wei Yongjun <yongjun_wei@trendmicro.com.cn>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 30, 2014 at 1:23 AM, Ingo Molnar <mingo@kernel.org> wrote:
>
> Well, if the consensus is that they help then we better make them
> correct in the KASLR case as well ...

In the kaslr case, the hex values cannot possibly help, since they are
meaningless due to the random offset (the external tools will *not* be
able to use them without relocation information anyway, and if the
tools can take relocation into account, they might as well just take
the symbol name into account anyway).

I'd really suggest dropping the damn thing entirely. Even if you do
use "objdump" (and I admit to doing that quite often myself), the
symbol version isn't really all that hard to use. And the thing is,
once again, the symbol version works even for kaslr, while the raw hex
does not.

I do agree that having to do the arithmetic can be annoying, but it
wouldn't actually be all that hard to write a script that turns the
"objdump" format from hex address to "symbol+offset" format. It would
probably be three lines of perl:

 - parse the "hex: rest-of-line" thing
 - if "rest-of-line" is of the format "<symbol>:", then remember the
hex and the symbol name.
 - print out "symbol+offset: rest-of-line" where "offset" is "hex -
remembered_hex"

Even I could probably do it, and my perl knowledge is really limited
to "I can edit other peoples perl code if I'm lucky". Somebody who
actually does perl probably goes "Three lines? That's a oneliner".

                        Linus
