Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752924Ab3J2VRW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Oct 2013 17:17:22 -0400
Received: from cantor2.suse.de ([195.135.220.15]:51013 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751889Ab3J2VRU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Oct 2013 17:17:20 -0400
Date: Tue, 29 Oct 2013 22:17:15 +0100
From: Jan Kara <jack@suse.cz>
To: Christoph Hellwig <hch@infradead.org>
Cc: Jan Kara <jack@suse.cz>, Jens Axboe <axboe@kernel.dk>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 6/7] kernel: use lockless list for
 smp_call_function_single
Message-ID: <20131029211715.GA12814@quack.suse.cz>
References: <20131024151921.537751910@bombadil.infradead.org>
 <20131024152314.204817634@bombadil.infradead.org>
 <20131029192536.GB9568@quack.suse.cz>
 <20131029192720.GA24089@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131029192720.GA24089@infradead.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue 29-10-13 12:27:20, Christoph Hellwig wrote:
> On Tue, Oct 29, 2013 at 08:25:36PM +0100, Jan Kara wrote:
> >   I'm wondering: Who's still using the normal list_head? I was grepping for
> > a while and I couldn't find any user. Otherwise the patch looks good to me.
> 
> The block/blk-softirq.c code is abusing it in a fairly ugly way.
  Ah, thanks for the pointer. Looking into the code, that could easily use
llist as well, couldn't it?

								Honza

-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
