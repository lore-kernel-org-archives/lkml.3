Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752371Ab3KDHDv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Nov 2013 02:03:51 -0500
Received: from bombadil.infradead.org ([198.137.202.9]:37578 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751621Ab3KDHDu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Nov 2013 02:03:50 -0500
Date: Sun, 3 Nov 2013 23:03:28 -0800
From: Christoph Hellwig <hch@infradead.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Davidlohr Bueso <davidlohr@hp.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Hugh Dickins <hughd@google.com>, Michel Lespinasse <walken@google.com>,
        Ingo Molnar <mingo@kernel.org>, Mel Gorman <mgorman@suse.de>,
        Rik van Riel <riel@redhat.com>, Guan Xuetao <gxt@mprc.pku.edu.cn>,
        "Chandramouleeswaran, Aswin" <aswin@hp.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-mm <linux-mm@kvack.org>, Dave Chinner <dchinner@redhat.com>
Subject: Re: [PATCH] mm: cache largest vma
Message-ID: <20131104070328.GA17995@infradead.org>
References: <1383337039.2653.18.camel@buesod1.americas.hpqcorp.net>
 <CA+55aFwrtOaFtwGc6xyZH6-1j3f--AG1JS-iZM8-pZPnwRHBow@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+55aFwrtOaFtwGc6xyZH6-1j3f--AG1JS-iZM8-pZPnwRHBow@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Nov 03, 2013 at 10:51:27AM -0800, Linus Torvalds wrote:
> Ugh. This patch makes me angry. It looks way too ad-hoc.
> 
> I can well imagine that our current one-entry cache is crap and could
> be improved, but this looks too random. Different code for the
> CONFIG_MMU case? Same name, but for non-MMU it's a single entry, for
> MMU it's an array? And the whole "largest" just looks odd. Plus why do
> you set LAST_USED if you also set LARGEST?
> 
> Did you try just a two- or four-entry pseudo-LRU instead, with a
> per-thread index for "last hit"? Or even possibly a small fixed-size
> hash table (say "idx = (add >> 10) & 3" or something)?

Btw, Dave Chiner has recently implemented a simple look aside cache for
the buffer cache, which also uses a rbtree.  Might beworth into making
that into a generic library and use it here:

	http://thread.gmane.org/gmane.comp.file-systems.xfs.general/56220
