Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753573AbaEUWdM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 May 2014 18:33:12 -0400
Received: from mail-ve0-f182.google.com ([209.85.128.182]:50146 "EHLO
	mail-ve0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753399AbaEUWcz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 May 2014 18:32:55 -0400
MIME-Version: 1.0
In-Reply-To: <20140521222541.GO1873@two.firstfloor.org>
References: <CALCETrXudJ8BkNF_M-r4O40XLN+PnZ5TOZw0P7N4kqo3qngzyg@mail.gmail.com>
 <20140521222541.GO1873@two.firstfloor.org>
From: Andy Lutomirski <luto@amacapital.net>
Date: Wed, 21 May 2014 15:32:33 -0700
Message-ID: <CALCETrVambcEkh8oQuUL95DupX4Lhxwh5W0tESNqia26z3_z3g@mail.gmail.com>
Subject: Re: [RFC] x86_64: A real proposal for iret-less return to kernel
To: Andi Kleen <andi@firstfloor.org>
Cc: Steven Rostedt <rostedt@goodmis.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Ingo Molnar <mingo@kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
        Borislav Petkov <bp@alien8.de>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 21, 2014 at 3:25 PM, Andi Kleen <andi@firstfloor.org> wrote:
>
> Seems like a lot of effort and risk to essentially only optimize in kernel
> interrupt handlers.

The idea is that it might allow us to remove a bunch of scary nested
NMI code as well as speeding things up.

>
> AFAIK the most interesting cases (like user page faults) are not
> affected at all. Usually most workloads don't spend all that much time
> in the kernel, so it won't help most interrupts.
>
> I suspect the only case that's really interesting here is interrupting
> idle. Maybe it would be possible to do some fast path in this case only.
>
> However idle currently has so much overhead that I suspect that there
> are lower hanging fruit elsewhere.

I will gladly buy a meal or beverage for whomever fixes the ttwu stuff
to stop sending IPIs to idle CPUs, which will help a lot.

--Andy
