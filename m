Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752646AbaIGSru (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Sep 2014 14:47:50 -0400
Received: from verein.lst.de ([213.95.11.211]:41968 "EHLO newverein.lst.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751354AbaIGSrt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Sep 2014 14:47:49 -0400
Date: Sun, 7 Sep 2014 20:47:45 +0200
From: Christoph Hellwig <hch@lst.de>
To: "Michael S. Tsirkin" <mst@redhat.com>
Cc: Christoph Hellwig <hch@lst.de>, Rusty Russell <rusty@rustcorp.com.au>,
        Jens Axboe <axboe@kernel.dk>, linux-kernel@vger.kernel.org,
        virtualization@lists.linux-foundation.org
Subject: Re: [PATCH] virtio_blk: merge S/G list entries by default
Message-ID: <20140907184745.GA23026@lst.de>
References: <1410044994-14943-1-git-send-email-hch@lst.de> <20140907114153.GB26569@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140907114153.GB26569@redhat.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Sep 07, 2014 at 02:41:53PM +0300, Michael S. Tsirkin wrote:
> > Signed-off-by: Christoph Hellwig <hch@lst.de>
> 
> OK so this is an optimization patch right?
> What kind of performance gain is observed with it?

None.  I actually wrote it when the block layer had a bug when dm was
used on top of the !merge case, and I decided to send it out as there had been
no discussion about disabling this by default on the existing blk-mq
drivers.

At least for my qemu/kvm setup it doesn't make a difference either way,
although not doing the cheap merge doesn't like the right kind of optimization
to me.
