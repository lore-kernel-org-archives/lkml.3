Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753958AbaGJNgZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jul 2014 09:36:25 -0400
Received: from kanga.kvack.org ([205.233.56.17]:52225 "EHLO kanga.kvack.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753406AbaGJNgK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jul 2014 09:36:10 -0400
Date: Thu, 10 Jul 2014 09:36:09 -0400
From: Benjamin LaHaise <bcrl@kvack.org>
To: Christoph Hellwig <hch@infradead.org>
Cc: "Elliott, Robert (Server Storage)" <Elliott@hp.com>,
        Jens Axboe <axboe@kernel.dk>,
        "dgilbert@interlog.com" <dgilbert@interlog.com>,
        James Bottomley <James.Bottomley@HansenPartnership.com>,
        Bart Van Assche <bvanassche@fusionio.com>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: scsi-mq V2
Message-ID: <20140710133609.GO12478@kvack.org>
References: <1403715121-1201-1-git-send-email-hch@lst.de> <20140708144829.GA5539@infradead.org> <53BD7041.5010300@interlog.com> <53BD9A24.7010203@kernel.dk> <94D0CD8314A33A4D9D801C0FE68B402958B9628B@G9W0745.americas.hpqcorp.net> <20140710062040.GB20146@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140710062040.GB20146@infradead.org>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 09, 2014 at 11:20:40PM -0700, Christoph Hellwig wrote:
> On Thu, Jul 10, 2014 at 12:53:36AM +0000, Elliott, Robert (Server Storage) wrote:
> > the problem still occurs - fio results in low or 0 IOPS, with perf top 
> > reporting unusual amounts of time spent in do_io_submit and io_submit.
> 
> The diff between the two version doesn't show too much other possible
> interesting commits, the most interesting being some minor block
> updates.
> 
> I guess we'll have to a manual bisect, I've pushed out a
> scsi-mq.3-bisect-1 branch that is rebased to just before the merge of
> the block tree, and a scsi-mq.3-bisect-2 branch that is just after
> the merge of the block tree to get started.

There is one possible concern that could be exacerbated by other changes in 
the system: if the application is running close to the bare minimum number 
of requests allocated in io_setup(), the per cpu reference counters will 
have a hard time batching things.  It might be worth testing with an 
increased number of requests being allocated if this is the case.

		-ben
-- 
"Thought is the essence of where you are now."
