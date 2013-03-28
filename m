Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756641Ab3C1J3V (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Mar 2013 05:29:21 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:52446 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756100Ab3C1J3T (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Mar 2013 05:29:19 -0400
Date: Thu, 28 Mar 2013 10:29:16 +0100
From: Pavel Machek <pavel@ucw.cz>
To: Grant Likely <grant.likely@secretlab.ca>
Cc: Olof Johansson <olof@lixom.net>, Stephen Warren <swarren@wwwdotorg.org>,
        kernel list <linux-kernel@vger.kernel.org>,
        "Rafael J. Wysocki" <rjw@sisk.pl>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Arnd Bergmann <arnd@arndb.de>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Rob Herring <rob.herring@calxeda.com>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: 3.9-rc1 regression in arm dtb build
Message-ID: <20130328092916.GA11187@amd.pavel.ucw.cz>
References: <20130306193332.GA6022@amd.pavel.ucw.cz>
 <5137C404.9060902@wwwdotorg.org>
 <20130307144506.GB7344@amd.pavel.ucw.cz>
 <5138FDAE.8060202@wwwdotorg.org>
 <20130311050546.GA21863@quad.lixom.net>
 <CACxGe6vkC7fjzf1-+K8O81+w=jQ63PvuTEhSPyitEBA9XiKYnw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CACxGe6vkC7fjzf1-+K8O81+w=jQ63PvuTEhSPyitEBA9XiKYnw@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon 2013-03-11 19:00:47, Grant Likely wrote:
> On Mon, Mar 11, 2013 at 1:05 PM, Olof Johansson <olof@lixom.net> wrote:
> > On Thu, Mar 07, 2013 at 01:50:54PM -0700, Stephen Warren wrote:
> >> On 03/07/2013 07:45 AM, Pavel Machek wrote:
> >> > Hi!
> >> >>> commit 499cd8298628eeabf0eb5eb6525d4faa0eec80d8
> >> >>> Author: Grant Likely <grant.likely@secretlab.ca>
> >> >>> Date:   Tue Nov 27 16:29:11 2012 -0700
> >> > ...
> >> >>> 1) it is inconsistent with 3.8, making switching between 3.9-rc1 and
> >> >>> 3.8 tricky
> >> >>
> >> >> It's pretty easy to locate the DTB by automatically looking in
> >> >> arch/*/boot/dts first, then if the file doesn't exist there, looking in
> >> >> arch/*/boot instead as a legacy fallback.
> >> >
> >> > Unfortunately, that does not work. See 2) below. Stale files even
> >> > survive "make clean".
> >>
> >> Oh right. I guess it works fine when having built 3.7 and then building
> >> 3.8, since you'd look in the new location first and only fall back to
> >> the old location if missing. However, if you then switch back to 3.7 to
> >> test something, I guess that doesn't work so well.
> >>
> >> I tend to always build the dtbs target, so I wasn't affected by this.
> >> And, often run "git clean -f -d -x" too.
> >>
> >> Grant, what's your call on this issue; should I/you look into ways to
> >> clean the files better, or do you want to revert this?
> >
> > I'm not Grant, but I think we're better off cleaning up the current situation
> > instead of reverting. Otherwise 3.8 will be the oddball weird release; it's
> > better to get people moved over to the new location.
> 
> Don't revert. It needs to be fixed up. Pavel, if you're really choked
> up about this we can symlink the files from the old location to the
> new. I personally don't think it is that onerous a change though since
> the files are easy to find and build systems can adapt.

So... lets see.

There's change that makes it pretty much impossible to build dtbs
reliably between different kernel versions, because it leaves old dtbs
around, and they survive even make clean.

You don't want it reverted, yet noone fixes it.

What are supposed advantages of new location? (Besides disadvantages I
listed before)? Can we just revert the patch?

									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
