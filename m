Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753765AbaEUWdh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 May 2014 18:33:37 -0400
Received: from mail-ve0-f173.google.com ([209.85.128.173]:60304 "EHLO
	mail-ve0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753402AbaEUWde (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 May 2014 18:33:34 -0400
MIME-Version: 1.0
In-Reply-To: <20140521222541.GO1873@two.firstfloor.org>
References: <CALCETrXudJ8BkNF_M-r4O40XLN+PnZ5TOZw0P7N4kqo3qngzyg@mail.gmail.com>
	<20140521222541.GO1873@two.firstfloor.org>
Date: Thu, 22 May 2014 07:33:32 +0900
X-Google-Sender-Auth: JTGDZsPHGs3lawVTUQj_kjpNz1c
Message-ID: <CA+55aFzx82y5xDa3-6aLm6fCvaf23FH1E14PvmXXUFngwpkdgw@mail.gmail.com>
Subject: Re: [RFC] x86_64: A real proposal for iret-less return to kernel
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Andi Kleen <andi@firstfloor.org>
Cc: Andy Lutomirski <luto@amacapital.net>,
        Steven Rostedt <rostedt@goodmis.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>, Borislav Petkov <bp@alien8.de>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 22, 2014 at 7:25 AM, Andi Kleen <andi@firstfloor.org> wrote:
>
> I suspect the only case that's really interesting here is interrupting
> idle. Maybe it would be possible to do some fast path in this case only.

Hardware-interrupts during kernel are actually fairly common under
network-intensive loads, even outside of idle (but idle is admittedly
likely *the* most common one). Many network loads are fairly
kernel-intensive.

Also, from a kernel perspective, idle isn't really any different from
most other kernel code. Using "ret" to return to the idle handler
would be *more* of a special case than using "ret" to return to just
generic kernel context.

So I disagree vehemently. Do *not* special-case idle. It makes the
code more complex and less generic.

                Linus
