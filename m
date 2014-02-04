Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932206AbaBDTGG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Feb 2014 14:06:06 -0500
Received: from merlin.infradead.org ([205.233.59.134]:55165 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751357AbaBDTGA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Feb 2014 14:06:00 -0500
Date: Tue, 4 Feb 2014 20:05:35 +0100
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
Message-ID: <20140204190535.GC5002@laptop.programming.kicks-ass.net>
References: <20140204184150.GB5002@laptop.programming.kicks-ass.net>
 <CA+55aFz9+AtK_OnUhH0gspUsXLxZN-MRwKVR5zVPsVGmGpBqxg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+55aFz9+AtK_OnUhH0gspUsXLxZN-MRwKVR5zVPsVGmGpBqxg@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 04, 2014 at 10:58:40AM -0800, Linus Torvalds wrote:
> On Tue, Feb 4, 2014 at 10:41 AM, Peter Zijlstra <peterz@infradead.org> wrote:
> >
> > Still doesn't make sense, because if we need the first sync to stop
> > writes from being re-ordered with the ll-sc, we also need the second
> > sync to avoid the same.
> 
> Presumably octeon doesn't do speculative writes, only *buffered* writes.

Speculative writes are bad.. :-)

> So writes move down, not up.

Right, but the ll-sc store might move down over a later store. Say
because the ll-sc needs to first get exclusive ownership of the
cacheline where the later store would be to an already owned line.


