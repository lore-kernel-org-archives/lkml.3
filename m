Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754059AbaFBU5S (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jun 2014 16:57:18 -0400
Received: from mail-pa0-f48.google.com ([209.85.220.48]:63007 "EHLO
	mail-pa0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752794AbaFBU5R (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jun 2014 16:57:17 -0400
Date: Mon, 2 Jun 2014 14:57:30 -0600
From: Jens Axboe <axboe@kernel.dk>
To: Tejun Heo <tj@kernel.org>
Cc: Paolo Valente <paolo.valente@unimore.it>, Li Zefan <lizefan@huawei.com>,
        Fabio Checconi <fchecconi@gmail.com>,
        Arianna Avanzini <avanzini.arianna@gmail.com>,
        Paolo Valente <posta_paolo@yahoo.it>, linux-kernel@vger.kernel.org,
        containers@lists.linux-foundation.org, cgroups@vger.kernel.org
Subject: Re: [PATCH RFC - TAKE TWO - 00/12] New version of the BFQ I/O
 Scheduler
Message-ID: <20140602205713.GB8357@kernel.dk>
References: <1401354343-5527-1-git-send-email-paolo.valente@unimore.it>
 <20140530160712.GG24871@htj.dyndns.org>
 <538926F6.7080409@kernel.dk>
 <20140531051635.GA19925@mtj.dyndns.org>
 <538C8A47.1050502@kernel.dk>
 <20140602172454.GA8912@htj.dyndns.org>
 <538CB515.3090700@kernel.dk>
 <20140602174250.GC8912@htj.dyndns.org>
 <538CB87C.7030600@kernel.dk>
 <20140602185138.GD8912@htj.dyndns.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140602185138.GD8912@htj.dyndns.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 02 2014, Tejun Heo wrote:
> Hello,
> 
> On Mon, Jun 02, 2014 at 11:46:36AM -0600, Jens Axboe wrote:
> > But blk-mq will potentially drive anything, so it might not be out of
> > the question with a more expensive scheduling variant, if it makes any
> > sense to do of course. At least until there's no more rotating stuff out
> > there :-). But it's not a priority at all to me yet. As long as we have
> > coexisting IO paths, it'd be trivial to select the needed one based on
> > the device characteristics.
> 
> Hmmm... yeah, moving rotating devices over to blk-mq doesn't really
> seem beneficial to me.  I think there are fundamental behavioral
> differences for rotating rusts and newer solid state devices to share
> single code path for things like scheduling and selecting the
> appropriate path depending on the actual devices sounds like a much
> better plan even in the long term.

It's not so much about it being more beneficial to run in blk-mq, as it
is about not having two code paths. But yes, we're likely going to
maintain that code for a long time, so it's not going anywhere anytime
soon.

And for scsi-mq, it's already opt-in, though on a per-host basis. Doing
finer granularity than that is going to be difficult, unless we let
legacy-block and blk-mq share a tag map (though that would not be too
hard).

-- 
Jens Axboe

