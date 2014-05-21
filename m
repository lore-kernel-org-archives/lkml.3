Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752471AbaEUJqu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 May 2014 05:46:50 -0400
Received: from mail.skyhub.de ([78.46.96.112]:60401 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751023AbaEUJqt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 May 2014 05:46:49 -0400
Date: Wed, 21 May 2014 11:46:26 +0200
From: Borislav Petkov <bp@alien8.de>
To: Andy Lutomirski <luto@amacapital.net>
Cc: Steven Rostedt <rostedt@goodmis.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Ingo Molnar <mingo@kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
        Andi Kleen <andi@firstfloor.org>
Subject: Re: [RFC] x86_64: A real proposal for iret-less return to kernel
Message-ID: <20140521094626.GB21205@pd.tnic>
References: <CALCETrXudJ8BkNF_M-r4O40XLN+PnZ5TOZw0P7N4kqo3qngzyg@mail.gmail.com>
 <1400639227.9759.21.camel@pippen.local.home>
 <CALCETrU34B6XMmxcN2ix1bhnPFVRp5vNjyjxXMGYiOERZD483A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <CALCETrU34B6XMmxcN2ix1bhnPFVRp5vNjyjxXMGYiOERZD483A@mail.gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 20, 2014 at 07:39:31PM -0700, Andy Lutomirski wrote:
> So the issue here is that we can have an NMI followed immediately by
> an MCE.

That part might need clarification for me: #MC is higher prio interrupt
than NMI so a machine check exception can interrupt the NMI handler at
any point.

But you're talking only about the small window when nmi_mce_nest_count
hasn't been incremented yet, right? I.e., this:

"The result is that the only interrupt that can happen with
`nmi_mce_nest_count == 0` in NMI context is an MCE at the beginning or
end of the NMI handler."

Correct?

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
