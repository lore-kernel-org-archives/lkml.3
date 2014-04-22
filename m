Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753942AbaDVCeP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Apr 2014 22:34:15 -0400
Received: from know-smtprelay-omc-8.server.virginmedia.net ([80.0.253.72]:53759
	"EHLO know-smtprelay-omc-8.server.virginmedia.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751371AbaDVCeN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Apr 2014 22:34:13 -0400
X-Originating-IP: [81.106.150.188]
X-Spam: 0
X-Authority: v=2.1 cv=TM7LSjVa c=1 sm=1 tr=0 a=DGj713NdaxKrsjjgQne7PA==:117
 a=DGj713NdaxKrsjjgQne7PA==:17 a=J0QyKEt1u0cA:10 a=BdtlclQ1lucA:10
 a=uObrxnre4hsA:10 a=IkcTkHD0fZMA:10 a=NLZqzBF-AAAA:8 a=pGLkceISAAAA:8
 a=zd2uoN0lAAAA:8 a=Z4Rwk6OoAAAA:8 a=VwQbUJbxAAAA:8 a=FuE5Ay7eAgbjKXUaVF8A:9
 a=QEXdDO2ut3YA:10 a=MSl-tDqOz04A:10 a=wu_e27o_rKQA:10 a=jbrJJM5MRmoA:10
Date: Tue, 22 Apr 2014 03:34:10 +0100
From: Ken Moffat <zarniwhoop@ntlworld.com>
To: Ed Tomlinson <edt@aei.ca>
Cc: Alex Deucher <alexdeucher@gmail.com>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: 3.15.0-rc2 radeon HD 7480D [Aruba] blank display
Message-ID: <20140422023410.GB1709@milliways>
References: <20140421203207.GA27025@milliways>
 <5549363.XIKIYZeGzc@grover>
 <20140422023106.GA1709@milliways>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20140422023106.GA1709@milliways>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 22, 2014 at 03:31:06AM +0100, Ken Moffat wrote:

[ resending, somehow lkml dropped out of the Cc. ]

> On Tue, Apr 22, 2014 at 12:19:40AM +0100, Ken Moffat wrote:
> > On Mon, Apr 21, 2014 at 05:29:27PM -0400, Ed Tomlinson wrote:
> 
> > > Ken,
> > > 
> > > You might want to try reverting:
> > > 
> > > commit 379dfc25e257ffe10eb53b86d2375f7c0f4f33ef
> > > Author: Alex Deucher <alexdeucher@gmail.com>
> > > Date:   Mon Apr 7 10:33:46 2014 -0400
> > > 
> > >     drm/radeon/dp: switch to the common i2c over aux code
> > >     
> > >     Provides a nice cleanup in radeon.
> > >     
> > >     Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
> > >     Signed-off-by: Christian König <christian.koenig@amd.com>
> > > 
> > > This fixed a similar problem here (see the drm pull thread for rc1)
> > > 
> > > Thanks
> > > Ed Tomlinson
> > 
> >  Tried reverting that from rc2, but it didn't help.  Thanks anyway.
> > 
> 
>  Well, I *believed* I had created a patch for that commit, and
> reverted it from -rc2 with patch -R.  But I've now bisected through
> drivers/gpu/drm between v3.14.0 and v3.15-rc2 and the bisection
> pointed to that same commit, so I guess I did something wrong.
> 
>  There were a couple of other issues along the way (mounting nfs
> hung on one commit, startx hung on several of the commits, but I've
> marked those as "good" because I had a display, even if the system
> was not usable).
> 
>  I've now gone back to linus' tree that I cloned a few hours ago,
> i.e.
> commit c089b229dfdd09d59a11d8bc2344bf8196d575ce
> Merge: 9ac03675010a 0565103d1adb
> Author: Linus Torvalds <torvalds@linux-foundation.org>
> Date:   Mon Apr 21 10:05:35 2014 -0700
> 
>     Merge branch 'for-linus' of
> git://git.kernel.org/pub/scm/linux/kernel/git/rw/uml
> 
> created a branch, and *definitely* reverted
> 379dfc25e257ffe10eb53b86d2375f7c0f4f33ef (using git revert) in that
> branch.  And this version works fine.
> 
>  So belatedly I see that I seem to have the same problem as Ed.  Or
> at least that the same commit is causing both our problems.
> 
>  Alex - do you need any more information from me to help with this ?
> 
> ĸen
> -- 
> das eine Mal als Tragödie, dieses Mal als Farce

-- 
das eine Mal als Tragödie, dieses Mal als Farce
