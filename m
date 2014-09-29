Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752926AbaI2VTh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Sep 2014 17:19:37 -0400
Received: from mout.gmx.net ([212.227.17.21]:61361 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750970AbaI2VTg convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Sep 2014 17:19:36 -0400
MIME-Version: 1.0
Message-ID: <trinity-ff6d6a3f-e1a7-4d9b-a199-3fd66138f758-1412025565926@3capp-gmx-bs36>
From: "Heinrich Schuchardt" <xypron.glpk@gmx.de>
To: "Yann Droneaud" <ydroneaud@opteya.com>
Cc: "Greg Kroah-Hartman" <gregkh@linuxfoundation.org>,
        "Colin Cross" <ccross@android.com>,
        "John Stultz" <john.stultz@linaro.org>,
        "Daniel Vetter" <daniel@ffwll.ch>,
        "Sumit Semwal" <sumit.semwal@linaro.org>,
        "Masanari Iida" <standby24x7@gmail.com>,
        "Daeseok Youn" <daeseok.youn@gmail.com>,
        "Maarten Lankhorst" <maarten.lankhorst@canonical.com>,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        "Yann Droneaud" <ydroneaud@opteya.com>
Subject: Aw: Re: [PATCH 1/1] staging : android : sync : get_unused_fd
Content-Type: text/plain; charset=UTF-8
Date: Mon, 29 Sep 2014 23:19:26 +0200
Importance: normal
Sensitivity: Normal
In-Reply-To: <1412013833.9750.12.camel@localhost.localdomain>
References: <1411807958-1522-1-git-send-email-xypron.glpk@gmx.de>,
 <1412013833.9750.12.camel@localhost.localdomain>
Content-Transfer-Encoding: 8BIT
X-UI-Message-Type: mail
X-Priority: 3
X-Provags-ID: V03:K0:pVznaouJbDcrwjQxpFkOQ0GSK7AKbJ3VlT4Iugbezka
 9do3kJ+qNJnFSfQfNlD177zY5ueM05yFWhkB0A8ooAoCl3ilTk
 oT0fC8ksXRXIi/8Goui69W7/mub3IoVsxdUxRFfJ0ga2jIhvOz
 dMMfen/dVlKQx9U7VpfblH6C+JRdpcaQq9FWgOQCPI7X2e8b+h
 TYVSWzlUaWy+el2Br34yeRfj2uNvktjhFsbKgo+PO2Awjtep5Y
 sYmFpu49lPI/DKLSlDK4m/XvwKC3/QZ+Nu5Kf8YBP6qTpqE+8D pthoz8=
X-UI-Out-Filterresults: notjunk:1;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> Gesendet: Montag, 29. September 2014 um 20:03 Uhr
> Von: "Yann Droneaud" <ydroneaud@opteya.com>
> An: "Heinrich Schuchardt" <xypron.glpk@gmx.de>
> Cc: "Greg Kroah-Hartman" <gregkh@linuxfoundation.org>, "Colin Cross" <ccross@android.com>, "John Stultz" <john.stultz@linaro.org>, "Daniel Vetter" <daniel@ffwll.ch>, "Sumit Semwal" <sumit.semwal@linaro.org>, "Masanari Iida" <standby24x7@gmail.com>, "Daeseok Youn" <daeseok.youn@gmail.com>, "Maarten Lankhorst" <maarten.lankhorst@canonical.com>, devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org, "Yann Droneaud" <ydroneaud@opteya.com>
> Betreff: Re: [PATCH 1/1] staging : android : sync : get_unused_fd
>
> Hi,
> 
> Le samedi 27 septembre 2014 à 10:52 +0200, Heinrich Schuchardt a écrit :
> > sync.h recommends to use get_unused_fd which does not set
> > O_CLOEXEC while the rest of the android tree uses
> > get_unused_fd_flags and sets O_CLOEXEC.
> > 
> > The patch adjust the comment.
> > 
> 
> I'd like to add this patch to my patchset which try to remove
> get_unused_fd() in favor of get_unused_fd_flags():
> 
> http://lkml.kernel.org/r/cover.1411562410.git.ydroneaud@opteya.com
> 
> But having O_CLOEXEC is welcome but not strictly needed,
> so I think the patch should be reworked to not require O_CLOEXEC.

All calls to get_unused_fd_flags() in directory drivers/staging/android
use O_CLOEXEC. That is why I guess it is correct to put it into the
sync.h comment too.

Your patch set inspired me to look for further usages of get_unused_fd().
But I think the patch below is valid even if get_unused_fd() should not
be removed from the kernel.

Best regards

Heinrich 

> 
> > Signed-off-by: Heinrich Schuchardt <xypron.glpk@gmx.de>
> > ---
> >  drivers/staging/android/sync.h | 3 ++-
> >  1 file changed, 2 insertions(+), 1 deletion(-)
> > 
> > diff --git a/drivers/staging/android/sync.h b/drivers/staging/android/sync.h
> > index 66b0f43..a21b79f 100644
> > --- a/drivers/staging/android/sync.h
> > +++ b/drivers/staging/android/sync.h
> > @@ -293,7 +293,8 @@ void sync_fence_put(struct sync_fence *fence);
> >   * @fence:	fence to install
> >   * @fd:		file descriptor in which to install the fence
> >   *
> > - * Installs @fence into @fd.  @fd's should be acquired through get_unused_fd().
> > + * Installs @fence into @fd.  @fd's should be acquired through
> > + * get_unused_fd_flags(O_CLOEXEC).
> 
> I think it will be better to have something like:
> 
>     get_unused_fd_flags(flags), with flags either provided by userspace
>     or set to O_CLOEXEC.
> 
> 
> >   */
> >  void sync_fence_install(struct sync_fence *fence, int fd);
> >  
> 
> Regards.
> 
> -- 
> Yann Droneaud
> OPTEYA
> 
> 
>
