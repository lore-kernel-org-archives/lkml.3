Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751783AbaLTSzh (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Dec 2014 13:55:37 -0500
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:57338 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751003AbaLTSzd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Dec 2014 13:55:33 -0500
Date: Sat, 20 Dec 2014 19:55:31 +0100
From: Pavel Machek <pavel@ucw.cz>
To: Pali =?iso-8859-1?Q?Roh=E1r?= <pali.rohar@gmail.com>
Cc: Henrique de Moraes Holschuh <hmh@hmh.eng.br>,
        Darren Hart <dvhart@infradead.org>,
        Gabriele Mazzotta <gabriele.mzt@gmail.com>,
        Matthew Garrett <mjg59@srcf.ucam.org>,
        platform-driver-x86@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 0/3] dell-wmi: Don't send unneeded keypresses
Message-ID: <20141220185531.GA28431@amd>
References: <1417648583-9336-1-git-send-email-gabriele.mzt@gmail.com>
 <201412052207.35676@pali>
 <20141203180329.GB20370@vmdeb7>
 <201412201010.18151@pali>
 <20141220151108.GA11752@amd>
 <20141220162804.GA7872@khazad-dum.debian.net>
 <CAHYPw2FVniWP-7e3K905Xd5yh2zK-ytTD0z3CwwqZFTqMX5kXA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAHYPw2FVniWP-7e3K905Xd5yh2zK-ytTD0z3CwwqZFTqMX5kXA@mail.gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat 2014-12-20 18:02:49, Pali Rohár wrote:
> 2014-12-20 17:28 GMT+01:00 Henrique de Moraes Holschuh <hmh@hmh.eng.br>:
> 
> > On Sat, 20 Dec 2014, Pavel Machek wrote:
> > > > > > Ok, I agree that it is subjective how serious it is...
> > > > > > Just to remind that patch fixing problem described in
> > > > > >
> > > > > > http://www.spinics.net/lists/platform-driver-x86/msg05922.ht
> > > > > > ml
> > > > > > http://www.spinics.net/lists/platform-driver-x86/msg05924.h
> > > > > > tml
> > > > >
> > > > > I don't have any objection to sending this back to stable.
> > > > > Stable is for fixing REAL bugs, as opposed to theorhetical
> > > > > races, etc. This is a "real" bug.
> > > > >
> > > > > As to not chaning behavior, if it's OK for mainline, it's OK
> > > > > for stable. At least that is my understanding of it. Folks
> > > > > are free to verify with Greg if they disagree.
> > > >
> > > > Darren, so how you decided? Now when patches are in linus tree,
> > > > are you going to send them to stable tree?
> > >
> > > Please don't. -stable is for serious mainline bugs people are actually
> > > hitting. Null pointer dereference counts, if people actually hit
> > > it. This is more behaviour change, and yes, the new behaviour is
> > > better, but it is really different class.
> >
> > Sometimes the old behavior is something that is a major pain for users and
> > userspace.  In that case, where the new behavior fixes really annoying
> > usecase bugs, the fix belongs in -stable IMHO.
> >
> > Broken behavior hits, by definition, every user of the feature after all.
> >
> > --
> >   "One disk to rule them all, One disk to find them. One disk to bring
> >   them all and in the darkness grind them. In the Land of Redmond
> >   where the shadows lie." -- The Silicon Valley Tarot
> >   Henrique Holschuh
> >
> 
> Ok, I'm asking. It's up to you how you decide. Problem with keyboard
> illumination button is that BIOS change keyboard backlight plus it send
> keycode. So if you have userspace application which listening for
> illumination button and then do something with that event (e.g change
> keyboard backlight) you will get duplicate actions (or cyclic events, etc).
> But if you think that this change should not go to stable tree, its ok. I'm
> just ask how you decide...

Well, user report "keyboard illumination does not work in GNOME
3.14159 on Mandriva 1.732 and this patch fixes it" would certainly help.

But I'm afraid that Fedora 1.4142 already knows and expects those
duplicate events.

									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
