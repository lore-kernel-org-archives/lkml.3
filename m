Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757208AbaDVPe1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Apr 2014 11:34:27 -0400
Received: from mail001.aei.ca ([206.123.6.130]:45831 "EHLO mail001.aei.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756760AbaDVPeW convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Apr 2014 11:34:22 -0400
From: Ed Tomlinson <edt@aei.ca>
To: Alex Deucher <alexdeucher@gmail.com>
Cc: Ken Moffat <zarniwhoop@ntlworld.com>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: 3.15.0-rc2 radeon HD 7480D [Aruba] blank display
Date: Tue, 22 Apr 2014 11:34:14 -0400
Message-ID: <5851435.BbPITSaS3V@grover>
Organization: me
User-Agent: KMail/4.13 (Linux/3.15.0-1-git; KDE/4.13.0; x86_64; ; )
In-Reply-To: <CADnq5_OPQdict2MoUFDcLB0AXjkg9Np4W+U6O+RR8mExWKt-Rw@mail.gmail.com>
References: <20140421203207.GA27025@milliways> <20140422023410.GB1709@milliways> <CADnq5_OPQdict2MoUFDcLB0AXjkg9Np4W+U6O+RR8mExWKt-Rw@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 22 April 2014 01:54:01 Alex Deucher wrote:
> On Mon, Apr 21, 2014 at 10:34 PM, Ken Moffat <zarniwhoop@ntlworld.com> wrote:
> > On Tue, Apr 22, 2014 at 03:31:06AM +0100, Ken Moffat wrote:
> >
> > [ resending, somehow lkml dropped out of the Cc. ]
> >
> >> On Tue, Apr 22, 2014 at 12:19:40AM +0100, Ken Moffat wrote:
> >> > On Mon, Apr 21, 2014 at 05:29:27PM -0400, Ed Tomlinson wrote:
> >>
> >> > > Ken,
> >> > >
> >> > > You might want to try reverting:
> >> > >
> >> > > commit 379dfc25e257ffe10eb53b86d2375f7c0f4f33ef
> >> > > Author: Alex Deucher <alexdeucher@gmail.com>
> >> > > Date:   Mon Apr 7 10:33:46 2014 -0400
> >> > >
> >> > >     drm/radeon/dp: switch to the common i2c over aux code
> >> > >
> >> > >     Provides a nice cleanup in radeon.
> >> > >
> >> > >     Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
> >> > >     Signed-off-by: Christian König <christian.koenig@amd.com>
> >> > >
> >> > > This fixed a similar problem here (see the drm pull thread for rc1)
> >> > >
> >> > > Thanks
> >> > > Ed Tomlinson
> >> >
> >> >  Tried reverting that from rc2, but it didn't help.  Thanks anyway.
> >> >
> >>
> >>  Well, I *believed* I had created a patch for that commit, and
> >> reverted it from -rc2 with patch -R.  But I've now bisected through
> >> drivers/gpu/drm between v3.14.0 and v3.15-rc2 and the bisection
> >> pointed to that same commit, so I guess I did something wrong.
> >>
> >>  There were a couple of other issues along the way (mounting nfs
> >> hung on one commit, startx hung on several of the commits, but I've
> >> marked those as "good" because I had a display, even if the system
> >> was not usable).
> >>
> >>  I've now gone back to linus' tree that I cloned a few hours ago,
> >> i.e.
> >> commit c089b229dfdd09d59a11d8bc2344bf8196d575ce
> >> Merge: 9ac03675010a 0565103d1adb
> >> Author: Linus Torvalds <torvalds@linux-foundation.org>
> >> Date:   Mon Apr 21 10:05:35 2014 -0700
> >>
> >>     Merge branch 'for-linus' of
> >> git://git.kernel.org/pub/scm/linux/kernel/git/rw/uml
> >>
> >> created a branch, and *definitely* reverted
> >> 379dfc25e257ffe10eb53b86d2375f7c0f4f33ef (using git revert) in that
> >> branch.  And this version works fine.
> >>
> >>  So belatedly I see that I seem to have the same problem as Ed.  Or
> >> at least that the same commit is causing both our problems.
> >>
> >>  Alex - do you need any more information from me to help with this ?
> 
> The attached patch should fix it.

And it does here (on bonaire, r7 260x).  You can add my tested by

Tested-by: Ed Tomlinson <edtoml@gmail.com>

Thanks,
Ed Tomlinson
