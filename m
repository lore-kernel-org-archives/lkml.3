Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753884Ab3KZHcO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Nov 2013 02:32:14 -0500
Received: from mail-pb0-f52.google.com ([209.85.160.52]:60035 "EHLO
	mail-pb0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751648Ab3KZHcL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Nov 2013 02:32:11 -0500
Date: Mon, 25 Nov 2013 23:32:41 -0800
From: Kent Overstreet <kmo@daterainc.com>
To: Christoph Hellwig <hch@infradead.org>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        axboe@kernel.dk, Asai Thambi S P <asamymuthupa@micron.com>,
        Sam Bradshaw <sbradshaw@micron.com>
Subject: Re: [PATCH 2/5] mtip32xx: handle arbitrary size bios
Message-ID: <20131126073240.GG9244@kmo-pixel>
References: <1385418633-9753-1-git-send-email-kmo@daterainc.com>
 <1385418633-9753-3-git-send-email-kmo@daterainc.com>
 <20131126061018.GC6434@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131126061018.GC6434@infradead.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 25, 2013 at 10:10:18PM -0800, Christoph Hellwig wrote:
> On Mon, Nov 25, 2013 at 02:30:30PM -0800, Kent Overstreet wrote:
> > We get a measurable performance increase by handling this in the driver when
> > we're already looping over the biovec, instead of handling it separately in
> > generic_make_request() (or bio_add_page() originally)
> 
> Given that Jens has a patch queue up to convert the driver to blk-mq
> adjusting the blk-mq infrastructure to handle this might be a better
> plan forward..

I mostly wanted the patch in the series as an example conversion -
converting blk-mq is going to take some thought and time to familiarize
myself with the code.
