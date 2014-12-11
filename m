Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757295AbaLKKV4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Dec 2014 05:21:56 -0500
Received: from mail-wg0-f42.google.com ([74.125.82.42]:49766 "EHLO
	mail-wg0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750959AbaLKKVx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Dec 2014 05:21:53 -0500
Date: Thu, 11 Dec 2014 11:21:49 +0100
From: Dongsu Park <dongsu.park@profitbricks.com>
To: Kent Overstreet <kmo@daterainc.com>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jens Axboe <axboe@kernel.dk>, Christoph Hellwig <hch@infradead.org>
Subject: Re: Block layer projects that I haven't had time for
Message-ID: <20141211102149.GB2409@gmail.com>
References: <20141124041629.GA17907@kmo-pixel>
 <20141204110027.GA28552@gmail.com>
 <20141206030205.GA22669@kmo-pixel>
 <20141208114813.GA2724@gmail.com>
 <20141210224921.GB31102@daterainc.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20141210224921.GB31102@daterainc.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Kent,

On 10.12.2014 14:49, Kent Overstreet wrote:
> On Mon, Dec 08, 2014 at 12:48:13PM +0100, Dongsu Park wrote:
> > Thanks for the reply.
> > 
> > On 05.12.2014 19:02, Kent Overstreet wrote:
> > > On Thu, Dec 04, 2014 at 12:00:27PM +0100, Dongsu Park wrote:
> > > > Playing a little with your block_stuff tree based on 3.15, however,
> > > > I think there still seems to be a couple of issues.
> > > > First of all, it doesn't work with virtio-blk. A testing Qemu VM panics
> > > > at the very early stage of booting. This issue should be addressed as
> > > > the first step, so that other parts can be tested.
> > > 
> > > Really? I was testing with virtio-blk, that's odd..
> > 
> > The culprit seems to be the plugging commit.
> > Before that change, it works well also with virtio-blk.
> > Though that's not the only issue...
> 
> Ohh - the plugging stuff was definitely broken and very preliminary. I'm
> surprised that code even compiled (or did it?)

No, it didn't. But it was just one of dozens of compile errors.
It's no big deal. After all someone has to get it compiled when rebasing
a patchset on top of a new kernel. :-)

> > > > Moreover, I've already tried to rebase these patches on top of current
> > > > mainline, 3.18-rc7. It's now compilable, but it seems to introduce
> > > > more bugs about direct-IO. I didn't manage to find out the reason.
> > > > I'd need to also look at the previous review comments in [1], [2].
> > > > 
> > > > Don't you have other trees based on top of 3.17 or higher?
> > > > If not, can I create my own tree based on 3.18-rc7 to publish?
> > > 
> > > Yeah, I'd post what you have now and I'll try and take a look.
> > 
> > I've created a git tree to include what I have right now.
> > Please see <https://github.com/dongsupark/linux>.
> > 
> > To be able to handle different issues one by one,
> > I got the entire tree separated out into 4 branches based on 3.18.
> > 
> > * block-generic-req-for-next : the most stable branch you can test with.
> >   With this branch, you can test most of block drivers as well as file
> >   systems with less critical bugs. Though it's not 100% perfect yet,
> >   e.g. btrfs doesn't seem to work quite well. Thus more tests are needed.
> > 
> > * block-mpage-bvecs-for-next : block-generic-req-for-next + multipage bvecs.
> >   This branch shows a critical issue that writing blocks to ext4 rootfs
> >   causes the whole system to crash. Need-to-investigate.
> >   
> > * block-plug-for-next: block-mpage-bvecs-for-next + plugging.
> >   This branch has an additional bug with virtio-blk, that the kernel
> >   panics at the very early stage of booting. Need-to-investigate.
> > 
> > * block-dio-rewrite-for-next: block-plug-for-next + dio-rewriting.
> >   This branch has more issues w.r.t. direct-io. For example, dio_init()
> >   causes the kernel to panic at the early stage of booting.
> > 
> > All branches are compilable. But it's still somehow half-way complete.
> > Commit messages should be properly written too, so that they can be posted
> > to mailing lists.
> 
> Cool!
> 
> I'll take a look. I think the multipage bvec stuff still had a fair amount of
> work to do, and getting the dio rewrite finished will be _hard_ (I was close to
> having it working at one point, but xfstests was finding some subtle issues).
> 
> It'll be pretty awesome if we can get even some of this stuff in.

Thanks. I actually want to tidy up the 1st branch, block-generic-req-for-next,
moving several commits about bio_for_each_page() to block-mpage-bvecs-for-next.
Then I'd be able to make the 1st branch with ca. 14 patches, so they could be
posted to mailing lists a little easily. Though I still couldn't get it
done due to some code dependencies. I'll try it again in the next days.

Dongsu
