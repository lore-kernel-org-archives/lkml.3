Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753704AbaG3Muq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jul 2014 08:50:46 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:43424 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752929AbaG3Mun (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jul 2014 08:50:43 -0400
Date: Wed, 30 Jul 2014 14:50:41 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Hannes Frederic Sowa <hannes@stressinduktion.org>
Cc: George Spelvin <linux@horizon.com>, tytso@mit.edu,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH, RFC] random: introduce getrandom(2) system call
Message-ID: <20140730125041.GD13965@amd.pavel.ucw.cz>
References: <20140723115253.9808.qmail@ns.horizon.com>
 <1406117416.4473.144770005.5B5ED8C2@webmail.messagingengine.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1406117416.4473.144770005.5B5ED8C2@webmail.messagingengine.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed 2014-07-23 14:10:16, Hannes Frederic Sowa wrote:
> 
> 
> On Wed, Jul 23, 2014, at 13:52, George Spelvin wrote:
> > I keep wishing for a more general solution.  For example, some way to
> > have a "spare" extra fd that could be accessed with a special O_NOFAIL
> > flag.
> > 
> > That would allow any number of library functions to not fail, such as
> > logging from nasty corner cases.
> > 
> > But you'd have to provide one per thread, and block non-fatal signals
> > while it was open, so you don't get reentrancy problems.  Ick.
> > 
> > 
> > This overly-specialized system call (and worse yet, a blocking
> > system call that you can't put into a poll() loop) just feels ugly
> > to me.  Is it *absolutely* necessary?
> 
> One point that often came up besides fd exhaustion is missing
> /dev/u?random device nodes in chroot environments.

>From the maillist discussion, it seems you sometimes _want_
/dev/random not to be present.

For example you want to trace exactly the same path through malware
every time.

> > For example, how about simply making getentropy() a library function that
> > aborts if it can't open /dev/urandom?  If you're suffering fd exhaustion,
> > you're being DoSed already.
> 
> Maybe applications want to mitigate fd exhaustion.

Dunno. Will we add special read_passwd() syscall that reads just
/etc/passwd, to allow uid<->name resolution without available FDs?

I like the library function suggestion, this should not need a new
syscall.

And btw -- compatibility with getentropy() is _not_ going to be easy,
if they have different blocking / partial read / signals policy.

									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
