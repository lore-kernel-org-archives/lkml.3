Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753387AbaEUVgV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 May 2014 17:36:21 -0400
Received: from mail-vc0-f174.google.com ([209.85.220.174]:54779 "EHLO
	mail-vc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752629AbaEUVgU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 May 2014 17:36:20 -0400
MIME-Version: 1.0
In-Reply-To: <alpine.LNX.2.00.1405212323190.12047@pobox.suse.cz>
References: <CALCETrXudJ8BkNF_M-r4O40XLN+PnZ5TOZw0P7N4kqo3qngzyg@mail.gmail.com>
 <1400639227.9759.21.camel@pippen.local.home> <CALCETrU34B6XMmxcN2ix1bhnPFVRp5vNjyjxXMGYiOERZD483A@mail.gmail.com>
 <alpine.LRH.2.00.1405211450410.27739@twin.jikos.cz> <CALCETrXO9EyWs5hykkAO2wU8udW0WE9AHfvjGog7s9ydPf4iEw@mail.gmail.com>
 <20140521163315.GJ21205@pd.tnic> <alpine.LNX.2.00.1405212323190.12047@pobox.suse.cz>
From: Andy Lutomirski <luto@amacapital.net>
Date: Wed, 21 May 2014 14:35:59 -0700
Message-ID: <CALCETrVPVcyTd8FYV90DPhKvGW1GhHxkUPObpXK69AhwwqLi1w@mail.gmail.com>
Subject: Re: [RFC] x86_64: A real proposal for iret-less return to kernel
To: Jiri Kosina <jkosina@suse.cz>
Cc: Borislav Petkov <bp@alien8.de>, Thomas Gleixner <tglx@linutronix.de>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Steven Rostedt <rostedt@goodmis.org>, Andi Kleen <andi@firstfloor.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 21, 2014 at 2:25 PM, Jiri Kosina <jkosina@suse.cz> wrote:
> On Wed, 21 May 2014, Borislav Petkov wrote:
>
>> > ISTM the do_machine_check code ought to consider any kill-worthy MCE
>> > from kernel space to be non-recoverable, but I want to keep the scope
>> > of these patches under control.
>>
>> MCA has a bit called RIPV which, if set, signals that RIP is valid and
>> it is safe to return provided we've taken proper care of handling even
>> non-correctable errors (memory poisoning, etc).
>
> Yeah, but it tries to send SIGBUS from MCE context. And if MCE triggered
> at the time the CPU was already holding sighand->siglock for that
> particular task, it'll deadlock against itself.
>

If RIPV is set but we interrupted *kernel* code, SIGBUS doesn't seem
like the right solution anyway.

Are there any machine check exceptions for which it makes sense to
continue right where we left off without a signal?  Is CMIC such a
beast?  Can CMIC be delivered when interrupts are off?

--Andy
