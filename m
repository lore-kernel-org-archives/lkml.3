Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752271AbaKZOLi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Nov 2014 09:11:38 -0500
Received: from mx1.redhat.com ([209.132.183.28]:41602 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750870AbaKZOLh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Nov 2014 09:11:37 -0500
Date: Wed, 26 Nov 2014 09:10:59 -0500
From: Mike Snitzer <snitzer@redhat.com>
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: "Michael S. Tsirkin" <mst@redhat.com>, axboe@kernel.dk,
        linux-kernel@vger.kernel.org, martin.petersen@oracle.com,
        hch@infradead.org, dm-devel@redhat.com
Subject: Re: virtio_blk: fix defaults for max_hw_sectors and max_segment_size
Message-ID: <20141126141058.GA29855@redhat.com>
References: <20141120190058.GA31214@redhat.com>
 <20141120203044.GA9078@redhat.com>
 <20141120211521.GA846@redhat.com>
 <87bnnuy03g.fsf@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87bnnuy03g.fsf@rustcorp.com.au>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 26 2014 at 12:58am -0500,
Rusty Russell <rusty@rustcorp.com.au> wrote:

> Mike Snitzer <snitzer@redhat.com> writes:
> > On Thu, Nov 20 2014 at  3:30pm -0500,
> > Michael S. Tsirkin <mst@redhat.com> wrote:
> >
> >> On Thu, Nov 20, 2014 at 02:00:59PM -0500, Mike Snitzer wrote:
> >> > virtio_blk incorrectly established -1U as the default for these
> >> > queue_limits.  Set these limits to sane default values to avoid crashing
> >> > the kernel.
> > ...
> >> > Attempting to mkfs.xfs against a thin device from this thin-pool quickly
> >> > resulted in fs/direct-io.c:dio_send_cur_page()'s BUG_ON.
> >> 
> >> Why exactly does it BUG_ON?
> >> Did some memory allocation fail?
> >
> > No idea, kernel log doesn't say.. all it has is "kernel BUG" pointing to
> > fs/direct-io.c:dio_send_cur_page()'s BUG_ON.
> >
> > I could dig deeper on _why_ but honestly, there really isn't much point.
> 
> There is *always* a point in understanding the code you are modifying.

Yes, I agree (and understanding the BUG in question will be pursued).
But in the context of the patch I proposed it was irrelevent.
virtio-blk still _should_ fix its limits to reflect those of the block
device it stacks on.  My patch was a stop-gap until proper virtio-blk
protocol extensions were added.  But you don't seem inclined to care.

> > virtio-blk doesn't get to live in fantasy-land just because it happens
> > to think it is limitless.
> 
> Calm down please.

Sure, but it'd have helped if virtio-blk developers demonstrated
acknowledgement that a stacking block driver should stack the limits of
the underlying device.  Instead you decided to trim all related portions
of my reply to mst that were measured and helpful.

> We don't have a sector limit.  We have a segment limit, which is set
> above this line.

Then at a minimum max_hw_sectors should reflect that segment limit.

But again, the underlying device has limits that should be stacked up.
Why is that irrelevent to virtio-blk?  Plus, this is a matter of not
allowing a user to shoot themselves in the foot by fiddling with
traditional block limits only to find in some kernel (*cough* RHEL6)
they result in BUG.

Mike
