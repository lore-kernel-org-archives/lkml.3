Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756657AbaE2GDb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 May 2014 02:03:31 -0400
Received: from userp1040.oracle.com ([156.151.31.81]:30742 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751547AbaE2GDa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 May 2014 02:03:30 -0400
Date: Thu, 29 May 2014 09:03:11 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Alex Deucher <alexdeucher@gmail.com>
Cc: Ken Moffat <zarniwhoop@ntlworld.com>,
        Daniel Vetter <daniel.vetter@ffwll.ch>,
        Dave Airlie <airlied@redhat.com>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: Resume from suspend broken in 3.15. (bisected)
Message-ID: <20140529060311.GU17724@mwanda>
References: <20140528172521.GA9945@milliways>
 <20140528234927.GA18638@milliways>
 <CADnq5_PWigm5e4CwnfW+3TaohbFo82uDpiCMftL=OmRvCkJQzQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CADnq5_PWigm5e4CwnfW+3TaohbFo82uDpiCMftL=OmRvCkJQzQ@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 28, 2014 at 08:26:53PM -0400, Alex Deucher wrote:
> On Wed, May 28, 2014 at 7:49 PM, Ken Moffat <zarniwhoop@ntlworld.com> wrote:
> > On Wed, May 28, 2014 at 06:25:21PM +0100, Ken Moffat wrote:
> >> Hi Daniel,
> >>
> >
> >  [ correcting details, confirming that reverting this does fix the
> > problem, adding Cc:s ]
> >
> >>  I've only started full testing of 3.15 on one of my machines now
> >> that -rc7 has been released (this one had two issues in the radeon
> >> code, second was fixed in rc7).  Unfortunately, suspend to RAM
> >> (pm-suspend), or rather the wake-up, is broken on this box [ my
> >> other two boxes are fine in rc7 ].
> >>
> >> Bisection identified one of your commits -
> >>
> >> commit 25f397a429dfa43f22c278d0119a60a343aa568f
> >> Author: Daniel Vetter <daniel.vetter@ffwll.ch>
> >> Date:   Fri Jul 19 18:57:11 2013 +0200
> >>
> >>     drm/crtc-helper: explicit DPMS on after modeset
> >>
> >>     Atm the crtc helper implementation of set_config has really
> >>     inconsisten semantics: If just an fb update is good enough, dpms state
> >>     will be left as-is, but if we do a full modeset we force everything to
> >>     dpms on.
> >>
> >>     This change has already been applied to the i915 modeset code in
> >>
> >> ('git show' stops at that point)
> >
> >  update : I've no idea what was going on there, nor for the problem
> > with attempting to revert it.  I've now gone back into git,
> > extracted the full commit to a file with 'git show', and then used
> > git apply -R to revert it from 3.15-rc7.  That version wakes up from
> > suspend to RAM, 3.15-rc7 itself did not.
> >
> >  Maybe I was still in git log when I thought I was on the command
> > line.  Anyway, snipping git's view of my failed attempt to revert
> > it, and adding Dan and Alex who were CC'd on the commit.
> >
> 
> Duplicate of:
> https://bugzilla.kernel.org/show_bug.cgi?id=74751
> and also reported here:
> https://lkml.org/lkml/2014/5/2/388
> Unless there is a good reason to keep the commit, I'd say let's just revert it.
>

Yes.  Let's revert it.

regards,
dan carpenter

