Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754313AbaFCUlH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jun 2014 16:41:07 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:42774 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753781AbaFCUlF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jun 2014 16:41:05 -0400
Date: Tue, 3 Jun 2014 22:40:57 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Paolo Valente <paolo.valente@unimore.it>
Cc: Tejun Heo <tj@kernel.org>, Jens Axboe <axboe@kernel.dk>,
        Li Zefan <lizefan@huawei.com>, Fabio Checconi <fchecconi@gmail.com>,
        Arianna Avanzini <avanzini.arianna@gmail.com>,
        linux-kernel@vger.kernel.org, containers@lists.linux-foundation.org,
        cgroups@vger.kernel.org
Subject: Re: [PATCH RFC - TAKE TWO - 00/12] New version of the BFQ I/O
 Scheduler
Message-ID: <20140603204057.GA18900@amd.pavel.ucw.cz>
References: <20140528221929.GG1419@htj.dyndns.org>
 <1401354343-5527-1-git-send-email-paolo.valente@unimore.it>
 <20140530160712.GG24871@htj.dyndns.org>
 <464F6CBE-A63E-46EF-A90D-BF8450430444@unimore.it>
 <20140530232804.GA5057@htj.dyndns.org>
 <20140602111432.GA3737@amd.pavel.ucw.cz>
 <20140602130226.GA14654@amd.pavel.ucw.cz>
 <FCFE0106-A4DD-4DEF-AAAE-040F3823A447@unimore.it>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <FCFE0106-A4DD-4DEF-AAAE-040F3823A447@unimore.it>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> >>> Well, it's all about how to actually route the changes and in general
> >>> whenever avoidable we try to avoid whole-sale code replacement
> >>> especially when most of the structural code is similar like in this
> >>> case.  Gradually evolving cfq to bfq is likely to take more work but
> >>> I'm very positive that it'd definitely be a lot easier to merge the
> >>> changes that way and people involved, including the developers and
> >>> reviewers, would acquire a lot clearer picture of what's going on in
> >>> the process.  For example, AFAICS, most of the heuristics added by
> >> 
> >> Would it make sense to merge bfq first, _then_ turn cfq into bfq, then
> >> remove bfq?
> >> 
> >> That way
> >> 
> >> 1. Users like me would see improvements soon 
> >> 
> >> 2. BFQ would get more testing early. 
> > 
> > Like this: I applied patch over today's git... 
> > 
> > I only see last bits of panic...
> > 
> > Call trace:
> > __bfq_bfqq_expire
> > bfq_bfqq_expire
> > bfq_dispatch_requests
> > sci_request_fn
> > ...
> > EIP: T.1839+0x26
> > Kernel panic - not syncing: Fatal exception in interrupt
> > Shutting down cpus with NMI
> > 
> > ...
> > 
> > Will retry.
> > 
> > Any ideas?
> > 			

>  We have tried to think about ways to trigger this failure, but in
> vain. Unfortunately, so far no user has reported any failure with
> this last version of bfq either. Finally, we have gone through a new
> static analysis, but also in this case uselessly.

Ok, it is pretty much reproducible here: system just will not finish
booting.

> So, if you are willing to retry, we have put online a version of the code filled with many BUG_ONs. I hope they can make it easier to track down the bug. The archive is here:
> http://algogroup.unimore.it/people/paolo/disk_sched/debugging-patches/3.15.0-rc8-v7rc5.tgz
> 

Ok, let me try.

> Should this attempt be useless as well, I will, if you do not mind, try by asking you more details about your system and reproducing your configuration as much as I can.
> 

It is thinkpad x60 notebook, x86-32 machine with 2GB ram.

But I think it died on my x86-32 core duo desktop, too. 

Best regards,
									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
