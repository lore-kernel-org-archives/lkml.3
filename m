Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752458AbaHTJwy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Aug 2014 05:52:54 -0400
Received: from out3-smtp.messagingengine.com ([66.111.4.27]:37072 "EHLO
	out3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751258AbaHTJww (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Aug 2014 05:52:52 -0400
X-Sasl-enc: SDtvOM95qA9XW0uVfWOSFiXDL+pWW9GsvMeXj/yhNCWg 1408528371
Message-ID: <1408528367.11028.44.camel@perseus.themaw.net>
Subject: Re: [PATCH 0/5] RCU-walk support for autofs
From: Ian Kent <raven@themaw.net>
To: NeilBrown <neilb@suse.de>
Cc: autofs@vger.kernel.org, linux-kernel@vger.kernel.org
Date: Wed, 20 Aug 2014 17:52:47 +0800
In-Reply-To: <1408506167.11028.32.camel@perseus.themaw.net>
References: <20140818062844.9860.43007.stgit@notabene.brown>
	 <1408350340.2533.3.camel@perseus.fritz.box>
	 <1408442547.11314.9.camel@perseus.themaw.net>
	 <20140819211654.5ec3853a@notabene.brown>
	 <1408451815.11314.15.camel@perseus.themaw.net>
	 <20140820131352.2aad3ca5@notabene.brown>
	 <1408506167.11028.32.camel@perseus.themaw.net>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.4 (3.10.4-3.fc20) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2014-08-20 at 11:42 +0800, Ian Kent wrote:
> Great minds think alike.
> I have basically the exact same patch and I'm testing now.
> It probably should be folded into "autofs4: avoid taking fs_lock during
> rcu-walk".
> 
> It takes ages though, the test has two configurations to test and each
> one takes about 70 minutes.
> 
> fyi, my criteria for the test is if it runs through to completion once
> then that's essentially a pass. If not then there is a race that needs
> to be fixed before merge. If it fails on runs two or three then there's
> a hard to find race that needs attention but is not serious enough to
> block merging. I usually stop after three runs but if fails are seen
> later then, they too need to be resolved in the fullness of time.
> 
> The reason for this is that in heavy use sites we rarely see more than
> about three processes concurrently accessing mount points and the test
> run uses 10 client instances (currently on a 6 CPU machine) that all
> access the mount tree at the same time so that should be somewhat more
> pressure than is seen under heavy use.
> 
> And indeed this rule of has proven reliable so far.

I've run my test three times now.

The first time I had debug logging enabled. I disabled it for the second
and third runs as that sometimes makes a difference.

All three runs went through fine.

The only thing I noticed was that the test took a little longer (two and
a half to three minutes longer, of 70) to complete than without the
patch series but I've seen that sort of variation in kernels at
different times in the past.

So I think the series is fine and should be merged.
Please feel free to add any of my acked, reviewed and tested by to them.

Ian


