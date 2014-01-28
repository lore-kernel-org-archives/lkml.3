Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755310AbaA1RFQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Jan 2014 12:05:16 -0500
Received: from mail-ee0-f52.google.com ([74.125.83.52]:48556 "EHLO
	mail-ee0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754736AbaA1RFO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Jan 2014 12:05:14 -0500
Date: Tue, 28 Jan 2014 18:05:07 +0100
From: Ingo Molnar <mingo@kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Richard Weinberger <richard@nod.at>,
        "H. Peter Anvin" <hpa@linux.intel.com>,
        Kees Cook <keescook@chromium.org>, Cong Ding <dinggnu@gmail.com>,
        Ingo Molnar <mingo@elte.hu>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Mathias Krause <minipli@googlemail.com>,
        Michael Davidson <md@google.com>, Thomas Gleixner <tglx@linutronix.de>,
        Wei Yongjun <yongjun_wei@trendmicro.com.cn>
Subject: Re: [GIT PULL] x86/kaslr for v3.14
Message-ID: <20140128170507.GA16279@gmail.com>
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
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+55aFzRJNEt-tOGgj-6OPB0cMW9ReM6y6kzCyR5bfts1de-Jg@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Linus Torvalds <torvalds@linux-foundation.org> wrote:

> On Tue, Jan 28, 2014 at 8:30 AM, H. Peter Anvin <hpa@zytor.com> wrote:
> >
> > I don't think there is any way to not break anything... we're
> > introducing a new kind of object ("normalized kernel pointer") here.
> 
> I suspect we could just drop the addresses entirely if we have a 
> symbolic version. It's not like the hex addresses are all that 
> interesting, and in commit messages I actually end up editing them 
> out just because they are worthless noise.

Well, I often use the hex numbers to look them up and disassemble them 
in a vmlinux via gdb and 'list *0x1234123412341234' - where the 
vmlinux has no debuginfo. (Debuginfo takes longer to build so I 
generally build without it.)

I'm quite sure other kernel developers do that as well.

> So we could just do "schedule+0x45/0x368" without the actual hex 
> address in brackets..

AFAICS this won't work in a symbol-less vmlinux. Is there some trick 
to do it with gdb?

Thanks,

	Ingo
