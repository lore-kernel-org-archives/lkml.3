Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752651AbaHLXaF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Aug 2014 19:30:05 -0400
Received: from g4t3426.houston.hp.com ([15.201.208.54]:9614 "EHLO
	g4t3426.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751166AbaHLXaE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Aug 2014 19:30:04 -0400
Message-ID: <1407886188.2695.3.camel@buesod1.americas.hpqcorp.net>
Subject: Re: [PATCH] mm: introduce for_each_vma helpers
From: Davidlohr Bueso <davidlohr@hp.com>
To: "Kirill A. Shutemov" <kirill@shutemov.name>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>,
        Heiko Carstens <heiko.carstens@de.ibm.com>,
        "James E.J. Bottomley" <jejb@parisc-linux.org>,
        Helge Deller <deller@gmx.de>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Robert Richter <rric@kernel.org>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, aswin@hp.com
Date: Tue, 12 Aug 2014 16:29:48 -0700
In-Reply-To: <20140812215213.GB17497@node.dhcp.inet.fi>
References: <1407865523.2633.3.camel@buesod1.americas.hpqcorp.net>
	 <20140812215213.GB17497@node.dhcp.inet.fi>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.4 (3.6.4-3.fc18) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2014-08-13 at 00:52 +0300, Kirill A. Shutemov wrote:
> On Tue, Aug 12, 2014 at 10:45:23AM -0700, Davidlohr Bueso wrote:
> > The most common way of iterating through the list of vmas, is via:
> >     for (vma = mm->mmap; vma; vma = vma->vm_next)
> > 
> > This patch replaces this logic with a new for_each_vma(vma) helper,
> > which 1) encapsulates this logic, and 2) make it easier to read.
> 
> Why does it need to be encapsulated?
> Do you have problem with reading plain for()?

No problem in particular. But encapsulation is always good to have, and
we have a number of examples similar to what I'm proposing all
throughout the kernel (just like at vma_interval_tree_foreach).

> Your for_each_vma(vma) assumes "mm" from the scope. This can be confusing
> for reader: whether it uses "mm" from the scope or "current->mm". This
> will lead to very hard to find bug one day.
> I don't like this.
> 
> > It also updates most of the callers, so its a pretty good start.
> > 
> > Similarly, we also have for_each_vma_start(vma, start) when the user
> > does not want to start at the beginning of the list. And lastly the
> > for_each_vma_start_inc(vma, start, inc) helper in introduced to allow
> > users to create higher level special vma abstractions, such as with
> > the case of ELF binaries.
> 
> for_each_vma_start_inc() is pretty much the plain for() but with
> really_long_and_fancy_name(). Why?

Because we can implement things like for_each_vma_gate() on top.

Thanks,
Davidlohr


