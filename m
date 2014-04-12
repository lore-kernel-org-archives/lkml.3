Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756814AbaDLXta (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Apr 2014 19:49:30 -0400
Received: from out5-smtp.messagingengine.com ([66.111.4.29]:51467 "EHLO
	out5-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756223AbaDLXt3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Apr 2014 19:49:29 -0400
Message-Id: <1397346568.13490.105824481.72FA2B8D@webmail.messagingengine.com>
X-Sasl-Enc: s4H/BqldMyf8QYiW3sWD4cuuXePCoqYGoSutYTjfMRHI 1397346568
From: Alexander van Heukelum <heukelum@fastmail.fm>
To: "H. Peter Anvin" <hpa@zytor.com>, Andy Lutomirski <luto@amacapital.net>,
        Brian Gerst <brgerst@gmail.com>, Ingo Molnar <mingo@kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>, stable@jasper.es
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Type: text/plain
X-Mailer: MessagingEngine.com Webmail Interface - ajax-5be85a12
In-Reply-To: <5349CCE3.3000003@zytor.com>
References: <tip-kicdm89kzw9lldryb1br9od0@git.kernel.org>
 <CAMzpN2jx4H4p8fQr-WHxVyCHhWi0iO3WZZKyxYD7Dfa7pWkEgg@mail.gmail.com>
 <53483487.6030103@zytor.com> <53485BB8.1000106@mit.edu>
 <53485D95.9030301@zytor.com>
 <1397345179.1772.105823721.224E1140@webmail.messagingengine.com>
 <5349CCE3.3000003@zytor.com>
Subject: Re: [tip:x86/urgent] x86-64,
 modify_ldt: Ban 16-bit segments on 64-bit kernels
Date: Sun, 13 Apr 2014 01:49:28 +0200
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Apr 13, 2014, at 1:31, H. Peter Anvin wrote:
> >>> d. Trampoline in user space
> >>>
> >>> A return to the vdso with values set up in registers r8-r15 would enable
> >>> a trampoline in user space.  Unfortunately there is no way
> >>> to do a far JMP entirely with register state so this would require
> >>> touching user space memory, possibly in an unsafe manner.
> > 
> > d.2. trampoline in user space via long mode
> > 
> > Return from the kernel to a user space trampoline via long mode.
> > The kernel changes the stack frame just before executing the iret
> > instruction. (the CS and RIP slots are set to run the trampoline code,
> > where CS is a long mode segment.) The trampoline code in userspace
> > is set up to this single instruction: a far jump to the final CS:EIP
> > (compatibility mode).
> 
> This still requires user space memory that the kernel can write to.
> Long mode is actually exactly identical to what I was suggesting above,
> except that I would avoid using self-modifying code in favor of just
> parameterization using the high registers.

No self modifying code... The far jump must be in the indirect form
anyhow. The CS:EIP must be accessible from user mode, but not
necessarily from compatibility mode. So the trampoline (the jump)
and data (CS:EIP) can live pretty much anywhere in virtual memory.
But indeed, I see what you meant now.

Greetings,
   Alexander

> 
> 	-hpa
> 
