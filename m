Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754000AbaEUXew (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 May 2014 19:34:52 -0400
Received: from mail-ve0-f173.google.com ([209.85.128.173]:47771 "EHLO
	mail-ve0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752160AbaEUXev (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 May 2014 19:34:51 -0400
MIME-Version: 1.0
In-Reply-To: <20140521232318.GP1873@two.firstfloor.org>
References: <CALCETrXudJ8BkNF_M-r4O40XLN+PnZ5TOZw0P7N4kqo3qngzyg@mail.gmail.com>
	<20140521222541.GO1873@two.firstfloor.org>
	<CA+55aFzx82y5xDa3-6aLm6fCvaf23FH1E14PvmXXUFngwpkdgw@mail.gmail.com>
	<20140521232318.GP1873@two.firstfloor.org>
Date: Thu, 22 May 2014 08:34:50 +0900
X-Google-Sender-Auth: l18KdmdckGoVJuHCc3oDnbxMRD0
Message-ID: <CA+55aFyOS_MYH6aD1Xkbc9kvgmxmM2mgE4ji-USEWQLhA1oHiA@mail.gmail.com>
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

On Thu, May 22, 2014 at 8:23 AM, Andi Kleen <andi@firstfloor.org> wrote:
>> Hardware-interrupts during kernel are actually fairly common under
>> network-intensive loads, even outside of idle (but idle is admittedly
>> likely *the* most common one). Many network loads are fairly
>> kernel-intensive.
>
> For network workloads we can arbitarily coalesce interrupts or just use NAPI
> to lower the costs.  No need to optimize network interrupts too much.

BS. Lots of network loads are latency-criticial, to the point that
people sometimes actually turn off coalescing. But even with
coalescing, it doesn't do crap for ping-pong kinds of loads that are
not "interrupt storm from tons and tons of separate packets", but
"lots of individual packets that are data-dependent", so you don't
have new ones coming in while processing old ones.

Ask Andy L. He had numbers. Interrupt overhead was quite big for him.

And you ignored the real issue: special-casing idle is *stupid*. It's
more complicated, and gives fewer cases where it helps. It's simply
fundamentally stupid and wrong.

         Linus
