Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752646AbaENTTe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 May 2014 15:19:34 -0400
Received: from mail-ie0-f175.google.com ([209.85.223.175]:50076 "EHLO
	mail-ie0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752079AbaENTTc convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 May 2014 15:19:32 -0400
MIME-Version: 1.0
X-Originating-IP: [84.73.67.144]
In-Reply-To: <20140514204738.60a2f49c@neptune.home>
References: <20140512031029.GA18875@psychosnugglebunnies.net>
	<20140514204738.60a2f49c@neptune.home>
Date: Wed, 14 May 2014 21:19:32 +0200
X-Google-Sender-Auth: mnidkIx2VASYBGy36AbV3gMHMsw
Message-ID: <CAKMK7uFDJym3fKewmivps_894_P_ifQ0TYeBXg5oevP6wrz1zw@mail.gmail.com>
Subject: Re: [Intel-gfx] 3.14.3 i915 dead display under X11
From: Daniel Vetter <daniel@ffwll.ch>
To: =?UTF-8?Q?Bruno_Pr=C3=A9mont?= <bonbons@linux-vserver.org>,
        Greg KH <gregkh@linuxfoundation.org>
Cc: Carbonated Beverage <ramune@psychosnugglebunnies.net>,
        Intel Graphics Development <intel-gfx@lists.freedesktop.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 14, 2014 at 08:47:38PM +0200, Bruno Prémont wrote:
> CCing intel-gfx as otherwise it will probably not get seen by developers.
>
> On Sun, 11 May 2014 Carbonated Beverage <ramune@psychosnugglebunnies.net> wrote:
> > Bisecting from 3.13.6 (good) to 3.14.3 (bad) ended up with...
> >
> > commit b35684b8fa94e04f55fd38bf672b737741d2f9e2
> > Author: Jani Nikula <jani.nikula@intel.com>
> > Date:   Thu Nov 14 12:13:41 2013 +0200
> >
> >     drm/i915: do full backlight setup at enable time
> >
> >     We should now have all the information we need to do a full
> >     initialization of the backlight registers.
> >
> >     v2: Keep QUIRK_NO_PCH_PWM_ENABLE for now (Imre).
> >
> >     Signed-off-by: Jani Nikula <jani.nikula@intel.com>
> >     Reviewed-by: Imre Deak <imre.deak@intel.com>
> >     Signed-off-by: Daniel Vetter <daniel.vetter@ffwll.ch>
> >
> > Which is in 3.12.0????
> >
> > I'm not sure how that came to be.  Does that look right?  What other
> > information would be required to track this down?

We've killed this again in 3.14 since we've hoped the backlight rework in
there fixed it. For 3.15 we finally have the right fix - vbt has a bit
telling us not to look at the integrated PWM for the panel.

For 3.14 we will (again) resurrect the quirk because the vbt thing is a
bit too risky an imo needs a full -rc cycle for testing. But that revert
is currently stalled because Greg KH is travelling too much ;-)

Cc'ing him to make sure that patch doesn't miss the next 3.14.x release.

My apologies for breaking this machine so often :(
-Daniel
-- 
Daniel Vetter
Software Engineer, Intel Corporation
+41 (0) 79 365 57 48 - http://blog.ffwll.ch
