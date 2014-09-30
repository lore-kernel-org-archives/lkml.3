Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752735AbaI3T5h (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Sep 2014 15:57:37 -0400
Received: from ou.quest-ce.net ([195.154.187.82]:60183 "EHLO ou.quest-ce.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750967AbaI3T5g (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Sep 2014 15:57:36 -0400
Message-ID: <1412097349.4380.16.camel@localhost.localdomain>
From: Yann Droneaud <ydroneaud@opteya.com>
To: Heinrich Schuchardt <xypron.glpk@gmx.de>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Erik Gilling <konkers@android.com>, Colin Cross <ccross@android.com>,
        John Stultz <john.stultz@linaro.org>, Daniel Vetter <daniel@ffwll.ch>,
        Sumit Semwal <sumit.semwal@linaro.org>,
        Masanari Iida <standby24x7@gmail.com>,
        Daeseok Youn <daeseok.youn@gmail.com>,
        Maarten Lankhorst <maarten.lankhorst@canonical.com>,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Yann Droneaud <ydroneaud@opteya.com>
In-Reply-To: <trinity-ff6d6a3f-e1a7-4d9b-a199-3fd66138f758-1412025565926@3capp-gmx-bs36>
References: <1411807958-1522-1-git-send-email-xypron.glpk@gmx.de>
	 , <1412013833.9750.12.camel@localhost.localdomain>
	 <trinity-ff6d6a3f-e1a7-4d9b-a199-3fd66138f758-1412025565926@3capp-gmx-bs36>
Organization: OPTEYA
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 30 Sep 2014 19:15:49 +0200
Mime-Version: 1.0
X-Mailer: Evolution 3.10.4 (3.10.4-4.fc20) 
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2a01:e35:2e9f:6ac0:1d34:d55:2d28:af2e
X-SA-Exim-Mail-From: ydroneaud@opteya.com
Subject: Re: Aw: Re: [PATCH 1/1] staging : android : sync : get_unused_fd
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on ou.quest-ce.net)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Le lundi 29 septembre 2014 à 23:19 +0200, Heinrich Schuchardt a écrit :
> > Gesendet: Montag, 29. September 2014 um 20:03 Uhr
> > Von: "Yann Droneaud" <ydroneaud@opteya.com>
> > An: "Heinrich Schuchardt" <xypron.glpk@gmx.de>
> > Cc: "Greg Kroah-Hartman" <gregkh@linuxfoundation.org>, "Colin Cross" <ccross@android.com>, "John Stultz" <john.stultz@linaro.org>, "Daniel Vetter" <daniel@ffwll.ch>, "Sumit Semwal" <sumit.semwal@linaro.org>, "Masanari Iida" <standby24x7@gmail.com>, "Daeseok Youn" <daeseok.youn@gmail.com>, "Maarten Lankhorst" <maarten.lankhorst@canonical.com>, devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org, "Yann Droneaud" <ydroneaud@opteya.com>
> > Betreff: Re: [PATCH 1/1] staging : android : sync : get_unused_fd
> >
> > Hi,
> > 
> > Le samedi 27 septembre 2014 à 10:52 +0200, Heinrich Schuchardt a écrit :
> > > sync.h recommends to use get_unused_fd which does not set
> > > O_CLOEXEC while the rest of the android tree uses
> > > get_unused_fd_flags and sets O_CLOEXEC.
> > > 
> > > The patch adjust the comment.
> > > 
> > 
> > I'd like to add this patch to my patchset which try to remove
> > get_unused_fd() in favor of get_unused_fd_flags():
> > 
> > http://lkml.kernel.org/r/cover.1411562410.git.ydroneaud@opteya.com
> > 
> > But having O_CLOEXEC is welcome but not strictly needed,
> > so I think the patch should be reworked to not require O_CLOEXEC.
> 
> All calls to get_unused_fd_flags() in directory drivers/staging/android
> use O_CLOEXEC. That is why I guess it is correct to put it into the
> sync.h comment too.
> 

They use O_CLOEXEC because I've suggested it should be a good thing to
do it if possible, and Erik Gilling suggested it would be possible.

So please add a mention to commit 9c6cd3b39048 ('android/sync: use 
get_unused_fd_flags(O_CLOEXEC) instead o get_unused_fd()') and commit 
45acea57335e ('android/sw_sync: use get_unused_fd_flags(O_CLOEXEC) 
instead of get_unused_fd()').

> Your patch set inspired me to look for further usages of get_unused_fd().

I haven't grep through the source nor the documentation, so I failed to
notice this comment. I'm glad you've found it and going to fix it.

> But I think the patch below is valid even if get_unused_fd() should not
> be removed from the kernel.
> 

Getting a file descriptor with get_unused_fd_flags(O_CLOEXEC) is not
required to use sync_fence_install(): O_CLOEXEC is only one of the two
values having a meaning for get_unused_fd_flags(), and
sync_fence_install() doesn't care about it.

So I still prefer you use an alternate wording for the comment, so that
it match the behavor of sync_fence_install() and provide advice
regarding O_CLOEXEC usage.

Regards.


> Best regards
> 
> Heinrich 
> 
> > 
> > > Signed-off-by: Heinrich Schuchardt <xypron.glpk@gmx.de>
> > > ---
> > >  drivers/staging/android/sync.h | 3 ++-
> > >  1 file changed, 2 insertions(+), 1 deletion(-)
> > > 
> > > diff --git a/drivers/staging/android/sync.h b/drivers/staging/android/sync.h
> > > index 66b0f43..a21b79f 100644
> > > --- a/drivers/staging/android/sync.h
> > > +++ b/drivers/staging/android/sync.h
> > > @@ -293,7 +293,8 @@ void sync_fence_put(struct sync_fence *fence);
> > >   * @fence:	fence to install
> > >   * @fd:		file descriptor in which to install the fence
> > >   *
> > > - * Installs @fence into @fd.  @fd's should be acquired through get_unused_fd().
> > > + * Installs @fence into @fd.  @fd's should be acquired through
> > > + * get_unused_fd_flags(O_CLOEXEC).
> > 
> > I think it will be better to have something like:
> > 
> >     get_unused_fd_flags(flags), with flags either provided by userspace
> >     or set to O_CLOEXEC.
> > 
> > 
> > >   */
> > >  void sync_fence_install(struct sync_fence *fence, int fd);
> > >  

-- 
Yann Droneaud
OPTEYA


