Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752780AbaEUPWT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 May 2014 11:22:19 -0400
Received: from mail-vc0-f177.google.com ([209.85.220.177]:43740 "EHLO
	mail-vc0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751450AbaEUPWS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 May 2014 11:22:18 -0400
MIME-Version: 1.0
In-Reply-To: <alpine.LRH.2.00.1405211450410.27739@twin.jikos.cz>
References: <CALCETrXudJ8BkNF_M-r4O40XLN+PnZ5TOZw0P7N4kqo3qngzyg@mail.gmail.com>
 <1400639227.9759.21.camel@pippen.local.home> <CALCETrU34B6XMmxcN2ix1bhnPFVRp5vNjyjxXMGYiOERZD483A@mail.gmail.com>
 <alpine.LRH.2.00.1405211450410.27739@twin.jikos.cz>
From: Andy Lutomirski <luto@amacapital.net>
Date: Wed, 21 May 2014 08:21:57 -0700
Message-ID: <CALCETrXO9EyWs5hykkAO2wU8udW0WE9AHfvjGog7s9ydPf4iEw@mail.gmail.com>
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

On May 21, 2014 5:51 AM, "Jiri Kosina" <jkosina@suse.cz> wrote:
>
> On Tue, 20 May 2014, Andy Lutomirski wrote:
>
> > So the issue here is that we can have an NMI followed immediately by
> > an MCE.  The MCE code can call force_sig
>
> This is interesting by itself. force_sig() takes siglock spinlock. This
> really looks like a deadlock sitting there waiting to happen.

ISTM the do_machine_check code ought to consider any kill-worthy MCE
from kernel space to be non-recoverable, but I want to keep the scope
of these patches under control.

That being said, if an MCE that came from CPL0 never tried to return,
this would be simpler.  I don't know enough about the machine check
architecture to know whether that's a reasonable thing to do.

--Andy

>
> --
> Jiri Kosina
> SUSE Labs
>
