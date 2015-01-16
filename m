Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754846AbbAPL6v (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Jan 2015 06:58:51 -0500
Received: from mail-wg0-f53.google.com ([74.125.82.53]:43919 "EHLO
	mail-wg0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751390AbbAPL6u (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Jan 2015 06:58:50 -0500
Date: Fri, 16 Jan 2015 12:58:45 +0100
From: Dongsu Park <dongsu.park@profitbricks.com>
To: Christoph Hellwig <hch@infradead.org>
Cc: linux-kernel@vger.kernel.org, Kent Overstreet <kmo@daterainc.com>,
        Jens Axboe <axboe@kernel.dk>, Al Viro <viro@zeniv.linux.org.uk>
Subject: Re: [PATCH v2 2/7] block: rewrite __bio_copy_iov()
Message-ID: <20150116115845.GB22882@posteo.de>
References: <cover.1421052656.git.dongsu.park@profitbricks.com>
 <0bdbbd2ef9d449be2d00e01ca7dc7f101b6cfb88.1421052656.git.dongsu.park@profitbricks.com>
 <20150115181817.GA32041@infradead.org>
 <20150116113145.GA14063@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20150116113145.GA14063@infradead.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Christoph,

On 16.01.2015 03:31, Christoph Hellwig wrote:
> On Thu, Jan 15, 2015 at 10:18:17AM -0800, Christoph Hellwig wrote:
> > This breaks booting a simple KVM VM for me:
> Seems like the issue actually is in the patch before this one, but
> only shows up with this one applied.
> The root cause is that we only copy the iov_iter, but not the
> actual iovecs into the bio_map_data.
> I have a fixed series, which I'll send out together with various
> related cleanups ASAP.

Thanks for testing it and finding out the root cause.
Strange, I haven't never seen the bug.
Maybe I'd have to test it also with virtio-scsi, which I don't do usually.

Dongsu
