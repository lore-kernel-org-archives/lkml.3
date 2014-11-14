Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422663AbaKNVOn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Nov 2014 16:14:43 -0500
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:35478 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754335AbaKNVOm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Nov 2014 16:14:42 -0500
Date: Fri, 14 Nov 2014 22:14:38 +0100
From: Pavel Machek <pavel@ucw.cz>
To: Ivaylo Dimitrov <ivo.g.dimitrov.75@gmail.com>
Cc: Sebastian Reichel <sre@kernel.org>, Pali Roh?r <pali.rohar@gmail.com>,
        kernel list <linux-kernel@vger.kernel.org>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        linux-omap@vger.kernel.org, tony@atomide.com, khilman@kernel.org,
        aaro.koskinen@iki.fi, freemangordon@abv.bg,
        Sakari Ailus <sakari.ailus@iki.fi>
Subject: Re: N900 modem support in 3.18-rc1
Message-ID: <20141114211438.GA6658@amd>
References: <20141104205117.GA17606@amd>
 <20141106180335.GA21513@earth.universe>
 <20141106225005.GA14002@amd>
 <201411070001.46481@pali>
 <545C6F14.8050303@gmail.com>
 <20141113162420.GB8512@xo-6d-61-c0.localdomain>
 <5465A977.4030605@gmail.com>
 <20141114172008.GB12250@earth.universe>
 <54665E02.8050108@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <54665E02.8050108@gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

On Fri 2014-11-14 21:54:42, Ivaylo Dimitrov wrote:
> On 14.11.2014 19:20, Sebastian Reichel wrote:
> >
> >The patch looks ok. It does not cleanup the cmt-speech driver for
> >mainline usage, but it should work. Before adding this driver to the
> >mainline kernel there should be open source userspace support anyway.
> >
> 
> I am aware of that(patch not ready), it's one of the reasons this patch
> still sits on gitorious IMO.
> 
> libcmtspeechdata was opened by Nokia long ago, so I don't understand what
> userspace support (for inclusion of the driver in the mainline kernel that
> is) is needed. see https://gitorious.org/meego-cellular/libcmtspeechdata/source/7f8f3ce357513e4849e1bf6d657980a514529c1a:
> 
> REed pulseaudio modules that use cmtspeech will be ready sooner than later
> (I believe in 2-3 monts from now), see on gitorious how fast we progressed
> with -record and -music modules. Sure, -voice module is way more
> complicated, but lots of it is already opensourced, we just need to figure
> out a couple of DSP algorithms(drc, agc, aec, etc) related to call quality.
> But I don't think the driver should wait for those modules to be REed, they
> can be used as is even now, in their closed form for testing. Unfortunately
> all my spare time is dedicated to that PA stuff, so I simply can't cleanup
> cmtspeech driver and send a patch for upstreaming. (Pavel, what
>about you?)

Hey, I can try.

But there are two things I'd like to understand, first:

a) how did Mer people solve this? Or did they just ship nokia
binaries?

b) do we really need those DSP algorithms? Can we just take data from
microphone and send it down the GSM line, and take data from GSM line
and put it to the speaker? If it will not work in the speakerphone
mode, I can live with that... It should somehow work in normal-phone
mode, and be definitely feasible with wired handsfree, no?

Thanks,
									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
