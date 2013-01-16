Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758274Ab3APQuK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jan 2013 11:50:10 -0500
Received: from mail-ob0-f172.google.com ([209.85.214.172]:62805 "EHLO
	mail-ob0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757745Ab3APQuF convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jan 2013 11:50:05 -0500
Date: Wed, 16 Jan 2013 09:50:20 -0600
From: Rob Landley <rob@landley.net>
Subject: Re: Transparent Hugepage Nit
To: Andi Kleen <andi@firstfloor.org>
Cc: John McCorquodale <mcq@rockgeek.org>, linux-kernel@vger.kernel.org
References: <20130115205041.GA12113@rockgeek.org>
	<m2zk0ayw65.fsf@firstfloor.org>
In-Reply-To: <m2zk0ayw65.fsf@firstfloor.org> (from andi@firstfloor.org on
	Tue Jan 15 15:26:58 2013)
X-Mailer: Balsa 2.4.11
Message-Id: <1358351420.32505.35@driftwood>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; DelSp=Yes; Format=Flowed
Content-Disposition: inline
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/15/2013 03:26:58 PM, Andi Kleen wrote:
> John McCorquodale <mcq@rockgeek.org> writes:
> 
> > Suppose a hugepage-aligned mmap(MAP_ANONYMOUS) mapping has been  
> madvise()d
> > HUGEPAGE.  If a subeqeuent call to mremap() grows the mapping and  
> has to
> > move the mapping, the hugepage-alignment is not preserved in the  
> choice of
> > new address (in 3.7.2).
> >
> > I can workaround this by doing a 1-hugepage-oversized remap to find  
> a new
> > aligned address and then size it back down MREMAP_FIXED, but that's  
> probably
> > a lot of frags to 4k pages and back that aren't necessary.
> >
> > Should it not be the case that mremap(MAYMOVE) on something advised  
> hugepage
> > ALWAYS chooses a hugepage-aligned address?  This would be handy  
> when doing the
> > initial allocation too: mmap, madvise, mremap (to the same size) to  
> get
> > alignment.
> 
> The hole searching currently doesn't know anything about transparent
> huge pages. There were some discussions on fixing it. But it's
> essentially a trade off between memory fragmentation and huge page
> optimization: aggressively aligning to 2MB can lose address space
> in holes.
> 
> Usually if the program uses large enough mappings and enough memory
> it shouldn't be a problem.

Possibly we should just document that doing mremap() on a hugepage  
loses the hugepageness, and consider it pilot error to do that?

Rob