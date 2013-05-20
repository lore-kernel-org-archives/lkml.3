Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757098Ab3ETOi4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 May 2013 10:38:56 -0400
Received: from cantor2.suse.de ([195.135.220.15]:48908 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756972Ab3ETOik (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 May 2013 10:38:40 -0400
Date: Mon, 20 May 2013 15:38:33 +0100
From: Mel Gorman <mgorman@suse.de>
To: Johannes Weiner <hannes@cmpxchg.org>
Cc: Alexey Lyahkov <alexey.lyashkov@gmail.com>,
        Andrew Perepechko <anserper@ya.ru>, Robin Dong <sanbai@taobao.com>,
        Theodore Tso <tytso@mit.edu>,
        Andrew Morton <akpm@linux-foundation.org>,
        Hugh Dickins <hughd@google.com>, Rik van Riel <riel@redhat.com>,
        Bernd Schubert <bernd.schubert@fastmail.fm>,
        David Howells <dhowells@redhat.com>,
        Trond Myklebust <Trond.Myklebust@netapp.com>,
        Linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        Linux-ext4 <linux-ext4@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, Linux-mm <linux-mm@kvack.org>
Subject: Re: [PATCH 4/5] mm: Remove lru parameter from __pagevec_lru_add and
 remove parts of pagevec API
Message-ID: <20130520143833.GS11497@suse.de>
References: <1368784087-956-1-git-send-email-mgorman@suse.de>
 <1368784087-956-5-git-send-email-mgorman@suse.de>
 <20130517204452.GC15721@cmpxchg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <20130517204452.GC15721@cmpxchg.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 17, 2013 at 04:44:52PM -0400, Johannes Weiner wrote:
> On Fri, May 17, 2013 at 10:48:06AM +0100, Mel Gorman wrote:
> > Now that the LRU to add a page to is decided at LRU-add time, remove the
> > misleading lru parameter from __pagevec_lru_add. A consequence of this is
> > that the pagevec_lru_add_file, pagevec_lru_add_anon and similar helpers
> > are misleading as the caller no longer has direct control over what LRU
> > the page is added to. Unused helpers are removed by this patch and existing
> > users of pagevec_lru_add_file() are converted to use lru_cache_add_file()
> > directly and use the per-cpu pagevecs instead of creating their own pagevec.
> > 
> > Signed-off-by: Mel Gorman <mgorman@suse.de>
> > Reviewed-by: Jan Kara <jack@suse.cz>
> > Reviewed-by: Rik van Riel <riel@redhat.com>
> 
> > @@ -452,8 +448,7 @@ int cachefiles_read_or_alloc_page(struct fscache_retrieval *op,
> >  	if (block) {
> >  		/* submit the apparently valid page to the backing fs to be
> >  		 * read from disk */
> > -		ret = cachefiles_read_backing_file_one(object, op, page,
> > -						       &pagevec);
> > +		ret = cachefiles_read_backing_file_one(object, op, page);
> 
> Also remove the declaration and pagevec_init a few lines up?  Minor
> detail, though.
> 

It's still used and passed to fscache_mark_pages_cached

> Acked-by: Johannes Weiner <hannes@cmpxchg.org>

Thanks

-- 
Mel Gorman
SUSE Labs
