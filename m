Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754458Ab3JXJrO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Oct 2013 05:47:14 -0400
Received: from bombadil.infradead.org ([198.137.202.9]:51806 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754291Ab3JXJrN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Oct 2013 05:47:13 -0400
Date: Thu, 24 Oct 2013 02:47:13 -0700
From: Christoph Hellwig <hch@infradead.org>
To: Jens Axboe <axboe@kernel.dk>
Cc: linux-kernel@vger.kernel.org, hch@infradead.org,
        Al Viro <viro@zeniv.linux.org.uk>
Subject: Re: [PATCH 05/11] direct-io: only inc/dec inode->i_dio_count for
 file systems
Message-ID: <20131024094713.GA17840@infradead.org>
References: <1382606764-8309-1-git-send-email-axboe@kernel.dk>
 <1382606764-8309-6-git-send-email-axboe@kernel.dk>
 <20131024094600.GS14598@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131024094600.GS14598@kernel.dk>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 24, 2013 at 10:46:00AM +0100, Jens Axboe wrote:
> On Thu, Oct 24 2013, Jens Axboe wrote:
> > We don't need truncate protection for block devices, so add a flag
> > bypassing this cache line dirtying twice for every IO. This easily
> > contributes to 5-10% of the CPU time on high IOPS O_DIRECT testing.
> 
> There's a merge error in this patch, please find the correct one below.

Btw, I think this patch should not go in with this series but rather via
the VFS tree as it's not related to the blk-mq infrastructure at all.

