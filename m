Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751296AbaKJSKF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Nov 2014 13:10:05 -0500
Received: from mail-vc0-f174.google.com ([209.85.220.174]:44961 "EHLO
	mail-vc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750829AbaKJSKC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Nov 2014 13:10:02 -0500
MIME-Version: 1.0
In-Reply-To: <CA+55aFw9MV1n8T7_k5oftfY-sOu8s1ywKYM-3k4+PF022vv9ow@mail.gmail.com>
References: <5458A9600200007800044AE5@mail.emea.novell.com>
	<20141110100117.GA15841@gmail.com>
	<CA+55aFw9MV1n8T7_k5oftfY-sOu8s1ywKYM-3k4+PF022vv9ow@mail.gmail.com>
Date: Mon, 10 Nov 2014 10:10:01 -0800
X-Google-Sender-Auth: er0CCMPy4TT9fPC95NOIY28G9Bw
Message-ID: <CA+55aFwZYeFtuQbxtAbOoMVNFN_fQKnxGbRybdz-LYRzwMqX9w@mail.gmail.com>
Subject: Re: [PATCH, RFC] x86: also CFI-annotate certain inline asm()s
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: Peter Anvin <hpa@zytor.com>, Jan Beulich <JBeulich@suse.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Tony Jones <tonyj@suse.de>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 10, 2014 at 9:56 AM, Linus Torvalds
<torvalds@linux-foundation.org> wrote:
>
> So no. A very strong NACK. The code was too ugly to live, there is no good
> stated reason for it, and the only reason I can even remotely imagine is
> wrong and complete crap anyway (ie making the CFI annotations a correctness
> issue by introducing other infrastructure that depends on it always being
> right).

Btw, the sane thing to do is to make your infrastructure just say "If
my frame walker hits a push/pop without CFI information, I'll just add
it myself".

Yes, that involved having to actuall ylook at the instruction. Tough
shit. Just do it right. There aren't that many push/pop patterns.
Don't make the kernel more fragile by introducing these kinds of hacky
macros-from-hell.

Improve the debugger, don't make kernel code worse because your
out-of-tree debugging infrastructure is too broken to live.

                      Linus
