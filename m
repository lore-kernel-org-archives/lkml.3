Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752982AbaFDO6h (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jun 2014 10:58:37 -0400
Received: from mail-qa0-f47.google.com ([209.85.216.47]:35197 "EHLO
	mail-qa0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752008AbaFDO6d (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jun 2014 10:58:33 -0400
Date: Wed, 4 Jun 2014 10:58:29 -0400
From: Tejun Heo <tj@kernel.org>
To: Christoph Hellwig <hch@infradead.org>
Cc: Jens Axboe <axboe@kernel.dk>, Paolo Valente <paolo.valente@unimore.it>,
        Li Zefan <lizefan@huawei.com>, Fabio Checconi <fchecconi@gmail.com>,
        Arianna Avanzini <avanzini.arianna@gmail.com>,
        Paolo Valente <posta_paolo@yahoo.it>, linux-kernel@vger.kernel.org,
        containers@lists.linux-foundation.org, cgroups@vger.kernel.org
Subject: Re: [PATCH RFC - TAKE TWO - 00/12] New version of the BFQ I/O
 Scheduler
Message-ID: <20140604145829.GF5004@htj.dyndns.org>
References: <538C8A47.1050502@kernel.dk>
 <20140602172454.GA8912@htj.dyndns.org>
 <538CB515.3090700@kernel.dk>
 <20140602174250.GC8912@htj.dyndns.org>
 <538CB87C.7030600@kernel.dk>
 <20140602185138.GD8912@htj.dyndns.org>
 <20140602205713.GB8357@kernel.dk>
 <20140604143136.GA1920@infradead.org>
 <20140604145053.GE5004@htj.dyndns.org>
 <20140604145330.GA2955@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140604145330.GA2955@infradead.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 04, 2014 at 07:53:30AM -0700, Christoph Hellwig wrote:
> On Wed, Jun 04, 2014 at 10:50:53AM -0400, Tejun Heo wrote:
> > Hmmm... the biggest thing is ioscheds.  They heavily rely on being
> > strongly synchronized and are pretty important for rotating rusts.
> > Maybe they can be made to work with blk-mq by forcing single queue or
> > something but do we wnat that?
> 
> Jens is planning to add an (optional) I/O scheduler to blk-mq, and
> that is indeed required for proper disk support.  I don't think there
> even is a need to limit it to a single queue technically, although
> devices that support multiple queues are unlikely to need I/O
> scheduling.

I think what Jens is planning is something really minimal.  Things
like [cb]fq heavily depend on the old block infrastructure.  I don't
know.  Maybe they can be merged in time but I'm not quite sure we'd
have enough pressure to actually do that.  Host-granular switching
should be good enough, I guess.

Thanks.

-- 
tejun
