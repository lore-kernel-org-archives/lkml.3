Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756078AbaLWLqr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Dec 2014 06:46:47 -0500
Received: from mail-wg0-f43.google.com ([74.125.82.43]:53245 "EHLO
	mail-wg0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755779AbaLWLqp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Dec 2014 06:46:45 -0500
Date: Tue, 23 Dec 2014 12:46:41 +0100
From: Dongsu Park <dongsu.park@profitbricks.com>
To: Christoph Hellwig <hch@infradead.org>
Cc: linux-kernel@vger.kernel.org, Jens Axboe <axboe@kernel.dk>,
        Kent Overstreet <kmo@daterainc.com>, Ming Lin <mlin@minggr.net>,
        target-devel@vger.kernel.org, Boaz Harrosh <ooo@electrozaur.com>,
        Benny Halevy <bhalevy@primarydata.com>
Subject: Re: [RFC PATCH 02/17] block: simplify bio_add_page()
Message-ID: <20141223114641.GC15080@gmail.com>
References: <cover.1419241597.git.dongsu.park@profitbricks.com>
 <f67d71b4a375ab504c2fc02e94a9d2a651686cab.1419241597.git.dongsu.park@profitbricks.com>
 <20141223102221.GB13138@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20141223102221.GB13138@infradead.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 23.12.2014 02:22, Christoph Hellwig wrote:
> On Mon, Dec 22, 2014 at 12:48:29PM +0100, Dongsu Park wrote:
> > From: Kent Overstreet <kmo@daterainc.com>
> > 
> > Since generic_make_request() can now handle arbitrary size bios, all we
> > have to do is make sure the bvec array doesn't overflow.
> > __bio_add_page() doesn't need to call ->merge_bvec_fn(), where
> > we can get rid of unnecessary code paths.
> 
> This needs an explanation of why removign the call to ->merge_bvec_fn
> is fine for bio_add_pc_page.  I guess it's because neither
> the target pscsi pass through mode, nor the osd code ever use anything
> but a simple scsi devices that doesn't even have one, but it needs to be
> clearly spelled out.

Agreed.

> > + *	Attempt to add a page to the bio_vec maplist. This will only fail if
> > + *	bio->bi_vcnt == bio->bi_max_vecs.
> 
> It also fails on a cloned bio, although that might better be turned into
> a BUG_ON().

Agreed, I'll update both of them in the next round.

Thanks,
Dongsu
