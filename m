Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933084AbaDVPqk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Apr 2014 11:46:40 -0400
Received: from mail001.aei.ca ([206.123.6.130]:46167 "EHLO mail001.aei.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750993AbaDVPqg convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Apr 2014 11:46:36 -0400
From: Ed Tomlinson <edt@aei.ca>
To: Dave Airlie <airlied@linux.ie>
Cc: torvalds@linux-foundation.org, linux-kernel@vger.kernel.org,
        DRI mailing list <dri-devel@lists.freedesktop.org>,
        Christian =?ISO-8859-1?Q?K=F6nig?= <christian.koenig@amd.com>,
        Alex Deucher <alexdeucher@gmail.com>
Subject: Re: [git pull] drm fixes
Date: Tue, 22 Apr 2014 11:46:28 -0400
Message-ID: <10435496.M4aSBzoVye@grover>
Organization: me
User-Agent: KMail/4.13 (Linux/3.15.0-1-git; KDE/4.13.0; x86_64; ; )
In-Reply-To: <1549585.kmUPduLgev@grover>
References: <alpine.DEB.2.00.1404190810001.7507@skynet.skynet.ie> <2619529.mEMJol0YfM@grover> <1549585.kmUPduLgev@grover>
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 21 April 2014 17:26:15 Ed Tomlinson wrote:
> On Monday 21 April 2014 15:08:24 Ed Tomlinson wrote:
> > On Monday 21 April 2014 10:25:25 Ed Tomlinson wrote:
> > > On Saturday 19 April 2014 21:03:05 Markus Trippelsdorf wrote:
> > > > On 2014.04.19 at 08:19 +0100, Dave Airlie wrote:
> > > > > 
> > > > > Unfortunately this contains no easter eggs, its a bit larger than I'd 
> > > > > like, but I included a patch that just moves code from one file to another 
> > > > > and I'd like to avoid merge conflicts with that later, so it makes it seem 
> > > > > worse than it is,
> > > > 
> > > > > Christian König (2):
> > > > >       drm/radeon: apply more strict limits for PLL params v2
> > > > >       drm/radeon: improve PLL params if we don't match exactly v2
> > > > 
> > > > commit f8a2645ecede4eaf90b3d785f2805c8ecb76d43e
> > > > Author: Christian König <christian.koenig@amd.com>
> > > > Date:   Wed Apr 16 11:54:21 2014 +0200
> > > > 
> > > >     drm/radeon: improve PLL params if we don't match exactly v2
> > > > 
> > > > The commit above causes my monitor to just stay blank after boot.
> > > > No framebuffer, no Xorg, no nothing. I'm using a Radeon RS780.
> 
> Reverting 
> 
> commit 379dfc25e257ffe10eb53b86d2375f7c0f4f33ef
> Author: Alex Deucher <alexdeucher@gmail.com>
> Date:   Mon Apr 7 10:33:46 2014 -0400
> 
>     drm/radeon/dp: switch to the common i2c over aux code
>     
>     Provides a nice cleanup in radeon.
>     
>     Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
>     Signed-off-by: Christian König <christian.koenig@amd.com>
> 
> Restores the display - no more i2c errors

This fixed here without reverts by the patch from Alex Deucher attached in the thread: 
"Re: 3.15.0-rc2 radeon HD 7480D [Aruba] blank display"

Thanks
Ed

> > > I have the same symptoms with rc2 and a r7 260x using display port.  I cannot 
> > > seem to get a dmesg of a failure (I _really_ need to figure out how to add
> > > a serial console).  I'll try reverting once I figure out how to get pacman to
> > > do a revert when building from git.
> > 
> > Neither reverting the above patch or add the fix from "https://bugs.freedesktop.org/show_bug.cgi?id=77673"
> > helps here.  I managed to get dmesg(s) from 14.1 and 15-rc2.  The major difference has to do with i2c.  On the
> > 14.1 kernel I see:

