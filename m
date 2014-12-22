Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754088AbaLVHck (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Dec 2014 02:32:40 -0500
Received: from mail-pa0-f53.google.com ([209.85.220.53]:60224 "EHLO
	mail-pa0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753977AbaLVHci (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Dec 2014 02:32:38 -0500
Date: Sun, 21 Dec 2014 23:32:34 -0800
From: Omar Sandoval <osandov@osandov.com>
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Trond Myklebust <trond.myklebust@primarydata.com>,
        Christoph Hellwig <hch@infradead.org>, linux-fsdevel@vger.kernel.org,
        linux-mm@kvack.org, linux-nfs@vger.kernel.org,
        linux-kernel@vger.kernel.org, Mel Gorman <mgorman@suse.de>
Subject: Re: [PATCH v2 4/5] swapfile: use ->read_iter and ->write_iter
Message-ID: <20141222073234.GA14207@mew>
References: <cover.1419044605.git.osandov@osandov.com>
 <d8819b57849221b3db7c479f070067808912f0d5.1419044605.git.osandov@osandov.com>
 <20141220061337.GB22149@ZenIV.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141220061337.GB22149@ZenIV.linux.org.uk>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Dec 20, 2014 at 06:13:37AM +0000, Al Viro wrote:
> On Fri, Dec 19, 2014 at 07:18:28PM -0800, Omar Sandoval wrote:
> 
> > +		ret = swap_file->f_op->read_iter(&kiocb, &to);
> > +		if (ret == PAGE_SIZE) {
> > +			SetPageUptodate(page);
> >  			count_vm_event(PSWPIN);
> > +			ret = 0;
> > +		} else {
> > +			ClearPageUptodate(page);
> > +			SetPageError(page);
> > +		}
> > +		unlock_page(page);
> 
> Umm...  What's to guarantee that ->read_iter() won't try lock_page() on what
> turns out to be equal to page?

Ergh. I don't see why ->read_iter would be screwing around in the swap
cache or with the pages in the iterator, anything in particular you can
see happening?

-- 
Omar
