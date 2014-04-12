Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756729AbaDLXcU (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Apr 2014 19:32:20 -0400
Received: from terminus.zytor.com ([198.137.202.10]:57980 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750833AbaDLXcT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Apr 2014 19:32:19 -0400
Message-ID: <5349CCE3.3000003@zytor.com>
Date: Sat, 12 Apr 2014 16:31:47 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: Alexander van Heukelum <heukelum@fastmail.fm>,
        Andy Lutomirski <luto@amacapital.net>, Brian Gerst <brgerst@gmail.com>,
        Ingo Molnar <mingo@kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>, stable@jasper.es
Subject: Re: [tip:x86/urgent] x86-64, modify_ldt: Ban 16-bit segments on 64-bit
 kernels
References: <tip-kicdm89kzw9lldryb1br9od0@git.kernel.org> <CAMzpN2jx4H4p8fQr-WHxVyCHhWi0iO3WZZKyxYD7Dfa7pWkEgg@mail.gmail.com> <53483487.6030103@zytor.com> <53485BB8.1000106@mit.edu> <53485D95.9030301@zytor.com> <1397345179.1772.105823721.224E1140@webmail.messagingengine.com>
In-Reply-To: <1397345179.1772.105823721.224E1140@webmail.messagingengine.com>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/12/2014 04:26 PM, Alexander van Heukelum wrote:
>>>
>>> c. Trampoline in kernel space
>>>
>>> A trampoline in kernel space is not feasible since all ring transition
>>> instructions capable of returning to 16-bit mode require the use of the
>>> stack.
> 
> "16 bit mode" -> "a mode with 16-bit stack"

Yes... I believe it is the SS.B bit that is relevant, not CS.B (although
I haven't confirmed that experimentally.)  Not that that helps one iota,
as far as I can tell.

>>> d. Trampoline in user space
>>>
>>> A return to the vdso with values set up in registers r8-r15 would enable
>>> a trampoline in user space.  Unfortunately there is no way
>>> to do a far JMP entirely with register state so this would require
>>> touching user space memory, possibly in an unsafe manner.
> 
> d.2. trampoline in user space via long mode
> 
> Return from the kernel to a user space trampoline via long mode.
> The kernel changes the stack frame just before executing the iret
> instruction. (the CS and RIP slots are set to run the trampoline code,
> where CS is a long mode segment.) The trampoline code in userspace
> is set up to this single instruction: a far jump to the final CS:EIP
> (compatibility mode).

This still requires user space memory that the kernel can write to.
Long mode is actually exactly identical to what I was suggesting above,
except that I would avoid using self-modifying code in favor of just
parameterization using the high registers.

	-hpa

