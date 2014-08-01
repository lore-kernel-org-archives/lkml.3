Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754695AbaHAKXB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Aug 2014 06:23:01 -0400
Received: from gate.crashing.org ([63.228.1.57]:41062 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752779AbaHAKXA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Aug 2014 06:23:00 -0400
Message-ID: <1406888211.4935.245.camel@pasglop>
Subject: Re: [RFC][PATCH 0/5] VM_PINNED
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Konstantin Khlebnikov <koct9i@gmail.com>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Christoph Lameter <cl@linux.com>, Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        Hugh Dickins <hughd@google.com>, Mel Gorman <mgorman@suse.de>,
        Roland Dreier <roland@kernel.org>, Sean Hefty <sean.hefty@intel.com>,
        Hal Rosenstock <hal.rosenstock@gmail.com>,
        Mike Marciniszyn <infinipath@intel.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        Alexey Kardashevskiy <aik@au1.ibm.com>
Date: Fri, 01 Aug 2014 20:16:51 +1000
In-Reply-To: <20140526203232.GC5444@laptop.programming.kicks-ass.net>
References: <20140526145605.016140154@infradead.org>
	 <CALYGNiMG1NVBUS4TJrYJMr92yWGZHSdGUdCGtBJDHoUMMhE+Wg@mail.gmail.com>
	 <20140526203232.GC5444@laptop.programming.kicks-ass.net>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.12.2 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2014-05-26 at 22:32 +0200, Peter Zijlstra wrote:

> Not sure what you mean, the one bit is perfectly fine for what I want it
> to do.
> 
> > This supposed to supports pinning only by one user and only in its own mm?
> 
> Pretty much, that's adequate for all users I'm aware of and mirrors the
> mlock semantics.

Ok so I only just saw this. CC'ing Alex Williamson

There is definitely another potential user for that stuff which is KVM
with passed-through devices.

What vfio does today on x86 is "interesting":

Look at drivers/vfio/vfio_iommu_type1.c and functions vfio_pin_pages()

I especially like the racy "delayed" accounting ...

The problem is that in the generic case of VFIO, we don't know in
advance what needs to be pinned. The user might pin pages on demand and
it has to be a reasonably fast path.

Additionally, a given page can be mapped multiple times and we don't
have a good place to keep a counter....

So the one bit of state is definitely not enough.

Cheers,
Ben.


