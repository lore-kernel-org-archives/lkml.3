Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760612AbaKAUZ7 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Nov 2014 16:25:59 -0400
Received: from gate.crashing.org ([63.228.1.57]:38170 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758469AbaKAUZ6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Nov 2014 16:25:58 -0400
Message-ID: <1414873502.28356.80.camel@pasglop>
Subject: Re: [RFC PATCH 1/2] zap_pte_range: update addr when forcing flush
 after TLB batching faiure
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Will Deacon <will.deacon@arm.com>, Peter Zijlstra <peterz@infradead.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>
Date: Sun, 02 Nov 2014 07:25:02 +1100
In-Reply-To: <CA+55aFwZDQgfjMuftKF0TeMwV-uU=4SgJNfH+u4MyQ_UgfiFEg@mail.gmail.com>
References: <1414496662-25202-1-git-send-email-will.deacon@arm.com>
	 <1414496662-25202-2-git-send-email-will.deacon@arm.com>
	 <CA+55aFxVtxA-j7uwVCeB4asm4DB-gz4xnsygW8_s0OYfU8hXrw@mail.gmail.com>
	 <CA+55aFwpOCeXdThX3zB64AU4hFwufD6UdJDi2tkD8Q7yEV2pOA@mail.gmail.com>
	 <20141029194738.GA29911@arm.com>
	 <CA+55aFxoQSm5ko8bQxPd8usXxaZy_RgGpv36PTiEzYaWcOiwTA@mail.gmail.com>
	 <1414618065.4257.21.camel@pasglop>
	 <CA+55aFwZDQgfjMuftKF0TeMwV-uU=4SgJNfH+u4MyQ_UgfiFEg@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.12.2 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2014-11-01 at 10:01 -0700, Linus Torvalds wrote:
> On Wed, Oct 29, 2014 at 2:27 PM, Benjamin Herrenschmidt
> <benh@kernel.crashing.org> wrote:
> >
> > TLB flushing is only me I think, I'll engage my brain after breakfast
> > and see if is all good
> 
> Ping? Breakfast is either long over, of you're starting to look a bit
> like Mr Creosote...

Argh... dropped that ball.

> Anyway, Will, I assume this is not a correctness issue for you, just
> an annoying performance issue. Right? Or is there actually some issue
> with the actual range not being set to be sufficiently large?

It should be fine for us in term of correctness I think. We rely on the
lazy mmu bits for batching/flushing on hash64, we use
__tlb_remove_tlb_entry() for immediate flush on hash32 and the SW loaded
TLB cases are pretty dumb here and should be generally unaffected.

> Also, it strikes me that I *think* that you might be able to extend
> your patch to remove the whole "need_flush" field, since as far as I
> can tell, "tlb->need_flush" is now equivalent to "tlb->start <
> tlb->end". Of course, as long as we still require that
> "need_flush_all", that doesn't actually save us any space, so maybe
> it's not worth changing.

Cheers,
Ben.

>                        Linus
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/


