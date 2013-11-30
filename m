Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752692Ab3K3PTe (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Nov 2013 10:19:34 -0500
Received: from mx1.redhat.com ([209.132.183.28]:1413 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751434Ab3K3PTd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Nov 2013 10:19:33 -0500
Date: Sat, 30 Nov 2013 16:20:13 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Jiri Kosina <jkosina@suse.cz>
Cc: Andi Kleen <andi@firstfloor.org>, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, x86@kernel.org,
        Andi Kleen <ak@linux.intel.com>, "H. Peter Anvin" <hpa@zytor.com>,
        Ingo Molnar <mingo@kernel.org>, Borislav Petkov <bp@alien8.de>
Subject: Re: [PATCH] Add a text_poke syscall v2
Message-ID: <20131130152013.GC15790@redhat.com>
References: <1385426236-14960-1-git-send-email-andi@firstfloor.org> <20131129183558.GA9803@redhat.com> <20131129195419.GB17656@two.firstfloor.org> <20131129200532.GA13561@redhat.com> <alpine.LRH.2.00.1311300023070.9932@twin.jikos.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LRH.2.00.1311300023070.9932@twin.jikos.cz>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/30, Jiri Kosina wrote:
>
> On Fri, 29 Nov 2013, Oleg Nesterov wrote:
>
> > > > Andi, et al. I am going to discuss the things I do not really
> > > > understand, probably this can't make any sense, but...
> > >
> > > I think it's enough to set the dirty bit in the underlying
> > > struct page, no need to play games with the PTE.
> >
> > Ah, sorry for confusion, I guess you misunderstood.
> >
> > I meant, perhaps sys_text_poke() doesn't the in-kernel text_poke
> > machinery altogether?
> >
> > Can't we invalidate pte (so that any user will stuck in page fault),
> > update the page(s), restore the pte and drop the locks?
>
> Do you think this'd be faster than the int3-based aproach?

No.

And more, I simply do not know if it would be slower or faster, and how
much. Just I hope that this won't be "much" slower.

OTOH, this is obviously more scalable, and this way sys_text_poke() won't
block, say, jump_label or kprobes. Not sure this actually matters though.

> We have moved from using stop_machine() to int3-based patching exactly
> because it's much more lightweight.

Oh, I do not think it makes sense to compare stop_machine() with this
approach...

Oleg.

