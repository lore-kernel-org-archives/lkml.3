Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752598Ab3AaLv3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jan 2013 06:51:29 -0500
Received: from mail-ob0-f169.google.com ([209.85.214.169]:64527 "EHLO
	mail-ob0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751282Ab3AaLv2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jan 2013 06:51:28 -0500
MIME-Version: 1.0
In-Reply-To: <20130131092146.GB3361@kroah.com>
References: <20130130200648.GA13298@flint.arm.linux.org.uk>
	<20130130215211.GA28418@flint.arm.linux.org.uk>
	<CAKMK7uHEggaGfLTq4c3MfY7csQSFpb=kRwdbJUQMN9Cz9K=V4A@mail.gmail.com>
	<20130130221946.GA14801@flint.arm.linux.org.uk>
	<CA+55aFyRHK3dmwQf_mdfB18dmoaRZqBG9FvHRqTs7cqBjgUs+g@mail.gmail.com>
	<CAPM=9tz6YBh2o3T8Ogt4K=wxSrC3Jc4PCJMzfpbyY=B132fA5g@mail.gmail.com>
	<20130131001339.GC14801@flint.arm.linux.org.uk>
	<CA+55aFxfeXWAiXV18qGgOk9+2HHiD7LUuyk55brHFXd+_c6eZQ@mail.gmail.com>
	<20130131054002.GA3697@kroah.com>
	<CAKMK7uGUrvh2dXza_b288kVdztiLjSCNpH304oBQgg_ZonEnzw@mail.gmail.com>
	<20130131092146.GB3361@kroah.com>
Date: Thu, 31 Jan 2013 22:51:27 +1100
Message-ID: <CAPM=9tzZLPZ0EqEvEuZbimomSQv+xMnLpTq28z7=bKBF1w26TQ@mail.gmail.com>
Subject: Re: BUG: circular locking dependency detected
From: Dave Airlie <airlied@gmail.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Daniel Vetter <daniel.vetter@ffwll.ch>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Russell King <rmk@arm.linux.org.uk>,
        Andrew Morton <akpm@linux-foundation.org>,
        Florian Tobias Schandinat <FlorianSchandinat@gmx.de>,
        "linux-fbdev@vger.kernel.org" <linux-fbdev@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        dri-devel <dri-devel@lists.freedesktop.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 31, 2013 at 8:21 PM, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
> On Thu, Jan 31, 2013 at 09:21:16AM +0100, Daniel Vetter wrote:
>> On Thu, Jan 31, 2013 at 6:40 AM, Greg Kroah-Hartman
>> <gregkh@linuxfoundation.org> wrote:
>> > On Thu, Jan 31, 2013 at 11:26:53AM +1100, Linus Torvalds wrote:
>> >> On Thu, Jan 31, 2013 at 11:13 AM, Russell King <rmk@arm.linux.org.uk> wrote:
>> >> >
>> >> > Which may or may not be a good thing depending how you look at it; it
>> >> > means that once your kernel blanks, you get a lockdep dump.  At that
>> >> > point you lose lockdep checking for everything else because lockdep
>> >> > disables itself after the first dump.
>> >>
>> >> Fair enough, we may want to revert the lockdep checking for
>> >> console_lock, and make re-enabling it part of the patch-series that
>> >> fixes the locking.
>> >>
>> >> Daniel/Dave? Does that sound reasonable?
>>
>> Yeah, sounds good.
>>
>> > Reverting the patch is fine with me.  Just let me know so I can queue it
>> > up again for 3.9.
>>
>> Can you please also pick up the (currently) three locking fixups
>> around fbcon? Just so that we don't repeat the same fun where people
>> complain about lockdep splats, but the fixes are stuck somewhere. And
>> I guess Dave would be happy to not end up as fbcon maintainer ;-) He
>> has a git branch with them at
>> http://cgit.freedesktop.org/~airlied/linux/log/?h=fbcon-locking-fixes
>> though I have a small bikeshed on his last patch pending.
>
> Care to just send me the patches through email when you all get done
> bikesheding?  And for some reason I thought Andrew was going to handle
> these fbcon patches, but if not, I'll be glad to take them.

I'll ship them via my tree at this point I think, since I now need to
queue a revert of the revert on top.

I have a few vgacon/fbcon fixes that I need to go in this cycle.

Dave.
