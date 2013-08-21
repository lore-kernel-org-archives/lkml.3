Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752065Ab3HUQTv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Aug 2013 12:19:51 -0400
Received: from mail-la0-f49.google.com ([209.85.215.49]:53775 "EHLO
	mail-la0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751519Ab3HUQTt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Aug 2013 12:19:49 -0400
Date: Wed, 21 Aug 2013 20:19:46 +0400
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: Jan Beulich <JBeulich@suse.com>
Cc: Andy Lutomirski <luto@amacapital.net>,
        David Vrabel <david.vrabel@citrix.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Xen-devel@lists.xen.org, Boris Ostrovsky <boris.ostrovsky@oracle.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Pavel Emelyanov <xemul@parallels.com>, Ingo Molnar <mingo@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: Regression: x86/mm: new _PTE_SWP_SOFT_DIRTY bit conflicts with
 existing use
Message-ID: <20130821161946.GW18673@moon>
References: <5214C524.1050900@citrix.com>
 <20130821141223.GS18673@moon>
 <5214F09002000078000ED5C3@nat28.tlf.novell.com>
 <20130821154238.GV18673@moon>
 <521500E102000078000ED65C@nat28.tlf.novell.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <521500E102000078000ED65C@nat28.tlf.novell.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 21, 2013 at 05:03:13PM +0100, Jan Beulich wrote:
> > 
> > Only to non-present ptes, as far as I know.
> 
> That's not really any guarantee. And the accessor functions also
> don't check that they'd be used on non-present PTEs only.

Wait. This _PAGE_SWP_SOFT_DIRTY bit (which is in real PSE bit) assigned
in only one place -- in try_to_unmap_one(). The PTE get non-present then
and consists of swap entry format. I don't see any accessor to such entry
without testing if it's swap entry or pte-none. What I'm missing?

> > orig_pte has pse bit set if page has been soft dirty
> > when it reached swap.
> 
> "when it reached swap" to me again implies that it could come
> from a live page table, with the present bit set. So that
> explanation attempt of yours confuses me more than it
> clarifies things for me. (And referring to this bit as PSE bit is

When page swapped out it become non-present in pte entry.

> sort of wrong here too - there's no PSE bit for 4k PTEs, that
> bit is the PAT one, and that's what the whole discussion
> started from.)

And I asked David to point me how it happens, because I don't
understand at which point pse bit get analized when page is
not present.
