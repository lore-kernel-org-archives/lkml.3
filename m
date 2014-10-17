Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753449AbaJQICL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Oct 2014 04:02:11 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:52966 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751037AbaJQICI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Oct 2014 04:02:08 -0400
Date: Fri, 17 Oct 2014 10:01:01 +0200
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: John Stultz <john.stultz@linaro.org>
Cc: lkml <linux-kernel@vger.kernel.org>, devel@driverdev.osuosl.org,
        Linux API <linux-api@vger.kernel.org>,
        Santosh Shilimkar <santosh.shilimkar@ti.com>,
        Arve =?iso-8859-1?B?SGr4bm5lduVn?= <arve@android.com>,
        Sumit Semwal <sumit.semwal@linaro.org>,
        Rebecca Schultz Zavin <rebecca@android.com>,
        Christoffer Dall <christoffer.dall@linaro.org>,
        Anup Patel <anup.patel@linaro.org>
Subject: Re: [PATCH] staging: android: binder: move to the "real" part of the
 kernel
Message-ID: <20141017080101.GA20268@kroah.com>
References: <20141016124741.GA3832@kroah.com>
 <CALAqxLU05D8qQA47E77PiuuN7eVt66WEq1qn+PqdE-tpEUzFpw@mail.gmail.com>
 <20141016231221.GA13592@kroah.com>
 <CALAqxLXDZ4Q_C456o_A-V_LkcY=wpoC30kvNavyVaZRu7uK9fQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CALAqxLXDZ4Q_C456o_A-V_LkcY=wpoC30kvNavyVaZRu7uK9fQ@mail.gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 16, 2014 at 08:25:33PM -0700, John Stultz wrote:
> On Thu, Oct 16, 2014 at 4:12 PM, Greg Kroah-Hartman
> <gregkh@linuxfoundation.org> wrote:
> > On Thu, Oct 16, 2014 at 10:09:04AM -0700, John Stultz wrote:
> >> On Thu, Oct 16, 2014 at 5:47 AM, Greg Kroah-Hartman
> >> <gregkh@linuxfoundation.org> wrote:
> >> > From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> >> >
> >> > The Android binder code has been "stable" for many years now.  No matter
> >>
> >> Well, ignoring the ABI break that landed in the last year. :)
> >
> > As no one noticed, it wasn't a "break" :)
> >
> >> > This was discussed in the Android miniconf at the Plumbers conference.
> >> > If anyone has any objections to this, please let me know, otherwise I'm
> >> > queueing this up for 3.19-rc1
> >>
> >> So my main concerns/thoughts here are:
> >>
> >> Who is going to maintain this? Has Arve agreed?
> >
> > Do we really need someone to do more work that has been done on it in
> > the past as an official "maintainer"?  I'll be glad to do it, as I doubt
> > it will require any time at all.
> 
> Ok. The only caution I have if Arve isn't involved is that we have in
> the past merged cleanup changes that introduced bugs, and it wasn't
> until Arve took at look at the new kernel that these were sorted out
> (see e194fd8a5d8e0a7eeed239a8534460724b62fe2d). So I think if at all
> possible getting his ack on things would be good.

I'll make sure to get his Ack on anything that could possibly cause a
problem.

> But yes, I'm fine with it going in. I'm just a bit surprised at how
> quickly thoughts change here.

Over the past year I've realized that code in staging needs to progress
either out of the kernel due to no need/use, or into the main part of
the kernel as people rely on it.  The android code is something that
people rely on, and this code is "stable", so it should be merged into
the main kernel tree.

So yes, this does seem to be a change in the public stance, but it's
something that I have been talking about with people at the zillion
conferences I go to around the world.

> This does raise the question if the same standard could be held to
> ashmem then?

Ah, you beat me to it, I was going to wait to talk to you in person
about this :)

> That's a *much* simpler and easier to maintain chunk of
> code, and is just as isolated, logic wise.  And while I think it would
> be ideal if the unpinning feature could be done more generically, if
> volatile ranges really doesn't have a future, then its maybe silly to
> hold ashmem out as well?

Yes, that was the second thing I was going to move, I'll send a patch
for that later today.

thanks,

greg k-h
