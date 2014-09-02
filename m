Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753663AbaIBLDn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Sep 2014 07:03:43 -0400
Received: from imap.thunk.org ([74.207.234.97]:60502 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753486AbaIBLDm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Sep 2014 07:03:42 -0400
Date: Tue, 2 Sep 2014 07:03:37 -0400
From: "Theodore Ts'o" <tytso@mit.edu>
To: Dave Airlie <airlied@gmail.com>
Cc: Daniel Vetter <daniel.vetter@ffwll.ch>,
        dri-devel <dri-devel@lists.freedesktop.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Jani Nikula <jani.nikula@intel.com>
Subject: Re: [REGRESSION] i915: failure to see Dell 30" monitor connected to
 a Lenovo Haswell docking station
Message-ID: <20140902110337.GA5049@thunk.org>
Mail-Followup-To: Theodore Ts'o <tytso@mit.edu>,
	Dave Airlie <airlied@gmail.com>,
	Daniel Vetter <daniel.vetter@ffwll.ch>,
	dri-devel <dri-devel@lists.freedesktop.org>,
	LKML <linux-kernel@vger.kernel.org>,
	Jani Nikula <jani.nikula@intel.com>
References: <20140902040527.GA5508@thunk.org>
 <CAPM=9txYd6LBojX+y5TYdW=8O=v49mcodj4iBZAmytXTRL68LA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAPM=9txYd6LBojX+y5TYdW=8O=v49mcodj4iBZAmytXTRL68LA@mail.gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on imap.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 02, 2014 at 02:15:39PM +1000, Dave Airlie wrote:
> On 2 September 2014 14:05, Theodore Ts'o <tytso@mit.edu> wrote:
> > I recently upgraded to v3.17-rc3, and on my Lenovo T540p, I can no
> > longer see the my Dell 30" monitor when it is connected via the
> > docking station using a Displayport connector.  This worked using 3.16
> > kernel.
> >
> > If I connect to the monitor using the mini-display, by passing the
> > docking station, things work fine (but of course it's annoying not to
> > be able to use the docking station).
> >
> > Is this a known problem?  This is not the first time that we've had
> > regressions with this docking station.   It's vaguely reminsicent of
> >
> >         https://bugs.freedesktop.org/show_bug.cgi?id=71267
> >
> > Except the system isn't hanging; it's just not seeing the monitor at all.
> 
> Have you the Dell 30" set to Displayport 1.2 enabled mode?

No, it DP 1.2 was disabled.  If I enable it, it breaks things when I
try connecting via the MiniDP port (bypassing the dock), and it is
still broken when I try to talk via the DisplayPort in the dock.

If I disable DP 1.2 again, it works via the MiniDP port, but if I try
to connect through the dock (which has a DP Hub which I believe is
MST/DP 1.2 capable), it is still broken.

It does seem that this might be related to 3.17-rc3 trying to talk DP
1.2 if it is available, since I can't control what the DP hub in the
docking station advertises --- is there a commit or some kind of hack
I can try to force talking to the DP hub using DP 1.1?

						- Ted
