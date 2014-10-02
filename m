Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752037AbaJBI2z (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Oct 2014 04:28:55 -0400
Received: from bombadil.infradead.org ([198.137.202.9]:49579 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751180AbaJBI2x (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Oct 2014 04:28:53 -0400
Date: Thu, 2 Oct 2014 10:28:46 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Rik van Riel <riel@redhat.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Hugh Dickins <hughd@google.com>, Dave Jones <davej@redhat.com>,
        Al Viro <viro@zeniv.linux.org.uk>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@redhat.com>, Michel Lespinasse <walken@google.com>,
        "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>,
        Mel Gorman <mgorman@suse.de>, Sasha Levin <sasha.levin@oracle.com>
Subject: Re: pipe/page fault oddness.
Message-ID: <20141002082846.GA3259@worktop.programming.kicks-ass.net>
References: <CA+55aFzTEXxxh_4_BwVydw1UgCu-NRF95OrzVhj=cievXFTJTg@mail.gmail.com>
 <20140930162201.GC15903@redhat.com>
 <20140930164047.GA18354@redhat.com>
 <CA+55aFzKgJ41Mp=Ub8Kq_uFDHYzkHo3zhO3MHOJo_O2iExdYmQ@mail.gmail.com>
 <20140930182059.GA24431@redhat.com>
 <CA+55aFzfvXHd2LUhQ5OiV1H1Oq2y3PL8hX_Hrv-C907PyDNugA@mail.gmail.com>
 <alpine.LSU.2.11.1410010031070.1902@eggly.anvils>
 <CA+55aFyJ09+iv2HX1nfAaDi0-7=L3KxKi11CACbM8K_Coo6kzg@mail.gmail.com>
 <CA+55aFzHgemAV7igyG=0pmctTaV7cZfO4fdqukhrCc8VXTrZuw@mail.gmail.com>
 <542C39E0.8030609@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <542C39E0.8030609@redhat.com>
User-Agent: Mutt/1.5.22.1 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 01, 2014 at 01:29:04PM -0400, Rik van Riel wrote:
> On 10/01/2014 12:18 PM, Linus Torvalds wrote:
> 
> > Seriously, why can't we just do this, and throw away all the crap that
> > is "numa special case". This would make all the random games in
> > change_pte_range() just go away entirely, because the whole NUMA thing
> > really wouldn't be a special case for the pte AT ALL any more. All it
> > would be is that a pte could be marked PROT_NONE even if the
> > vma->vm_flags aren't.
> 
> That's what I suggested quite a while back, but IIRC either
> Peter or Mel brought up a reason why this was not possible.

Hey, I'm the one that did the numa faulting with PROTNONE to begin with.
Andrea and Mel (and possibly you) all didn't like that and did the per
arch pagetable nonensen :-) I've never understood why.

https://lkml.org/lkml/2012/9/27/76
