Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752064AbaGKCt6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jul 2014 22:49:58 -0400
Received: from out2-smtp.messagingengine.com ([66.111.4.26]:36598 "EHLO
	out2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751364AbaGKCt4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jul 2014 22:49:56 -0400
X-Sasl-enc: Va7MpBf9QUJ9YRrR53U+r+t93JTgKNf2b54RklCqlVZj 1405046995
Message-ID: <1405046992.2574.10.camel@perseus.fritz.box>
Subject: Re: [PATCH 0/6] autofs4: support RCU-walk
From: Ian Kent <raven@themaw.net>
To: NeilBrown <neilb@suse.de>
Cc: autofs@vger.kernel.org, linux-kernel@vger.kernel.org
Date: Fri, 11 Jul 2014 10:49:52 +0800
In-Reply-To: <20140710182519.79120b90@notabene.brown>
References: <20140709233541.4525.25151.stgit@notabene.brown>
	 <1404978220.2609.25.camel@perseus.fritz.box>
	 <20140710182519.79120b90@notabene.brown>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.4 (3.10.4-2.fc20) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2014-07-10 at 18:25 +1000, NeilBrown wrote:
> On Thu, 10 Jul 2014 15:43:40 +0800 Ian Kent <raven@themaw.net> wrote:
> 
> > On Thu, 2014-07-10 at 09:41 +1000, NeilBrown wrote:
> > > autofs4 currently doesn't support RCU-walk - it immediately
> > > aborts any attempt at RCU-walk to force REF-walk for path name
> > > lookup.
> > > 
> > > This can cause a significant performance impact on multi-core
> > > systems.
> > > I have a client with a test case which spends >80% of its time
> > > waiting for spinlocks with a "make -j 40" on a 40 core system.
> > 
> > Right, sounds worth the effort.
> > 
> > > 
> > > This patchset aims to remove most of these spinlocks.  To be fully
> > > effective in the particular case it needs a second patch set which
> > > makes NFS RCU-walk friendly, but one thing at a time.
> > > 
> > > This has only been lightly tested so far so I'm really after feed-back
> > > rather than to have the patch set accepted, though the first two
> > > patches are trivial and could be taken immediately.
> > 
> > I've only scanned the patches so far, I'll need to spend a bit more time
> > on them before I can comment.
> > 
> > I'm going to be pressed for time for at least several days so I won't be
> > able to get to this right away.
> > 
> > I expect the submount_test I use to stress path walking and expire to
> > mount transitions will likely be a good test to use. I haven't used it
> > in my personal environment for quite a while now so I'll need to have a
> > look around and see if I can still find a suitable set of scripts.
> > Otherwise I'll need to decouple it from the RedHat automated test
> > environment.
> > 
> > > 
> > > The last two patches are the most interesting so review comments on
> > > those are particularly welcome.
> > 
> > Again I haven't looked closely at these but don't you mean the last
> > three patches or am I just fussing over an obviously straight forward
> > patch 3?
> 
> Exactly right - that thirds last patch was "obviously straight forward", so
> is naturally the one that I have already found a bug in (the patch assumes
> that autofs4_check_leaves returns a different dentry, which clearly isn't
> true).

Ha, IIRC that was to support the old pseudo direct mounts that would
expire the leaves of a tree independently. That was a long time ago now
and probably isn't used but it should remain think.

I'll need to have a look at that too, to refresh my memory.

> 
> I'll repost it, probably on Monday.
> 
> > 
> > Thanks for your effort Bruce,
> > Ian
> > 
> 
>     http://www.youtube.com/watch?v=_f_p0CgPeyA
> 
> (Usually when people get my name wrong they call me "Ian", so you calling me
> Bruce is both slightly ironic and quite refreshing!)

LOL, but I have a lame excuse!
I was thinking Bruce Fields when replying since have the impression you
both work in similar areas.

Ian

