Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751301AbaHONLl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Aug 2014 09:11:41 -0400
Received: from bombadil.infradead.org ([198.137.202.9]:51278 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750967AbaHONLk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Aug 2014 09:11:40 -0400
Date: Fri, 15 Aug 2014 06:11:37 -0700
From: Christoph Hellwig <hch@infradead.org>
To: Ming Lei <ming.lei@canonical.com>
Cc: Jens Axboe <axboe@kernel.dk>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Dave Kleikamp <dave.kleikamp@oracle.com>, Zach Brown <zab@zabbo.net>,
        Benjamin LaHaise <bcrl@kvack.org>,
        Christoph Hellwig <hch@infradead.org>,
        Kent Overstreet <kmo@daterainc.com>,
        "open list:AIO" <linux-aio@kvack.org>,
        Linux FS Devel <linux-fsdevel@vger.kernel.org>,
        Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH v1 0/9] block & aio: kernel aio and loop mq conversion
Message-ID: <20140815131137.GA31079@infradead.org>
References: <1408031441-31156-1-git-send-email-ming.lei@canonical.com>
 <53ECE998.8070407@kernel.dk>
 <CACVXFVNGaZ0C1cA5fq0UnEBDPPMpBDqF2PxNk4TAOOCGL3jh5g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CACVXFVNGaZ0C1cA5fq0UnEBDPPMpBDqF2PxNk4TAOOCGL3jh5g@mail.gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 15, 2014 at 08:59:56PM +0800, Ming Lei wrote:
> Your concern is right, previous I thought that mq conversion wouldn't improve
> throughput, but I did ignore workqueue's concurrency management, it
> turns out blk-mq conversion can improvment throughput close to 10 times in
> my test(loop over virtio-blk which is backed by one image on SSD).  It is like
> POSIX style AIO after mq conversion thanks to workqueue, and I need to
> update the performance data in V2.
> 
> Actually kernel AIO needn't such high concurrency.

Can you juse send a loop blk-mq conversion for now?  I think that's
a bit less controversial than the new kernel aio APIs, and keeping the
two separate is a good idea in general.

