Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756883AbaAISfP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Jan 2014 13:35:15 -0500
Received: from bombadil.infradead.org ([198.137.202.9]:37138 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754539AbaAISfI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Jan 2014 13:35:08 -0500
Date: Thu, 9 Jan 2014 10:35:07 -0800
From: Christoph Hellwig <hch@infradead.org>
To: Jens Axboe <axboe@kernel.dk>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] blk-mq: use __smp_call_function_single directly
Message-ID: <20140109183507.GA23826@infradead.org>
References: <20140108173337.GA29514@infradead.org>
 <52CDC3A3.5050203@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <52CDC3A3.5050203@kernel.dk>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 08, 2014 at 02:31:15PM -0700, Jens Axboe wrote:
> On 01/08/2014 10:33 AM, Christoph Hellwig wrote:
> > __smp_call_function_single already avoids multiple IPIs by internally
> > queing up the items, and now also is available for non-SMP builds as
> > a trivially correct stub, so there is no need to wrap it.  If the
> > additional lock roundtrip cause problems my patch to convert the
> > generic IPI code to llists is waiting to get merged will fix it.
> 
> Thanks Christoph, applied it.

Btw, the same should be done to the null_blk ipi completion
path in theory.  But given that it always tries to IPI the local
CPU __smp_call_function_single turns into a simple indirect function
call, so I don't really understand the point of that code path at all.
