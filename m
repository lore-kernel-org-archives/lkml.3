Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755297AbaHLVx0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Aug 2014 17:53:26 -0400
Received: from mta-out1.inet.fi ([62.71.2.194]:36672 "EHLO jenni1.inet.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753195AbaHLVxX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Aug 2014 17:53:23 -0400
Date: Wed, 13 Aug 2014 00:52:13 +0300
From: "Kirill A. Shutemov" <kirill@shutemov.name>
To: Davidlohr Bueso <davidlohr@hp.com>
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
Subject: Re: [PATCH] mm: introduce for_each_vma helpers
Message-ID: <20140812215213.GB17497@node.dhcp.inet.fi>
References: <1407865523.2633.3.camel@buesod1.americas.hpqcorp.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1407865523.2633.3.camel@buesod1.americas.hpqcorp.net>
User-Agent: Mutt/1.5.22.1 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 12, 2014 at 10:45:23AM -0700, Davidlohr Bueso wrote:
> The most common way of iterating through the list of vmas, is via:
>     for (vma = mm->mmap; vma; vma = vma->vm_next)
> 
> This patch replaces this logic with a new for_each_vma(vma) helper,
> which 1) encapsulates this logic, and 2) make it easier to read.

Why does it need to be encapsulated?
Do you have problem with reading plain for()?

Your for_each_vma(vma) assumes "mm" from the scope. This can be confusing
for reader: whether it uses "mm" from the scope or "current->mm". This
will lead to very hard to find bug one day.
I don't like this.

> It also updates most of the callers, so its a pretty good start.
> 
> Similarly, we also have for_each_vma_start(vma, start) when the user
> does not want to start at the beginning of the list. And lastly the
> for_each_vma_start_inc(vma, start, inc) helper in introduced to allow
> users to create higher level special vma abstractions, such as with
> the case of ELF binaries.

for_each_vma_start_inc() is pretty much the plain for() but with
really_long_and_fancy_name(). Why?

-- 
 Kirill A. Shutemov
