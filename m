Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932130AbaDBOAL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Apr 2014 10:00:11 -0400
Received: from mail-wg0-f51.google.com ([74.125.82.51]:51424 "EHLO
	mail-wg0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758600AbaDBOAK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Apr 2014 10:00:10 -0400
Date: Wed, 2 Apr 2014 16:00:05 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Jens Axboe <axboe@fb.com>, Jan Kara <jack@suse.cz>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linuxpatches@star.c10r.facebook.com
Subject: Re: [GIT PULL] Core block IO bits for 3.15-rc
Message-ID: <20140402135959.GA16397@localhost.localdomain>
References: <20140401190502.GA30970@kernel.dk>
 <CA+55aFzq+mAkUQQkVGe8U8Rd13_Cr1GTcTZfCadjKpF23_OGmA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+55aFzq+mAkUQQkVGe8U8Rd13_Cr1GTcTZfCadjKpF23_OGmA@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 01, 2014 at 07:43:08PM -0700, Linus Torvalds wrote:
> On Tue, Apr 1, 2014 at 12:05 PM, Jens Axboe <axboe@fb.com> wrote:
> >
> > - Cleanup of the IPI usage from the block layer, and associated helper
> >   code. From Frederic Weisbecker and Jan Kara.
> 
> So I absolutely *hate* how this was done.
> 
> Why the hell was it mixed in with the block layer code? It's not even
> in some clean separate branch, it's just randomly in the middle of the
> block code, for no obvious reason.
> 
> I'm pulling it this time, but quite frankly, next time I see this kind
> of ugly AND TOTALLY POINTLESS layering violation, I will just drop the
> stupid pull request.
> 
> If you want to push me cleanups that are to generic code and are in no
> way specific to the block layer, fine. But I want a separate pull
> request that is not in any way mixed up with block code.
> 
> In other words, this was NOT OK. This was stupid and wrong, and
> violated all sanity. I can see absolutely no reason why that
> smp_call_function_single_async() renaming and the other cleanups are
> in the block branch. They are totally separate in every single way.
> 
> What the hell was going on here?

I think it's because we were worried that these smp cleanups had strong
conflicts against block changes.

Changes on core SMP APIs resulted in changes on these APIs users (ie: block
for the most part here). But then these changes in API users had to face
quite some conflicting changes in the block code.

So the mistake started with me: I did a branch with the smp changes on top of the
block core in order to resolve the conflict early.

Then Jens pulled it in the block tree. Then again it looked right to me as further
block changes would then have no risk of conflict, and Jens is the maintainer of
both parts.

So yeah that's because I was worried about strong conflicts. What kind of approach
do you prefer then to solve that kind of issue? Do you prefer that we create a seperate
branch and deal with non trivial nor small conflicts on merge window time?

Yeah now that I think about it, maybe when the conflicts are significant we should
have a seperate SMP branch which has the conflicts resolved once the block bits are pulled in.
