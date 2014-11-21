Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758187AbaKUJzB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Nov 2014 04:55:01 -0500
Received: from bombadil.infradead.org ([198.137.202.9]:38656 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752547AbaKUJy7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Nov 2014 04:54:59 -0500
Date: Fri, 21 Nov 2014 01:54:56 -0800
From: Christoph Hellwig <hch@infradead.org>
To: Mike Snitzer <snitzer@redhat.com>
Cc: axboe@kernel.dk, linux-kernel@vger.kernel.org, martin.petersen@oracle.com,
        hch@infradead.org, mst@redhat.com, rusty@rustcorp.com.au,
        dm-devel@redhat.com, Paolo Bonzini <pbonzini@redhat.com>,
        qemu-devel@nongnu.org
Subject: Re: [PATCH] virtio_blk: fix defaults for max_hw_sectors and
 max_segment_size
Message-ID: <20141121095456.GB8866@infradead.org>
References: <20141120190058.GA31214@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141120190058.GA31214@redhat.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 20, 2014 at 02:00:59PM -0500, Mike Snitzer wrote:
> virtio_blk incorrectly established -1U as the default for these
> queue_limits.  Set these limits to sane default values to avoid crashing
> the kernel.  But the virtio-blk protocol should probably be extended to
> allow proper stacking of the disk's limits from the host.
> 
> This change fixes a crash that was reported when virtio-blk was used to
> test linux-dm.git commit 604ea90641b4 ("dm thin: adjust max_sectors_kb
> based on thinp blocksize") that will initially set max_sectors to
> max_hw_sectors and then rounddown to the first power-of-2 factor of the
> DM thin-pool's blocksize.  Basically that commit assumes drivers don't
> suck when establishing max_hw_sectors so it acted like a canary in the
> coal mine.

Is that a crash in the host or guest?  What kind of mishandling did you
see?  Unless the recent virtio standard changed anything the host
should be able to handle our arbitrary limits, and even if it doesn't
that something we need to hash out with qemu and the virtio standards
folks.
