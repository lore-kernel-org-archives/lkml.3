Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932620AbaFJT7L (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jun 2014 15:59:11 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:60748 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754302AbaFJT7H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jun 2014 15:59:07 -0400
Date: Tue, 10 Jun 2014 21:59:05 +0200
From: Pavel Machek <pavel@ucw.cz>
To: "Rafael J. Wysocki" <rjw@rjwysocki.net>
Cc: Linux PM list <linux-pm@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 3/3][update] PM / sleep: Introduce command line
 argument for sleep state enumeration
Message-ID: <20140610195905.GA6805@amd.pavel.ucw.cz>
References: <1817539.9KW2IGGbDV@vostro.rjw.lan>
 <1579932.qSkFQPvI6f@vostro.rjw.lan>
 <20140610131206.GA7626@amd.pavel.ucw.cz>
 <1848200.GDD9x0Rptb@vostro.rjw.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1848200.GDD9x0Rptb@vostro.rjw.lan>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue 2014-06-10 17:23:24, Rafael J. Wysocki wrote:
> On Tuesday, June 10, 2014 03:12:06 PM Pavel Machek wrote:
> > Hi!
> > 
> > > From: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
> > > 
> > > On some systems the platform doesn't support neither
> > > PM_SUSPEND_MEM nor PM_SUSPEND_STANDBY, so PM_SUSPEND_FREEZE is the
> > > only available system sleep state.  However, some user space frameworks
> > > only use the "mem" and (sometimes) "standby" sleep state labels, so
> > > the users of those systems need to modify user space in order to be
> > > able to use system suspend at all and that is not always possible.
> > 
> > I'd say we should fix the frameworks, not add option to change kernel
> > interfaces.
> > 
> > Because, as you mentioned, if we add this, we are probably going to
> > get stuck with it forever :-(.
> 
> Unfortunately, fixing the frameworks is rather less than realistic in any
> reasonable time frame, since  Android. :-)

Actually, you still have the sources from android, and this issue
sounds almost simple enough for binary patch.

Android misuses /proc/sys/vm/drop_caches, too, IIRC. Are we going to
change interface to match their expectations? They have binder and
wakelocks. Are we going to apply those patches just because Android
wants that?

Android people usually patch their kernels, anyway, so why not add
this one, too?
									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
