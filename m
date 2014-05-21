Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753545AbaEUV7Y (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 May 2014 17:59:24 -0400
Received: from cantor2.suse.de ([195.135.220.15]:54306 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752629AbaEUV7X (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 May 2014 17:59:23 -0400
Date: Wed, 21 May 2014 23:59:21 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
To: Borislav Petkov <bp@alien8.de>
cc: Andy Lutomirski <luto@amacapital.net>,
        Thomas Gleixner <tglx@linutronix.de>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Steven Rostedt <rostedt@goodmis.org>, Andi Kleen <andi@firstfloor.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@kernel.org>,
        Tony Luck <tony.luck@intel.com>
Subject: Re: [RFC] x86_64: A real proposal for iret-less return to kernel
In-Reply-To: <20140521215547.GJ25130@pd.tnic>
Message-ID: <alpine.LNX.2.00.1405212357150.12047@pobox.suse.cz>
References: <CALCETrXudJ8BkNF_M-r4O40XLN+PnZ5TOZw0P7N4kqo3qngzyg@mail.gmail.com> <1400639227.9759.21.camel@pippen.local.home> <CALCETrU34B6XMmxcN2ix1bhnPFVRp5vNjyjxXMGYiOERZD483A@mail.gmail.com> <alpine.LRH.2.00.1405211450410.27739@twin.jikos.cz>
 <CALCETrXO9EyWs5hykkAO2wU8udW0WE9AHfvjGog7s9ydPf4iEw@mail.gmail.com> <20140521163315.GJ21205@pd.tnic> <alpine.LNX.2.00.1405212323190.12047@pobox.suse.cz> <CALCETrVPVcyTd8FYV90DPhKvGW1GhHxkUPObpXK69AhwwqLi1w@mail.gmail.com> <20140521214845.GG25130@pd.tnic>
 <CALCETrUr75gGj3E5cSZdGRpX-wd6pDzDruMGave+GbnpWaptRA@mail.gmail.com> <20140521215547.GJ25130@pd.tnic>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 21 May 2014, Borislav Petkov wrote:

> > Why is it a problem if user_mode_vm(regs)?  Conversely, why is sending
> > a signal a remotely reasonable thing to do if !user_mode_vm(regs)?
> 
> Let me quote Jiri:
> 
> (1) task sends signal to itself
> (2) it acquires sighand->siglock so that it's able to queue the signal
> (3) MCE triggers
> (4) it tries to send a signal to the same task
> (5) it tries to acquire sighand->siglock and loops forever

Ah, alright, but due to what mce_severity() does, this can't happen, 
because if the current CPU is in the kernel (which is obviously implied by 
holding a spinlock), it never proceeds sending the signal, becase 
no_way_out gets set and mce_panic() invoked.

-- 
Jiri Kosina
SUSE Labs
