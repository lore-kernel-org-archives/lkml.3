Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753990AbaAUFSs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Jan 2014 00:18:48 -0500
Received: from mail-oa0-f49.google.com ([209.85.219.49]:64730 "EHLO
	mail-oa0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753517AbaAUFSh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Jan 2014 00:18:37 -0500
MIME-Version: 1.0
In-Reply-To: <CA+55aFyxisSNKstMuanfrkhu5=2bxcu2cxZxMg38Zw0HAoXppg@mail.gmail.com>
References: <201401201647.s0KGlZdh004167@tazenda.hos.anvin.org>
	<CA+55aFyxisSNKstMuanfrkhu5=2bxcu2cxZxMg38Zw0HAoXppg@mail.gmail.com>
Date: Mon, 20 Jan 2014 21:18:37 -0800
X-Google-Sender-Auth: Bk0AEApbmTMag6MvQOQLVcRvkcA
Message-ID: <CAGXu5jJ7FFpjAkuMjXLXFd5P=FewfHDSReVsZGhYgPVuYMyzBw@mail.gmail.com>
Subject: Re: [GIT PULL] x86/kaslr for v3.14
From: Kees Cook <keescook@chromium.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Cong Ding <dinggnu@gmail.com>,
        "H. Peter Anvin" <hpa@linux.intel.com>, Ingo Molnar <mingo@elte.hu>,
        Ingo Molnar <mingo@kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Mathias Krause <minipli@googlemail.com>,
        Michael Davidson <md@google.com>, Thomas Gleixner <tglx@linutronix.de>,
        Wei Yongjun <yongjun_wei@trendmicro.com.cn>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 20, 2014 at 2:54 PM, Linus Torvalds
<torvalds@linux-foundation.org> wrote:
> So I pulled this, but one question:
>
> On Mon, Jan 20, 2014 at 8:47 AM, H. Peter Anvin <hpa@zytor.com> wrote:
>> +config RANDOMIZE_BASE
>> +       bool "Randomize the address of the kernel image"
>> +       depends on RELOCATABLE
>> +       depends on !HIBERNATION
>
> How fundamental is that "!HIBERNATION" issue? Right now that
> anti-dependency on hibernation support will mean that no distro kernel
> will actually use the kernel address space randomization. Which
> long-term is a problem.
>
> I'm not sure HIBERNATION is really getting all that much use, but I
> suspect distros would still want to support it.
>
> Is it just a temporary "I wasn't able to make it work, need to get
> some PM people involved", or is it something really fundamental?

Right, this is a "need to get PM people involved" situation. When
kASLR was being designed, hibernation learning about the kernel base
looked like a separable problem, and given the very long list of
requirements for making it work at all, I carved this out as "future
work".

As for perf, it's similar -- it's another entirely solvable problem,
but perf needs to be untaught some of its assumptions.

We've had a static kernel base forever, so I'm expecting some bumps in
the road here. I'm hopeful none of it will be too painful, though.

-Kees

-- 
Kees Cook
Chrome OS Security
