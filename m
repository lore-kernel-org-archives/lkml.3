Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756674AbaHVPDL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Aug 2014 11:03:11 -0400
Received: from bombadil.infradead.org ([198.137.202.9]:60540 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756290AbaHVPDJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Aug 2014 11:03:09 -0400
Date: Fri, 22 Aug 2014 08:03:07 -0700
From: Christoph Hellwig <hch@infradead.org>
To: David Vrabel <david.vrabel@citrix.com>
Cc: Arianna Avanzini <avanzini.arianna@gmail.com>, konrad.wilk@oracle.com,
        boris.ostrovsky@oracle.com, xen-devel@lists.xenproject.org,
        linux-kernel@vger.kernel.org, bob.liu@oracle.com,
        felipe.franciosi@citrix.com, axboe@fb.com
Subject: Re: [PATCH RFC 1/4] xen, blkfront: add support for the multi-queue
 block layer API
Message-ID: <20140822150307.GB29424@infradead.org>
References: <1408706404-6614-1-git-send-email-avanzini.arianna@gmail.com>
 <1408706404-6614-2-git-send-email-avanzini.arianna@gmail.com>
 <53F736BE.9010202@citrix.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <53F736BE.9010202@citrix.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 22, 2014 at 01:25:34PM +0100, David Vrabel wrote:
> > +	spin_lock_irq(&info->io_lock);
> 
> Is this lock necessary?  Does the block layer serialise calls to the
> queue_rq op?

Calls to ->queue_rq are not serialized by the block layer.

