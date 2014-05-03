Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750920AbaECGMd (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 May 2014 02:12:33 -0400
Received: from terminus.zytor.com ([198.137.202.10]:55732 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750796AbaECGMc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 May 2014 02:12:32 -0400
Message-ID: <536488C2.8040106@zytor.com>
Date: Fri, 02 May 2014 23:12:18 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>,
        Andy Lutomirski <luto@amacapital.net>
CC: Thomas Gleixner <tglx@linutronix.de>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        the arch/x86 maintainers <x86@kernel.org>
Subject: Re: [PATCH v2] x86: Return to kernel without IRET
References: <6cfe29821979c42cd812878e05577f69f99fafaf.1399074748.git.luto@amacapital.net> <CA+55aFwmhOGRv0Z7Sqgk08pTOYDJg4C9GB_XNHRAtiCLFrHG1g@mail.gmail.com>
In-Reply-To: <CA+55aFwmhOGRv0Z7Sqgk08pTOYDJg4C9GB_XNHRAtiCLFrHG1g@mail.gmail.com>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/02/2014 09:32 PM, Linus Torvalds wrote:
> On Fri, May 2, 2014 at 4:53 PM, Andy Lutomirski <luto@amacapital.net> wrote:
>> On my box, this saves about 100ns on each interrupt and trap that
>> happens while running in kernel space.  This speeds up my kernel_pf
>> microbenchmark by about 17%.
> 
> Btw, would you mind _trying_ to do a similar trick for the "return to
> user space" case?
> 
> At least as a proof-of-concept, having a code sequence in user mode
> trampoline that does
> 
>    popq %rsi
>    popq %r11
>    retq $128
> 
> and building up a stack in user space at '%rsp-128' that has the
> values or rsi/r11/rip should allow us to use 'sysret'. Hmm?
> 

That would be a security hole if another userspace thread could muck
with the stack.

	-hpa


