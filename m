Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754601Ab3JXK5w (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Oct 2013 06:57:52 -0400
Received: from mail-wg0-f45.google.com ([74.125.82.45]:39298 "EHLO
	mail-wg0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754003Ab3JXK5u (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Oct 2013 06:57:50 -0400
Date: Thu, 24 Oct 2013 11:57:45 +0100
From: Tejun Heo <tj@kernel.org>
To: "Serge E. Hallyn" <serge@hallyn.com>
Cc: Serge Hallyn <serge.hallyn@ubuntu.com>,
        Containers <containers@lists.linux-foundation.org>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        lkml <linux-kernel@vger.kernel.org>
Subject: Re: [RFC PATCH 1/2] devices cgroup: allow can_attach() if ns_capable
Message-ID: <20131024105745.GC13159@mtj.dyndns.org>
References: <20130723181606.GA6342@sergelap>
 <20130723183018.GF21100@mtj.dyndns.org>
 <20130723183841.GA9021@tp>
 <CAOS58YPynQ-QBx5nZEnYrP5kGTVvv9VAj0cV0aYeikTitvTQbA@mail.gmail.com>
 <20131023004130.GA12788@mail.hallyn.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131023004130.GA12788@mail.hallyn.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 23, 2013 at 12:41:30AM +0000, Serge E. Hallyn wrote:
> Quoting Tejun Heo (tj@kernel.org):
> > On Tue, Jul 23, 2013 at 2:38 PM, Serge Hallyn <serge.hallyn@ubuntu.com> wrote:
> > > This doesn't delegate it into the container.  It allows me, on the host,
> > > to set the cgroup for a container.
> > 
> > Hmmm? I'm a bit confused. Isn't the description saying that the patch
> > allows pseudo-root in userns to change cgroup membership even if it
> > isn't actually root?
> > 
> > Besides, I find the whole check rather bogus and would actually much
> > prefer just nuking the check and just follow the standard permission
> > checks.
> 
> Can we please nuke it like this then?
> 
> From b840083ec8fa1f0645ae925c79db3dc51edd019c Mon Sep 17 00:00:00 2001
> From: Serge Hallyn <serge.hallyn@ubuntu.com>
> Date: Wed, 23 Oct 2013 01:34:00 +0200
> Subject: [PATCH 1/1] device_cgroup: remove can_attach
> 
> It is really only wanting to duplicate a check which is already done by the
> cgroup subsystem.
> 
> With this patch, user jdoe still cannot move pid 1 into a devices cgroup
> he owns, but now he can move his own other tasks into devices cgroups.
> 
> Signed-off-by: Serge Hallyn <serge.hallyn@ubuntu.com>
> Cc: Aristeu Rozanski <aris@redhat.com>
> Cc: Tejun Heo <tj@kernel.org>

Applied to cgroup/for-3.13.  Thanks.

-- 
tejun
