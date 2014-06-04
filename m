Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752150AbaFDOu7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jun 2014 10:50:59 -0400
Received: from mail-qg0-f51.google.com ([209.85.192.51]:37998 "EHLO
	mail-qg0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750933AbaFDOu5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jun 2014 10:50:57 -0400
Date: Wed, 4 Jun 2014 10:50:53 -0400
From: Tejun Heo <tj@kernel.org>
To: Christoph Hellwig <hch@infradead.org>
Cc: Jens Axboe <axboe@kernel.dk>, Paolo Valente <paolo.valente@unimore.it>,
        Li Zefan <lizefan@huawei.com>, Fabio Checconi <fchecconi@gmail.com>,
        Arianna Avanzini <avanzini.arianna@gmail.com>,
        Paolo Valente <posta_paolo@yahoo.it>, linux-kernel@vger.kernel.org,
        containers@lists.linux-foundation.org, cgroups@vger.kernel.org
Subject: Re: [PATCH RFC - TAKE TWO - 00/12] New version of the BFQ I/O
 Scheduler
Message-ID: <20140604145053.GE5004@htj.dyndns.org>
References: <538926F6.7080409@kernel.dk>
 <20140531051635.GA19925@mtj.dyndns.org>
 <538C8A47.1050502@kernel.dk>
 <20140602172454.GA8912@htj.dyndns.org>
 <538CB515.3090700@kernel.dk>
 <20140602174250.GC8912@htj.dyndns.org>
 <538CB87C.7030600@kernel.dk>
 <20140602185138.GD8912@htj.dyndns.org>
 <20140602205713.GB8357@kernel.dk>
 <20140604143136.GA1920@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140604143136.GA1920@infradead.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hey, Christoph.

On Wed, Jun 04, 2014 at 07:31:36AM -0700, Christoph Hellwig wrote:
> I don't really think there's anything inherently counter productive
> to spinning rust (at least for somewhat modern spinning rust and
> infrastructure) in blk-mq.  I'd really like to get rid of the old
> request layer in a reasonable amount of time, and for SCSI I'm very
> reluctant to add more integration between the old and new code.  I'd
> really planning on not maintaining the old request based SCSI code
> for a long time once we get positive reports in from users of various
> kinds of older hardware.

Hmmm... the biggest thing is ioscheds.  They heavily rely on being
strongly synchronized and are pretty important for rotating rusts.
Maybe they can be made to work with blk-mq by forcing single queue or
something but do we wnat that?

Thanks.

-- 
tejun
