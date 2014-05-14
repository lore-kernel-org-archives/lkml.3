Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751582AbaENTdl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 May 2014 15:33:41 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:45890 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750871AbaENTdk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 May 2014 15:33:40 -0400
Date: Wed, 14 May 2014 12:33:39 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Daniel Vetter <daniel@ffwll.ch>
Cc: Bruno =?iso-8859-1?Q?Pr=E9mont?= <bonbons@linux-vserver.org>,
        Carbonated Beverage <ramune@psychosnugglebunnies.net>,
        Intel Graphics Development <intel-gfx@lists.freedesktop.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [Intel-gfx] 3.14.3 i915 dead display under X11
Message-ID: <20140514193339.GA18197@kroah.com>
References: <20140512031029.GA18875@psychosnugglebunnies.net>
 <20140514204738.60a2f49c@neptune.home>
 <CAKMK7uFDJym3fKewmivps_894_P_ifQ0TYeBXg5oevP6wrz1zw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAKMK7uFDJym3fKewmivps_894_P_ifQ0TYeBXg5oevP6wrz1zw@mail.gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 14, 2014 at 09:19:32PM +0200, Daniel Vetter wrote:
> On Wed, May 14, 2014 at 08:47:38PM +0200, Bruno Prémont wrote:
> > CCing intel-gfx as otherwise it will probably not get seen by developers.
> >
> > On Sun, 11 May 2014 Carbonated Beverage <ramune@psychosnugglebunnies.net> wrote:
> > > Bisecting from 3.13.6 (good) to 3.14.3 (bad) ended up with...
> > >
> > > commit b35684b8fa94e04f55fd38bf672b737741d2f9e2
> > > Author: Jani Nikula <jani.nikula@intel.com>
> > > Date:   Thu Nov 14 12:13:41 2013 +0200
> > >
> > >     drm/i915: do full backlight setup at enable time
> > >
> > >     We should now have all the information we need to do a full
> > >     initialization of the backlight registers.
> > >
> > >     v2: Keep QUIRK_NO_PCH_PWM_ENABLE for now (Imre).
> > >
> > >     Signed-off-by: Jani Nikula <jani.nikula@intel.com>
> > >     Reviewed-by: Imre Deak <imre.deak@intel.com>
> > >     Signed-off-by: Daniel Vetter <daniel.vetter@ffwll.ch>
> > >
> > > Which is in 3.12.0????
> > >
> > > I'm not sure how that came to be.  Does that look right?  What other
> > > information would be required to track this down?
> 
> We've killed this again in 3.14 since we've hoped the backlight rework in
> there fixed it. For 3.15 we finally have the right fix - vbt has a bit
> telling us not to look at the integrated PWM for the panel.
> 
> For 3.14 we will (again) resurrect the quirk because the vbt thing is a
> bit too risky an imo needs a full -rc cycle for testing. But that revert
> is currently stalled because Greg KH is travelling too much ;-)
> 
> Cc'ing him to make sure that patch doesn't miss the next 3.14.x release.

What specific patch are you wanting to make sure makes it in?  I've been
avoiding all of the drm patches so far for 3.14.y as it's an easy thing
to do, but I'll eventually have to start paying attention to them :)

thanks,

greg k-h
