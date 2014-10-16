Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752641AbaJPXNb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Oct 2014 19:13:31 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:49594 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750765AbaJPXN3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Oct 2014 19:13:29 -0400
Date: Fri, 17 Oct 2014 01:12:21 +0200
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
Message-ID: <20141016231221.GA13592@kroah.com>
References: <20141016124741.GA3832@kroah.com>
 <CALAqxLU05D8qQA47E77PiuuN7eVt66WEq1qn+PqdE-tpEUzFpw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CALAqxLU05D8qQA47E77PiuuN7eVt66WEq1qn+PqdE-tpEUzFpw@mail.gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 16, 2014 at 10:09:04AM -0700, John Stultz wrote:
> On Thu, Oct 16, 2014 at 5:47 AM, Greg Kroah-Hartman
> <gregkh@linuxfoundation.org> wrote:
> > From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> >
> > The Android binder code has been "stable" for many years now.  No matter
> 
> Well, ignoring the ABI break that landed in the last year. :)

As no one noticed, it wasn't a "break" :)

> > This was discussed in the Android miniconf at the Plumbers conference.
> > If anyone has any objections to this, please let me know, otherwise I'm
> > queueing this up for 3.19-rc1
> 
> So my main concerns/thoughts here are:
> 
> Who is going to maintain this? Has Arve agreed?

Do we really need someone to do more work that has been done on it in
the past as an official "maintainer"?  I'll be glad to do it, as I doubt
it will require any time at all.

> Are the Android guys comfortable with the ABI stability rules they'll
> now face?

Just because something is in staging, doesn't mean you don't have to
follow the same ABI stability rules as the rest of the kernel.  If a
change had happened to this code that broke userspace in the past, I
would have reverted it.  So this should not be anything different from
what has been happening inthe past.

And the Android developers said they were happy to see this code move
into the "real" part of the kernel.

> Currently in the android space no one but libbinder should use the
> kernel interface.

That is correct.  If you do that, you deserve all of the pain and
suffering and rooted machines you will get.

> Can we enforce that no one use this interface out-side of android (To
> ensure its one of those "if the abi breaks and no one notices..." edge
> cases)?

This is the kernel, we can not dictate "use", that's the good part of
the GPLv2 :)

Again, as no one has done this before, I strongly doubt it will happen
in the future.

> I'm still hopeful that a libbinder over kdbus will eventually pan out.
> I still see having two core IPC mechanisms (even if the use cases are
> different in style) as a negative, and I worry this might reduce
> motivation to unify things at the lower level. Granted, such work can
> still continue, but the incentives do change.

Yes, things are going to change in the future, there is work happening
here, and there was a presentation at Plumbers about what is going to be
coming.

But all of the changes will be in new code.  Be it kdbus, or something
else if that doesn't work out.  This existing binder.c file will not be
changing at all.  This existing ABI, and codebase, is something that we
have to maintain forever for those millions of devices out there in the
real world today.  So as there really is nothing left to do on it, it
deserves to be in the main part of the kernel source tree.

thanks,

greg k-h
