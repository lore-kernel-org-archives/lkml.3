Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753936AbaFMXBw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jun 2014 19:01:52 -0400
Received: from v094114.home.net.pl ([79.96.170.134]:55266 "HELO
	v094114.home.net.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751262AbaFMXBu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jun 2014 19:01:50 -0400
From: "Rafael J. Wysocki" <rjw@rjwysocki.net>
To: Pavel Machek <pavel@ucw.cz>
Cc: Linux PM list <linux-pm@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 3/3][update] PM / sleep: Introduce command line argument for sleep state enumeration
Date: Sat, 14 Jun 2014 01:19:18 +0200
Message-ID: <2242480.eT2OxdNqLH@vostro.rjw.lan>
User-Agent: KMail/4.11.5 (Linux/3.15.0-rc5+; KDE/4.11.5; x86_64; ; )
In-Reply-To: <34237308.7Kff3QYgup@vostro.rjw.lan>
References: <1817539.9KW2IGGbDV@vostro.rjw.lan> <3836835.YaZPGXsEQ2@vostro.rjw.lan> <34237308.7Kff3QYgup@vostro.rjw.lan>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday, June 14, 2014 12:23:15 AM Rafael J. Wysocki wrote:
> On Saturday, June 14, 2014 12:16:26 AM Rafael J. Wysocki wrote:
> > On Friday, June 13, 2014 11:46:12 PM Pavel Machek wrote:
> 
> [...]
> 
> > > > So I'm really not sure what's the problem?  Do you think it's wrong to be
> > > > helpful to users or something?
> > > 
> > > It is not wrong to be helpful, but messed up interface is too big a
> > > price.
> > 
> > Why?  I will have to maintain it after all, right?
> 
> And by the way, the very fact that this workaround is even useful in some cases
> indicates that the interface that we've invented originally is not particularly
> useful to user space.  The reason why is because user space is supposed to
> enumerate the sleep states and then present the ones that are present in a
> consistent way to the user.  It basically has to do "Is 'mem' present"?  Use it
> if so, but if not is 'standby' present?  Use it if so etc." every time or
> squirrel that information somewhere which isn't particularly straightforward.

Moreover, the "mem" and "standby" states are not really well defined on anything
different from ACPI, so "mem" is used by everybody having just one platform-supported
state.  That's why user space doesn't bother to check the other ones in many
cases and it is not really their problem.  It is the problem of our existing
interface that wasn't designed correctly.

My first reaction to this issue was pretty much the same as yours, but when I started
to think more about it, I've realized that we messed up things to start with and now
we're just having to deal with the consequences.  So yes, we can put our heads in
the ground and say "that's not our problem, it has to be addressed in user space",
but quite frankly I'm not seeing how we can persuade user space developers address
it given that the vast majority of systems use "mem" only anyway and that they don't
really understand where the problem is.

For this reason I'm considering changing the defaul behavior going forward (so
that "mem" is always present and means "the deepest sleep state available other
than hibernation"), but I don't want to do that in one go.

Rafael

