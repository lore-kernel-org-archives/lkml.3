Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754628AbaIBQVt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Sep 2014 12:21:49 -0400
Received: from bombadil.infradead.org ([198.137.202.9]:34842 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754172AbaIBQVs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Sep 2014 12:21:48 -0400
Date: Tue, 2 Sep 2014 09:21:46 -0700
From: Christoph Hellwig <hch@infradead.org>
To: Ming Lei <ming.lei@canonical.com>
Cc: Jens Axboe <axboe@kernel.dk>, linux-kernel@vger.kernel.org,
        Kick In <pierre-andre.morey@canonical.com>,
        Chris J Arges <chris.j.arges@canonical.com>
Subject: Re: [PATCH] blk-merge: fix blk_recount_segments
Message-ID: <20140902162146.GA28741@infradead.org>
References: <1409670180-17352-1-git-send-email-ming.lei@canonical.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1409670180-17352-1-git-send-email-ming.lei@canonical.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Btw, one thing we should reconsider is where we set
QUEUE_FLAG_NO_SG_MERGE.  At least for virtio-blk it seems to me that
doing the S/G merge should be a lot cheaper than fanning out into the
indirect descriptors.

