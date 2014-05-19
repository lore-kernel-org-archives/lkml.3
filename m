Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755137AbaESQ6t (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 May 2014 12:58:49 -0400
Received: from bombadil.infradead.org ([198.137.202.9]:50648 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755017AbaESQ6s (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 May 2014 12:58:48 -0400
Date: Mon, 19 May 2014 09:58:46 -0700
From: Christoph Hellwig <hch@infradead.org>
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: Christoph Hellwig <hch@infradead.org>, Jens Axboe <axboe@kernel.dk>,
        linux-kernel@vger.kernel.org
Subject: Re: time to move fs/bio.c to block/ ?
Message-ID: <20140519165846.GC663@infradead.org>
References: <20140519141309.GB21570@infradead.org>
 <537A11CC.5060708@kernel.dk>
 <20140519142519.GI18016@ZenIV.linux.org.uk>
 <537A15B9.6000102@kernel.dk>
 <20140519143416.GC568@infradead.org>
 <20140519163942.GJ18016@ZenIV.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140519163942.GJ18016@ZenIV.linux.org.uk>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 19, 2014 at 05:39:42PM +0100, Al Viro wrote:
> ACK on ioprio.c (BTW, looking at block...  WTF is the story with that
> pile of blk-* in there?  IOW, why blk-exec.c is better than exec.c,
> etc.?)
> 
> As for fs/no-block.c...  IMO that's a bad idea - it makes sense only
> if we take fs/block.c there as well, and that one wants fs/internal.h.

Right, we still have block_dev.c which is more VFS than block.  Makes
sense to keep no-block.c then.

> Why do we need that ->llseek = noop_llseek there, while we are at it?
> Its ->open() always fails, so how is ->llseek() going to get looked at,
> let alone called?

Looks like a larger mechanical conversation of lseek instances..
