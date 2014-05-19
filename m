Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755080AbaESQjp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 May 2014 12:39:45 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:57411 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752137AbaESQjo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 May 2014 12:39:44 -0400
Date: Mon, 19 May 2014 17:39:42 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Christoph Hellwig <hch@infradead.org>
Cc: Jens Axboe <axboe@kernel.dk>, linux-kernel@vger.kernel.org
Subject: Re: time to move fs/bio.c to block/ ?
Message-ID: <20140519163942.GJ18016@ZenIV.linux.org.uk>
References: <20140519141309.GB21570@infradead.org>
 <537A11CC.5060708@kernel.dk>
 <20140519142519.GI18016@ZenIV.linux.org.uk>
 <537A15B9.6000102@kernel.dk>
 <20140519143416.GC568@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140519143416.GC568@infradead.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 19, 2014 at 07:34:16AM -0700, Christoph Hellwig wrote:
> On Mon, May 19, 2014 at 08:31:21AM -0600, Jens Axboe wrote:
> > > While you are at it, could you take bio-integrity.c with it?  _That_
> > > has zero excuse being anywhere in fs/* - not even "filesystem code
> > > uses quite a few functions from that sucker" as with bio.c.
> > > FWIW, consider the move ACKed.
> > 
> > Yeah, I did include that in the move.
> 
> Other candidates to move to block/ might be ioprio.c and no-block.c

ACK on ioprio.c (BTW, looking at block...  WTF is the story with that
pile of blk-* in there?  IOW, why blk-exec.c is better than exec.c,
etc.?)

As for fs/no-block.c...  IMO that's a bad idea - it makes sense only
if we take fs/block.c there as well, and that one wants fs/internal.h.

Why do we need that ->llseek = noop_llseek there, while we are at it?
Its ->open() always fails, so how is ->llseek() going to get looked at,
let alone called?
