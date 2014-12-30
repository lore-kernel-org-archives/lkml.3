Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752040AbaL3K4I (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Dec 2014 05:56:08 -0500
Received: from e06smtp15.uk.ibm.com ([195.75.94.111]:36152 "EHLO
	e06smtp15.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751683AbaL3K4F (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Dec 2014 05:56:05 -0500
Date: Tue, 30 Dec 2014 11:55:56 +0100
From: Martin Schwidefsky <schwidefsky@de.ibm.com>
To: "Kirill A. Shutemov" <kirill@shutemov.name>
Cc: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>,
        akpm@linux-foundation.org, peterz@infradead.org, mingo@kernel.org,
        davej@redhat.com, sasha.levin@oracle.com, hughd@google.com,
        linux-mm@kvack.org, linux-arch@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Heiko Carstens <heiko.carstens@de.ibm.com>
Subject: Re: [PATCH 30/38] s390: drop pte_file()-related helpers
Message-ID: <20141230115556.1a8b1a94@mschwide>
In-Reply-To: <20141229103757.GA379@node.dhcp.inet.fi>
References: <1419423766-114457-1-git-send-email-kirill.shutemov@linux.intel.com>
	<1419423766-114457-31-git-send-email-kirill.shutemov@linux.intel.com>
	<20141229110727.75afa56d@mschwide>
	<20141229103757.GA379@node.dhcp.inet.fi>
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.23; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14123010-0021-0000-0000-0000025405BA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 29 Dec 2014 12:37:57 +0200
"Kirill A. Shutemov" <kirill@shutemov.name> wrote:

> On Mon, Dec 29, 2014 at 11:07:27AM +0100, Martin Schwidefsky wrote:
> > On Wed, 24 Dec 2014 14:22:38 +0200
> > "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com> wrote:
> > 
> > > We've replaced remap_file_pages(2) implementation with emulation.
> > > Nobody creates non-linear mapping anymore.
> > > 
> > > Signed-off-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
> > > Cc: Martin Schwidefsky <schwidefsky@de.ibm.com>
> > > Cc: Heiko Carstens <heiko.carstens@de.ibm.com>
> > > ---
> > > @@ -279,7 +279,6 @@ static inline int is_module_addr(void *addr)
> > >   *
> > >   * pte_present is true for the bit pattern .xx...xxxxx1, (pte & 0x001) == 0x001
> > >   * pte_none    is true for the bit pattern .10...xxxx00, (pte & 0x603) == 0x400
> > > - * pte_file    is true for the bit pattern .11...xxxxx0, (pte & 0x601) == 0x600
> > >   * pte_swap    is true for the bit pattern .10...xxxx10, (pte & 0x603) == 0x402
> > >   */
> >  
> > Nice, once this is upstream I can free up one of the software bits in
> > the pte by redefining the type bits. Right now all of them are used up.
> > Is the removal of non-linear mappings a done deal ?
> 
> Yes, if no horrible regression will be reported. We don't create
> non-linear mapping in -mm (and -next) tree for a few release cycles.
> Nobody complained so far.
> 
> Ack?

Yes, ack! 


-- 
blue skies,
   Martin.

"Reality continues to ruin my life." - Calvin.

