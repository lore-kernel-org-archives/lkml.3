Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752596AbaLEJQI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Dec 2014 04:16:08 -0500
Received: from mail-wg0-f49.google.com ([74.125.82.49]:61910 "EHLO
	mail-wg0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751881AbaLEJQD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Dec 2014 04:16:03 -0500
Date: Fri, 5 Dec 2014 10:16:30 +0100
From: Daniel Vetter <daniel@ffwll.ch>
To: John Stultz <john.stultz@linaro.org>
Cc: Daniel Vetter <daniel.vetter@ffwll.ch>,
        Chris Wilson <chris@chris-wilson.co.uk>,
        Intel Graphics Development <intel-gfx@lists.freedesktop.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Daniel Vetter <daniel.vetter@intel.com>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [Intel-gfx] [PATCH] drm/i915: compute wait_ioctl timeout
 correctly
Message-ID: <20141205091630.GI20350@phenom.ffwll.local>
Mail-Followup-To: John Stultz <john.stultz@linaro.org>,
	Chris Wilson <chris@chris-wilson.co.uk>,
	Intel Graphics Development <intel-gfx@lists.freedesktop.org>,
	LKML <linux-kernel@vger.kernel.org>,
	Daniel Vetter <daniel.vetter@intel.com>,
	Thomas Gleixner <tglx@linutronix.de>
References: <20141202163506.GG18921@nuc-i3427.alporthouse.com>
 <CALAqxLUCD7zxyNrZJnKUE3wbORyZez-bDvScGLXyTjVvvZdinA@mail.gmail.com>
 <20141203143029.GF32117@phenom.ffwll.local>
 <CALAqxLUYL91khoW=oLAp_FtPBrDnSazfYqVpkXYTBJsTjDsv+g@mail.gmail.com>
 <20141204104228.GJ32117@phenom.ffwll.local>
 <CALAqxLX0hvv5DeLRji7g+jVX+F2ipU_f04YtehjFnSV4i==q4w@mail.gmail.com>
 <CAKMK7uHQzqqtg=HBDfyMdZbOGNuzaMz10XeDdCnxkta+R8Sv9Q@mail.gmail.com>
 <CALAqxLUGh=2LF4kvK231P7AbChUmXGsHVvsD2PQcM_SHPpGvyw@mail.gmail.com>
 <CAKMK7uGwTCK0UNW93zVCmBoJLnX7VQ-UkQHhccZN-oDod0r8kw@mail.gmail.com>
 <CALAqxLXbb-K0VrEKXFMe2gtvSt0+Aur=oSD9EuBBY0xLjOMUCw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CALAqxLXbb-K0VrEKXFMe2gtvSt0+Aur=oSD9EuBBY0xLjOMUCw@mail.gmail.com>
X-Operating-System: Linux phenom 3.16-2-amd64 
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 04, 2014 at 12:35:44PM -0800, John Stultz wrote:
> On Thu, Dec 4, 2014 at 10:51 AM, Daniel Vetter <daniel.vetter@ffwll.ch> wrote:
> > On Thu, Dec 4, 2014 at 7:16 PM, John Stultz <john.stultz@linaro.org> wrote:
> >> On Thu, Dec 4, 2014 at 9:50 AM, Daniel Vetter <daniel.vetter@ffwll.ch> wrote:
> >>> On Thu, Dec 4, 2014 at 6:42 PM, John Stultz <john.stultz@linaro.org> wrote:
> >>>> Sigh. So you're going to make me write a separate patch that moves it over?
> >>>
> >>> We've written it already, Imre posted the link to the old discussion:
> >>>
> >>> https://lkml.org/lkml/2013/5/10/187
> >>>
> >>> But if the first attempt doesn't sufficiently stick I tend to chase
> >>> the patches any more. But if you want to resurrect this I could ping
> >>> Imre and ask him to pick it up again or you could rebase his patches.
> >>
> >> Well, last I saw the initial patch was buggy, no? I don't think I saw
> >> it being resubmitted.
> >
> > I didn't see your reply in that thread nor in the v2 follow up at
> > http://marc.info/?l=linux-kernel&m=136854294730957&w=2 Maybe I missed
> > it, but response seems to have been lukewarm overall.
> 
> Ok, I wasn't cc'ed on the v2, thanks for the pointer.  There's some
> general lukewarmness to all things jiffies, since getting rid of them
> has been a long term goal forever. But overall that patch set seemed
> ok (though I'm not a fan of macro generation of functions). But minor
> details..

btw have you seen the other fallout from the ktime->nsec conversion in
i915?

http://www.spinics.net/lists/intel-gfx/msg56445.html

Is this just the inaccuracy of nsec_to_jiffies (and why it explicitly
states that this is for the scheduler only) or is there some bigger fish
in there?

Insight very much appreciated.

Thanks, Daniel
-- 
Daniel Vetter
Software Engineer, Intel Corporation
+41 (0) 79 365 57 48 - http://blog.ffwll.ch
