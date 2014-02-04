Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932262AbaBDTkA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Feb 2014 14:40:00 -0500
Received: from merlin.infradead.org ([205.233.59.134]:56434 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754870AbaBDTj5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Feb 2014 14:39:57 -0500
Date: Tue, 4 Feb 2014 20:39:41 +0100
From: Peter Zijlstra <peterz@infradead.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: David Daney <ddaney@caviumnetworks.com>,
        Ralf Baechle <ralf@linux-mips.org>,
        "linux-arch@vger.kernel.org" <linux-arch@vger.kernel.org>,
        linux-mips <linux-mips@linux-mips.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Paul McKenney <paulmck@linux.vnet.ibm.com>,
        Will Deacon <will.deacon@arm.com>
Subject: Re: mips octeon memory model questions
Message-ID: <20140204193941.GD5002@laptop.programming.kicks-ass.net>
References: <20140204184150.GB5002@laptop.programming.kicks-ass.net>
 <CA+55aFz9+AtK_OnUhH0gspUsXLxZN-MRwKVR5zVPsVGmGpBqxg@mail.gmail.com>
 <20140204190535.GC5002@laptop.programming.kicks-ass.net>
 <CA+55aFwiuE+WbNLdeV8sGqZccoXkjg_VFOJ+xKMZUgbFP_sKZw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+55aFwiuE+WbNLdeV8sGqZccoXkjg_VFOJ+xKMZUgbFP_sKZw@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 04, 2014 at 11:16:58AM -0800, Linus Torvalds wrote:
> On Tue, Feb 4, 2014 at 11:05 AM, Peter Zijlstra
> >
> >> So writes move down, not up.
> >
> > Right, but the ll-sc store might move down over a later store.
> 
> Unlikely. The thing is, in order for the sc to succeed, it has to
> already have hit the cache coherency domain (or at least reserved it -
> ie maybe the value is not actually *in* the cache, but the sc needs to
> have gotten exclusive access to the cacheline).
> 
> So just how do you expect a later store (that is *after* the
> conditional branch that tests the result of the sc) to move up before
> it?

Ah, I completely overlooked the control dependency to the subsequent
store.

Yes, given that this makes sense.
