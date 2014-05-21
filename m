Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752487AbaEUQdk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 May 2014 12:33:40 -0400
Received: from mail.skyhub.de ([78.46.96.112]:54131 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751018AbaEUQdi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 May 2014 12:33:38 -0400
Date: Wed, 21 May 2014 18:33:15 +0200
From: Borislav Petkov <bp@alien8.de>
To: Andy Lutomirski <luto@amacapital.net>
Cc: Jiri Kosina <jkosina@suse.cz>, Thomas Gleixner <tglx@linutronix.de>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Steven Rostedt <rostedt@goodmis.org>, Andi Kleen <andi@firstfloor.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@kernel.org>
Subject: Re: [RFC] x86_64: A real proposal for iret-less return to kernel
Message-ID: <20140521163315.GJ21205@pd.tnic>
References: <CALCETrXudJ8BkNF_M-r4O40XLN+PnZ5TOZw0P7N4kqo3qngzyg@mail.gmail.com>
 <1400639227.9759.21.camel@pippen.local.home>
 <CALCETrU34B6XMmxcN2ix1bhnPFVRp5vNjyjxXMGYiOERZD483A@mail.gmail.com>
 <alpine.LRH.2.00.1405211450410.27739@twin.jikos.cz>
 <CALCETrXO9EyWs5hykkAO2wU8udW0WE9AHfvjGog7s9ydPf4iEw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <CALCETrXO9EyWs5hykkAO2wU8udW0WE9AHfvjGog7s9ydPf4iEw@mail.gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 21, 2014 at 08:21:57AM -0700, Andy Lutomirski wrote:
> ISTM the do_machine_check code ought to consider any kill-worthy MCE
> from kernel space to be non-recoverable, but I want to keep the scope
> of these patches under control.

MCA has a bit called RIPV which, if set, signals that RIP is valid and
it is safe to return provided we've taken proper care of handling even
non-correctable errors (memory poisoning, etc).

If RIPV is not set, we panic anyway.

> That being said, if an MCE that came from CPL0 never tried to return,
> this would be simpler.  I don't know enough about the machine check
> architecture to know whether that's a reasonable thing to do.

Yeah, there are cases where MCE can return, see above.

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
