Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752464AbaFJMpP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jun 2014 08:45:15 -0400
Received: from verein.lst.de ([213.95.11.211]:39680 "EHLO newverein.lst.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752098AbaFJMpN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jun 2014 08:45:13 -0400
Date: Tue, 10 Jun 2014 14:45:08 +0200
From: Christoph Hellwig <hch@lst.de>
To: Ming Lei <tom.leiming@gmail.com>
Cc: Jens Axboe <axboe@kernel.dk>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Matias =?iso-8859-1?Q?Bj=F8rling?= <m@bjorling.me>
Subject: Re: [PATCH] blk-mq: kick requeue list in blk_mq_requeue_request()
Message-ID: <20140610124508.GA5671@lst.de>
References: <1402375925-21720-1-git-send-email-tom.leiming@gmail.com> <20140610112827.GA359@lst.de> <CACVXFVNxSh7ryy2vfnoNYpvmnjU0+TcipgdZxJ3tDbu-RBY=zA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CACVXFVNxSh7ryy2vfnoNYpvmnjU0+TcipgdZxJ3tDbu-RBY=zA@mail.gmail.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 10, 2014 at 07:45:47PM +0800, Ming Lei wrote:
> OK, but the API name is a bit confusing, and that is easy to cause
> misuse, like in nvme.
> 
> Also requeue one request in completion handler may be a
> common case, so maybe it is better to let blk_mq_requeue_request()
> handle both adding to request list and kicking off, and introduce
> blk_mq_prep_requeue_req()(or better name) to batch operations.

For now please just add some documentation.  I'm happy to revisit
these once we have a few user in tree, but for now I'd like to keep
blk-mq a little more stable to not impact the merges of the major
users.
