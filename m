Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752439AbaFDWb4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jun 2014 18:31:56 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:56268 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751680AbaFDWby (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jun 2014 18:31:54 -0400
Date: Thu, 5 Jun 2014 00:31:52 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Tejun Heo <tj@kernel.org>
Cc: Paolo Valente <paolo.valente@unimore.it>, Jens Axboe <axboe@kernel.dk>,
        Li Zefan <lizefan@huawei.com>, Fabio Checconi <fchecconi@gmail.com>,
        Arianna Avanzini <avanzini.arianna@gmail.com>,
        linux-kernel@vger.kernel.org, containers@lists.linux-foundation.org,
        cgroups@vger.kernel.org
Subject: Re: [PATCH RFC - TAKE TWO - 00/12] New version of the BFQ I/O
 Scheduler
Message-ID: <20140604223152.GA7881@amd.pavel.ucw.cz>
References: <20140528221929.GG1419@htj.dyndns.org>
 <1401354343-5527-1-git-send-email-paolo.valente@unimore.it>
 <20140530160712.GG24871@htj.dyndns.org>
 <464F6CBE-A63E-46EF-A90D-BF8450430444@unimore.it>
 <20140530232804.GA5057@htj.dyndns.org>
 <20140602111432.GA3737@amd.pavel.ucw.cz>
 <20140602173332.GB8912@htj.dyndns.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140602173332.GB8912@htj.dyndns.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

On Mon 2014-06-02 13:33:32, Tejun Heo wrote:
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

Yes, that might happen. But it appears that conditions that would
make us stuck with CFQ&BFQ are the same conditions that would make us
stuck with CFQ alone.

And if BFQ is really better for interactivity under load, I'd really
really like option to use it, even if it leads to regression under
batch loads (or something else)... 

> overhead isn't the only factor here.  Providing two slightly different
> alternatives inevitably makes userland grow dependencies on subtleties
> of both and there's a lot less pressure to make judgement calls and

Dunno. It is just the scheduler. It makes stuff slower or faster, but
should not affect userland too badly.

									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
