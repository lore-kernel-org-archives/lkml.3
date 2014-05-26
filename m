Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751738AbaEZUck (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 May 2014 16:32:40 -0400
Received: from casper.infradead.org ([85.118.1.10]:34406 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751218AbaEZUcj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 May 2014 16:32:39 -0400
Date: Mon, 26 May 2014 22:32:32 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Konstantin Khlebnikov <koct9i@gmail.com>
Cc: "linux-mm@kvack.org" <linux-mm@kvack.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Christoph Lameter <cl@linux.com>, Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        Hugh Dickins <hughd@google.com>, Mel Gorman <mgorman@suse.de>,
        Roland Dreier <roland@kernel.org>, Sean Hefty <sean.hefty@intel.com>,
        Hal Rosenstock <hal.rosenstock@gmail.com>,
        Mike Marciniszyn <infinipath@intel.com>
Subject: Re: [RFC][PATCH 0/5] VM_PINNED
Message-ID: <20140526203232.GC5444@laptop.programming.kicks-ass.net>
References: <20140526145605.016140154@infradead.org>
 <CALYGNiMG1NVBUS4TJrYJMr92yWGZHSdGUdCGtBJDHoUMMhE+Wg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CALYGNiMG1NVBUS4TJrYJMr92yWGZHSdGUdCGtBJDHoUMMhE+Wg@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 27, 2014 at 12:19:16AM +0400, Konstantin Khlebnikov wrote:
> On Mon, May 26, 2014 at 6:56 PM, Peter Zijlstra <peterz@infradead.org> wrote:
> > Hi all,
> >
> > I mentioned at LSF/MM that I wanted to revive this, and at the time there were
> > no disagreements.
> >
> > I finally got around to refreshing the patch(es) so here goes.
> >
> > These patches introduce VM_PINNED infrastructure, vma tracking of persistent
> > 'pinned' page ranges. Pinned is anything that has a fixed phys address (as
> > required for say IO DMA engines) and thus cannot use the weaker VM_LOCKED. One
> > popular way to pin pages is through get_user_pages() but that not nessecarily
> > the only way.
> 
> Lol, this looks like resurrection of VM_RESERVED which I've removed
> not so long time ago.

Not sure what VM_RESERVED did, but there might be a similarity.

> Maybe single-bit state isn't flexible enought?

Not sure what you mean, the one bit is perfectly fine for what I want it
to do.

> This supposed to supports pinning only by one user and only in its own mm?

Pretty much, that's adequate for all users I'm aware of and mirrors the
mlock semantics.

> This might be done as extension of existing memory-policy engine.
> It allows to keep vm_area_struct slim in normal cases and change
> behaviour when needed.
> memory-policy might hold reference-counter of "pinners", track
> ownership and so on.

That all sounds like raping the mempolicy code and massive over
engineering.

