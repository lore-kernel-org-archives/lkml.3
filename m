Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757364AbaJ2V3G (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Oct 2014 17:29:06 -0400
Received: from gate.crashing.org ([63.228.1.57]:42456 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757019AbaJ2V3E (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Oct 2014 17:29:04 -0400
Message-ID: <1414618065.4257.21.camel@pasglop>
Subject: Re: [RFC PATCH 1/2] zap_pte_range: update addr when forcing flush
 after TLB batching faiure
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Will Deacon <will.deacon@arm.com>, Peter Zijlstra <peterz@infradead.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>
Date: Thu, 30 Oct 2014 08:27:45 +1100
In-Reply-To: <CA+55aFxoQSm5ko8bQxPd8usXxaZy_RgGpv36PTiEzYaWcOiwTA@mail.gmail.com>
References: <1414496662-25202-1-git-send-email-will.deacon@arm.com>
	 <1414496662-25202-2-git-send-email-will.deacon@arm.com>
	 <CA+55aFxVtxA-j7uwVCeB4asm4DB-gz4xnsygW8_s0OYfU8hXrw@mail.gmail.com>
	 <CA+55aFwpOCeXdThX3zB64AU4hFwufD6UdJDi2tkD8Q7yEV2pOA@mail.gmail.com>
	 <20141029194738.GA29911@arm.com>
	 <CA+55aFxoQSm5ko8bQxPd8usXxaZy_RgGpv36PTiEzYaWcOiwTA@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.12.2 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2014-10-29 at 14:11 -0700, Linus Torvalds wrote:
> On Wed, Oct 29, 2014 at 12:47 PM, Will Deacon <will.deacon@arm.com> wrote:
> >
> > I've cooked up something (see below), but it unfortunately makes a couple
> > of minor changes to powerpc and microblaze to address redefinitions of
> > some of the gather callbacks (tlb{start,end}vma, __tlb_remove_tlb_entry).
> >
> > On the plus side, it tidies up the force_flush case in zap_pte_range
> > quite nicely (assuming I didn't screw it up again).
> 
> Yes, this looks fine to me. Looks like a good cleanup, and moves more
> code to generic headers rather than having arch-specific stuff.
> 
> Ben, can you check that this is ok on powerpc? Who else should
> double-check this due to having been involved in tlb flushing? But I
> think this is good to go, modulo checking other architectures for
> sanity.

TLB flushing is only me I think, I'll engage my brain after breakfast
and see if is all good. The difficulty for us is that SW loaded TLB,
hash32 and hash64 are all very different and my brain's been good at
swapping a lot of that stuff out lately...

Cheers,
Ben.


