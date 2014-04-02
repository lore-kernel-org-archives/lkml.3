Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932659AbaDBRBT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Apr 2014 13:01:19 -0400
Received: from mail-we0-f175.google.com ([74.125.82.175]:51175 "EHLO
	mail-we0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932413AbaDBRBP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Apr 2014 13:01:15 -0400
Date: Wed, 2 Apr 2014 19:01:11 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Jens Axboe <axboe@fb.com>, Jan Kara <jack@suse.cz>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linuxpatches@star.c10r.facebook.com
Subject: Re: [GIT PULL] Core block IO bits for 3.15-rc
Message-ID: <20140402170108.GD16397@localhost.localdomain>
References: <20140401190502.GA30970@kernel.dk>
 <CA+55aFzq+mAkUQQkVGe8U8Rd13_Cr1GTcTZfCadjKpF23_OGmA@mail.gmail.com>
 <20140402135959.GA16397@localhost.localdomain>
 <CA+55aFxcy=TDWucdnjHPPp=Dh-boA0uPLkKQP3oCGaKMDg-h_A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+55aFxcy=TDWucdnjHPPp=Dh-boA0uPLkKQP3oCGaKMDg-h_A@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 02, 2014 at 08:02:13AM -0700, Linus Torvalds wrote:
> On Wed, Apr 2, 2014 at 7:00 AM, Frederic Weisbecker <fweisbec@gmail.com> wrote:
> >
> > So yeah that's because I was worried about strong conflicts. What kind of approach
> > do you prefer then to solve that kind of issue? Do you prefer that we create a seperate
> > branch and deal with non trivial nor small conflicts on merge window time?
> 
> I'd indeed rather see a separate branch, and deal with the conflicts.
> 
> And in fact I think you over-estimate the conflicts. The smp function
> naming changes were trivial as far as outside users were concerned,
> and while the "stop abusing fileds in csd" might have clashed more
> with the rest of the block changes (because they were actually to the
> block functions), I doubt it would have been painful. In fact, looking
> at "fifo_time" there should be no conflicts at all, and the queuelist
> changes look like they would have had a *trivial* conflict with
> "blk-mq: merge blk_mq_insert_request and blk_mq_run_request" just
> because there were changes nearby. Even that is debatable - it's
> possible git would just have resolved that one automatically too.
> 
> So I think that the patches from you and Honza could easily have been
> in another branch, and had trivial or no conflicts with the other
> block changes.
> 
>                 Linus

Yeah indeed. I think maybe I started to work on top of a stale tree and got
confused with conflicts against pre v3.13 commits that were actually merged
upstream for a while already.

But you're right, looking at it closer, the real conflicts against pending -block
patches weren't that bad actually

Anyway, thanks for pulling it in the end, I'll be more careful!
