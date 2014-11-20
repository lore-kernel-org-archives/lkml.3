Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932266AbaKTKN0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Nov 2014 05:13:26 -0500
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:58167 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751680AbaKTKNY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Nov 2014 05:13:24 -0500
Date: Thu, 20 Nov 2014 11:13:21 +0100
From: Pavel Machek <pavel@ucw.cz>
To: Sebastian Reichel <sre@kernel.org>
Cc: Ivaylo Dimitrov <ivo.g.dimitrov.75@gmail.com>,
        Pali Roh?r <pali.rohar@gmail.com>,
        kernel list <linux-kernel@vger.kernel.org>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        linux-omap@vger.kernel.org, tony@atomide.com, khilman@kernel.org,
        aaro.koskinen@iki.fi, freemangordon@abv.bg,
        Sakari Ailus <sakari.ailus@iki.fi>
Subject: voice calls on N900 working (off-line) was Re: N900 modem support in
 3.18-rc1
Message-ID: <20141120101320.GA6356@amd>
References: <20141104205117.GA17606@amd>
 <20141106180335.GA21513@earth.universe>
 <20141106225005.GA14002@amd>
 <201411070001.46481@pali>
 <545C6F14.8050303@gmail.com>
 <20141113162420.GB8512@xo-6d-61-c0.localdomain>
 <5465A977.4030605@gmail.com>
 <20141114172008.GB12250@earth.universe>
 <54665E02.8050108@gmail.com>
 <20141114215749.GA19023@earth.universe>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141114215749.GA19023@earth.universe>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> > REed pulseaudio modules that use cmtspeech will be ready sooner than later
> > (I believe in 2-3 monts from now), see on gitorious how fast we progressed
> > with -record and -music modules. Sure, -voice module is way more
> > complicated, but lots of it is already opensourced, we just need to figure
> > out a couple of DSP algorithms(drc, agc, aec, etc) related to call quality.
> > But I don't think the driver should wait for those modules to be REed, they
> > can be used as is even now, in their closed form for testing.
> 
> https://gitorious.org/pulseaudio-modules-nemo/jusas-tanuk2-mer-packaging/source/6ed34611b49c99b007f614d9dff4d58369876345:
> https://github.com/nemomobile/pulseaudio-module-cmtspeech-n9xx/commits/master
> 
> It seems there is already cmtspeech code for pulseaudio?

Yes, and it works; but see below.

> > Unfortunately all my spare time is dedicated to that PA stuff, so
> > I simply can't cleanup cmtspeech driver and send a patch for
> > upstreaming. (Pavel, what about you?)
> 
> If somebody gets audio working with your driver and documents the
> steps needed in userland I will take care of upstreaming the driver.

I got it to work.

Ok, so realtime audio does not work due to some pulseaudio problems,
but I was able to record a (silent) call and then replay it with 

pacat --rate 4000 ../../../pulseaudio2.raw

on my PC. I have yet to do some testing on the microphone side.

I'm using Debian 7 as a a base, and I suggest nfsroot.

It seems that libcmtspeechdata + pulseaudio-module-cmtspeech-n9xx is
enough to get calls to work. Now. I could not get configure on these
packages to work, so I hard-coded build scripts (mkit). You'll need to
symlink resulting .so to pulseaudio directory (see
/my/pulseaudio-module-cmtspeech-n9xx/src/cmtspeech/mkit). I leave binaries in,
since this is non-trivial to compile. Some memory allocation stuff was
missing. I faked it; it seems it is not needed in the first call.

untar in the root directory of n900. Reset n900, no need to log in
into console, connect using ssh -X root@n900.

Then go to /my/tui/ofone. Run "./run" -- that should start
pulseaudio. Run "./ofone", hit "lowlevel: online", hit "contacts",
enter phone number you want to call, hit the number, it should start
dialing.

Wait a while, hit "lowlevel: hangup".

Now you should have:

/my/pulseaudio2.raw

you can play with pacat above, and /my/pulseaudio.log.*, which
contains stuff that needs to be fixed.

I've put the archive at

http://atrey.karlin.mff.cuni.cz/~pavel/outgoing/n900-my.tgz

Have fun!

									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
