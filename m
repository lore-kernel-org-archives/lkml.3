Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752811AbaEUQa1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 May 2014 12:30:27 -0400
Received: from mail.skyhub.de ([78.46.96.112]:57088 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752149AbaEUQa0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 May 2014 12:30:26 -0400
Date: Wed, 21 May 2014 18:30:02 +0200
From: Borislav Petkov <bp@alien8.de>
To: Andy Lutomirski <luto@amacapital.net>
Cc: Andi Kleen <andi@firstfloor.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Steven Rostedt <rostedt@goodmis.org>, Ingo Molnar <mingo@kernel.org>
Subject: Re: [RFC] x86_64: A real proposal for iret-less return to kernel
Message-ID: <20140521163002.GI21205@pd.tnic>
References: <CALCETrXudJ8BkNF_M-r4O40XLN+PnZ5TOZw0P7N4kqo3qngzyg@mail.gmail.com>
 <1400639227.9759.21.camel@pippen.local.home>
 <CALCETrU34B6XMmxcN2ix1bhnPFVRp5vNjyjxXMGYiOERZD483A@mail.gmail.com>
 <20140521094626.GB21205@pd.tnic>
 <CALCETrWkAnSe6kzha5+MmnZn+YT+rBrmu0vz+9Pr94uUjh9dDQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <CALCETrWkAnSe6kzha5+MmnZn+YT+rBrmu0vz+9Pr94uUjh9dDQ@mail.gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 21, 2014 at 08:21:08AM -0700, Andy Lutomirski wrote:
> On May 21, 2014 2:46 AM, "Borislav Petkov" <bp@alien8.de> wrote:
> >
> > On Tue, May 20, 2014 at 07:39:31PM -0700, Andy Lutomirski wrote:
> > > So the issue here is that we can have an NMI followed immediately by
> > > an MCE.
> >
> > That part might need clarification for me: #MC is higher prio interrupt
> > than NMI so a machine check exception can interrupt the NMI handler at
> > any point.
> 
> Except that NMI can interrupt #MC at any point as well, I think.

No, #MC is higher prio than NMI, actually even the highest along with
RESET#. And come to think of it, all exceptions which have a higher prio
than NMI should touch that nmi_mce_nest_count thing.

See Table 8-8 here:

http://amd-dev.wpengine.netdna-cdn.com/wordpress/media/2012/10/24593_APM_v21.pdf

That's the prios before 3, i.e. the NMI one.

HOWEVER, this all is spoken with the assumption that higher prio
interrupts can interrupt the NMI handler too at the first instruction
boundary they've been recognized.

The text is talking about simultaneous interrupts and not about
interrupt handler preemption.

But it must be because Steve wouldn't be dealing with exceptions in the
NMI handler and nested NMIs otherwise...

Hmmm.

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
