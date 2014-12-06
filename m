Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752273AbaLFC7s (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Dec 2014 21:59:48 -0500
Received: from mail-pa0-f52.google.com ([209.85.220.52]:53384 "EHLO
	mail-pa0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752037AbaLFC7q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Dec 2014 21:59:46 -0500
Date: Fri, 5 Dec 2014 19:02:05 -0800
From: Kent Overstreet <kmo@daterainc.com>
To: Dongsu Park <dongsu.park@profitbricks.com>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jens Axboe <axboe@kernel.dk>, Christoph Hellwig <hch@infradead.org>
Subject: Re: Block layer projects that I haven't had time for
Message-ID: <20141206030205.GA22669@kmo-pixel>
References: <20141124041629.GA17907@kmo-pixel>
 <20141204110027.GA28552@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141204110027.GA28552@gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 04, 2014 at 12:00:27PM +0100, Dongsu Park wrote:
> Hi Kent,
> 
> On 23.11.2014 20:16, Kent Overstreet wrote:
> > Since I'm starting to resign myself to the fact that I'm probably not going to
> > have much time for upstream development again any time soon, I figured maybe I
> > should try writing down all the things I was working on or planning on working
> > on in case someone else is feeling ambitious and looking for things to work on.
> > 
> > If anyone wants to take up any of this stuff, feel free to take my half baked
> > code and do whatever you want with it, or ping me for ideas/guidance.
> 
> I'm interested in taking up your work and further implement it.
> IMHO the 1st and 2nd items, making generic_make_request() take arbitrarily
> sized bios, are the essential ones. With those changes, individual block
> drivers wouldn't have to define ->merge_bvec_fn() any more.

Cool! Yeah, things get a lot simpler for a lot of code.

> Playing a little with your block_stuff tree based on 3.15, however,
> I think there still seems to be a couple of issues.
> First of all, it doesn't work with virtio-blk. A testing Qemu VM panics
> at the very early stage of booting. This issue should be addressed as
> the first step, so that other parts can be tested.

Really? I was testing with virtio-blk, that's odd..

> Moreover, I've already tried to rebase these patches on top of current
> mainline, 3.18-rc7. It's now compilable, but it seems to introduce
> more bugs about direct-IO. I didn't manage to find out the reason.
> I'd need to also look at the previous review comments in [1], [2].
> 
> Don't you have other trees based on top of 3.17 or higher?
> If not, can I create my own tree based on 3.18-rc7 to publish?

Yeah, I'd post what you have now and I'll try and take a look.
