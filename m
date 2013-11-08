Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753246Ab3KHIC1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Nov 2013 03:02:27 -0500
Received: from bombadil.infradead.org ([198.137.202.9]:56582 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751078Ab3KHICY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Nov 2013 03:02:24 -0500
Date: Fri, 8 Nov 2013 00:02:21 -0800
From: Christoph Hellwig <hch@infradead.org>
To: Kent Overstreet <kmo@daterainc.com>
Cc: Christoph Hellwig <hch@infradead.org>,
        Dave Kleikamp <dave.kleikamp@oracle.com>,
        Stephen Rothwell <sfr@canb.auug.org.au>, Jens Axboe <axboe@kernel.dk>,
        linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Zach Brown <zab@zabbo.net>, Olof Johansson <olof@lixom.net>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: linux-next: manual merge of the block tree with the  tree
Message-ID: <20131108080221.GA31866@infradead.org>
References: <527BE7FA.90904@oracle.com>
 <20131107192545.GA20624@moria.home.lan>
 <527C2AA9.9040608@oracle.com>
 <20131108125307.613427c04a7527c4359e6443@canb.auug.org.au>
 <20131108020805.GI3842@kmo>
 <527C4D35.8000907@oracle.com>
 <20131108073324.GA31662@infradead.org>
 <20131108073959.GA17807@kmo-pixel>
 <20131108074445.GA11595@infradead.org>
 <20131108075617.GB17807@kmo-pixel>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131108075617.GB17807@kmo-pixel>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 07, 2013 at 11:56:17PM -0800, Kent Overstreet wrote:
> So, I don't think the iov_iter stuff is the right approach for solving
> the loop issue; it's an ugly hack and after immutable biovecs we're
> pretty close to a better solution and some major cleanups too.

All the consumers aren't limited to a block-based filesystem backing,
including loop.  So we need a file-ops based approach for in-kernel
dio/aio.  If you have a counter proposal please at least describe it.

