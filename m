Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752709AbaEUPVa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 May 2014 11:21:30 -0400
Received: from mail-vc0-f171.google.com ([209.85.220.171]:52537 "EHLO
	mail-vc0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752218AbaEUPV3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 May 2014 11:21:29 -0400
MIME-Version: 1.0
In-Reply-To: <20140521094626.GB21205@pd.tnic>
References: <CALCETrXudJ8BkNF_M-r4O40XLN+PnZ5TOZw0P7N4kqo3qngzyg@mail.gmail.com>
 <1400639227.9759.21.camel@pippen.local.home> <CALCETrU34B6XMmxcN2ix1bhnPFVRp5vNjyjxXMGYiOERZD483A@mail.gmail.com>
 <20140521094626.GB21205@pd.tnic>
From: Andy Lutomirski <luto@amacapital.net>
Date: Wed, 21 May 2014 08:21:08 -0700
Message-ID: <CALCETrWkAnSe6kzha5+MmnZn+YT+rBrmu0vz+9Pr94uUjh9dDQ@mail.gmail.com>
Subject: Re: [RFC] x86_64: A real proposal for iret-less return to kernel
To: Borislav Petkov <bp@alien8.de>
Cc: Andi Kleen <andi@firstfloor.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Steven Rostedt <rostedt@goodmis.org>, Ingo Molnar <mingo@kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On May 21, 2014 2:46 AM, "Borislav Petkov" <bp@alien8.de> wrote:
>
> On Tue, May 20, 2014 at 07:39:31PM -0700, Andy Lutomirski wrote:
> > So the issue here is that we can have an NMI followed immediately by
> > an MCE.
>
> That part might need clarification for me: #MC is higher prio interrupt
> than NMI so a machine check exception can interrupt the NMI handler at
> any point.

Except that NMI can interrupt #MC at any point as well, I think.

>
> But you're talking only about the small window when nmi_mce_nest_count
> hasn't been incremented yet, right? I.e., this:
>
> "The result is that the only interrupt that can happen with
> `nmi_mce_nest_count == 0` in NMI context is an MCE at the beginning or
> end of the NMI handler."
>
> Correct?

Exactly.

>
> --
> Regards/Gruss,
>     Boris.
>
> Sent from a fat crate under my desk. Formatting is fine.
> --
