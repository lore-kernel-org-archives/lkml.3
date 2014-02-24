Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752655AbaBXWLa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Feb 2014 17:11:30 -0500
Received: from www.prifuk.cz ([31.31.77.241]:43463 "EHLO prifuk.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752054AbaBXWL2 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Feb 2014 17:11:28 -0500
From: Michal =?ISO-8859-1?Q?Mal=FD?= <madcatxster@prifuk.cz>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: Elias Vanderstuyft <elias.vds@gmail.com>,
        Anssi Hannula <anssi.hannula@iki.fi>, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org, Jiri Kosina <jkosina@suse.cz>,
        Simon Wood <simon@mungewell.org>
Subject: Re: [PATCH v2 0/4] Add ff-memless-next and make hid-lg4ff use it
Date: Mon, 24 Feb 2014 23:11:20 +0100
Message-ID: <1687636.joOxxSug6B@geidi-prime>
User-Agent: KMail/4.12.2 (Linux/3.13.5-1-ARCHMOD; KDE/4.12.2; x86_64; ; )
In-Reply-To: <20140224214818.GA4156@core.coreip.homeip.net>
References: <1516865.M993BQAYe4@geidi-prime> <CADbOyBQ0U_TiovwMJJO1zQpr5PcwmB1O155P4nC6CmwhZjA=UQ@mail.gmail.com> <20140224214818.GA4156@core.coreip.homeip.net>
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
Content-Type: text/plain; charset="iso-8859-1"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 24 of February 2014 13:48:18 Dmitry Torokhov wrote:
> On Mon, Feb 24, 2014 at 10:17:25PM +0100, Elias Vanderstuyft wrote:
> > On Mon, Feb 24, 2014 at 1:58 AM, Michal Malý <madcatxster@prifuk.cz> 
wrote:
> > > On Monday 24 of February 2014 02:32:27 Anssi Hannula wrote:
> > >> I think we should extend the current ff-memless instead of duplicating
> > >> its functionality (even on a "for now" basis).
> > >> 
> > >> Having looked at ff-memless-next briefly, it seems very similar to
> > >> ff-memless on its basic working principle, and therefore I don't really
> > >> see why extending ff-memless would be too cumbersome. Unless I'm
> > >> missing
> > >> something - in that case, feel free to point it out to me :)
> > > 
> > > Deciding whether to patch ff-memless or write a new driver from scratch
> > > was a perfect example of being caught between the rock and a hard
> > > place. I am not particularly fond of the fact that we would have two
> > > modules doing pretty much the same thing. My reasons for writing a
> > > separate module were:
> > > - Periodic effects. ff-memless doesn't do "real" periodic effects, it
> > > simply emulates them through rumble effect. Devices without rumble
> > > effect support require emulation through constant force effect. Just
> > > this was not something one could write in one afternoon:)
> > > - Conditional effects. These effects cannot be by nature combined into
> > > one
> > > overall force (at least not easily) so they have to be handled one by
> > > one -
> > > this is a concept ff-memless does not seem to consider. FFB devices have
> > > limits as to how many conditional (referred to as "uncombinable" in
> > > MLNX)
> > > effects can be active simultaneously, etc.
> > > All in all it seemed less error prone to write a new driver based on the
> > > ff- memless logic, test and deploy it on devices I have access to and
> > > once we are sure there are no nasty regressions port the rest of the
> > > drivers to the new API. Given the scope of the changes I am afraid that
> > > a "patch" to ff-memless would be pretty close to a rewrite anyway.
> > 
> > And add the fact that we already heavily tested the ff-memless-next
> > driver.
> > Unless you do a diff between the original ff-memless.c and the current
> > ff-memless-next.c (which will result in a rather unintuitive patch),
> > it would be a huge waste of time to retest the modified (when doing
> > efforts to create an intuitive patch) ff-memless-next.c, considered my
> > total time spend on testing (and not to speak of the time that Michal
> > spent to fix the corresponding bugs.)
> > I know that might not be much of an argument, but on the other side,
> > my motivation to test again from scratch will be much lower (I can't
> > change much on that, I'm afraid), which would eventually lead to lower
> > reliability of the final product.
> 
> On the other hand having 2 drivers implementing very similar
> functionality would lead to general confusion as to which one should be
> used; they will also have to be maintained.
> 
> I would rather see them merged into one driver providing necessary
> services to all memoryless FF devices.
> 
> Thanks.

Very well. It that case I guess the most sensible thing to do would be to add 
FF_RUMBLE to ff-memless-next and replace ff-memless completely. As Anssi 
pointed out a lot of the drivers that currently use ff-memless are very simple 
so any risk of breakage will hopefully be minimal.

As I don't have any device with rumble effect support I'll appreciate help on 
this front

Michal M.
