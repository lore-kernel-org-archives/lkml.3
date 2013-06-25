Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752857Ab3FYVOW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Jun 2013 17:14:22 -0400
Received: from oproxy5-pub.bluehost.com ([67.222.38.55]:59756 "HELO
	oproxy5.bluehost.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with SMTP id S1752551Ab3FYVOT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Jun 2013 17:14:19 -0400
X-Greylist: delayed 399 seconds by postgrey-1.27 at vger.kernel.org; Tue, 25 Jun 2013 17:14:19 EDT
Date: Tue, 25 Jun 2013 14:09:38 -0700
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: Shuah Khan <shuah.kh@samsung.com>
Cc: Daniel Vetter <daniel.vetter@ffwll.ch>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Chris Wilson <chris@chris-wilson.co.uk>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "shuahkhan@gmail.com" <shuahkhan@gmail.com>,
        Dave Airlie <airlied@redhat.com>,
        intel-gfx <intel-gfx@lists.freedesktop.org>
Subject: Re: Linux 3.10-rc7
Message-ID: <20130625140938.4be14168@jbarnes-desktop>
In-Reply-To: <B8EFE96D1287C24090BAD9D858E15E617306DD@sisaex02sj>
References: <CA+55aFz1yMZ1q5daHdTA91pW5QtQ1Yids1dLD9b2JC-ruicNQw@mail.gmail.com>
	<B8EFE96D1287C24090BAD9D858E15E6172FFB9@sisaex02sj>
	<CA+55aFxuB_nx8fZ_kN8U=fMFOq43cKZC_HJbj=6vKo7-fDqNuw@mail.gmail.com>
	<CAKMK7uH0q1vSaVRigtZD2pf5ZeVLEv1sn+tsiO7ZWjJdt=DwBA@mail.gmail.com>
	<20130625125437.6e7bb2d4@jbarnes-desktop>
	<B8EFE96D1287C24090BAD9D858E15E617305B4@sisaex02sj>
	<20130625130816.55e6cb80@jbarnes-desktop>
	<B8EFE96D1287C24090BAD9D858E15E617306DD@sisaex02sj>
X-Mailer: Claws Mail 3.8.0 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Identified-User: {10642:box514.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 67.161.37.189 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 25 Jun 2013 20:51:27 +0000
Shuah Khan <shuah.kh@samsung.com> wrote:

> On 06/25/2013 02:06 PM, Jesse Barnes wrote:
> > On Tue, 25 Jun 2013 19:59:28 +0000
> > Shuah Khan <shuah.kh@samsung.com> wrote:
> >
> >> On 06/25/2013 01:52 PM, Jesse Barnes wrote:
> >>> On Tue, 25 Jun 2013 21:37:37 +0200
> >>> Daniel Vetter <daniel.vetter@ffwll.ch> wrote:
> >>>
> >>
> >>>>
> >>>> Adding more lists to cc + Jesse since he's the guilty one for the
> >>>> vt-switchless state restore stuff.
> >>>
> >>> Yeah, looks like we don't fetch the PLL state on resume from hibernate,
> >>> leading to this warning.  The refcount is nonzero, indicating the pll
> >>> is in use, but the active field is clear, which means we're missing an
> >>> update somewhere.
> >>>
> >>> Shuah, just to confirm, does your resume actually work ok aside from
> >>> the warning?  I *think* it's harmless in this case, but does indicate a
> >>> real bug in our state tracking... trying to come up with a patch now.
> >>>
> >>> Thanks,
> >>>
> >>
> >> Resume works just fine. I see it take longer for it to suspend compared
> >> to 3.9.7 and then resumes just fine. Suspend taking longer very well
> >> could be because of this warn_on. Other than this warn_on I haven't
> >> noticed any other problems.
> >
> > Here's the patch I'm testing now, can you give it a try?
> >
> 
> Jesse,
> 
> With this patch warn_on went away. Resume worked. I started seeing:
> 
> [   78.733062] mei_me 0000:00:16.0: unexpected reset: dev_state = RESETTING
> [   78.733079] mei_me 0000:00:16.0: reset: wrong host start response
> [   78.733082] mei_me 0000:00:16.0: unexpected reset: dev_state = RESETTING
> 
> over and over again after resume from reboot mode suspend. dmesg filled 
> up with these messages.
> 
> I did suspend to disk shutdown mode right away. Resume worked, no 
> warn_ons, and no mei_me messages.

Ok good, so that means the new stuff we have queued will likely work
too.

I'll leave it up to Daniel and Linus whether we just kill this warning
for now though, or apply the state fetching patch.

-- 
Jesse Barnes, Intel Open Source Technology Center
