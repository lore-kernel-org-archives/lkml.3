Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752424AbaFDOxn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jun 2014 10:53:43 -0400
Received: from bombadil.infradead.org ([198.137.202.9]:55099 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752310AbaFDOxl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jun 2014 10:53:41 -0400
Date: Wed, 4 Jun 2014 07:53:30 -0700
From: Christoph Hellwig <hch@infradead.org>
To: Tejun Heo <tj@kernel.org>
Cc: Christoph Hellwig <hch@infradead.org>, Jens Axboe <axboe@kernel.dk>,
        Paolo Valente <paolo.valente@unimore.it>,
        Li Zefan <lizefan@huawei.com>, Fabio Checconi <fchecconi@gmail.com>,
        Arianna Avanzini <avanzini.arianna@gmail.com>,
        Paolo Valente <posta_paolo@yahoo.it>, linux-kernel@vger.kernel.org,
        containers@lists.linux-foundation.org, cgroups@vger.kernel.org
Subject: Re: [PATCH RFC - TAKE TWO - 00/12] New version of the BFQ I/O
 Scheduler
Message-ID: <20140604145330.GA2955@infradead.org>
References: <20140531051635.GA19925@mtj.dyndns.org>
 <538C8A47.1050502@kernel.dk>
 <20140602172454.GA8912@htj.dyndns.org>
 <538CB515.3090700@kernel.dk>
 <20140602174250.GC8912@htj.dyndns.org>
 <538CB87C.7030600@kernel.dk>
 <20140602185138.GD8912@htj.dyndns.org>
 <20140602205713.GB8357@kernel.dk>
 <20140604143136.GA1920@infradead.org>
 <20140604145053.GE5004@htj.dyndns.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140604145053.GE5004@htj.dyndns.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 04, 2014 at 10:50:53AM -0400, Tejun Heo wrote:
> Hmmm... the biggest thing is ioscheds.  They heavily rely on being
> strongly synchronized and are pretty important for rotating rusts.
> Maybe they can be made to work with blk-mq by forcing single queue or
> something but do we wnat that?

Jens is planning to add an (optional) I/O scheduler to blk-mq, and
that is indeed required for proper disk support.  I don't think there
even is a need to limit it to a single queue technically, although
devices that support multiple queues are unlikely to need I/O
scheduling.

