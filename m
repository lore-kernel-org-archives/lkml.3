Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752143AbaFCEMu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jun 2014 00:12:50 -0400
Received: from mail-wi0-f175.google.com ([209.85.212.175]:48972 "EHLO
	mail-wi0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751194AbaFCEMt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jun 2014 00:12:49 -0400
Message-ID: <1401768765.6214.39.camel@marge.simpson.net>
Subject: Re: [PATCH RFC - TAKE TWO - 00/12] New version of the BFQ I/O
 Scheduler
From: Mike Galbraith <umgwanakikbuti@gmail.com>
To: Tejun Heo <tj@kernel.org>
Cc: Pavel Machek <pavel@ucw.cz>, Paolo Valente <paolo.valente@unimore.it>,
        Jens Axboe <axboe@kernel.dk>, Li Zefan <lizefan@huawei.com>,
        Fabio Checconi <fchecconi@gmail.com>,
        Arianna Avanzini <avanzini.arianna@gmail.com>,
        linux-kernel@vger.kernel.org, containers@lists.linux-foundation.org,
        cgroups@vger.kernel.org
Date: Tue, 03 Jun 2014 06:12:45 +0200
In-Reply-To: <20140602173332.GB8912@htj.dyndns.org>
References: <20140528221929.GG1419@htj.dyndns.org>
	 <1401354343-5527-1-git-send-email-paolo.valente@unimore.it>
	 <20140530160712.GG24871@htj.dyndns.org>
	 <464F6CBE-A63E-46EF-A90D-BF8450430444@unimore.it>
	 <20140530232804.GA5057@htj.dyndns.org>
	 <20140602111432.GA3737@amd.pavel.ucw.cz>
	 <20140602173332.GB8912@htj.dyndns.org>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2014-06-02 at 13:33 -0400, Tejun Heo wrote: 
> Hello, Pavel.
> 
> On Mon, Jun 02, 2014 at 01:14:33PM +0200, Pavel Machek wrote:
> > Now.. I see it is more work for storage maintainers, because there'll
> > be more code to maintain in the interim. But perhaps user advantages
> > are worth it?
> 
> I'm quite skeptical about going that route.  Not necessarily because
> of the extra amount of work but more the higher probability of getting
> into situation where we can neither push forward or back out.  It's
> difficult to define clear deadline and there will likely be unforeseen
> challenges in the planned convergence of the two schedulers,
> eventually, it isn't too unlikely to be in a situation where we have
> to admit defeat and just keep both schedulers.  Note that developer
> overhead isn't the only factor here.  Providing two slightly different
> alternatives inevitably makes userland grow dependencies on subtleties
> of both and there's a lot less pressure to make judgement calls and
> take appropriate trade-offs, which have fairly high chance of
> deadlocking progress towards any direction.

But OTOH..

This thing (allegedly) fixes issues that have existed for ages, issues
which have (also allegedly) not been fixed in all that time despite a
number of people having done a lot of this and that over the years.  If
the claims are true, seems to me that would make BFQ a bit special, and
perhaps worth some extra leeway and effort to ensure that what we are
being offered on a silver plate doesn't molder away out of tree forever.

If it were say put in staging, and it were stated right up front that it
isn't ever going to go further (Jens already said that more or less),
and _will_ drop dead if it stagnates, that would surely increase the
test base to shake out problem spots (surely it has some), and allow
users who meet an issue in either IO scheduler to verify it with the
flick of a switch every step of the way to whichever ending, and maybe
even motivate other IO people to help with the merge and/or to compare
their changes at the flick of that same switch.

-Mike

