Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933217AbaFJUR1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jun 2014 16:17:27 -0400
Received: from v094114.home.net.pl ([79.96.170.134]:54043 "HELO
	v094114.home.net.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S932413AbaFJURZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jun 2014 16:17:25 -0400
From: "Rafael J. Wysocki" <rjw@rjwysocki.net>
To: Pavel Machek <pavel@ucw.cz>
Cc: Linux PM list <linux-pm@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 3/3][update] PM / sleep: Introduce command line argument for sleep state enumeration
Date: Tue, 10 Jun 2014 22:34:49 +0200
Message-ID: <1771964.SepbTGNdtD@vostro.rjw.lan>
User-Agent: KMail/4.11.5 (Linux/3.15.0-rc5+; KDE/4.11.5; x86_64; ; )
In-Reply-To: <20140610195905.GA6805@amd.pavel.ucw.cz>
References: <1817539.9KW2IGGbDV@vostro.rjw.lan> <1848200.GDD9x0Rptb@vostro.rjw.lan> <20140610195905.GA6805@amd.pavel.ucw.cz>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday, June 10, 2014 09:59:05 PM Pavel Machek wrote:
> On Tue 2014-06-10 17:23:24, Rafael J. Wysocki wrote:
> > On Tuesday, June 10, 2014 03:12:06 PM Pavel Machek wrote:
> > > Hi!
> > > 
> > > > From: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
> > > > 
> > > > On some systems the platform doesn't support neither
> > > > PM_SUSPEND_MEM nor PM_SUSPEND_STANDBY, so PM_SUSPEND_FREEZE is the
> > > > only available system sleep state.  However, some user space frameworks
> > > > only use the "mem" and (sometimes) "standby" sleep state labels, so
> > > > the users of those systems need to modify user space in order to be
> > > > able to use system suspend at all and that is not always possible.
> > > 
> > > I'd say we should fix the frameworks, not add option to change kernel
> > > interfaces.
> > > 
> > > Because, as you mentioned, if we add this, we are probably going to
> > > get stuck with it forever :-(.
> > 
> > Unfortunately, fixing the frameworks is rather less than realistic in any
> > reasonable time frame, since  Android. :-)
> 
> Actually, you still have the sources from android, and this issue
> sounds almost simple enough for binary patch.
> 
> Android misuses /proc/sys/vm/drop_caches, too, IIRC. Are we going to
> change interface to match their expectations? They have binder and
> wakelocks. Are we going to apply those patches just because Android
> wants that?

That depends on which versions of Android you're talking about.  The
newest ones use the power management interfaces we have upstream.

> Android people usually patch their kernels, anyway, so why not add
> this one, too?

I'm not talking about Android kernels, but about Android user space.

And this is not only about Android, other distros also have user space that
uses "mem" only, because nobody has used anything else for a long time anyway.
For the users of those distros, if they don't want to modify user space,
having a kernel command line like this is actually helpful.

So I'm really not sure what's the problem?  Do you think it's wrong to be
helpful to users or something?

Rafael

