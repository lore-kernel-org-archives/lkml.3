Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753531AbaFDObr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jun 2014 10:31:47 -0400
Received: from bombadil.infradead.org ([198.137.202.9]:47187 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751782AbaFDObp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jun 2014 10:31:45 -0400
Date: Wed, 4 Jun 2014 07:31:36 -0700
From: Christoph Hellwig <hch@infradead.org>
To: Jens Axboe <axboe@kernel.dk>
Cc: Tejun Heo <tj@kernel.org>, Paolo Valente <paolo.valente@unimore.it>,
        Li Zefan <lizefan@huawei.com>, Fabio Checconi <fchecconi@gmail.com>,
        Arianna Avanzini <avanzini.arianna@gmail.com>,
        Paolo Valente <posta_paolo@yahoo.it>, linux-kernel@vger.kernel.org,
        containers@lists.linux-foundation.org, cgroups@vger.kernel.org
Subject: Re: [PATCH RFC - TAKE TWO - 00/12] New version of the BFQ I/O
 Scheduler
Message-ID: <20140604143136.GA1920@infradead.org>
References: <20140530160712.GG24871@htj.dyndns.org>
 <538926F6.7080409@kernel.dk>
 <20140531051635.GA19925@mtj.dyndns.org>
 <538C8A47.1050502@kernel.dk>
 <20140602172454.GA8912@htj.dyndns.org>
 <538CB515.3090700@kernel.dk>
 <20140602174250.GC8912@htj.dyndns.org>
 <538CB87C.7030600@kernel.dk>
 <20140602185138.GD8912@htj.dyndns.org>
 <20140602205713.GB8357@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140602205713.GB8357@kernel.dk>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 02, 2014 at 02:57:30PM -0600, Jens Axboe wrote:
> It's not so much about it being more beneficial to run in blk-mq, as it
> is about not having two code paths. But yes, we're likely going to
> maintain that code for a long time, so it's not going anywhere anytime
> soon.
> 
> And for scsi-mq, it's already opt-in, though on a per-host basis. Doing
> finer granularity than that is going to be difficult, unless we let
> legacy-block and blk-mq share a tag map (though that would not be too
> hard).

I don't really think there's anything inherently counter productive
to spinning rust (at least for somewhat modern spinning rust and
infrastructure) in blk-mq.  I'd really like to get rid of the old
request layer in a reasonable amount of time, and for SCSI I'm very
reluctant to add more integration between the old and new code.  I'd
really planning on not maintaining the old request based SCSI code
for a long time once we get positive reports in from users of various
kinds of older hardware.

