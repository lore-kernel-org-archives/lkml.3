Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757437AbaD2ACu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Apr 2014 20:02:50 -0400
Received: from mail-vc0-f180.google.com ([209.85.220.180]:48165 "EHLO
	mail-vc0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755828AbaD2ACe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Apr 2014 20:02:34 -0400
MIME-Version: 1.0
In-Reply-To: <535EDF67.3090501@linux.intel.com>
References: <tip-kicdm89kzw9lldryb1br9od0@git.kernel.org> <1398120472-6190-1-git-send-email-hpa@linux.intel.com>
 <CAPM5UJ1DYxhGASFVTg_2eUDpg1-whe-26mJ9BD+PB=4FM+540g@mail.gmail.com>
 <CAObL_7G06PYn=8LGQT69-qhvyWFm_mJYMkbsuwem0PeiLRe0HQ@mail.gmail.com>
 <535EDEC5.7030209@zytor.com> <535EDF67.3090501@linux.intel.com>
From: Andrew Lutomirski <amluto@gmail.com>
Date: Mon, 28 Apr 2014 17:02:13 -0700
Message-ID: <CAObL_7HVOjpgp0=Ot9ih2tb6x7xv6MGstu-Krad+rrO4cVqyTg@mail.gmail.com>
Subject: Re: [PATCH] x86-64: espfix for 64-bit mode *PROTOTYPE*
To: "H. Peter Anvin" <hpa@linux.intel.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>, comex <comexk@gmail.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Ingo Molnar <mingo@kernel.org>,
        Alexander van Heukelum <heukelum@fastmail.fm>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Boris Ostrovsky <boris.ostrovsky@oracle.com>,
        Borislav Petkov <bp@alien8.de>,
        Arjan van de Ven <arjan.van.de.ven@intel.com>,
        Brian Gerst <brgerst@gmail.com>,
        Alexandre Julliard <julliard@winehq.com>,
        Andi Kleen <andi@firstfloor.org>, Thomas Gleixner <tglx@linutronix.de>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 28, 2014 at 4:08 PM, H. Peter Anvin <hpa@linux.intel.com> wrote:
> On 04/28/2014 04:05 PM, H. Peter Anvin wrote:
>>
>> So I tried writing this bit up, but it fails in some rather spectacular
>> ways.  Furthermore, I have been unable to debug it under Qemu, because
>> breakpoints don't work right (common Qemu problem, sadly.)
>>
>> The kernel code is at:
>>
>> https://git.kernel.org/cgit/linux/kernel/git/hpa/espfix64.git/
>>
>> There are two tests:
>>
>> git://git.zytor.com/users/hpa/test16/test16.git, build it, and run
>> ./run16 test/hello.elf
>> http://www.zytor.com/~hpa/ldttest.c
>>
>> The former will exercise the irq_return_ldt path, but not the fault
>> path; the latter will exercise the fault path, but doesn't actually use
>> a 16-bit segment.
>>
>> Under the 3.14 stock kernel, the former should die with SIGBUS and the
>> latter should pass.
>>
>
> Current status of the above code: if I remove the randomization in
> espfix_64.c then the first test passes; the second generally crashes the
> machine.  With the randomization there, both generally crash the machine.
>
> All my testing so far has been under KVM or Qemu, so there is always the
> possibility that I'm chasing a KVM/Qemu bug, but I suspect it is
> something simpler than that.

I'm compiling your branch.  In the mean time, two possibly stupid questions:

What's the assembly code in the double-fault entry for?

Have you tried hbreak in qemu?  I've had better luck with hbreak than
regular break in the past.

--Andy
