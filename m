Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753386AbaEUVxR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 May 2014 17:53:17 -0400
Received: from mail-ve0-f174.google.com ([209.85.128.174]:65526 "EHLO
	mail-ve0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752687AbaEUVxP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 May 2014 17:53:15 -0400
MIME-Version: 1.0
In-Reply-To: <20140521214845.GG25130@pd.tnic>
References: <CALCETrXudJ8BkNF_M-r4O40XLN+PnZ5TOZw0P7N4kqo3qngzyg@mail.gmail.com>
 <1400639227.9759.21.camel@pippen.local.home> <CALCETrU34B6XMmxcN2ix1bhnPFVRp5vNjyjxXMGYiOERZD483A@mail.gmail.com>
 <alpine.LRH.2.00.1405211450410.27739@twin.jikos.cz> <CALCETrXO9EyWs5hykkAO2wU8udW0WE9AHfvjGog7s9ydPf4iEw@mail.gmail.com>
 <20140521163315.GJ21205@pd.tnic> <alpine.LNX.2.00.1405212323190.12047@pobox.suse.cz>
 <CALCETrVPVcyTd8FYV90DPhKvGW1GhHxkUPObpXK69AhwwqLi1w@mail.gmail.com> <20140521214845.GG25130@pd.tnic>
From: Andy Lutomirski <luto@amacapital.net>
Date: Wed, 21 May 2014 14:52:55 -0700
Message-ID: <CALCETrUr75gGj3E5cSZdGRpX-wd6pDzDruMGave+GbnpWaptRA@mail.gmail.com>
Subject: Re: [RFC] x86_64: A real proposal for iret-less return to kernel
To: Borislav Petkov <bp@alien8.de>
Cc: Jiri Kosina <jkosina@suse.cz>, Thomas Gleixner <tglx@linutronix.de>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Steven Rostedt <rostedt@goodmis.org>, Andi Kleen <andi@firstfloor.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@kernel.org>,
        Tony Luck <tony.luck@intel.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 21, 2014 at 2:48 PM, Borislav Petkov <bp@alien8.de> wrote:
> On Wed, May 21, 2014 at 02:35:59PM -0700, Andy Lutomirski wrote:
>> If RIPV is set but we interrupted *kernel* code, SIGBUS doesn't seem
>> like the right solution anyway.
>>
>> Are there any machine check exceptions for which it makes sense to
>> continue right where we left off without a signal?  Is CMIC such a
>> beast?  Can CMIC be delivered when interrupts are off?
>
> I think you mean CMCI and that's not even reported with a MCE exception
> - there's a separate APIC interrupt for that.
>
> I think this signal thing is for killing processes which have poisoned
> memory but this memory can contained within that process and the
> physical page frame can be poisoned so that it doesn't get used ever
> again. In any case, this is an example for an uncorrectable error which
> needs action from us but doesn't necessarily have to kill the whole
> machine.
>
> This is supposed to be more graceful instead of consuming the corrupted
> data and sending it out to disk.
>
> But sending signals from #MC context is definitely a bad idea. I think
> we had addressed this with irq_work at some point but my memory is very
> hazy.

Why is it a problem if user_mode_vm(regs)?  Conversely, why is sending
a signal a remotely reasonable thing to do if !user_mode_vm(regs)?

--Andy
