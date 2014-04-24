Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756387AbaDXMJH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Apr 2014 08:09:07 -0400
Received: from twin.jikos.cz ([89.185.236.188]:57818 "EHLO twin.jikos.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753443AbaDXMHX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Apr 2014 08:07:23 -0400
X-Greylist: delayed 1661 seconds by postgrey-1.27 at vger.kernel.org; Thu, 24 Apr 2014 08:07:23 EDT
Date: Thu, 24 Apr 2014 13:39:30 +0200 (CEST)
From: Jiri Kosina <jikos@jikos.cz>
To: Pavel Machek <pavel@ucw.cz>
cc: Chris Wilson <chris@chris-wilson.co.uk>,
        Daniel Vetter <daniel.vetter@ffwll.ch>,
        intel-gfx <intel-gfx@lists.freedesktop.org>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        dri-devel <dri-devel@lists.freedesktop.org>,
        kernel list <linux-kernel@vger.kernel.org>
Subject: Re: 3.15-rc2: i915 regression: only top 20% of screen works in X
In-Reply-To: <20140424104252.GA6743@amd.pavel.ucw.cz>
Message-ID: <alpine.LRH.2.00.1404241336360.1491@twin.jikos.cz>
References: <20140423202248.GA3621@amd.pavel.ucw.cz> <CAKMK7uFT5eW8Y8kKvWO1P_aN=SHgP+bZWB8fO2mATKaO=_DNjA@mail.gmail.com> <20140423220952.GA3627@amd.pavel.ucw.cz> <20140424055023.GA31221@nuc-i3427.alporthouse.com> <20140424104252.GA6743@amd.pavel.ucw.cz>
User-Agent: Alpine 2.00 (LRH 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 24 Apr 2014, Pavel Machek wrote:

> > That says that i915.ko failed to initialise the GPU (or rather the GPU 
> > wasn't responding) and bailed during module load. The key line here is
> 
> > [drm:init_ring_common] *ERROR* render ring initialization failed ctl
> > 0001f001 head 00002034 tail 00000000 start 0012f000
> 
> Actually, I'm not using modules -- everything is build-in. Can you try
> that config? Perhaps you can then reproduce the failure.

> > Jiri has been seeing a similar issue creep in during resume, but it is 
> > not reliable enough to bisect. Is your boot failure reliable enough to 
> > bisect? Also drm-intel-nightly should mitigate this failure and allow 
> > i915.ko to continue to load and run X, which would be worth testing to 
> > make sure that works as intended.
> 
> So far it failed 100% of time, but this is my main machine, so
> bringing it down for extended periods is no-no.
> 
> Greetings to Prague :-). Jiri, do you have  i915 a module or build-in?

Hi there Pavel, long time no see :)

I have i915 built as a module.

The thing is, that I can't really bisect this; the problem is, that I've 
started seeing this quite a long time ago, but only very sporadically 
(something like once in 40 resumes). But it was getting gradually worse 
and worse with newer kernels, and with current tree (both Linus' tree and 
drm-intel-testing), I am getting it 100% reproducibly on every resume.

This makes bisection completely impossible though.

-- 
Jiri Kosina
