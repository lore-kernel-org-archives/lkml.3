Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751928AbbAPLls (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Jan 2015 06:41:48 -0500
Received: from bombadil.infradead.org ([198.137.202.9]:48681 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751295AbbAPLlr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Jan 2015 06:41:47 -0500
Date: Fri, 16 Jan 2015 03:41:46 -0800
From: Christoph Hellwig <hch@infradead.org>
To: Dongsu Park <dongsu.park@profitbricks.com>
Cc: linux-kernel@vger.kernel.org, Christoph Hellwig <hch@infradead.org>,
        Kent Overstreet <kmo@daterainc.com>, Jens Axboe <axboe@kernel.dk>,
        "Hans J. Koch" <hjk@hansjkoch.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Al Viro <viro@zeniv.linux.org.uk>
Subject: Re: [PATCH v2 3/7] block: refactor iov_count_pages() from
 bio_{copy,map}_user_iov()
Message-ID: <20150116114146.GA31449@infradead.org>
References: <cover.1421052656.git.dongsu.park@profitbricks.com>
 <0117035a25929ae97e2039edc895f582d53cf217.1421052656.git.dongsu.park@profitbricks.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <0117035a25929ae97e2039edc895f582d53cf217.1421052656.git.dongsu.park@profitbricks.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

mm/iov_iter.c already has a iov_iter_npages, although that
one doesn't do an alignment check yet.  But it might be worth
to just the iov_iter_alignment similar to how iov_iter_alignment
does it instead of this new function.
