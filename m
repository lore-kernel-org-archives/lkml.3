Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753765AbaKCR5e (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Nov 2014 12:57:34 -0500
Received: from foss-mx-na.foss.arm.com ([217.140.108.86]:52251 "EHLO
	foss-mx-na.foss.arm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753171AbaKCR4i (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Nov 2014 12:56:38 -0500
Date: Mon, 3 Nov 2014 17:56:33 +0000
From: Will Deacon <will.deacon@arm.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>
Subject: Re: [RFC PATCH 1/2] zap_pte_range: update addr when forcing flush
 after TLB batching faiure
Message-ID: <20141103175633.GC15689@arm.com>
References: <1414496662-25202-1-git-send-email-will.deacon@arm.com>
 <1414496662-25202-2-git-send-email-will.deacon@arm.com>
 <CA+55aFxVtxA-j7uwVCeB4asm4DB-gz4xnsygW8_s0OYfU8hXrw@mail.gmail.com>
 <CA+55aFwpOCeXdThX3zB64AU4hFwufD6UdJDi2tkD8Q7yEV2pOA@mail.gmail.com>
 <20141029194738.GA29911@arm.com>
 <CA+55aFxoQSm5ko8bQxPd8usXxaZy_RgGpv36PTiEzYaWcOiwTA@mail.gmail.com>
 <1414618065.4257.21.camel@pasglop>
 <CA+55aFwZDQgfjMuftKF0TeMwV-uU=4SgJNfH+u4MyQ_UgfiFEg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+55aFwZDQgfjMuftKF0TeMwV-uU=4SgJNfH+u4MyQ_UgfiFEg@mail.gmail.com>
Thread-Topic: [RFC PATCH 1/2] zap_pte_range: update addr when forcing flush
 after TLB batching faiure
Accept-Language: en-GB, en-US
Content-Language: en-US
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Nov 01, 2014 at 05:01:30PM +0000, Linus Torvalds wrote:
> On Wed, Oct 29, 2014 at 2:27 PM, Benjamin Herrenschmidt
> <benh@kernel.crashing.org> wrote:
> >
> > TLB flushing is only me I think, I'll engage my brain after breakfast
> > and see if is all good
> 
> Ping? Breakfast is either long over, of you're starting to look a bit
> like Mr Creosote...

Wafer thin patch?

> Anyway, Will, I assume this is not a correctness issue for you, just
> an annoying performance issue. Right? Or is there actually some issue
> with the actual range not being set to be sufficiently large?

Yeah, it's just a performance issue. For ranges over 1k pages, we end up
flushing the whole TLB.

> Also, it strikes me that I *think* that you might be able to extend
> your patch to remove the whole "need_flush" field, since as far as I
> can tell, "tlb->need_flush" is now equivalent to "tlb->start <
> tlb->end". Of course, as long as we still require that
> "need_flush_all", that doesn't actually save us any space, so maybe
> it's not worth changing.

We use `tlb->end > 0' in the arm64 backend, so I think you're right. I'll
take a look in the name of cleanup and this can wait until 3.19.

Will
