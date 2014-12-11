Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934567AbaLKKMO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Dec 2014 05:12:14 -0500
Received: from mail-pd0-f179.google.com ([209.85.192.179]:64669 "EHLO
	mail-pd0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933516AbaLKKMM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Dec 2014 05:12:12 -0500
Date: Thu, 11 Dec 2014 02:14:34 -0800
From: Kent Overstreet <kmo@daterainc.com>
To: Dongsu Park <dongsu.park@profitbricks.com>
Cc: Ming Lin <mlin@minggr.net>, linux-fsdevel@vger.kernel.org,
        lkml <linux-kernel@vger.kernel.org>, Jens Axboe <axboe@kernel.dk>,
        Christoph Hellwig <hch@infradead.org>
Subject: Re: Block layer projects that I haven't had time for
Message-ID: <20141211101434.GA12545@kmo-pixel>
References: <20141124041629.GA17907@kmo-pixel>
 <20141204110027.GA28552@gmail.com>
 <20141206030205.GA22669@kmo-pixel>
 <20141208114813.GA2724@gmail.com>
 <CAF1ivSYYTO-abY32rFy2SVscPpxJaDyDZTULygXTys3rgWLONg@mail.gmail.com>
 <20141210225707.GC31102@daterainc.com>
 <572ec4bea03f28abe72225a053684878.squirrel@minggr.net>
 <20141211100751.GA2409@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141211100751.GA2409@gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 11, 2014 at 11:07:51AM +0100, Dongsu Park wrote:
> Hi Ming & Kent,
> 
> On 10.12.2014 23:11, Ming Lin wrote:
> > > On Wed, Dec 10, 2014 at 02:42:14PM -0800, Ming Lin wrote:
> > > Try this fix:
> > Yes, it fixed ext4 problem.
> 
> @kent: Thank you for the patch. Indeed it fixes the ext4 lockup I've seen.
> I've applied it to my tree, under the branch block-mpage-bvecs-for-next.
> See 0d2e05525a58 ("fs/ext4: fix a lockup when writing blocks into ext4
> rootfs") <https://github.com/dongsupark/linux/commit/0d2e05525a58>.
> 
> After that of course, more bugs start to appear, e.g. crash with virtio-blk,
> like we'd have opened a can of worms. ;-)

Yeah :) You'll need to audit every usage of bio_for_each_segment() to figure out
which ones need converting to bio_for_each_page(). I did some of this - but just
enough to get it working for me, and I haven't worked on that code since at
least 3.14 so really everything needs to be audited.

Hopefully in the future a lot of stuff could be converted to
bio_for_each_segment() and changed to use more efficient algorithms, but that
will be a lot more work. With bio_for_each_page() it shouldn't be too hard to
get it stable, though.
