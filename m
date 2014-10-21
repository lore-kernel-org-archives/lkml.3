Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933285AbaJUUF3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Oct 2014 16:05:29 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:35805 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932842AbaJUUFZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Oct 2014 16:05:25 -0400
Date: Tue, 21 Oct 2014 22:05:22 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, viro@zeniv.linux.org.uk,
        John Stultz <john.stultz@linaro.org>,
        lkml <linux-kernel@vger.kernel.org>, devel@driverdev.osuosl.org,
        Linux API <linux-api@vger.kernel.org>,
        Santosh Shilimkar <santosh.shilimkar@ti.com>,
        Arve =?iso-8859-1?B?SGr4bm5lduVn?= <arve@android.com>,
        Sumit Semwal <sumit.semwal@linaro.org>,
        Rebecca Schultz Zavin <rebecca@android.com>,
        Christoffer Dall <christoffer.dall@linaro.org>,
        Anup Patel <anup.patel@linaro.org>
Subject: Re: [PATCH] staging: android: binder: move to the "real" part of the
 kernel
Message-ID: <20141021200522.GB2969@amd>
References: <20141016124741.GA3832@kroah.com>
 <20141016231221.GA13592@kroah.com>
 <20141021103622.GB23161@amd>
 <4227199.e5u61J7jtX@wuerfel>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4227199.e5u61J7jtX@wuerfel>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue 2014-10-21 16:12:24, Arnd Bergmann wrote:
> On Tuesday 21 October 2014 12:36:22 Pavel Machek wrote:
> > On Fri 2014-10-17 01:12:21, Greg Kroah-Hartman wrote:
> > > On Thu, Oct 16, 2014 at 10:09:04AM -0700, John Stultz wrote:
> > > > On Thu, Oct 16, 2014 at 5:47 AM, Greg Kroah-Hartman
> > > > <gregkh@linuxfoundation.org> wrote:
> > > > > From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> > 
> > > > Are the Android guys comfortable with the ABI stability rules they'll
> > > > now face?
> > > 
> > > Just because something is in staging, doesn't mean you don't have to
> > > follow the same ABI stability rules as the rest of the kernel.  If a
> > > change had happened to this code that broke userspace in the past, I
> > > would have reverted it.  So this should not be anything different from
> > > what has been happening inthe past.
> > 
> > Actually, there's big difference.
> > 
> > If Al Viro changes core filesystem in a way that breaks
> > staging/binder, binder is broken, and if it can't be fixed... well it
> > can't be fixed.
> > 
> > If Al Viro changes core filesystem in a way that breaks
> > drivers/binder, Al's change is going to be reverted.
> 
> One might have argued that we'd have to do that already, but the reasons
> for doing that with binder in the main kernel are certainly stronger.
> 
> > It is really hard to review without API documentation. Normally, API
> > documentation is required for stuff like this.
> > 
> > For example: does it add new files in /proc?
> > 
> > Given that it is stable, can we get rid of binder_debug() and
> > especially BINDER_DEBUG_ENTRY stuff?
> 
> Good point. We require documentation for every single sysfs attribute
> that gets added to a driver (some escape the review, but that doesn't
> change the rule), so we should not make an exception for a new procfs
> file here.

Actually, it looked like it is debugfs file. Code was messy enough
that I was not sure.

> > Could binder_transcation() be split to smaller functions according to
> > CodingStyle? 17 goto targets at the end of function are not exactly
> > easy to read.
> > 
> > ginder_thread_read/write also needs splitting.
> 
> Yes, in principle, but this is still a detail that would mainly serve
> to simplify review. The problem is more the lack of review and
> documentation of the API.

Yes, the problem is that code is impossible to review without API
documentation.

									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
