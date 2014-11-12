Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753467AbaKLUgV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Nov 2014 15:36:21 -0500
Received: from mail-vc0-f181.google.com ([209.85.220.181]:41481 "EHLO
	mail-vc0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753190AbaKLUgU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Nov 2014 15:36:20 -0500
MIME-Version: 1.0
In-Reply-To: <5461CC0702000078000464B3@mail.emea.novell.com>
References: <5458A9600200007800044AE5@mail.emea.novell.com>
	<20141110100117.GA15841@gmail.com>
	<CA+55aFw9MV1n8T7_k5oftfY-sOu8s1ywKYM-3k4+PF022vv9ow@mail.gmail.com>
	<5461CC0702000078000464B3@mail.emea.novell.com>
Date: Wed, 12 Nov 2014 12:36:19 -0800
X-Google-Sender-Auth: Nmudg0J3SQemkzpCMtWND_Tr6qo
Message-ID: <CA+55aFzukHUryw_Jo4xvmb8RSADN9KrJ-HNk2U=8VCGwZzHaAw@mail.gmail.com>
Subject: Re: [PATCH, RFC] x86: also CFI-annotate certain inline asm()s
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Jan Beulich <JBeulich@suse.com>
Cc: Ingo Molnar <mingo@elte.hu>, Ingo Molnar <mingo@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>, Tony Jones <tonyj@suse.de>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Peter Anvin <hpa@zytor.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 10, 2014 at 11:42 PM, Jan Beulich <JBeulich@suse.com> wrote:
>
> Nothing crashes with the unwind information being wrong. It is
> solely you who was claiming (without proof) years ago that the
> unwinder repeatedly caused issues.

Umm. We had oopses showing it. Several times.

> Yes, we did find a bug or two over the years in it

.. and you and Andi repeatedly refused to make the code more robust
when I asked.

Which is why I don't work with Andi or you directly any more, and why
the code got entirely removed when I got fed up with the last time it
crashed in ways that it *wouldn't* have crashed if it had been made
more robust.

Every time there were just excuses. Like now. "All code has bugs".
Sure. But debugging code had better be better than "all code", and it
had better be written to be robust, and it had better not make bugs
more _likely_ either by failing, or by making the non-debug code
harder to read.

I'm done with your crazy unwinder games. We removed a lot of CFI stuff
entirely because it made the asm code hard to read. Much of it ended
up getting re-introduced when you made the infrastructure more
bearable.

But this patch I NAK'ed because the code is not readable, and the
infrastructure is not bearable.

Live with it.

                      Linus
