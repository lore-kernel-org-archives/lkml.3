Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753878AbaGHJul (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jul 2014 05:50:41 -0400
Received: from bombadil.infradead.org ([198.137.202.9]:44118 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753677AbaGHJuj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jul 2014 05:50:39 -0400
Date: Tue, 8 Jul 2014 02:50:38 -0700
From: Christoph Hellwig <hch@infradead.org>
To: Mikulas Patocka <mpatocka@redhat.com>
Cc: Jens Axboe <axboe@kernel.dk>, dm-devel@redhat.com,
        linux-kernel@vger.kernel.org
Subject: Re: [dm-devel] [PATCH] blk-lib: fix error reporting
Message-ID: <20140708095038.GA31180@infradead.org>
References: <alpine.LRH.2.02.1407031514320.3347@file01.intranet.prod.int.rdu2.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LRH.2.02.1407031514320.3347@file01.intranet.prod.int.rdu2.redhat.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> +	if (unlikely(err))
> +		ACCESS_ONCE(bb->error) = err;

I can't see a reason for the ACCESS_ONCE here.

Also the likely/unlikely annotations here smell like premature
optimization.

Otherwise looks good to me.

