Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932218AbaDBOJn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Apr 2014 10:09:43 -0400
Received: from mail-wi0-f174.google.com ([209.85.212.174]:63822 "EHLO
	mail-wi0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932178AbaDBOJm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Apr 2014 10:09:42 -0400
Date: Wed, 2 Apr 2014 16:09:39 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Jens Axboe <axboe@fb.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, Jan Kara <jack@suse.cz>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [GIT PULL] Core block IO bits for 3.15-rc
Message-ID: <20140402140936.GB16397@localhost.localdomain>
References: <20140401190502.GA30970@kernel.dk>
 <CA+55aFzq+mAkUQQkVGe8U8Rd13_Cr1GTcTZfCadjKpF23_OGmA@mail.gmail.com>
 <533B7A90.6060504@fb.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <533B7A90.6060504@fb.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 01, 2014 at 08:48:48PM -0600, Jens Axboe wrote:
> On 2014-04-01 20:43, Linus Torvalds wrote:
> >On Tue, Apr 1, 2014 at 12:05 PM, Jens Axboe <axboe@fb.com> wrote:
> >>
> >>- Cleanup of the IPI usage from the block layer, and associated helper
> >>   code. From Frederic Weisbecker and Jan Kara.
> >
> >So I absolutely *hate* how this was done.
> >
> >Why the hell was it mixed in with the block layer code? It's not even
> >in some clean separate branch, it's just randomly in the middle of the
> >block code, for no obvious reason.
> >
> >I'm pulling it this time, but quite frankly, next time I see this kind
> >of ugly AND TOTALLY POINTLESS layering violation, I will just drop the
> >stupid pull request.
> >
> >If you want to push me cleanups that are to generic code and are in no
> >way specific to the block layer, fine. But I want a separate pull
> >request that is not in any way mixed up with block code.
> >
> >In other words, this was NOT OK. This was stupid and wrong, and
> >violated all sanity. I can see absolutely no reason why that
> >smp_call_function_single_async() renaming and the other cleanups are
> >in the block branch. They are totally separate in every single way.
> >
> >What the hell was going on here?
> 
> I agree, it should have been in its own topic branch. No real
> arguments there. And probably should have been split further, so
> only the block required parts ended up in there, and not eg the
> watchdog parts.

I think that having block and watchdog changes, among many other non-core SMP
changes, in the SMP branch is still unavoidable. If we change a core API,
we must convert the users all along. Of course such peripheral changes should
be strictly limited to these API conversion.

But then the right approach would have been to keep this branch standalone and
deal with conflictings changes like block bits once they are pulled in Linus tree.

Anyway sorry again, I initiated the mistake by making these smp changes on top
of the block bits.
