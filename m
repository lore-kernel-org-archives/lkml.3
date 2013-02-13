Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932254Ab3BMIXa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Feb 2013 03:23:30 -0500
Received: from mail-ea0-f177.google.com ([209.85.215.177]:38698 "EHLO
	mail-ea0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755433Ab3BMIX3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Feb 2013 03:23:29 -0500
Message-ID: <511B4D76.50504@redhat.com>
Date: Wed, 13 Feb 2013 09:23:18 +0100
From: Paolo Bonzini <pbonzini@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130110 Thunderbird/17.0.2
MIME-Version: 1.0
To: Ingo Molnar <mingo@kernel.org>
CC: Linus Torvalds <torvalds@linux-foundation.org>,
        "H. Peter Anvin" <hpa@linux.intel.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Randy Dunlap <rdunlap@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        David Rientjes <rientjes@google.com>,
        David Woodhouse <dwmw2@infradead.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sasha Levin <levinsasha928@gmail.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Pekka Enberg <penberg@kernel.org>,
        Michal Marek <mmarek@suse.cz>, Stephen Rothwell <sfr@canb.auug.org.au>
Subject: Re: kvmtool tree (Was: Re: [patch] config: fix make kvmconfig)
References: <CAOJsxLFDbmNitH=N8v3jSno0SFL33s=nPc+hGRAqJfYFZS0RGw@mail.gmail.com> <CA+55aFy=SaVjNby=Jy_O9ZRQ_Ofc-6_+bLv=HeMMSzQQHw9vMQ@mail.gmail.com> <CAOJsxLFpE=HjkPcX6NsWS8636qnEhDFDJi+49xX2Ge3Xp4MeUg@mail.gmail.com> <CA+55aFzXF-4Xwc4HU8vnTin4WqtvYcpXq0TsqTN_vRg=myLH_Q@mail.gmail.com> <20130211122654.GA5802@gmail.com> <CA+55aFwq+_TvOZNEPO-eFPjYuPuMFL0bgR0x=nLq_tvfATqaTA@mail.gmail.com> <20130211172807.GA9716@gmail.com> <CA+55aFx-0-qcYMqH2wnJJ7iAPhoEvD_EQ0xqVW3VGS3G9=_1_w@mail.gmail.com> <20130211175856.GC9716@gmail.com> <CA+55aFxpH2A5pTkeAt-bapN6Erac7SSEUhS9qaZ6jUhm_0EAtA@mail.gmail.com> <20130212095249.GC20039@gmail.com>
In-Reply-To: <20130212095249.GC20039@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Il 12/02/2013 10:52, Ingo Molnar ha scritto:
> Check the list I gave (unmodified):
> 
> "- Pekka listed new virtio drivers that were done via tools/kvm. 

vhost-scsi got in first in tools/kvm, but out-of-tree patches had
existed for QEMU for more than a year.  It was developed with QEMU.

>  - Pekka listed ARM KVM support which was written/prototyped
>    using tools/kvm.

Again, I think both QEMU and tools/kvm were used, with QEMU probably
coming first.  However, I'm not 100% sure.

>  - There's over a dozen bugfixes in your kernel which were found
>    via syscall fuzzing built into tools/kvm. (I can dig them all
>    out if you want.)

This sounds like something that runs in a guest, not in the host.  As
such it need not be tied to tools/kvm.  If there is a host component
(host C code), I'd be interested.  I know that Fujitsu guys have patches
for panic notification from the guest kernel, for example.

But if there is a host component to it, then please go back to the
original purpose of tools/kvm.  Drop all the QCOW, VNC, SeaBIOS
nonsense.  Drop the userspace networking stack (tap is enough).  Make
the tool into a library that supports nothing but virtio-{blk,net,9p}
and VFIO.  Build _many_ narrow-focused tools around that library.

>> "sparse" is useful for kernel development. "git" is useful for 
>> kernel development. "xterm" is useful for kernel development.
> 
> That argument is silly beyond belief. Read this list:
> 
>   - tools/kvm
>   - sparse
>   - git
>   - xterm
>   - perf
> 
> Which two tools in this list:
> 
>  - Use and focus on Linux specific system calls to provide Linux
>    specific functionality?
> 
>  - Are never - and will conceivably never - run on any kernel
>    which is not extremely Linux compatible?

QEMU runs KVM on Solaris, FWIW.

Paolo
