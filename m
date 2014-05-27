Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752903AbaE0WsP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 May 2014 18:48:15 -0400
Received: from mail-oa0-f50.google.com ([209.85.219.50]:33904 "EHLO
	mail-oa0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751186AbaE0WsO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 May 2014 18:48:14 -0400
Date: Tue, 27 May 2014 17:48:09 -0500
From: Seth Jennings <sjennings@variantweb.net>
To: Dan Streetman <ddstreet@ieee.org>
Cc: Minchan Kim <minchan@kernel.org>, Weijie Yang <weijie.yang@samsung.com>,
        Nitin Gupta <ngupta@vflare.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Bob Liu <bob.liu@oracle.com>, Hugh Dickins <hughd@google.com>,
        Mel Gorman <mgorman@suse.de>, Rik van Riel <riel@redhat.com>,
        Johannes Weiner <hannes@cmpxchg.org>,
        Sergey Senozhatsky <sergey.senozhatsky@gmail.com>,
        Linux-MM <linux-mm@kvack.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCHv3 3/6] mm/zpool: implement common zpool api to
 zbud/zsmalloc
Message-ID: <20140527224809.GD25781@cerebellum.variantweb.net>
References: <1399499496-3216-1-git-send-email-ddstreet@ieee.org>
 <1400958369-3588-1-git-send-email-ddstreet@ieee.org>
 <1400958369-3588-4-git-send-email-ddstreet@ieee.org>
 <20140527220639.GA25781@cerebellum.variantweb.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140527220639.GA25781@cerebellum.variantweb.net>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 27, 2014 at 05:06:39PM -0500, Seth Jennings wrote:
> On Sat, May 24, 2014 at 03:06:06PM -0400, Dan Streetman wrote:
<snip>
> > +
> > +int zpool_evict(void *pool, unsigned long handle)
> > +{
> > +	struct zpool *zpool;
> > +
> > +	spin_lock(&pools_lock);
> > +	list_for_each_entry(zpool, &pools_head, list) {
> 
> You can do a container_of() here:
> 
> zpool = container_of(pool, struct zpool, pool);

If you do this, all of the pools_head/pools_lock is unneeded as well.

Seth
