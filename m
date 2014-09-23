Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753183AbaIWGDv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Sep 2014 02:03:51 -0400
Received: from mail-qg0-f41.google.com ([209.85.192.41]:51174 "EHLO
	mail-qg0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750712AbaIWGDu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Sep 2014 02:03:50 -0400
Date: Tue, 23 Sep 2014 02:03:46 -0400
From: Tejun Heo <tj@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: Jens Axboe <axboe@kernel.dk>, linux-kernel@vger.kernel.org,
        linux-scsi@vger.kernel.org
Subject: Re: boot stall regression due to blk-mq: use percpu_ref for mq usage
 count
Message-ID: <20140923060346.GG11740@mtj.dyndns.org>
References: <20140919113815.GA10791@lst.de>
 <541C8047.80705@kernel.dk>
 <20140923055554.GA10189@lst.de>
 <20140923055648.GD11740@mtj.dyndns.org>
 <20140923055924.GA10295@lst.de>
 <20140923060141.GF11740@mtj.dyndns.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140923060141.GF11740@mtj.dyndns.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 23, 2014 at 02:01:41AM -0400, Tejun Heo wrote:
> On Tue, Sep 23, 2014 at 07:59:24AM +0200, Christoph Hellwig wrote:
> > "[PATCHSET percpu/for-3.18] percpu_ref: implement switch_to_atomic/percpu()"
> > 
> > looks way to big for 3.17, and the regression was introduced in the 3.17
> > merge window.  I'm not sure what was broken before, but it defintively
> > survived a lot of testing.
> 
> Do we even care about fixing it for 3.17?  scsi-mq isn't enabled by
> default even for 3.18.  The open-coded percpu ref thing was subtly
> broken there.  It'd be difficult to trigger but I'm fairly sure it'd
> crap out in the wild once in a blue moon.

Hmmm... also, this is actually an issue with scsi that block layer is
working around.  For other drivers (virtio), the latency during
shutdown should be completely fine.

-- 
tejun
