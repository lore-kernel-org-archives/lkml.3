Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754637AbbAPLbs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Jan 2015 06:31:48 -0500
Received: from bombadil.infradead.org ([198.137.202.9]:40833 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754548AbbAPLbq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Jan 2015 06:31:46 -0500
Date: Fri, 16 Jan 2015 03:31:45 -0800
From: Christoph Hellwig <hch@infradead.org>
To: Dongsu Park <dongsu.park@profitbricks.com>
Cc: linux-kernel@vger.kernel.org, Christoph Hellwig <hch@infradead.org>,
        Kent Overstreet <kmo@daterainc.com>, Jens Axboe <axboe@kernel.dk>,
        Al Viro <viro@zeniv.linux.org.uk>
Subject: Re: [PATCH v2 2/7] block: rewrite __bio_copy_iov()
Message-ID: <20150116113145.GA14063@infradead.org>
References: <cover.1421052656.git.dongsu.park@profitbricks.com>
 <0bdbbd2ef9d449be2d00e01ca7dc7f101b6cfb88.1421052656.git.dongsu.park@profitbricks.com>
 <20150115181817.GA32041@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20150115181817.GA32041@infradead.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 15, 2015 at 10:18:17AM -0800, Christoph Hellwig wrote:
> This breaks booting a simple KVM VM for me:

Seems like the issue actually is in the patch before this one, but
only shows up with this one applied.

The root cause is that we only copy the iov_iter, but not the
actual iovecs into the bio_map_data.

I have a fixed series, which I'll send out together with various
related cleanups ASAP.
