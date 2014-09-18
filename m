Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932204AbaIRQ0o (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Sep 2014 12:26:44 -0400
Received: from verein.lst.de ([213.95.11.211]:42039 "EHLO newverein.lst.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756556AbaIRQ0m (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Sep 2014 12:26:42 -0400
Date: Thu, 18 Sep 2014 18:26:38 +0200
From: Christoph Hellwig <hch@lst.de>
To: Ming Lei <ming.lei@canonical.com>
Cc: Jens Axboe <axboe@kernel.dk>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Ming Lei <ming.lei@canoical.com>
Subject: Re: [PATCH 2/2] blk-mq: remove unnecessary blk_clear_rq_complete()
Message-ID: <20140918162638.GA3950@lst.de>
References: <1410947278-15733-1-git-send-email-ming.lei@canonical.com> <1410947278-15733-3-git-send-email-ming.lei@canonical.com> <20140917164850.GB18472@lst.de> <CACVXFVOsHO28yTQN8uPgOgtrTjrs52Le01wChxdYyjeBr0ZcOQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CACVXFVOsHO28yTQN8uPgOgtrTjrs52Le01wChxdYyjeBr0ZcOQ@mail.gmail.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 18, 2014 at 09:33:35AM +0800, Ming Lei wrote:
> > Why yo you think it's not nessecary?  The request is not in the drivers
> 
> The COMPLETED flag will be cleared in blk_mq_start_request(), so
> it needn't to be cleared here, and it is a bit early and might cause
> a tiny race window.
> 
> > hand at this point, so it should not be marked started.  Maybe I'm missing
> > something, but this sounds like it could very likely cause regressions.
> 
> The STARTED flag has been cleared in __blk_mq_requeue_request(),
> I mean the COMPLETED flag, consider the following situation:
> 
> - one req is queued to driver, and the req is completed from
> the device just before its timeout expired
> - the driver checks the result and finds it need to requeue for some reason
> - blk_mq_requeue_request() is called to requeue the req
> - COMPLETED is cleared before clearing STARTED because of
> writes reorder
> - timeout just comes between the two writes
> - then the request may be completed another time because of timeout

Ok, I guess you are right on this one.  Objection cleared.
