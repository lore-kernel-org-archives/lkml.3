Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754490AbaBDOjm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Feb 2014 09:39:42 -0500
Received: from userp1040.oracle.com ([156.151.31.81]:32720 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751234AbaBDOjj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Feb 2014 09:39:39 -0500
Date: Tue, 4 Feb 2014 09:38:01 -0500
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: David Vrabel <david.vrabel@citrix.com>,
        Linus Torvalds <torvalds@linux-foundation.org>
Cc: Mel Gorman <mgorman@suse.de>, Ingo Molnar <mingo@redhat.com>,
        Boris Ostrovsky <boris.ostrovsky@oracle.com>,
        Steven Noonan <steven@uplinklabs.net>,
        Andrew Morton <akpm@linux-foundation.org>,
        George Dunlap <george.dunlap@eu.citrix.com>,
        Dario Faggioli <dario.faggioli@citrix.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>,
        Rik van Riel <riel@redhat.com>, Elena Ufimtseva <ufimtseva@gmail.com>,
        Linux Kernel mailing List <linux-kernel@vger.kernel.org>,
        Linux-MM <linux-mm@kvack.org>, Linux-X86 <x86@kernel.org>,
        xen-devel <xen-devel@lists.xenproject.org>
Subject: Re: [PATCH] Subject: [PATCH] xen: Properly account for _PAGE_NUMA
 during xen pte translations
Message-ID: <20140204143801.GC3853@phenom.dumpdata.com>
References: <20140122072914.GA9283@orcus.uplinklabs.net>
 <52DFD5DB.6060603@iogearbox.net>
 <CAEr7rXhJf1tf2KUErsGgUyYNUpVwLYD=fKUf8aPm0Dcg21MuNQ@mail.gmail.com>
 <20140122203337.GA31908@orcus.uplinklabs.net>
 <CAEr7rXjge6rKzxbwy+0A6-5YhVZL9WGmaLrDYbE8H5hrtwq_4A@mail.gmail.com>
 <20140124133830.GU4963@suse.de>
 <CAEr7rXjmVp-F88zQnc4a2tSzBAJFshzR0FPkOBdo1jbQLOv+2A@mail.gmail.com>
 <CAEr7rXgCoYW7O0E38YGCThUKgmxYFfLfYP-x_KSzVBLOCiHeDg@mail.gmail.com>
 <20140204114445.GM6732@suse.de>
 <52F0D39D.4050409@citrix.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <52F0D39D.4050409@citrix.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 04, 2014 at 11:48:45AM +0000, David Vrabel wrote:
> On 04/02/14 11:44, Mel Gorman wrote:
> > Steven Noonan forwarded a users report where they had a problem starting
> > vsftpd on a Xen paravirtualized guest, with this in dmesg:
> > 
> [...]
> > 
> > The issue could not be reproduced under an HVM instance with the same kernel,
> > so it appears to be exclusive to paravirtual Xen guests. He bisected the
> > problem to commit 1667918b (mm: numa: clear numa hinting information on
> > mprotect) that was also included in 3.12-stable.
> > 
> > The problem was related to how xen translates ptes because it was not
> > accounting for the _PAGE_NUMA bit. This patch splits pte_present to add
> > a pteval_present helper for use by xen so both bare metal and xen use
> > the same code when checking if a PTE is present.
> 
> Reviewed-by: David Vrabel <david.vrabel@citrix.com>

Thank you for fixing it!

Acked-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>

I can ingest it through the Xen tree for rc2. Or let Linus handle it
if he prefers it.

> 
> Thanks.
> 
> David
