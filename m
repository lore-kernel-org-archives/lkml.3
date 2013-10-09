Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753792Ab3JIOcc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Oct 2013 10:32:32 -0400
Received: from mail-ea0-f171.google.com ([209.85.215.171]:49609 "EHLO
	mail-ea0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752079Ab3JIOcb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Oct 2013 10:32:31 -0400
Date: Wed, 9 Oct 2013 16:32:26 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Oleg Nesterov <oleg@redhat.com>, Fengguang Wu <fengguang.wu@intel.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [x86] BUG: unable to handle kernel paging request at 00740060
Message-ID: <20131009143226.GA24911@gmail.com>
References: <20131005234430.GA22485@localhost>
 <CA+55aFxEeKixnH7mZZs5iwupA9_GsRN0N7QZxqcTcE4RKZvTTg@mail.gmail.com>
 <20131008143400.GA14721@redhat.com>
 <20131009080459.GA2298@localhost>
 <20131009124310.GA11769@redhat.com>
 <20131009140734.GH3081@twins.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131009140734.GH3081@twins.programming.kicks-ass.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Peter Zijlstra <peterz@infradead.org> wrote:

> > This is what we are going to return. But note that -20(%ebp) was not
> > initialized if TIF_NOTIFY_RESUME was already set, "jc .L2" skips .L5
> > above. IOW, in this case we seem to return a random value from stack.
> 
> I think you're quite right, and I can confirm I can reproduce this with
> gcc-4.8.1 and Wu's .config:
>
> [...]
>
> Once I force a x86_64 build using the 'same' config it goes away and 
> generates 'sensible' code again [...]

So this at least opens up the possibility that we can create a not too 
painful quirk and only use the 'asm goto' optimization tricks on 64-bit 
kernels?

Thanks,

	Ingo
