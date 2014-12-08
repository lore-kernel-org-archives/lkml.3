Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755266AbaLHLsU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Dec 2014 06:48:20 -0500
Received: from mail-wi0-f179.google.com ([209.85.212.179]:46385 "EHLO
	mail-wi0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755146AbaLHLsS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Dec 2014 06:48:18 -0500
Date: Mon, 8 Dec 2014 12:48:13 +0100
From: Dongsu Park <dongsu.park@profitbricks.com>
To: Kent Overstreet <kmo@daterainc.com>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jens Axboe <axboe@kernel.dk>, Christoph Hellwig <hch@infradead.org>
Subject: Re: Block layer projects that I haven't had time for
Message-ID: <20141208114813.GA2724@gmail.com>
References: <20141124041629.GA17907@kmo-pixel>
 <20141204110027.GA28552@gmail.com>
 <20141206030205.GA22669@kmo-pixel>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20141206030205.GA22669@kmo-pixel>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thanks for the reply.

On 05.12.2014 19:02, Kent Overstreet wrote:
> On Thu, Dec 04, 2014 at 12:00:27PM +0100, Dongsu Park wrote:
> > Playing a little with your block_stuff tree based on 3.15, however,
> > I think there still seems to be a couple of issues.
> > First of all, it doesn't work with virtio-blk. A testing Qemu VM panics
> > at the very early stage of booting. This issue should be addressed as
> > the first step, so that other parts can be tested.
> 
> Really? I was testing with virtio-blk, that's odd..

The culprit seems to be the plugging commit.
Before that change, it works well also with virtio-blk.
Though that's not the only issue...

> > Moreover, I've already tried to rebase these patches on top of current
> > mainline, 3.18-rc7. It's now compilable, but it seems to introduce
> > more bugs about direct-IO. I didn't manage to find out the reason.
> > I'd need to also look at the previous review comments in [1], [2].
> > 
> > Don't you have other trees based on top of 3.17 or higher?
> > If not, can I create my own tree based on 3.18-rc7 to publish?
> 
> Yeah, I'd post what you have now and I'll try and take a look.

I've created a git tree to include what I have right now.
Please see <https://github.com/dongsupark/linux>.

To be able to handle different issues one by one,
I got the entire tree separated out into 4 branches based on 3.18.

* block-generic-req-for-next : the most stable branch you can test with.
  With this branch, you can test most of block drivers as well as file
  systems with less critical bugs. Though it's not 100% perfect yet,
  e.g. btrfs doesn't seem to work quite well. Thus more tests are needed.

* block-mpage-bvecs-for-next : block-generic-req-for-next + multipage bvecs.
  This branch shows a critical issue that writing blocks to ext4 rootfs
  causes the whole system to crash. Need-to-investigate.
  
* block-plug-for-next: block-mpage-bvecs-for-next + plugging.
  This branch has an additional bug with virtio-blk, that the kernel
  panics at the very early stage of booting. Need-to-investigate.

* block-dio-rewrite-for-next: block-plug-for-next + dio-rewriting.
  This branch has more issues w.r.t. direct-io. For example, dio_init()
  causes the kernel to panic at the early stage of booting.

All branches are compilable. But it's still somehow half-way complete.
Commit messages should be properly written too, so that they can be posted
to mailing lists.

Regards,
Dongsu
