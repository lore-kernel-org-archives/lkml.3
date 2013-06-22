Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751804Ab3FVTpc (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Jun 2013 15:45:32 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:55115 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751366Ab3FVTp3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Jun 2013 15:45:29 -0400
Date: Sat, 22 Jun 2013 21:45:27 +0200
From: Pavel Machek <pavel@ucw.cz>
To: =?iso-8859-1?Q?Ga=EBl?= PORTAY <g.portay@overkiz.com>,
        Rob Landley <rob@landley.net>, Bryan Wu <cooloney@gmail.com>,
        Richard Purdie <rpurdie@rpsys.net>,
        "Milo(Woogyom) Kim" <milo.kim@ti.com>, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-leds@vger.kernel.org
Subject: Re: [RFC PATCH] led: add Cycle LED trigger.
Message-ID: <20130622194526.GA18809@amd.pavel.ucw.cz>
References: <1371572663-10846-1-git-send-email-g.portay@overkiz.com>
 <20130622112619.GA8075@amd.pavel.ucw.cz>
 <20130622164300.GB19420@earth.universe>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20130622164300.GB19420@earth.universe>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat 2013-06-22 18:43:01, Sebastian Reichel wrote:
> On Sat, Jun 22, 2013 at 01:26:20PM +0200, Pavel Machek wrote:
> > On Tue 2013-06-18 18:24:23, Gaël PORTAY wrote:
> > > Currently, none of available triggers supports playing with the LED brightness
> > > level.  The cycle trigger provides a way to define custom brightness cycle.
> > > For example, it is easy to customize the cycle to mock up the rhythm of human
> > > breathing which is a nice cycle to tell the user the system is doing something.
> > > 
> > > This trigger is meant to be usable for waiting an event to happen, for example
> > > when the system gets ready.  Those cycles may be used to reflect well known
> > > system status (e.g. idle mode, startup...).
> > > 
> > > This implementation provides several interfaces:
> > >  - to define the cycle itself:
> > >    * plot: definition of plot points using plot or rawplot files,
> > >            each points defines the brightness level
> > >    * interval: constant time interval between each plot point
> > >  - to control the cycle:
> > >    * repeat: the number of repetition of the whole plot cycle
> > >              0 for an infinite loop
> > >    * control: used to control the cycle trigger
> > >      + "start"/"stop": to start/stop the cycle
> > >      + "reset" to clear the cycle counter and the internal plot point index
> > >      + "pause"/"resume" to pause/resume the cycle
> > > 
> > > Signed-off-by: Gaël PORTAY <g.portay@overkiz.com>
> > 
> > I'd say this should go to userspace.... and maybe should handle RGB
> > leds. ... like the one on n900/HTC dream/....
> > 
> > Actually, there's probably some daemon in maemo that already does
> > this.
> 
> Actually the n900 has hardware support for this. There's a
> programmable LED driver on the board, which is called LP5523.
> 
> So... I don't think there's a daemon in maemo ;)

You are right. LP5523 seems to do such effects on its own.

But that means that there's good reason to include effects in the
kernel, and that we should make sure same it has same interface as on
n900.

(Or invent suitable interface that can work on n900).
									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
