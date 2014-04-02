Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932273AbaDBPCP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Apr 2014 11:02:15 -0400
Received: from mail-vc0-f180.google.com ([209.85.220.180]:59818 "EHLO
	mail-vc0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932180AbaDBPCO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Apr 2014 11:02:14 -0400
MIME-Version: 1.0
In-Reply-To: <20140402135959.GA16397@localhost.localdomain>
References: <20140401190502.GA30970@kernel.dk>
	<CA+55aFzq+mAkUQQkVGe8U8Rd13_Cr1GTcTZfCadjKpF23_OGmA@mail.gmail.com>
	<20140402135959.GA16397@localhost.localdomain>
Date: Wed, 2 Apr 2014 08:02:13 -0700
X-Google-Sender-Auth: INl-auNSPxZgf0823VfGoMDAcUE
Message-ID: <CA+55aFxcy=TDWucdnjHPPp=Dh-boA0uPLkKQP3oCGaKMDg-h_A@mail.gmail.com>
Subject: Re: [GIT PULL] Core block IO bits for 3.15-rc
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Jens Axboe <axboe@fb.com>, Jan Kara <jack@suse.cz>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linuxpatches@star.c10r.facebook.com
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 2, 2014 at 7:00 AM, Frederic Weisbecker <fweisbec@gmail.com> wrote:
>
> So yeah that's because I was worried about strong conflicts. What kind of approach
> do you prefer then to solve that kind of issue? Do you prefer that we create a seperate
> branch and deal with non trivial nor small conflicts on merge window time?

I'd indeed rather see a separate branch, and deal with the conflicts.

And in fact I think you over-estimate the conflicts. The smp function
naming changes were trivial as far as outside users were concerned,
and while the "stop abusing fileds in csd" might have clashed more
with the rest of the block changes (because they were actually to the
block functions), I doubt it would have been painful. In fact, looking
at "fifo_time" there should be no conflicts at all, and the queuelist
changes look like they would have had a *trivial* conflict with
"blk-mq: merge blk_mq_insert_request and blk_mq_run_request" just
because there were changes nearby. Even that is debatable - it's
possible git would just have resolved that one automatically too.

So I think that the patches from you and Honza could easily have been
in another branch, and had trivial or no conflicts with the other
block changes.

                Linus
