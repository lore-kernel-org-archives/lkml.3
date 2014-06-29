Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753539AbaF2VcO (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Jun 2014 17:32:14 -0400
Received: from imap.thunk.org ([74.207.234.97]:35832 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753376AbaF2VcM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Jun 2014 17:32:12 -0400
Date: Sun, 29 Jun 2014 17:32:06 -0400
From: "Theodore Ts'o" <tytso@mit.edu>
To: Levente Kurusa <levex@linux.com>
Cc: "Gideon D'souza" <gidisrael@gmail.com>, Nick Krause <xerofoify@gmail.com>,
        One Thousand Gnomes <gnomes@lxorguk.ukuu.org.uk>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: Cleanup of Kernel Bugzilla
Message-ID: <20140629213206.GE2162@thunk.org>
Mail-Followup-To: Theodore Ts'o <tytso@mit.edu>,
	Levente Kurusa <levex@linux.com>,
	Gideon D'souza <gidisrael@gmail.com>,
	Nick Krause <xerofoify@gmail.com>,
	One Thousand Gnomes <gnomes@lxorguk.ukuu.org.uk>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
References: <CAPDOMVg=L+spebzkckNpM0=9NY=meV=F_+ko+VJN_6M50NdNew@mail.gmail.com>
 <CAPDOMVjnROuS4D4E2B7=PxOZUB4YXHuFUKy5C9Y8Lm7gxN=N_Q@mail.gmail.com>
 <20140628201804.215ca896@alan.etchedpixels.co.uk>
 <CAPDOMVgYsQ_zDaBN-XPwN06OUvph9YGPRqn2gUoso4f5y2fZ=g@mail.gmail.com>
 <CAPNrq4yZTFXhPG4U5H4mqFw-xbvJL5Ht-XofwKTqApgM2jsAGQ@mail.gmail.com>
 <53AFBE8A.3020408@linux.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <53AFBE8A.3020408@linux.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on imap.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jun 29, 2014 at 09:21:46AM +0200, Levente Kurusa wrote:
> 
> I think that is because they are relatively young and they are generally
> used for one direct purpose. The kernel has to make sure it works in a lot
> of different situations and hence a lot of different bugs arise.

There are a huge number of bugs which are hardware specific --- and
worse, fixing it for one hardware device can often cause problems for
others.

> >With the linux kernel not only doesn't anything exist, the project
> >itself is so bloody hard right, kernel programming, most of the
> >bugzilla bugs I can barely understand let alone even begin to deduce
> >what is going on. Now given that the list itself isn't maintained
> >makes things extremely hard.
> 
> There are still methods to extract various unresolved bugs from the
> bugzilla though. Look in any subsystem you find delicious and then
> just sort the bugs by the date they were modified. This will yield
> a list of nice fresh bugs along with some recently fixed bugs.

Or, try to find your own bugs.  Grab the development kernel, and see
if it breaks on your system.  If it does, and it was working on the
last stable kernel, then you can use "git bisect" to try to find the
point where things broke, and report the problem, and perhaps try to
figure out why it didn't work.  This can be a huge benefit for
developers who can't test their changes on every single hardware
configuration out there, so this sort of early testing of either daily
linux-next, or the mainline linux tree right after the merge window,
is a great way to learn about kernel programming.

Because of the focus on "no new regressions", testing the bleeding
edge development kernels so we can fix problems before they get
released to civilians is not only important, but often means that the
bugs that are still open are the ones which are incredibly hard to
reproduce, or which require very specialized hardware.  So it's very
likely that they won't be the bugs that are best suited for people who
are just getting started on kernel development.  Basically, for the
most part, if they were easy, they would have been fixed already.  :-)

> I brought this up as well on the Kernel Summit list. There wasn't any
> feedback on this :-), I guess there are some maintainers who care about
> bugzilla, but the rest (and the majority probably) does not care.

If you ("you" being the generic you) are someone who likes grooming
the bug tracking systems, you can certainly start to try to figure out
which bugs are no longer relevant, and then work with someone like
Alan so they can get closed out.  Over time, as you become trusted to
have good judgement over bugs, various subsystem maintainers may be
willing to give you admin bits to close bugs directly.  (And by the
way, that's something else important to note --- it's good to
specialize; the kernel is huge, so focusing on a single subsystem is a
good way to more quickly build up expertise, and for developers for
that subsystem to get to know you and to trust your judgement and your
skills.)

However, you may find that unless you're someone who tends to be a bit
obsessive-compulsive, that grooming the bugzilla doesn't really
provide much in the way of real benefit to kernel development, and so
don't provide you with much satisfaction.

After all, we don't have any direct management oversight over
developers for the upstream kernel.  So tracking things so that
policies such as "all P1 bugs must be updated every day" can be
enforced, or to keep lists of which bugs have been opened for the
longest time so that people can have long interminable meetings about
why a short-staffed team has so many bugs open, are things which are
much more applicable for pointy-haired engineering managers who can
boss engineers around and tell them to work on a particular bugs or
else they will get a bad rating at the next performance review.  But
for a volunteer project, keeping track of bugs is something that has
benefits which are much more indirect.  If as a result, you don't find
bug grooming to be very satisfying, there's no shame in moving on to
some other form of kernel contributions that *do* give you more
satisfaction.

Best regards,

						- Ted
