Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754429Ab3AaAEI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jan 2013 19:04:08 -0500
Received: from mail-ob0-f172.google.com ([209.85.214.172]:52611 "EHLO
	mail-ob0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750908Ab3AaAEG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jan 2013 19:04:06 -0500
MIME-Version: 1.0
In-Reply-To: <CA+55aFyRHK3dmwQf_mdfB18dmoaRZqBG9FvHRqTs7cqBjgUs+g@mail.gmail.com>
References: <20130130200648.GA13298@flint.arm.linux.org.uk>
	<20130130215211.GA28418@flint.arm.linux.org.uk>
	<CAKMK7uHEggaGfLTq4c3MfY7csQSFpb=kRwdbJUQMN9Cz9K=V4A@mail.gmail.com>
	<20130130221946.GA14801@flint.arm.linux.org.uk>
	<CA+55aFyRHK3dmwQf_mdfB18dmoaRZqBG9FvHRqTs7cqBjgUs+g@mail.gmail.com>
Date: Thu, 31 Jan 2013 10:04:05 +1000
Message-ID: <CAPM=9tz6YBh2o3T8Ogt4K=wxSrC3Jc4PCJMzfpbyY=B132fA5g@mail.gmail.com>
Subject: Re: BUG: circular locking dependency detected
From: Dave Airlie <airlied@gmail.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Russell King <rmk@arm.linux.org.uk>,
        Daniel Vetter <daniel.vetter@ffwll.ch>,
        Andrew Morton <akpm@linux-foundation.org>,
        Florian Tobias Schandinat <FlorianSchandinat@gmx.de>,
        "linux-fbdev@vger.kernel.org" <linux-fbdev@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        dri-devel <dri-devel@lists.freedesktop.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 31, 2013 at 9:52 AM, Linus Torvalds
<torvalds@linux-foundation.org> wrote:
> On Thu, Jan 31, 2013 at 9:19 AM, Russell King <rmk@arm.linux.org.uk> wrote:
>>
>> So... what you seem to be telling me is that 3.9 is going to be a
>> release which issues lockdep complaints when the console blanks, and
>> you think that's acceptable?
>>
>> Adding Linus and Andrew so they're aware of this issue...
>
> Oh, we're extremely aware of it. And it's not a new issue, the locking
> problem have apparently been around forever, although I'm not sure why
> the lockdep splat itself started happening only recently.
>
> They'll make it into 3.9, it's 3.8 that won't have them. The patches
> initially caused way *worse* behavior than just a lockdep splat - they
> caused actual hard lockups (and that was *after* the initial series of
> fixes). That got fixed (hopefully for the last case!) fairly recently,
> and I'm not willing to take the scary patch-series that has had
> several problem cases.

Well we didn't have any lock validation support before Daniel added it
a couple of kernels back,
so instead of hidden locking problems we've had from time began, we now have
lockdep detectable locking problems.

Dave.
