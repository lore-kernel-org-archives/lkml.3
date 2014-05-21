Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753264AbaEUVZ5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 May 2014 17:25:57 -0400
Received: from cantor2.suse.de ([195.135.220.15]:53762 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753021AbaEUVZy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 May 2014 17:25:54 -0400
Date: Wed, 21 May 2014 23:25:51 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
To: Borislav Petkov <bp@alien8.de>
cc: Andy Lutomirski <luto@amacapital.net>,
        Thomas Gleixner <tglx@linutronix.de>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Steven Rostedt <rostedt@goodmis.org>, Andi Kleen <andi@firstfloor.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@kernel.org>
Subject: Re: [RFC] x86_64: A real proposal for iret-less return to kernel
In-Reply-To: <20140521163315.GJ21205@pd.tnic>
Message-ID: <alpine.LNX.2.00.1405212323190.12047@pobox.suse.cz>
References: <CALCETrXudJ8BkNF_M-r4O40XLN+PnZ5TOZw0P7N4kqo3qngzyg@mail.gmail.com> <1400639227.9759.21.camel@pippen.local.home> <CALCETrU34B6XMmxcN2ix1bhnPFVRp5vNjyjxXMGYiOERZD483A@mail.gmail.com> <alpine.LRH.2.00.1405211450410.27739@twin.jikos.cz>
 <CALCETrXO9EyWs5hykkAO2wU8udW0WE9AHfvjGog7s9ydPf4iEw@mail.gmail.com> <20140521163315.GJ21205@pd.tnic>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 21 May 2014, Borislav Petkov wrote:

> > ISTM the do_machine_check code ought to consider any kill-worthy MCE
> > from kernel space to be non-recoverable, but I want to keep the scope
> > of these patches under control.
> 
> MCA has a bit called RIPV which, if set, signals that RIP is valid and
> it is safe to return provided we've taken proper care of handling even
> non-correctable errors (memory poisoning, etc).

Yeah, but it tries to send SIGBUS from MCE context. And if MCE triggered 
at the time the CPU was already holding sighand->siglock for that 
particular task, it'll deadlock against itself.

-- 
Jiri Kosina
SUSE Labs
