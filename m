Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933903AbaFTQHO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jun 2014 12:07:14 -0400
Received: from mail-yh0-f42.google.com ([209.85.213.42]:59055 "EHLO
	mail-yh0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753347AbaFTQHL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jun 2014 12:07:11 -0400
From: Paul Moore <paul@paul-moore.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        James Morris <james.l.morris@oracle.com>,
        "Serge E. Hallyn" <serge@hallyn.com>
Subject: Re: linux-next: the selinux tree needs cleaning up
Date: Fri, 20 Jun 2014 12:06:28 -0400
Message-ID: <1474416.aEfMv8Ny53@sifl>
User-Agent: KMail/4.13.2 (Linux/3.14.8-gentoo; KDE/4.13.2; x86_64; ; )
In-Reply-To: <20140620085931.6427678d@canb.auug.org.au>
References: <20140618084046.1bce12cc@canb.auug.org.au> <3494783.s5KPIUO972@sifl> <20140620085931.6427678d@canb.auug.org.au>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday, June 20, 2014 08:59:31 AM Stephen Rothwell wrote:
> Hi Paul,

Hello again.

> On Thu, 19 Jun 2014 15:47:01 -0400 Paul Moore <paul@paul-moore.com> wrote:
> > I want to avoid use a -rcX release as the foundation of any of my trees;
> > the -rc releases aren't as stable and it goes against what we're trying
> > to do with the different Linux Security trees.  Unfortunately, based on
> > what I've read above, this seems to be incompatible with linux-next.
> 
> The problem with basing your development for v3.17 on v3.15 is that
> you  do not take into account any of the changes done by others during
> v3.16-rc1 (or even your upstream tree) some of which may be core API
> changes.

The way I currently do things - merge the latest major release on top of the 
existing #next and then start applying the new #next patches - does leave the 
SELinux tree a bit behind when it comes to other subsystems, but it does at 
least include all of the SELinux relevant patches.

I'll admit it isn't perfect, but it seems to work reasonably well for SELinux 
development, and it was the process used by the previous SELinux maintainer.

> > While I hate to split my development branch from the #next branch, it
> > seems
> 
> I don't want that either ...
> 
> > like that is the only way to accomplish both a reasonably current and
> > stable development tree and get the patches into linux-next.  Unless you,
> > or anyone else for that matter, has a different suggestion I'm going to
> > go ahead and turn the current SELinux #next branch into a development
> > branch and create a new #next branch that will be based on the most
> > current -rc1, this new #next branch will be created new for each major
> > release.  Not exactly what I was hoping for, but will that work?
> 
> Do you mean that your #next branch will just be a merge of -rc1 and
> your development branch?  That would not actually change anything
> (except that you would possibly take care of some conflicts for me).

Sort of, I would basically create a new #next branch for linux-next which 
would be created fresh from the latest -rc1 and I would cherry-pick the 
patches for linux-next from my development branch.  It would be a bit of a 
mess to be honest, but I'm trying to reconcile the SELinux development 
needs/wants with the linux-next needs/wants. 

> At the core, what is in linux-next should just be exactly what will be
> merged by your upstream.

That has been, and remains the goal for me as well.  However, there have been 
a number of problems with this in the past, even excluding the latest merge 
window; I believe these past problems are what you are seeing now.

I am hopeful that these issues are behind us now, at least for the most part.

> My real point here is that that is not what has happened recently.  The
> patches in your tree have been cherry-picked or rebased into James' or
> Serge's trees, not merged so we now have duplication.  This is what you need
> to solve with James and Serge.  linux-next is a side issue - I can cope with
> a lot.

See above.  This issue has been solved with James a few months ago, this merge 
window was actually on track to go off without a problem, and it sorta did, 
but there were some out-of-band issues which caused some confusion in the 
linux-security world.  Let's try to move on a bit, discussing why the SELinux 
#next branch has some cruft in it doesn't help us resolve things since we all 
acknowledge there were problems for a while that should now be resolved ...

Stephen, assuming for a moment that I created a fresh branch, based against 
3.15, and then added the SELinux patches for 3.16 (basically the few new 
patches that were in the ole #next branch) would that serve as a reasonable 
basis for a new SELinux #next branch?  Around the -rc5/6/7 timeframe I would 
send a pull request to James to pull from this next branch into the Linux 
Security branch for 3.17.  Once 3.16 is released, I would merge that into this 
new #next branch and continue with the next round of patches.

FYI, more or less, the above is the process we've settled upon for all of the 
trees that get accumulated into the Linux Security tree.

-- 
paul moore
www.paul-moore.com

