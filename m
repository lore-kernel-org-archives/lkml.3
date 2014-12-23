Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755849AbaLWKXr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Dec 2014 05:23:47 -0500
Received: from bombadil.infradead.org ([198.137.202.9]:59408 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750798AbaLWKXp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Dec 2014 05:23:45 -0500
Date: Tue, 23 Dec 2014 02:23:45 -0800
From: Christoph Hellwig <hch@infradead.org>
To: Dongsu Park <dongsu.park@profitbricks.com>
Cc: linux-kernel@vger.kernel.org, Jens Axboe <axboe@kernel.dk>,
        Kent Overstreet <kmo@daterainc.com>, Ming Lin <mlin@minggr.net>
Subject: Re: [RFC PATCH 03/17] block: simplify issueing discard, write_same,
 zeroout
Message-ID: <20141223102345.GC13138@infradead.org>
References: <cover.1419241597.git.dongsu.park@profitbricks.com>
 <fe96db02d805ca6191dd605d03dac0d04c926fc1.1419241597.git.dongsu.park@profitbricks.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <fe96db02d805ca6191dd605d03dac0d04c926fc1.1419241597.git.dongsu.park@profitbricks.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 22, 2014 at 12:48:30PM +0100, Dongsu Park wrote:
> From: Kent Overstreet <kmo@daterainc.com>
> 
> Simplify special cases for issueing discard, write_same, and zeroout,
> replacing bio_batch completions with submit_bio_wait(). This conversion
> is possible because generic_make_request() will now do for us what the
> code in blk-lib.c was doing manually, with the bio_batch stuff. So we
> still need some looping in case we're trying to discard/zeroout more
> than around a gigabyte, but when we can submit that much at a time
> doing the submissions in parallel really shouldn't matter.

Unless there this makes later patches simpler I don't see a good reason
to remove this parallel submission for the gain of only about 100 less
lines of code.
