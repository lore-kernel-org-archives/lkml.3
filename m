Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754569AbaIXKTK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Sep 2014 06:19:10 -0400
Received: from verein.lst.de ([213.95.11.211]:52761 "EHLO newverein.lst.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754495AbaIXKSy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Sep 2014 06:18:54 -0400
Date: Wed, 24 Sep 2014 12:18:50 +0200
From: Christoph Hellwig <hch@lst.de>
To: Ming Lei <ming.lei@canonical.com>
Cc: Jens Axboe <axboe@kernel.dk>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v4 02/10] block: introduce blk_init_flush and its pair
Message-ID: <20140924101850.GA19078@lst.de>
References: <1410786675-7761-1-git-send-email-ming.lei@canonical.com> <1410786675-7761-3-git-send-email-ming.lei@canonical.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1410786675-7761-3-git-send-email-ming.lei@canonical.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 15, 2014 at 09:11:06PM +0800, Ming Lei wrote:
> These two temporary functions are introduced for holding flush
> initialization and de-initialization, so that we can
> introduce 'flush queue' easier in the following patch. And
> once 'flush queue' and its allocation/free functions are ready,
> they will be removed for sake of code readability.

Shouldn't we just do the mq work in this helper as well?  blk_mq_init_flush
does exactly the same work, plus initializing a lock, which is harmless
for the !mq case as well.

