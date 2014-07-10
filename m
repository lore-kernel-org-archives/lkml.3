Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751996AbaGJHnr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jul 2014 03:43:47 -0400
Received: from out2-smtp.messagingengine.com ([66.111.4.26]:38737 "EHLO
	out2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751760AbaGJHno (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jul 2014 03:43:44 -0400
X-Sasl-enc: 5A2kI+z/bXkT3xsz3WaxjeJQyRqEaZKf65QAEu6lubHl 1404978223
Message-ID: <1404978220.2609.25.camel@perseus.fritz.box>
Subject: Re: [PATCH 0/6] autofs4: support RCU-walk
From: Ian Kent <raven@themaw.net>
To: NeilBrown <neilb@suse.de>
Cc: autofs@vger.kernel.org, linux-kernel@vger.kernel.org
Date: Thu, 10 Jul 2014 15:43:40 +0800
In-Reply-To: <20140709233541.4525.25151.stgit@notabene.brown>
References: <20140709233541.4525.25151.stgit@notabene.brown>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.4 (3.10.4-2.fc20) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2014-07-10 at 09:41 +1000, NeilBrown wrote:
> autofs4 currently doesn't support RCU-walk - it immediately
> aborts any attempt at RCU-walk to force REF-walk for path name
> lookup.
> 
> This can cause a significant performance impact on multi-core
> systems.
> I have a client with a test case which spends >80% of its time
> waiting for spinlocks with a "make -j 40" on a 40 core system.

Right, sounds worth the effort.

> 
> This patchset aims to remove most of these spinlocks.  To be fully
> effective in the particular case it needs a second patch set which
> makes NFS RCU-walk friendly, but one thing at a time.
> 
> This has only been lightly tested so far so I'm really after feed-back
> rather than to have the patch set accepted, though the first two
> patches are trivial and could be taken immediately.

I've only scanned the patches so far, I'll need to spend a bit more time
on them before I can comment.

I'm going to be pressed for time for at least several days so I won't be
able to get to this right away.

I expect the submount_test I use to stress path walking and expire to
mount transitions will likely be a good test to use. I haven't used it
in my personal environment for quite a while now so I'll need to have a
look around and see if I can still find a suitable set of scripts.
Otherwise I'll need to decouple it from the RedHat automated test
environment.

> 
> The last two patches are the most interesting so review comments on
> those are particularly welcome.

Again I haven't looked closely at these but don't you mean the last
three patches or am I just fussing over an obviously straight forward
patch 3?

Thanks for your effort Bruce,
Ian


