Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933519AbaDVR0i (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Apr 2014 13:26:38 -0400
Received: from mail.skyhub.de ([78.46.96.112]:41207 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932873AbaDVR0g (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Apr 2014 13:26:36 -0400
Date: Tue, 22 Apr 2014 19:26:30 +0200
From: Borislav Petkov <bp@alien8.de>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Lutomirski <amluto@gmail.com>,
        "H. Peter Anvin" <hpa@linux.intel.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@kernel.org>,
        Alexander van Heukelum <heukelum@fastmail.fm>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Boris Ostrovsky <boris.ostrovsky@oracle.com>,
        Arjan van de Ven <arjan.van.de.ven@intel.com>,
        Brian Gerst <brgerst@gmail.com>,
        Alexandre Julliard <julliard@winehq.com>,
        Andi Kleen <andi@firstfloor.org>, Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH] x86-64: espfix for 64-bit mode *PROTOTYPE*
Message-ID: <20140422172630.GG15882@pd.tnic>
References: <CAObL_7HTDvN2zu2_CDnVR_ztZ-b7PfLYz0csuVX-ShQ7EHGEjg@mail.gmail.com>
 <20140422112312.GB15882@pd.tnic>
 <20140422144659.GF15882@pd.tnic>
 <CAObL_7FGs4n6zusbdwTLi5W5q2V81Sf7pOnOmHPFyv5d7jMfvA@mail.gmail.com>
 <53569467.1030809@zytor.com>
 <CAObL_7F9yxt=vXjbssYB5wjZ7HUyKcstG7KYaRWxDDK0n7_vQw@mail.gmail.com>
 <CA+55aFyg1n6=Lnp_qhqdGESoP3u-sv_+MbvSdT4MEutGQAJESg@mail.gmail.com>
 <CAObL_7HdWs2hoNYd0gKzh6iVJr293Z9p+Dg1C6u+5GYQiDfgnA@mail.gmail.com>
 <CA+55aFzRf2Dhh3Eea1E74cpD9DXijUHpsXa71AURy_n6F_JKbw@mail.gma!il.com>
 <5356A2BF.2060609@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <5356A2BF.2060609@zytor.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 22, 2014 at 10:11:27AM -0700, H. Peter Anvin wrote:
> The fastpath interference is:
> 
> 1. Testing for an LDT SS selector before IRET.  This is actually easier
> than on 32 bits, because on 64 bits the SS:RSP on the stack is always valid.
> 
> 2. Testing for an RSP inside the espfix region on exception entry, so we
> can switch back the stack.  This has to be done very early in the
> exception entry since the espfix stack is so small.  If NMI and #MC
> didn't use IST it wouldn't work at all (but neither would SYSCALL).
> 
> #2 currently saves/restores %rdi, which is also saved further down.
> This is obviously wasteful.

Btw, can we runtime-patch the fastpath interference chunk the moment we
see a 16-bit segment? I.e., connect it to the write_idt() path, i.e. in
the hunk you've removed in there and enable the espfix checks there the
moment we load a 16-bit segment.

I know, I know, this is not so important right now but let me put it out
there just the same.

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
