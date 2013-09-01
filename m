Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757870Ab3IASul (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Sep 2013 14:50:41 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:43658 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756574Ab3IASuk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Sep 2013 14:50:40 -0400
Date: Sun, 1 Sep 2013 20:50:38 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Gustavo Padovan <gustavo@padovan.org>, marcel@holtmann.org,
        johan.hedberg@gmail.com, linux-bluetooth@vger.kernel.org,
        kernel list <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Cc: security@kernel.org
Subject: 3.11-final plan: unpriviledged user can crash the kernel (using
 bluetooth rfcomm)
Message-ID: <20130901185038.GA11714@amd.pavel.ucw.cz>
References: <20130831100127.GA6711@amd.pavel.ucw.cz>
 <20130831100933.GA7029@amd.pavel.ucw.cz>
 <20130831101451.GC7029@amd.pavel.ucw.cz>
 <20130831104238.GA7767@amd.pavel.ucw.cz>
 <20130901165525.GK7440@joana>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130901165525.GK7440@joana>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> > On Sat 2013-08-31 12:14:51, Pavel Machek wrote:
> > > On Sat 2013-08-31 12:09:33, Pavel Machek wrote:
> > > > Hi!
> > > > 
> > > > > . Python sources for client/server are at 
> > > > > 
> > > > > http://tui.cvs.sourceforge.net/viewvc/tui/tui/liveview/
> > > > > 
> > > > > . My kernels like to warn about
> > > > System is debian stable with gnome2.
> > > 
> > > And no, it is not fixed in 3.11-rc7.
> > 
> > 2.6.32-5-686 from debian seems to work.
> 
> Could you try linux-next? We recently pushed a rework of the RFCOMM tty
> handling, it should fix this. The work was too big to be pushed to 3.11

So... In 3.11 unpriviledged user can crash the kernel, but the fix is
too big, so we release it without the fix?

Somehow, I don't think that's good idea.

Do you have an idea what is the impact? Is it crash-the-kernel or
execute-arbitrary-code?

What about:

a) marking CONFIG_RFCOMM as dangerous in the help text. I just
checked, help text makes it sound like a good thing.

(joke) b) renaming CONFIG_RFCOMM to CONFIG_LET_USER_CRASH_KERNEL

or better yet:

c) removing CONFIG_RFCOMM option in affected releases? I know
regressions are bad, but...

Multiuser desktops are not too common these days, but all the
Android cellphones are "multiuser"...

Plus note that bug is so easy to trigger that I hit it in first minute
trying to get non-malicious application to run.

[3.10 seems also affected.]
									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
