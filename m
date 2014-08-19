Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751804AbaHSKCu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Aug 2014 06:02:50 -0400
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:45752 "EHLO
	out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750789AbaHSKCs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Aug 2014 06:02:48 -0400
X-Sasl-enc: wOPEFlqJ8MKzotCfNrdBWCTlul2bfjv8+aThZRxlFvs5 1408442566
Message-ID: <1408442547.11314.9.camel@perseus.themaw.net>
Subject: Re: [PATCH 0/5] RCU-walk support for autofs
From: Ian Kent <raven@themaw.net>
To: NeilBrown <neilb@suse.de>
Cc: autofs@vger.kernel.org, linux-kernel@vger.kernel.org
Date: Tue, 19 Aug 2014 18:02:27 +0800
In-Reply-To: <1408350340.2533.3.camel@perseus.fritz.box>
References: <20140818062844.9860.43007.stgit@notabene.brown>
	 <1408350340.2533.3.camel@perseus.fritz.box>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.4 (3.10.4-3.fc20) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2014-08-18 at 16:25 +0800, Ian Kent wrote:
> On Mon, 2014-08-18 at 16:33 +1000, NeilBrown wrote:
> > Hi Ian,
> >  Have you had a chance to run your tests in these patches yet?
> >  I've done what testing I can think of and cannot fault them.
> 
> I haven't, I've been plagued with illness so I'm not getting nearly
> enough done. I'll try to put a kernel together and run the test in the
> next week or so.

Just to let you know that I managed to spend some time on this. I built
a kernel (3.17.0-rc1) with the series and ran a couple of tests.

I'm not certain that the patches I used are identical to your posting, I
saw one difference, after the fact, that shouldn't matter, I'll have to
check that.

It isn't possible to test expire to mount races because the mounts in
the tree never expire.

At first I thought it was because so many processes were accessing the
tree all the time but manually constructing the maps and mounting the
mounts shows that nothing ever expires, at least for this tree.

However, issuing a shut down does expire all the mounts and shuts down
autofs cleanly.

So there is something not quite right with the expire check or my
patches have mistakes.

> 
> > 
> >  This set is against 3.17-rc1 and make use of the new -EISDIR handling
> >  for d_manage() and assumes the other patches which already went in
> >  through Andrew Morton.
> > 
> >  I've added a section to autofs4.txt about mount namespaces, but it is
> >  otherwise unchanged.
> > 
> >  If I could get an {Acked,Reviewed,Tested}-By in the next few weeks so
> >  I can send them on to Andrew I would really appreciate it.
> > 
> > Thanks,
> > NeilBrown
> > 
> > 
> > 
> > ---
> > 
> > NeilBrown (5):
> >       autofs4: allow RCU-walk to walk through autofs4.
> >       autofs4: factor should_expire() out of autofs4_expire_indirect.
> >       autofs4: avoid taking fs_lock during rcu-walk
> >       autofs4: d_manage() should return -EISDIR when appropriate in rcu-walk mode.
> >       autofs: the documentation I wanted to read
> > 
> > 
> >  Documentation/filesystems/autofs4.txt |  520 +++++++++++++++++++++++++++++++++
> >  fs/autofs4/autofs_i.h                 |    6 
> >  fs/autofs4/dev-ioctl.c                |    2 
> >  fs/autofs4/expire.c                   |  200 ++++++++-----
> >  fs/autofs4/root.c                     |   62 +++-
> >  5 files changed, 694 insertions(+), 96 deletions(-)
> >  create mode 100644 Documentation/filesystems/autofs4.txt
> > 
> 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe autofs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


