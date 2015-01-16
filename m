Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753844AbbAPLoP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Jan 2015 06:44:15 -0500
Received: from bombadil.infradead.org ([198.137.202.9]:49797 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751421AbbAPLoO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Jan 2015 06:44:14 -0500
Date: Fri, 16 Jan 2015 03:44:13 -0800
From: Christoph Hellwig <hch@infradead.org>
To: Dongsu Park <dongsu.park@profitbricks.com>
Cc: linux-kernel@vger.kernel.org, Christoph Hellwig <hch@infradead.org>,
        Kent Overstreet <kmo@daterainc.com>, Jens Axboe <axboe@kernel.dk>
Subject: Re: [PATCH v2 4/7] block: refactor bio_get_user_pages() from
 __bio_map_user_iov()
Message-ID: <20150116114413.GB31449@infradead.org>
References: <cover.1421052656.git.dongsu.park@profitbricks.com>
 <63ea4e86f2a06cbe273692932bdf2499fef01644.1421052656.git.dongsu.park@profitbricks.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <63ea4e86f2a06cbe273692932bdf2499fef01644.1421052656.git.dongsu.park@profitbricks.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This switches to opencoding bio_add_pc_page, and thus losing the
max_hw_sectors check.  Additionally it exports a function that's
not used outside the file without a user showing up in the
series.

For now I'd suggest defeing this to the series that uses it, but
I suspect we can't really use common code between SG_IO and direct I/O
in the end due to the different nature of filesystem vs BLOCK_PC I/O.
